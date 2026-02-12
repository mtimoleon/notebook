---
categories:
  - "[[Work]]"
  - "[[Issues]]"
created: 2026-01-16T12:12
tags:
  - intelligen
status: completed
product: ScpCloud
---

- [x] Add user mtimoleon  
- [x] Add webmin  
- [x] Install svn  
- [x] Install trac  
- [x] Upload svn repos  
- [x] Copy apache settings from current vm (etc/apache2)
	- copy files svn-auth-file, svn-authz-file
	- apache2.conf add line "ServerName 62.219.176.140"
	- create certificate inside etc/crt
	  openssl req -new -newkey rsa:2048 -nodes \
		-keyout SvnServerKey.pem \  
		-x509 -days 36500 -sha256 \  
		-subj "/CN=svn.intelligen.com" \  
		-addext "subjectAltName=DNS:svn.intelligen.com,IP:68.219.176.140" \  
		-out SvnServer.pem
	- create ssl-www.conf
	- enable ssl-www.conf
	  a2ensite ssl-www.conf
	  systemctl reload apache2
- [x] Copy necessarry settings from current vm
	- copy file /var/www/trac.wsgi
- [x] Install cron job for repos backup =\> just run the /backup/hotcopy.sh every day @7:00  
- [x] mkdir /var/lib/backup
 - scripts
 - hotcopy  
- [x] Change server name inside /etc/apache2/sites-available/ssl-www.conf from ip to **svn.intelligen.com** why do we need?
 
==Meta to hotcopy==  
==na mpei sto db transactions kai trn-protorevs me www-data owner kai 755==  
==na ginoyn ta hooks executable==
 
SVN & Trac Migration Guide (Hotcopy-based, Apache, SSL)  
Scope

- New Ubuntu server (no prior SVN / Trac installation)
- Apache as frontend
- SVN repositories restored fromΒ `svnadmin hotcopy`
- Trac environments restored fully (SQLite)
- HTTPS enabled with self-signed or existing certificates
- Authentication via Apache Basic Auth
- Optional SVN path-based authorization (`authz`)
 
1. Assumptions

- Old server still existsΒ **or**Β validΒ `svnadmin hotcopy`Β backups exist
- Trac version β‰¥ 1.6
- Target filesystem paths:
    - SVN:Β `/var/lib/svn`
    - Trac:Β `/var/lib/trac`
- Apache user:Β `www-data`
- OS: Ubuntu Server (22.04 / 24.04)
 
2. Base System Preparation  

```
apt update

```
 Install required packages:  

```
apt install -y \
  apache2 \
  subversion \
  libapache2-mod-svn \
  trac \
  libapache2-mod-wsgi-py3 \
  openssl

```
 Enable required Apache modules:  

```
a2enmod ssl dav dav_svn dav_fs wsgi
systemctl restart apache2

```
 
3. Directory Layout  
Create canonical directories:  

```
mkdir -p /var/lib/svn /var/lib/trac
chown -R www-data:www-data /var/lib/svn /var/lib/trac
chmod -R 750 /var/lib/svn /var/lib/trac
```
 
4. SSL Certificate  
Generate new self-signed cert  

```
openssl req -new -newkey rsa:2048 -nodes \
  -keyout /etc/crt/SvnServerKey.pem \
  -x509 -days 36500 -sha256 \
  -subj "/CN=svn.intelligen.com" \
  -addext "subjectAltName=DNS:svn.intelligen.com,IP:68.219.176.140" \
  -out /etc/crt/SvnServer.pem
```
 
5. Apache Virtual Hosts  
FileΒ _/etc/apache2/apache2.conf_  
Add lineΒ `ServerName \<your-server-ip\>`
 
HTTP (80)  
`/etc/apache2/sites-available/000-default.conf`Β (Standard, unchanged)
 
HTTPS (443)  

```
/etc/apache2/sites-available/ssl-www.conf
\<VirtualHost *:443\>
	ServerAdmin webmaster@localhost
	ServerName svn.intelligen.com

SSLEngine on
	SSLCertificateFile    "/etc/crt/SvnServer.pem"
	SSLCertificateKeyFile "/etc/crt/SvnServerKey.pem"

DocumentRoot /var/www/
	\<Directory /\>
		Options FollowSymLinks
		AllowOverride None
	\</Directory\>
	\<Directory /var/www/\>
		Options Indexes FollowSymLinks MultiViews
		AllowOverride None
		# AuthType Basic
		# AuthName "Intelligen WWW"
		# AuthUserFile "/etc/apache2/svn-auth-file"
		# Require valid-user
	\</Directory\>

\<Location /svn\>
		DAV svn
		SVNParentPath "/var/lib/svn/"
		AuthType Basic
		AuthName "Subversion repository"
		AuthUserFile "/etc/apache2/svn-auth-file"
		AuthzSVNAccessFile "/etc/apache2/svn-authz-file"
		Require valid-user
	\</Location\>

#	\<Location /trac\>
#		SetHandler mod_python
#		PythonInterpreter main_interpreter
#		PythonHandler trac.web.modpython_frontend
#		PythonOption TracEnv /var/lib/trac
#		PythonOption TracEnvParentDir /var/lib/trac
#		PythonOption TracUriRoot /trac
#		PythonOption TracEnvIndexTemplate /var/lib/trac/ProjectsTemplate
#		AuthType Basic
#		AuthName "Intelligen WWW"
#		AuthUserFile "/etc/apache2/svn-auth-file"
#		Require valid-user
#	\</Location\>

# === Trac through WSGI in /trac ===
    WSGIDaemonProcess trac user=www-data group=www-data processes=2 threads=10 display-name=%{GROUP}
    WSGIProcessGroup trac

# The WSGI app of Trac
    WSGIScriptAlias /trac /var/www/trac.wsgi

# Static files of Trac (chrome)
    Alias /trac/chrome/common /usr/lib/python3/dist-packages/trac/htdocs/
    \<Directory /usr/lib/python3/dist-packages/trac/htdocs/\>
        Require all granted
    \</Directory\>

# Access to WSGI script
    \<Directory /var/www\>
        \<Files trac.wsgi\>
            Require all granted
        \</Files\>
    \</Directory\>

# Basic Auth in /trac
    \<Location /trac\>
        AuthType Basic
        AuthName "Intelligen WWW"
        AuthUserFile "/etc/apache2/svn-auth-file"
        Require valid-user
    \</Location\>

\<Location /dav\>
		Order Allow,Deny
		Allow from all
		Dav On
		AuthType Basic
		AuthName "Web DAV"
		AuthUserFile "/etc/apache2/svn-auth-file"
		Require valid-user
		\<LimitExcept GET OPTIONS\>
			Require user John
		\</LimitExcept\>
	\</Location\>
#	\<LocationMatch "/trac/[^/]+/login"\>
#		AuthType Basic
#		AuthName "Trac"
#		AuthUserFile /etc/apache2/svn-auth-file
#		Require valid-user
#	\</LocationMatch\>

ScriptAlias /cgi-bin/ /usr/lib/cgi-bin/
	\<Directory "/usr/lib/cgi-bin"\>
		AllowOverride None
		Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch
		Order allow,deny
		Allow from all
	\</Directory\>

ErrorLog /var/log/apache2/error.log

# Possible values include: debug, info, notice, warn, error, crit,
	# alert, emerg.
	LogLevel warn

CustomLog /var/log/apache2/access.log combined
	ServerSignature On
\</VirtualHost\>

```
 Enable site:  

