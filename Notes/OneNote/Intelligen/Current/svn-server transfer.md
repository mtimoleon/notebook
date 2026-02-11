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
- SVN repositories restored from `svnadmin hotcopy`
- Trac environments restored fully (SQLite)
- HTTPS enabled with self-signed or existing certificates
- Authentication via Apache Basic Auth
- Optional SVN path-based authorization (`authz`)
 
1. Assumptions

- Old server still exists **or** valid `svnadmin hotcopy` backups exist
- Trac version ≥ 1.6
- Target filesystem paths:
    - SVN: `/var/lib/svn`
    - Trac: `/var/lib/trac`
- Apache user: `www-data`
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
File _/etc/apache2/apache2.conf_  
Add line `ServerName \<your-server-ip\>`
 
HTTP (80)  
`/etc/apache2/sites-available/000-default.conf` (Standard, unchanged)
 
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
 If this fails → **stop**. Re-take hotcopy from the old server with all services stopped.
 
8. Restore Trac Environments  
Restore **entire environments**, not just `trac.ini`.  
Also copy `/var/www/trac.wsgi` to the new machine (same place).  

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
 Copy backup scripts from the old machine into `/var/lib/backup/scripts` (at minimum `hotcopy.sh` and `backup_rotated_30.sh`) and ensure they are executable.  
`backup_rotated_30.sh` is the wrapper that:

- runs `/var/lib/backup/scripts/hotcopy.sh`
- archives `/var/lib/backup/hotcopy` into `/var/lib/backup/hotcopy-backups/${hostname}-YYYY-MM-DD.tgz`
- enforces 30-day retention in `/var/lib/backup/hotcopy-backups` (deletes files older than 30 days)
- NOTE: if it runs multiple times per day it will overwrite the same daily filename unless you include time in the archive name

Make scripts executable:  

```
chmod 755 /var/lib/backup/scripts/*.sh

```
 _CAUTION: svnadmin needs the projects folder to exist in order to perform hotcopy. So you need to take care the folders creation before script run or fix it inside the script._  
Create a daily cron job (runs as `root`) at 07:00:  

```
cat \> /etc/cron.d/svn-trac-hotcopy \<\<'EOF'
0 7 * * * root /var/lib/backup/scripts/backup_rotated_30.sh 2\>&1 | logger -t backup-hotcopy-job
EOF
chmod 644 /etc/cron.d/svn-trac-hotcopy

```
 If you create cronjob wihtin webmin you will find it under `/var/spool/cron/crontabs` inside `root` file.
 
12. Common Failure Causes (Post-mortem)

- Hotcopy taken while SVN was active
- SSL vhost not enabled → HTTP on port 443 → `wrong version number`
- Authz file blocks root access → `/svn` returns 403
 
13. Final Conclusion  
If **all of the following are true**, the migration is correct:

14. `svnadmin verify` passes
15. ```
    https://server/svn/
    ```
    
     is browsable with auth
16. ```
    https://server/trac
    ```
    
     loads and shows commits
   

Παρακάτω είναι συγκεντρωμένες, πρακτικές οδηγίες για **καθαρή νέα εγκατάσταση SVN + Trac** και **μεταφορά repos από hotcopy backup**.
 
**Στόχος εγκατάστασης**

1. SVN repositories κάτω από /var/lib/svn
2. Trac environments κάτω από /var/lib/trac
3. Apache ως front-end (DAV SVN + Trac μέσω mod_wsgi ή CGI)
4. Μεταφορά **αυτούσιων repos** από svnadmin hotcopy
5. Έλεγχος και μεταφορά μόνο των ουσιαστικών ρυθμίσεων από το παλιό μηχάνημα
 
**1. Προαπαιτούμενα πακέτα (Ubuntu Server)**  
Ελάχιστα και κλασικά:

- subversion
- apache2
- libapache2-mod-svn
- trac
- python3
- python3-pip
- (αν Trac με WSGI) libapache2-mod-wsgi-py3

Δεν χρειάζεσαι database server αν το Trac είναι με SQLite (default και προτείνεται).
 