```
a2ensite ssl-www.conf
a2dissite default-ssl.conf   # if enabled and not needed
apachectl configtest
systemctl restart apache2

```
 
6. Authentication Files  
Users (Basic Auth)  
`/etc/apache2/svn-auth-file`  
Copy from old server or recreate:  

```
htpasswd -c /etc/apache2/svn-auth-file admin

```
 Permissions:  

```
chown root:www-data /etc/apache2/svn-auth-file
chmod 640 /etc/apache2/svn-auth-file

```
 
SVN Authorization (Authz)  
`/etc/apache2/svn-authz-file`  
Example:  

```
[SchedulePro:/]
user-name = rw

```
 Permissions:  

```
chown root:www-data /etc/apache2/svn-authz-file
chmod 640 /etc/apache2/svn-authz-file

```
 
7. Restore SVN Repositories (Hotcopy)  
For each repository:  

```
rsync -a SchedulePro /var/lib/svn/
chown -R www-data:www-data /var/lib/svn/SchedulePro

```
 **Mandatory verification:**  

```
svnadmin verify /var/lib/svn/SchedulePro

```
 If this fails β†’Β **stop**. Re-take hotcopy from the old server with all services stopped.
 
8. Restore Trac Environments  
RestoreΒ **entire environments**, not justΒ `trac.ini`.  
Also copyΒ `/var/www/trac.wsgi`Β to the new machine (same place).  

```
rsync -a SchedulePro /var/lib/trac/
chown -R www-data:www-data /var/lib/trac/SchedulePro

```
 Upgrade & resync:  

```
trac-admin /var/lib/trac/SchedulePro upgrade
trac-admin /var/lib/trac/SchedulePro wiki upgrade

```
 
9. Trac Repository Sync (Trac 1.6+)  
Check repositories:  

```
trac-admin /var/lib/trac/SchedulePro repository list

```
 Resync:  

```
trac-admin /var/lib/trac/SchedulePro repository resync SchedulePro

```
 
10. Validation Checklist  
Apache / TLS  

```
apachectl -S
curl -kI https://127.0.0.1/

```
 SVN  

```
svnadmin verify /var/lib/svn/SchedulePro
curl -k -u admin:PASS https://127.0.0.1/svn/

```
 Trac  

```
trac-admin /var/lib/trac/SchedulePro help
curl -k -u admin:PASS https://127.0.0.1/trac

```
 Timeline must show SVN commits.
 
11. Backups (Hotcopy + Cron)  
Create backup directory layout:  

```
mkdir -p /var/lib/backup/scripts /var/lib/backup/hotcopy/svn /var/lib/backup/hotcopy/trac /var/lib/backup/hotcopy-backups
chown -R root:root /var/lib/backup
chmod -R 755 /var/lib/backup

```
 Copy backup scripts from the old machine intoΒ `/var/lib/backup/scripts`Β (at minimumΒ `hotcopy.sh`Β andΒ `backup_rotated_30.sh`) and ensure they are executable.  
`backup_rotated_30.sh`Β is the wrapper that:

- runsΒ `/var/lib/backup/scripts/hotcopy.sh`
- archivesΒ `/var/lib/backup/hotcopy`Β intoΒ `/var/lib/backup/hotcopy-backups/${hostname}-YYYY-MM-DD.tgz`
- enforces 30-day retention inΒ `/var/lib/backup/hotcopy-backups`Β (deletes files older than 30 days)
- NOTE: if it runs multiple times per day it will overwrite the same daily filename unless you include time in the archive name

Make scripts executable:  

```
chmod 755 /var/lib/backup/scripts/*.sh

```
 _CAUTION: svnadmin needs the projects folder to exist in order to perform hotcopy. So you need to take care the folders creation before script run or fix it inside the script._  
Create a daily cron job (runs asΒ `root`) at 07:00:  

```
cat \> /etc/cron.d/svn-trac-hotcopy \<\<'EOF'
0 7 * * * root /var/lib/backup/scripts/backup_rotated_30.sh 2\>&1 | logger -t backup-hotcopy-job
EOF
chmod 644 /etc/cron.d/svn-trac-hotcopy

```
 If you create cronjob wihtin webmin you will find it underΒ `/var/spool/cron/crontabs`Β insideΒ `root`Β file.
 
12. Common Failure Causes (Post-mortem)

- Hotcopy taken while SVN was active
- SSL vhost not enabled β†’ HTTP on port 443 β†’Β `wrong version number`
- Authz file blocks root access β†’Β `/svn`Β returns 403
 
13. Final Conclusion  
IfΒ **all of the following are true**, the migration is correct:

14. `svnadmin verify`Β passes
15. ```
    https://server/svn/
    ```
    
    Β is browsable with auth
16. ```
    https://server/trac
    ```
    
    Β loads and shows commits
   

Ξ Ξ±ΟΞ±ΞΊΞ¬Ο„Ο‰ ΞµΞ―Ξ½Ξ±ΞΉ ΟƒΟ…Ξ³ΞΊΞµΞ½Ο„ΟΟ‰ΞΌΞ­Ξ½ΞµΟ‚, Ο€ΟΞ±ΞΊΟ„ΞΉΞΊΞ­Ο‚ ΞΏΞ΄Ξ·Ξ³Ξ―ΞµΟ‚ Ξ³ΞΉΞ± **ΞΊΞ±ΞΈΞ±ΟΞ® Ξ½Ξ­Ξ± ΞµΞ³ΞΊΞ±Ο„Ξ¬ΟƒΟ„Ξ±ΟƒΞ· SVN + Trac** ΞΊΞ±ΞΉ **ΞΌΞµΟ„Ξ±Ο†ΞΏΟΞ¬ repos Ξ±Ο€Ο hotcopy backup**.
 
**Ξ£Ο„ΟΟ‡ΞΏΟ‚ ΞµΞ³ΞΊΞ±Ο„Ξ¬ΟƒΟ„Ξ±ΟƒΞ·Ο‚**

1. SVN repositories ΞΊΞ¬Ο„Ο‰ Ξ±Ο€Ο /var/lib/svn
2. Trac environments ΞΊΞ¬Ο„Ο‰ Ξ±Ο€Ο /var/lib/trac
3. Apache Ο‰Ο‚ front-end (DAV SVN + Trac ΞΌΞ­ΟƒΟ‰ mod_wsgi Ξ® CGI)
4. ΞΞµΟ„Ξ±Ο†ΞΏΟΞ¬ **Ξ±Ο…Ο„ΞΏΟΟƒΞΉΟ‰Ξ½ repos** Ξ±Ο€Ο svnadmin hotcopy
5. ΞΞ»ΞµΞ³Ο‡ΞΏΟ‚ ΞΊΞ±ΞΉ ΞΌΞµΟ„Ξ±Ο†ΞΏΟΞ¬ ΞΌΟΞ½ΞΏ Ο„Ο‰Ξ½ ΞΏΟ…ΟƒΞΉΞ±ΟƒΟ„ΞΉΞΊΟΞ½ ΟΟ…ΞΈΞΌΞ―ΟƒΞµΟ‰Ξ½ Ξ±Ο€Ο Ο„ΞΏ Ο€Ξ±Ξ»ΞΉΟ ΞΌΞ·Ο‡Ξ¬Ξ½Ξ·ΞΌΞ±
 
**1. Ξ ΟΞΏΞ±Ο€Ξ±ΞΉΟ„ΞΏΟΞΌΞµΞ½Ξ± Ο€Ξ±ΞΊΞ­Ο„Ξ± (Ubuntu Server)**  
Ξ•Ξ»Ξ¬Ο‡ΞΉΟƒΟ„Ξ± ΞΊΞ±ΞΉ ΞΊΞ»Ξ±ΟƒΞΉΞΊΞ¬:

- subversion
- apache2
- libapache2-mod-svn
- trac
- python3
- python3-pip
- (Ξ±Ξ½ Trac ΞΌΞµ WSGI) libapache2-mod-wsgi-py3

Ξ”ΞµΞ½ Ο‡ΟΞµΞΉΞ¬Ξ¶ΞµΟƒΞ±ΞΉ database server Ξ±Ξ½ Ο„ΞΏ Trac ΞµΞ―Ξ½Ξ±ΞΉ ΞΌΞµ SQLite (default ΞΊΞ±ΞΉ Ο€ΟΞΏΟ„ΞµΞ―Ξ½ΞµΟ„Ξ±ΞΉ).
 
**2. Ξ”ΞΏΞΌΞ® Ο†Ξ±ΞΊΞ­Ξ»Ο‰Ξ½ (ΟƒΟ„Ξ±ΞΈΞµΟΞ® β€“ ΞΌΞ·Ξ½ Ο„Ξ·Ξ½ Ξ±Ξ»Ξ»Ξ¬ΞΎΞµΞΉΟ‚)**  
/var/lib/
 β”β”€β”€ svn/
 β”‚ β”β”€β”€ repo1/
 β”‚ β”β”€β”€ repo2/
 β”‚ β””β”€β”€ ...
 β””β”€β”€ trac/
 β”β”€β”€ project1/
 β”β”€β”€ project2/
 β””β”€β”€ ...
  
Ξ™Ξ΄ΞΉΞΏΞΊΟ„Ξ®Ο„Ξ·Ο‚:  
chown -R www-data:www-data /var/lib/svn /var/lib/trac
chmod -R 750 /var/lib/svn /var/lib/trac
  
Ξ‘Ξ½ ΟƒΟ„ΞΏ Ο€Ξ±Ξ»ΞΉΟ ΟƒΟΟƒΟ„Ξ·ΞΌΞ± Ξ­Ο„ΟΞµΟ‡Ξµ ΞΌΞµ svn user Ξ±Ξ½Ο„Ξ― Ξ³ΞΉΞ± www-data, Ο„ΞΏ **ΞµΞ»Ξ­Ξ³Ο‡ΞµΞΉΟ‚ Ο€ΟΟΟ„Ξ±** (Ξ²Ξ». ΞµΞ½ΟΟ„Ξ·Ο„Ξ± 6).
 
**3. ΞΞµΟ„Ξ±Ο†ΞΏΟΞ¬ SVN repositories (hotcopy)**  
Ξ‘Ο†ΞΏΟ Ο„Ξ± backup ΞµΞ―Ξ½Ξ±ΞΉ svnadmin hotcopy, Ξ”Ξ•Ξ ΞΊΞ¬Ξ½ΞµΞΉΟ‚ dump/load.  
**Ξ’Ξ®ΞΌΞ±Ο„Ξ±**

1. Ξ‘Ξ½Ο„ΞΉΞ³ΟΞ±Ο†Ξ® repos:

rsync -a repo1 /var/lib/svn/