**2. Δομή φακέλων (σταθερή – μην την αλλάξεις)**  
/var/lib/
 ├── svn/
 │ ├── repo1/
 │ ├── repo2/
 │ └── ...
 └── trac/
 ├── project1/
 ├── project2/
 └── ...
  
Ιδιοκτήτης:  
chown -R www-data:www-data /var/lib/svn /var/lib/trac
chmod -R 750 /var/lib/svn /var/lib/trac
  
Αν στο παλιό σύστημα έτρεχε με svn user αντί για www-data, το **ελέγχεις πρώτα** (βλ. ενότητα 6).
 
**3. Μεταφορά SVN repositories (hotcopy)**  
Αφού τα backup είναι svnadmin hotcopy, ΔΕΝ κάνεις dump/load.  
**Βήματα**

1. Αντιγραφή repos:

rsync -a repo1 /var/lib/svn/


1. Έλεγχος:

svnadmin verify /var/lib/svn/repo1


1. Διόρθωση permissions (απαραίτητο):

chown -R www-data:www-data /var/lib/svn/repo1
  
Αν αποτύχει το verify → σταματάς εδώ. Δεν πας παρακάτω.
 
**4. Apache + SVN (mod_dav_svn)**  
**Ελάχιστο VirtualHost παράδειγμα**  
\<Location /svn\>
 DAV svn
 SVNParentPath /var/lib/svn
  
AuthType Basic
 AuthName "Subversion"
 AuthUserFile /etc/apache2/svn.passwd
 Require valid-user
\</Location\>
  
==Ενεργοποίηση modules:==  
a2enmod dav
a2enmod dav_svn
systemctl reload apache2

 
**5. Trac – νέα εγκατάσταση & σύνδεση με υπάρχον SVN**  
**Δημιουργία Trac environment**  
trac-admin /var/lib/trac/project1 initenv


- Database: sqlite
- Repository type: svn
- Repository path: /var/lib/svn/repo1

Μετά:  
chown -R www-data:www-data /var/lib/trac/project1
  
**Apache – Trac μέσω WSGI (προτεινόμενο)**  
WSGIDaemonProcess trac user=www-data group=www-data threads=5
WSGIProcessGroup trac
  
WSGIScriptAlias /trac /var/lib/trac/project1/cgi-bin/trac.wsgi
  
\<Directory /var/lib/trac/project1\>
 Require all granted
\</Directory\>

 
**6. Τι ΠΡΕΠΕΙ να ελέγξεις από την παλιά εγκατάσταση (πολύ σημαντικό)**  
**A. SVN repositories**  
Στο παλιό μηχάνημα:

1. **Hooks**

hooks/
 ├── pre-commit
 ├── post-commit
 └── start-commit


- Αν υπάρχουν custom scripts → πρέπει να μεταφερθούν.
- Έλεγξε paths hardcoded (π.χ. /usr/bin/python, mailer paths).
- **svnserve.conf / authz**
- Αν χρησιμοποιούσες file-based authz:

conf/authz
conf/svnserve.conf


1. **FS type**

svnadmin info /path/to/repo
  
Αν είναι FSFS (99% πιθανό), δεν σε νοιάζει.
 
**B. Apache configs (παλιά μηχανή)**  
Ψάχνεις ΜΟΝΟ αυτά:  
grep -R "SVN" /etc/apache2
grep -R "trac" /etc/apache2
  
Κράτα:

- SVNParentPath
- AuthUserFile
- AuthzSVNAccessFile
- custom \<Location\> blocks

ΜΗΝ μεταφέρεις ολόκληρα conf αρχεία στα τυφλά.
 
**C. Trac configs (παλιά μηχανή)**  
Από κάθε project:  
/var/lib/trac/project/conf/trac.ini
  
Κρίσιμα sections:

- [components] (plugins)
- [trac]
- [repository]
- [repositories]
- [browser]
- [logging]

Αν έχεις plugins:  
plugins/
  
→ πρέπει να αντιγραφούν ή να επανεγκατασταθούν.
 
**7. Permissions & SELinux (αν υπάρχει)**

- Σε Ubuntu συνήθως **δεν υπάρχει SELinux**.
- Αν είναι enabled → θέλει context για Apache access (σπάνιο).
 
**8. Τελικά checks**

1. Apache:

apachectl configtest