1. ΞΞ»ΞµΞ³Ο‡ΞΏΟ‚:

svnadmin verify /var/lib/svn/repo1


1. Ξ”ΞΉΟΟΞΈΟ‰ΟƒΞ· permissions (Ξ±Ο€Ξ±ΟΞ±Ξ―Ο„Ξ·Ο„ΞΏ):

chown -R www-data:www-data /var/lib/svn/repo1
  
Ξ‘Ξ½ Ξ±Ο€ΞΏΟ„ΟΟ‡ΞµΞΉ Ο„ΞΏ verify β†’ ΟƒΟ„Ξ±ΞΌΞ±Ο„Ξ¬Ο‚ ΞµΞ΄Ο. Ξ”ΞµΞ½ Ο€Ξ±Ο‚ Ο€Ξ±ΟΞ±ΞΊΞ¬Ο„Ο‰.
 
**4. Apache + SVN (mod_dav_svn)**  
**Ξ•Ξ»Ξ¬Ο‡ΞΉΟƒΟ„ΞΏ VirtualHost Ο€Ξ±ΟΞ¬Ξ΄ΞµΞΉΞ³ΞΌΞ±**  
\<Location /svn\>
 DAV svn
 SVNParentPath /var/lib/svn
  
AuthType Basic
 AuthName "Subversion"
 AuthUserFile /etc/apache2/svn.passwd
 Require valid-user
\</Location\>
  
==Ξ•Ξ½ΞµΟΞ³ΞΏΟ€ΞΏΞ―Ξ·ΟƒΞ· modules:==  
a2enmod dav
a2enmod dav_svn
systemctl reload apache2

 
**5. Trac β€“ Ξ½Ξ­Ξ± ΞµΞ³ΞΊΞ±Ο„Ξ¬ΟƒΟ„Ξ±ΟƒΞ· & ΟƒΟΞ½Ξ΄ΞµΟƒΞ· ΞΌΞµ Ο…Ο€Ξ¬ΟΟ‡ΞΏΞ½ SVN**  
**Ξ”Ξ·ΞΌΞΉΞΏΟ…ΟΞ³Ξ―Ξ± Trac environment**  
trac-admin /var/lib/trac/project1 initenv


- Database: sqlite
- Repository type: svn
- Repository path: /var/lib/svn/repo1

ΞΞµΟ„Ξ¬:  
chown -R www-data:www-data /var/lib/trac/project1
  
**Apache β€“ Trac ΞΌΞ­ΟƒΟ‰ WSGI (Ο€ΟΞΏΟ„ΞµΞΉΞ½ΟΞΌΞµΞ½ΞΏ)**  
WSGIDaemonProcess trac user=www-data group=www-data threads=5
WSGIProcessGroup trac
  
WSGIScriptAlias /trac /var/lib/trac/project1/cgi-bin/trac.wsgi
  
\<Directory /var/lib/trac/project1\>
 Require all granted
\</Directory\>

 
**6. Ξ¤ΞΉ Ξ Ξ΅Ξ•Ξ Ξ•Ξ™ Ξ½Ξ± ΞµΞ»Ξ­Ξ³ΞΎΞµΞΉΟ‚ Ξ±Ο€Ο Ο„Ξ·Ξ½ Ο€Ξ±Ξ»ΞΉΞ¬ ΞµΞ³ΞΊΞ±Ο„Ξ¬ΟƒΟ„Ξ±ΟƒΞ· (Ο€ΞΏΞ»Ο ΟƒΞ·ΞΌΞ±Ξ½Ο„ΞΉΞΊΟ)**  
**A. SVN repositories**  
Ξ£Ο„ΞΏ Ο€Ξ±Ξ»ΞΉΟ ΞΌΞ·Ο‡Ξ¬Ξ½Ξ·ΞΌΞ±:

1. **Hooks**

hooks/
 β”β”€β”€ pre-commit
 β”β”€β”€ post-commit
 β””β”€β”€ start-commit


- Ξ‘Ξ½ Ο…Ο€Ξ¬ΟΟ‡ΞΏΟ…Ξ½ custom scripts β†’ Ο€ΟΞ­Ο€ΞµΞΉ Ξ½Ξ± ΞΌΞµΟ„Ξ±Ο†ΞµΟΞΈΞΏΟΞ½.
- ΞΞ»ΞµΞ³ΞΎΞµ paths hardcoded (Ο€.Ο‡. /usr/bin/python, mailer paths).
- **svnserve.conf / authz**
- Ξ‘Ξ½ Ο‡ΟΞ·ΟƒΞΉΞΌΞΏΟ€ΞΏΞΉΞΏΟΟƒΞµΟ‚ file-based authz:

conf/authz
conf/svnserve.conf


1. **FS type**

svnadmin info /path/to/repo
  
Ξ‘Ξ½ ΞµΞ―Ξ½Ξ±ΞΉ FSFS (99% Ο€ΞΉΞΈΞ±Ξ½Ο), Ξ΄ΞµΞ½ ΟƒΞµ Ξ½ΞΏΞΉΞ¬Ξ¶ΞµΞΉ.
 
**B. Apache configs (Ο€Ξ±Ξ»ΞΉΞ¬ ΞΌΞ·Ο‡Ξ±Ξ½Ξ®)**  
Ξ¨Ξ¬Ο‡Ξ½ΞµΞΉΟ‚ ΞΞΞΞ Ξ±Ο…Ο„Ξ¬:  
grep -R "SVN" /etc/apache2
grep -R "trac" /etc/apache2
  
ΞΟΞ¬Ο„Ξ±:

- SVNParentPath
- AuthUserFile
- AuthzSVNAccessFile
- custom \<Location\> blocks

ΞΞ—Ξ ΞΌΞµΟ„Ξ±Ο†Ξ­ΟΞµΞΉΟ‚ ΞΏΞ»ΟΞΊΞ»Ξ·ΟΞ± conf Ξ±ΟΟ‡ΞµΞ―Ξ± ΟƒΟ„Ξ± Ο„Ο…Ο†Ξ»Ξ¬.
 
**C. Trac configs (Ο€Ξ±Ξ»ΞΉΞ¬ ΞΌΞ·Ο‡Ξ±Ξ½Ξ®)**  
Ξ‘Ο€Ο ΞΊΞ¬ΞΈΞµ project:  
/var/lib/trac/project/conf/trac.ini
  
ΞΟΞ―ΟƒΞΉΞΌΞ± sections:

- [components] (plugins)
- [trac]
- [repository]
- [repositories]
- [browser]
- [logging]

Ξ‘Ξ½ Ξ­Ο‡ΞµΞΉΟ‚ plugins:  
plugins/
  
β†’ Ο€ΟΞ­Ο€ΞµΞΉ Ξ½Ξ± Ξ±Ξ½Ο„ΞΉΞ³ΟΞ±Ο†ΞΏΟΞ½ Ξ® Ξ½Ξ± ΞµΟ€Ξ±Ξ½ΞµΞ³ΞΊΞ±Ο„Ξ±ΟƒΟ„Ξ±ΞΈΞΏΟΞ½.
 
**7. Permissions & SELinux (Ξ±Ξ½ Ο…Ο€Ξ¬ΟΟ‡ΞµΞΉ)**

- Ξ£Ξµ Ubuntu ΟƒΟ…Ξ½Ξ®ΞΈΟ‰Ο‚ **Ξ΄ΞµΞ½ Ο…Ο€Ξ¬ΟΟ‡ΞµΞΉ SELinux**.
- Ξ‘Ξ½ ΞµΞ―Ξ½Ξ±ΞΉ enabled β†’ ΞΈΞ­Ξ»ΞµΞΉ context Ξ³ΞΉΞ± Apache access (ΟƒΟ€Ξ¬Ξ½ΞΉΞΏ).
 
**8. Ξ¤ΞµΞ»ΞΉΞΊΞ¬ checks**

1. Apache:

apachectl configtest


1. SVN ΞΌΞ­ΟƒΟ‰ browser:

[http://server/svn/repo1](http://server/svn/repo1)


1. Trac:

[http://server/trac](http://server/trac)


1. Trac β†” SVN sync:

trac-admin /var/lib/trac/project1 resync

 
**Ξ£Ο…ΞΌΟ€Ξ­ΟΞ±ΟƒΞΌΞ± (ΞΎΞµΞΊΞ¬ΞΈΞ±ΟΞΏ)**

1. Hotcopy β†’ Ξ±Ο€Ξ»Ξ® Ξ±Ξ½Ο„ΞΉΞ³ΟΞ±Ο†Ξ® + verify, ΟΟ‡ΞΉ dump/load.
2. ΞΞ»Ξ· Ξ· ΞΏΟ…ΟƒΞ―Ξ± ΞµΞ―Ξ½Ξ±ΞΉ:
    - hooks
    - apache auth / paths
    - trac.ini
3. ΞΟΞ¬Ο„Ξ± **Ξ―Ξ΄ΞΉΞ± paths** (/var/lib/...) Ξ³ΞΉΞ± Ξ½Ξ± ΞΌΞ·Ξ½ ΞΊΟ…Ξ½Ξ·Ξ³Ξ¬Ο‚ hardcoded ΟΟ…ΞΈΞΌΞ―ΟƒΞµΞΉΟ‚.
4. ΞΞ·Ξ½ ΞΌΞµΟ„Ξ±Ο†Ξ­ΟΞµΞΉΟ‚ configs wholesale. Ξ Ξ±Ξ―ΟΞ½ΞµΞΉΟ‚ ΞΌΟΞ½ΞΏ Ο,Ο„ΞΉ ΞµΞΎΟ…Ο€Ξ·ΟΞµΟ„ΞµΞ―.

Ξ‘Ξ½ ΞΈΞ­Ξ»ΞµΞΉΟ‚, ΞµΟ€ΟΞΌΞµΞ½ΞΏ Ξ²Ξ®ΞΌΞ±:

- Ξ½Ξ± ΞΌΞΏΟ… Ξ΄ΟΟƒΞµΞΉΟ‚ **Ξ­Ξ½Ξ± Ο€Ξ±Ξ»ΞΉΟ trac.ini** ΞΊΞ±ΞΉ **Ξ­Ξ½Ξ± apache \<Location\> block** ΞΊΞ±ΞΉ Ξ½Ξ± ΟƒΞΏΟ… Ο€Ο‰ Ο„ΞΉ ΞΊΟΞ±Ο„Ξ¬Ο‚ ΞΊΞ±ΞΉ Ο„ΞΉ Ο€ΞµΟ„Ξ¬Ο‚.
 \> Ξ‘Ο€Ο \<[https://chatgpt.com/g/g-p-68cbbce7e5548191a60334ef85b4335f/c/696a3d12-7bc8-8325-8fcd-ff83b5ec0b03](https://chatgpt.com/g/g-p-68cbbce7e5548191a60334ef85b4335f/c/696a3d12-7bc8-8325-8fcd-ff83b5ec0b03)\>     

**Ξ¤ΞΉ Ξ²Ξ»Ξ­Ο€Ο‰ Ξ±Ο€Ο Ο„ΞΏ trac.ini Ο€ΞΏΟ… Ξ­ΟƒΟ„ΞµΞΉΞ»ΞµΟ‚**

1. Ξ¤ΞΏ Trac ΞµΞ―Ξ½Ξ±ΞΉ **SQLite**:
2. \[trac] database = sqlite:db/trac.db
3. ΞΟ‡ΞµΞΉΟ‚ ΞΏΟΞΉΟƒΞΌΞ­Ξ½ΞΏ **Ξ­Ξ½Ξ± SVN repository** ΞΌΞµ ΟΞ½ΞΏΞΌΞ± SchedulePro:
4. \[repositories] SchedulePro.dir = /var/lib/svn/SchedulePro
5. \[versioncontrol] default_repository = SchedulePro
6. Ξ¤ΞΏ SVN integration ΞµΞ―Ξ½Ξ±ΞΉ ΞµΞ½ΞµΟΞ³Ο:
7. \[components] tracopt.versioncontrol.svn.* = enabled
8. Ξ”ΞµΞ½ Ο‡ΟΞ·ΟƒΞΉΞΌΞΏΟ€ΞΏΞΉΞµΞ―Ο‚ Trac-side authz:
9. \[svn] authz_file = (ΞΊΞµΞ½Ο)
10. Ξ”ΞµΞ½ Ο†Ξ±Ξ―Ξ½ΞµΟ„Ξ±ΞΉ ΞΊΞ¬Ο„ΞΉ β€Ο€ΞµΟΞ―ΞµΟΞ³ΞΏβ€/custom ΟƒΞµ plugins (Ξ΄ΞµΞ½ Ξ­Ο‡ΞµΞΉΟ‚ \[components] entries ΞµΞΊΟ„ΟΟ‚ Ο„ΞΏΟ… svn), Ξ¬ΟΞ± ΞΌΞ¬Ξ»Ξ»ΞΏΞ½ **vanilla Trac** Ο‡Ο‰ΟΞ―Ο‚ extra plugins.

Ξ£Ο…ΞΌΟ€Ξ­ΟΞ±ΟƒΞΌΞ±: Ο„ΞΏ trac.ini Ξ±Ο…Ο„Ο ΞΌΞµΟ„Ξ±Ο†Ξ­ΟΞµΟ„Ξ±ΞΉ ΟƒΟ‡ΞµΞ΄ΟΞ½ Ξ±Ο…Ο„ΞΏΟΟƒΞΉΞΏ. Ξ¤ΞΏ ΞΊΟΞ―ΟƒΞΉΞΌΞΏ ΞµΞ―Ξ½Ξ±ΞΉ Ξ½Ξ± **Ο…Ο€Ξ¬ΟΟ‡ΞµΞΉ repo ΟƒΟ„ΞΏ Ξ―Ξ΄ΞΉΞΏ path** /var/lib/svn/SchedulePro ΟƒΟ„ΞΏ Ξ½Ξ­ΞΏ ΞΌΞ·Ο‡Ξ¬Ξ½Ξ·ΞΌΞ± (ΟΟ€Ο‰Ο‚ ΞµΞ―Ο€ΞµΟ‚ ΟΟ„ΞΉ ΞΈΞ± ΟƒΟ„Ξ®ΟƒΞµΞΉΟ‚ ΞΊΞ¬Ο„Ο‰ Ξ±Ο€Ο /var/lib).
 
**Ξ¤ΞΉ Ο€ΟΞ­Ο€ΞµΞΉ Ξ½Ξ± ΞΊΟΞ±Ο„Ξ®ΟƒΞµΞΉΟ‚/Ξ±Ξ½Ο„ΞΉΞ³ΟΞ¬ΟΞµΞΉΟ‚ Ξ±Ο…Ο„ΞΏΟΟƒΞΉΞΏ**

1. ΞΞ»ΞΏ Ο„ΞΏ trac.ini ΟΟ€Ο‰Ο‚ ΞµΞ―Ξ½Ξ±ΞΉ (ΞµΞΊΟ„ΟΟ‚ Ξ±Ξ½ Ξ±Ξ»Ξ»Ξ¬ΞΎΞµΞΉ hostname/base_url Ξ±ΟΞ³ΟΟ„ΞµΟΞ±).
2. Ξ¤ΞΏ Trac environment folder (Ξ±Ξ½ ΞΈΞ­Ξ»ΞµΞΉΟ‚ Ο€Ξ»Ξ®ΟΞ· ΞΌΞµΟ„Ξ±Ο†ΞΏΟΞ¬ tickets/wiki):
3. ΞΞ§Ξ™ ΞΌΟΞ½ΞΏ trac.ini.
4. Ξ§ΟΞµΞΉΞ¬Ξ¶ΞµΟƒΞ±ΞΉ ΞΊΞ±ΞΉ db/trac.db, files/attachments, htdocs, ΞΊ.Ξ»Ο€.

Ξ‘Ξ½ ΞΈΞµΟ‚ β€ΞΌΞµΟ„Ξ±Ο†ΞΏΟΞ¬ Ξ­ΟΞ³ΞΏΟ…β€ ΞΊΞ±ΞΉ ΟΟ‡ΞΉ β€Ξ½Ξ­ΞΏ ΞΊΞµΞ½Ο Tracβ€, Ο„ΟΟ„Ξµ ΞΊΞ¬Ξ½ΞµΞΉΟ‚ rsync ΟΞ»ΞΏ Ο„ΞΏ env.
 
**ΞΞµΟ„Ξ±Ο†ΞΏΟΞ¬ Trac project Ξ±Ο€Ο Ο€Ξ±Ξ»ΞΉΟ ΞΌΞ·Ο‡Ξ¬Ξ½Ξ·ΞΌΞ± (ΟƒΟ‰ΟƒΟ„ΟΟ‚ Ο„ΟΟΟ€ΞΏΟ‚)**  
Ξ‘Ο‚ Ο€ΞΏΟΞΌΞµ ΟΟ„ΞΉ Ο„ΞΏ Ο€Ξ±Ξ»ΞΉΟ env ΞµΞ―Ξ½Ξ±ΞΉ:  
/var/lib/trac/SchedulePro  
Ξ£Ο„ΞΏ Ξ½Ξ­ΞΏ:

1. Ξ”Ξ·ΞΌΞΉΞΏΟ…ΟΞ³ΞµΞ―Ο‚ Ο†Ξ¬ΞΊΞµΞ»ΞΏ Ο€ΟΞΏΞΏΟΞΉΟƒΞΌΞΏΟ:

mkdir -p /var/lib/trac


1. Ξ‘Ξ½Ο„ΞΉΞ³ΟΞ¬Ο†ΞµΞΉΟ‚ ΞΞ›Ξ:

rsync -a /path/to/backup/SchedulePro /var/lib/trac/


1. Permissions:

chown -R www-data:www-data /var/lib/trac/SchedulePro
chmod -R 750 /var/lib/trac/SchedulePro


1. Upgrade (Ξ±Ξ½Ξ¬Ξ»ΞΏΞ³Ξ± ΞΌΞµ Ξ­ΞΊΞ΄ΞΏΟƒΞ· Trac, ΞΊΞ±Ξ»Ο ΞµΞ―Ξ½Ξ±ΞΉ Ξ½Ξ± Ο„ΞΏ Ο„ΟΞ­ΞΎΞµΞΉΟ‚):

trac-admin /var/lib/trac/SchedulePro upgrade
trac-admin /var/lib/trac/SchedulePro wiki upgrade


1. Resync repository:

trac-admin /var/lib/trac/SchedulePro resync

 
**ΞΞµΟ„Ξ±Ο†ΞΏΟΞ¬ SVN repo (hotcopy) ΟΟƒΟ„Ξµ Ξ½Ξ± Ο„Ξ±ΞΉΟΞΉΞ¬ΞΎΞµΞΉ ΞΌΞµ trac.ini**  
Ξ¤ΞΏ trac.ini Ξ¶Ξ·Ο„Ξ¬:  
/var/lib/svn/SchedulePro  
Ξ†ΟΞ± ΟƒΟ„ΞΏ Ξ½Ξ­ΞΏ Ο€ΟΞ­Ο€ΞµΞΉ Ξ½Ξ± Ξ­Ο‡ΞµΞΉΟ‚:  
/var/lib/svn/SchedulePro  
Ξ’Ξ®ΞΌΞ±Ο„Ξ±:  
mkdir -p /var/lib/svn
rsync -a /path/to/hotcopy/SchedulePro /var/lib/svn/
chown -R www-data:www-data /var/lib/svn/SchedulePro
svnadmin verify /var/lib/svn/SchedulePro

 
**Apache config Ο€ΞΏΟ… Ο€ΟΞ­Ο€ΞµΞΉ Ξ½Ξ± Ξ­Ο‡ΞµΞΉΟ‚ Ξ³ΞΉΞ± Ξ½Ξ± β€ΞΊΞΏΟ…ΞΌΟ€ΟΟƒΞµΞΉβ€ ΞΌΞµ Ξ±Ο…Ο„Ο Ο„ΞΏ setup**  
**A. SVN location (parent path)**  
\<Location /svn\>
 DAV svn
 SVNParentPath /var/lib/svn
  
AuthType Basic
 AuthName "Subversion"
 AuthUserFile /etc/apache2/svn.passwd
 Require valid-user
\</Location\>
  
Ξ‘Ο…Ο„Ο ΞΈΞ± Ξ΄ΟΟƒΞµΞΉ URL:

- /svn/SchedulePro

Ξ¤ΞΏ Trac ΟΞΌΟ‰Ο‚ Ξ”Ξ•Ξ Ο‡ΟΞµΞΉΞ¬Ξ¶ΞµΟ„Ξ±ΞΉ Ξ½Ξ± Ξ²Ξ»Ξ­Ο€ΞµΞΉ Ο„ΞΏ repo Ξ±Ο€Ο HTTP. Ξ¤ΞΏ Ξ²Ξ»Ξ­Ο€ΞµΞΉ Ξ±Ο€Ο filesystem (/var/lib/svn/SchedulePro), ΟΟ€Ο‰Ο‚ Ξ®Ξ΄Ξ· Ξ­Ο‡ΞµΞΉΟ‚.  
**B. Trac via WSGI**  
ΞΞ­Ξ»ΞµΞΉΟ‚ ΞΊΞ¬Ο„ΞΉ ΟƒΞ±Ξ½:  
WSGIDaemonProcess trac user=www-data group=www-data threads=5
WSGIProcessGroup trac
  
WSGIScriptAlias /trac /var/lib/trac/SchedulePro/cgi-bin/trac.wsgi
  
\<Directory /var/lib/trac/SchedulePro\>
 Require all granted
\</Directory\>

 
**Ξ¤ΞΉ Ξ½Ξ± ΟΞ¬ΞΎΞµΞΉΟ‚ ΟƒΟ„Ξ·Ξ½ Ο€Ξ±Ξ»ΞΉΞ¬ ΞµΞ³ΞΊΞ±Ο„Ξ¬ΟƒΟ„Ξ±ΟƒΞ· Ξ³ΞΉΞ± SVN + Apache (Ξ»Ξ―ΟƒΟ„Ξ± β€ΞΌΟΞ½ΞΏ Ο„Ξ± ΞΊΟΞ―ΟƒΞΉΞΌΞ±β€)**

1. Apache conf blocks Ο€ΞΏΟ… Ξ±Ο†ΞΏΟΞΏΟΞ½ svn/trac:
2. /etc/apache2/sites-available/*
3. /etc/apache2/conf-available/*
4. /etc/apache2/mods-enabled/dav_svn.conf (Ξ® custom)
5. Ξ£Ο„ΞΏ \<Location /svn\> ΞΊΞΏΞ―Ο„Ξ±:
6. SVNParentPath Ξ® SVNPath (Ξ±Ξ½ Ξ®Ο„Ξ±Ξ½ single repo)
7. AuthUserFile (Ο€ΞΏΟ ΞµΞ―Ξ½Ξ±ΞΉ Ο„ΞΏ password file)
8. AuthzSVNAccessFile (Ξ±Ξ½ ΞµΞ―Ο‡ΞµΟ‚ per-path permissions)
9. Require rules
10. SVNListParentPath (Ξ±Ξ½ ΞµΞΌΟ†Ξ±Ξ½Ξ―Ξ¶ΞµΞΉ Ξ»Ξ―ΟƒΟ„Ξ± repos)
11. Password file:
12. ΟƒΟ…Ξ½Ξ®ΞΈΟ‰Ο‚ /etc/apache2/svn.passwd Ξ® /etc/subversion/passwd
13. Ο„ΞΏ ΞΌΞµΟ„Ξ±Ο†Ξ­ΟΞµΞΉΟ‚ Ξ±Ο…Ο„ΞΏΟΟƒΞΉΞΏ (ΞµΞ―Ξ½Ξ±ΞΉ htpasswd hash file)
14. Hooks ΟƒΟ„Ξ± repos:
15. /var/lib/svn/SchedulePro/hooks/*
16. Ξ±Ο…Ο„Ξ¬ Ξ΄ΞµΞ½ Ο„Ξ± β€ΞΊΞ±Ξ»ΟΟ€Ο„ΞµΞΉβ€ Ο„ΞΏ hotcopy Ξ±Ξ½ Ο„Ξ± Ξ­Ο‡ΞµΞΉΟ‚ ΟƒΟ„ΞΏ repo hotcopy Ξ½Ξ±ΞΉ, Ξ±Ξ»Ξ»Ξ¬ ΞΈΞ­Ξ»ΞµΞΉΟ‚ Ξ½Ξ± Ξ²ΞµΞ²Ξ±ΞΉΟ‰ΞΈΞµΞ―Ο‚ ΟΟ„ΞΉ Ο…Ο€Ξ¬ΟΟ‡ΞΏΟ…Ξ½ ΞΊΞ±ΞΉ Ξ΄ΞΏΟ…Ξ»ΞµΟΞΏΟ…Ξ½ (mail commit, integration, ΞΊ.Ξ»Ο€.)
 
**Ξ¤ΞΏ ΞΌΟΞ½ΞΏ β€red flagβ€ ΟƒΟ„ΞΏ trac.ini ΟƒΞΏΟ…**

1. \[project] footer Ξ­Ο‡ΞµΞΉ link ΟƒΟ„ΞΏ trac.edgewall (default). Ξ”ΞµΞ½ ΞµΞ―Ξ½Ξ±ΞΉ Ο€ΟΟΞ²Ξ»Ξ·ΞΌΞ±.
2. base_url ΞµΞ―Ξ½Ξ±ΞΉ ΞΊΞµΞ½Ο. Ξ‘Ξ½ ΞΈΞµΟ‚ ΟƒΟ‰ΟƒΟ„Ξ¬ links ΟƒΞµ notifications, ΞΊΞ¬Ο€ΞΏΞΉΞ± ΟƒΟ„ΞΉΞ³ΞΌΞ® ΞΈΞ± Ο„ΞΏ ΞΏΟΞ―ΟƒΞµΞΉΟ‚ (Ξ±Ξ»Ξ»Ξ¬ Ξ±Ο†ΞΏΟ Ο€ΟΟΟ„Ξ± ΟƒΞ·ΞΊΟΟƒΞµΞΉΟ‚ Ο„ΞΏ ΟƒΟΟƒΟ„Ξ·ΞΌΞ±).
 
**Ξ£Ο…ΞΌΟ€Ξ­ΟΞ±ΟƒΞΌΞ±**

1. Ξ‘Ο…Ο„Ο Ο„ΞΏ trac.ini Ξ΄ΞµΞ―Ο‡Ξ½ΞµΞΉ ΟΟ„ΞΉ ΞΈΞµΟ‚:
2. SVN repo ΟƒΟ„ΞΏ /var/lib/svn/SchedulePro
3. Trac env Ο€ΞΏΟ… Ξ­Ο‡ΞµΞΉ Ο„ΞΏ sqlite DB ΞΌΞ­ΟƒΞ± (db/trac.db)
4. Ξ“ΞΉΞ± Ο€ΟΞ±Ξ³ΞΌΞ±Ο„ΞΉΞΊΞ® ΞΌΞµΟ„Ξ±Ο†ΞΏΟΞ¬ Ξ­ΟΞ³ΞΏΟ…:
5. Ξ±Ξ½Ο„ΞΉΞ³ΟΞ¬Ο†ΞµΞΉΟ‚ **ΞΏΞ»ΟΞΊΞ»Ξ·ΟΞΏ** Ο„ΞΏ Trac environment directory, ΟΟ‡ΞΉ ΞΌΟΞ½ΞΏ config.
6. Apache config ΟƒΟ„ΞΏ Ξ½Ξ­ΞΏ ΞΌΞ·Ο‡Ξ¬Ξ½Ξ·ΞΌΞ±:
7. Ξ­Ξ½Ξ± /svn Location ΞΌΞµ SVNParentPath /var/lib/svn
8. Ξ­Ξ½Ξ± /trac WSGI Ο€ΟΞΏΟ‚ /var/lib/trac/SchedulePro/cgi-bin/trac.wsgi

Ξ‘Ξ½ ΞΌΞΏΟ… Ξ΄ΟΟƒΞµΞΉΟ‚ Ξ±Ο€Ο Ο„ΞΏ Ο€Ξ±Ξ»ΞΉΟ ΞΌΞ·Ο‡Ξ¬Ξ½Ξ·ΞΌΞ± Ο„ΞΏ Apache block Ο€ΞΏΟ… ΞµΞ―Ο‡ΞµΟ‚ (Ο„ΞΏ \<Location /svn\> ΞΊΞ±ΞΉ Ο„ΞΏ ΞΊΞΏΞΌΞΌΞ¬Ο„ΞΉ Trac), ΟƒΞΏΟ… Ξ»Ξ­Ο‰ Ξ±ΞΊΟΞΉΞ²ΟΟ‚ Ο„ΞΉ ΞΌΞµΟ„Ξ±Ο†Ξ­ΟΞµΞΉΟ‚ ΞΊΞ±ΞΉ Ο„ΞΉ Ξ±Ξ»Ξ»Ξ¬Ξ¶ΞµΞΉΟ‚ Ο‡Ο‰ΟΞ―Ο‚ Ξ½Ξ± Ο„ΞΏ ΞΎΞ±Ξ½Ξ±ΟƒΟ„Ξ®ΟƒΞµΞΉΟ‚ Ξ±Ο€Ο Ο„Ξ·Ξ½ Ξ±ΟΟ‡Ξ®.
 \> Ξ‘Ο€Ο \<[https://chatgpt.com/g/g-p-68cbbce7e5548191a60334ef85b4335f/c/696a3d12-7bc8-8325-8fcd-ff83b5ec0b03](https://chatgpt.com/g/g-p-68cbbce7e5548191a60334ef85b4335f/c/696a3d12-7bc8-8325-8fcd-ff83b5ec0b03)\>