1. SVN μέσω browser:

[http://server/svn/repo1](http://server/svn/repo1)


1. Trac:

[http://server/trac](http://server/trac)


1. Trac ↔ SVN sync:

trac-admin /var/lib/trac/project1 resync

 
**Συμπέρασμα (ξεκάθαρο)**

1. Hotcopy → απλή αντιγραφή + verify, όχι dump/load.
2. Όλη η ουσία είναι:
    - hooks
    - apache auth / paths
    - trac.ini
3. Κράτα **ίδια paths** (/var/lib/...) για να μην κυνηγάς hardcoded ρυθμίσεις.
4. Μην μεταφέρεις configs wholesale. Παίρνεις μόνο ό,τι εξυπηρετεί.

Αν θέλεις, επόμενο βήμα:

- να μου δώσεις **ένα παλιό trac.ini** και **ένα apache \<Location\> block** και να σου πω τι κρατάς και τι πετάς.
 \> Από \<[https://chatgpt.com/g/g-p-68cbbce7e5548191a60334ef85b4335f/c/696a3d12-7bc8-8325-8fcd-ff83b5ec0b03](https://chatgpt.com/g/g-p-68cbbce7e5548191a60334ef85b4335f/c/696a3d12-7bc8-8325-8fcd-ff83b5ec0b03)\>     

**Τι βλέπω από το trac.ini που έστειλες**

1. Το Trac είναι **SQLite**:
2. \[trac] database = sqlite:db/trac.db
3. Έχεις ορισμένο **ένα SVN repository** με όνομα SchedulePro:
4. \[repositories] SchedulePro.dir = /var/lib/svn/SchedulePro
5. \[versioncontrol] default_repository = SchedulePro
6. Το SVN integration είναι ενεργό:
7. \[components] tracopt.versioncontrol.svn.* = enabled
8. Δεν χρησιμοποιείς Trac-side authz:
9. \[svn] authz_file = (κενό)
10. Δεν φαίνεται κάτι “περίεργο”/custom σε plugins (δεν έχεις \[components] entries εκτός του svn), άρα μάλλον **vanilla Trac** χωρίς extra plugins.

Συμπέρασμα: το trac.ini αυτό μεταφέρεται σχεδόν αυτούσιο. Το κρίσιμο είναι να **υπάρχει repo στο ίδιο path** /var/lib/svn/SchedulePro στο νέο μηχάνημα (όπως είπες ότι θα στήσεις κάτω από /var/lib).
 
**Τι πρέπει να κρατήσεις/αντιγράψεις αυτούσιο**

1. Όλο το trac.ini όπως είναι (εκτός αν αλλάξει hostname/base_url αργότερα).
2. Το Trac environment folder (αν θέλεις πλήρη μεταφορά tickets/wiki):
3. ΟΧΙ μόνο trac.ini.
4. Χρειάζεσαι και db/trac.db, files/attachments, htdocs, κ.λπ.

Αν θες “μεταφορά έργου” και όχι “νέο κενό Trac”, τότε κάνεις rsync όλο το env.
 
**Μεταφορά Trac project από παλιό μηχάνημα (σωστός τρόπος)**  
Ας πούμε ότι το παλιό env είναι:  
/var/lib/trac/SchedulePro  
Στο νέο:

1. Δημιουργείς φάκελο προορισμού:

mkdir -p /var/lib/trac


1. Αντιγράφεις ΟΛΟ:

rsync -a /path/to/backup/SchedulePro /var/lib/trac/


1. Permissions:

chown -R www-data:www-data /var/lib/trac/SchedulePro
chmod -R 750 /var/lib/trac/SchedulePro


1. Upgrade (ανάλογα με έκδοση Trac, καλό είναι να το τρέξεις):

trac-admin /var/lib/trac/SchedulePro upgrade
trac-admin /var/lib/trac/SchedulePro wiki upgrade


1. Resync repository:

trac-admin /var/lib/trac/SchedulePro resync

 
**Μεταφορά SVN repo (hotcopy) ώστε να ταιριάξει με trac.ini**  
Το trac.ini ζητά:  
/var/lib/svn/SchedulePro  
Άρα στο νέο πρέπει να έχεις:  
/var/lib/svn/SchedulePro  
Βήματα:  
mkdir -p /var/lib/svn
rsync -a /path/to/hotcopy/SchedulePro /var/lib/svn/
chown -R www-data:www-data /var/lib/svn/SchedulePro
svnadmin verify /var/lib/svn/SchedulePro

 
**Apache config που πρέπει να έχεις για να “κουμπώσει” με αυτό το setup**  
**A. SVN location (parent path)**  
\<Location /svn\>
 DAV svn
 SVNParentPath /var/lib/svn
  
AuthType Basic
 AuthName "Subversion"
 AuthUserFile /etc/apache2/svn.passwd
 Require valid-user
\</Location\>
  
Αυτό θα δώσει URL:

- /svn/SchedulePro

Το Trac όμως ΔΕΝ χρειάζεται να βλέπει το repo από HTTP. Το βλέπει από filesystem (/var/lib/svn/SchedulePro), όπως ήδη έχεις.  
**B. Trac via WSGI**  
Θέλεις κάτι σαν:  
WSGIDaemonProcess trac user=www-data group=www-data threads=5
WSGIProcessGroup trac
  
WSGIScriptAlias /trac /var/lib/trac/SchedulePro/cgi-bin/trac.wsgi
  
\<Directory /var/lib/trac/SchedulePro\>
 Require all granted
\</Directory\>

 
**Τι να ψάξεις στην παλιά εγκατάσταση για SVN + Apache (λίστα “μόνο τα κρίσιμα”)**

1. Apache conf blocks που αφορούν svn/trac:
2. /etc/apache2/sites-available/*
3. /etc/apache2/conf-available/*
4. /etc/apache2/mods-enabled/dav_svn.conf (ή custom)
5. Στο \<Location /svn\> κοίτα:
6. SVNParentPath ή SVNPath (αν ήταν single repo)
7. AuthUserFile (πού είναι το password file)
8. AuthzSVNAccessFile (αν είχες per-path permissions)
9. Require rules
10. SVNListParentPath (αν εμφανίζει λίστα repos)
11. Password file:
12. συνήθως /etc/apache2/svn.passwd ή /etc/subversion/passwd
13. το μεταφέρεις αυτούσιο (είναι htpasswd hash file)
14. Hooks στα repos:
15. /var/lib/svn/SchedulePro/hooks/*
16. αυτά δεν τα “καλύπτει” το hotcopy αν τα έχεις στο repo hotcopy ναι, αλλά θέλεις να βεβαιωθείς ότι υπάρχουν και δουλεύουν (mail commit, integration, κ.λπ.)
 
**Το μόνο “red flag” στο trac.ini σου**

1. \[project] footer έχει link στο trac.edgewall (default). Δεν είναι πρόβλημα.
2. base_url είναι κενό. Αν θες σωστά links σε notifications, κάποια στιγμή θα το ορίσεις (αλλά αφού πρώτα σηκώσεις το σύστημα).
 
**Συμπέρασμα**

1. Αυτό το trac.ini δείχνει ότι θες:
2. SVN repo στο /var/lib/svn/SchedulePro
3. Trac env που έχει το sqlite DB μέσα (db/trac.db)
4. Για πραγματική μεταφορά έργου:
5. αντιγράφεις **ολόκληρο** το Trac environment directory, όχι μόνο config.
6. Apache config στο νέο μηχάνημα:
7. ένα /svn Location με SVNParentPath /var/lib/svn
8. ένα /trac WSGI προς /var/lib/trac/SchedulePro/cgi-bin/trac.wsgi

Αν μου δώσεις από το παλιό μηχάνημα το Apache block που είχες (το \<Location /svn\> και το κομμάτι Trac), σου λέω ακριβώς τι μεταφέρεις και τι αλλάζεις χωρίς να το ξαναστήσεις από την αρχή.
 \> Από \<[https://chatgpt.com/g/g-p-68cbbce7e5548191a60334ef85b4335f/c/696a3d12-7bc8-8325-8fcd-ff83b5ec0b03](https://chatgpt.com/g/g-p-68cbbce7e5548191a60334ef85b4335f/c/696a3d12-7bc8-8325-8fcd-ff83b5ec0b03)\>