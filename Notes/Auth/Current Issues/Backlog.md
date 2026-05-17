---
categories:
  - "[[Work]]"
created: 2026-02-24
product:
component:
status:
tags:
  - issues/auth
---


## e-Consent

- [x] Create ssh keys and add to jenkins and server  
- [x] Temporarily copy files from captain server to e-consent server  
- [x] Copy database from Captain server to e-consent-server  
[https://stackoverflow.com/questions/5495137/how-do-i-copy-a-database-from-one-mongodb-server-to-another](https://stackoverflow.com/questions/5495137/how-do-i-copy-a-database-from-one-mongodb-server-to-another)  
- [x] Create the e-consent services, production and develop  
- [x] Check if service is working  
- [x] Stop service  
- [ ] Update jenkins pipline using the new keys and server  
```
pipeline {
    agent any
    stages {
        stage('Deploy') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'my-ssh-key', keyFileVariable: 'KEY_FILE', usernameVariable: 'USER')]) {
                    sh "ssh -i $KEY_FILE $USER@your-server 'your-command'"
                }
            }
        }
    }
}
```
- [ ] Upgrade application packages to latest versions  
- [ ] Deploy to the new server  
- [x] Check flow described here: [https://docs.google.com/document/d/1T-OAsXGD2NHtFzlLksog1PB3c1vnLGAF/edit](https://docs.google.com/document/d/1T-OAsXGD2NHtFzlLksog1PB3c1vnLGAF/edit)  
- [ ] Add api endpoint
```
UserRole {  
	User = 0,  
	SuperUser = 1,  
	Admin = 2,  
	SuperAdmin = 3,  
}
sub {  
	service  
	user  
}
```
- First we need an account id: 1616d626-026f-11eb-ba9c-00505692f913
- Then add a user for this account id with role 2, Admin
- Then we need to create the admin token for this account, using the appropriate secret base64 encoded, also in the dev app temprarily we do not check for token expiration
- Then add a project
- Then add a subject
- Then upload a template
- Ask for consent
```
{  
	"id": {  
	"$oid": "62de84768105f58c68b20e94"  
	},  
	"contactMethods": ,  
	"accountId": "1616d626-026f-11eb-ba9c-00505692f913",  
	"role": 2,  
	"firstname": "mi",  
	"lastname": "timo",  
	"email": "mitimo@gmail.com",  
	"v": 0  
}  
{  
	"sub": "user",  
	"id": "62de842b8105f58c68b20e93",  
	"iat": 1516239022,  
	"exp": 1916239999,  
	"role": "Admin",  
	"accountId": "1616d626-026f-11eb-ba9c-00505692f913"  
}
```
- [ ] They will add a callback url in the study.  
- [ ] When a user accepts, rejects or withraw consent we will post the relative information to their url.  
- [ ] if they want different languages they have to create the corresponding Studies  
- [ ] We need to create a queue to record the unsuccessful requests  
- [ ] When a study gets updated the pending requests should get the new caleback url from the updated stuly.  
- [ ] We need to implement consent withdrawal.

## Panel management

[https://assos-auth.atlassian.net/browse/RAI-199](https://assos-auth.atlassian.net/browse/RAI-199)  
Show refresh button when frontend is updated
 
- **RAISE** - # **PANEL MANAGEMENT**
    - [ ] Delete interactions when we delete a user only.  
    - [ ] Check automapper for typescript (PM-server)  
    - [ ] Add consent templates  
    - [ ] Add project consents  
    - [ ] Add a link to panel management public search in vitalise project website
    - [Notes](Notes/Projects/enoll/Notes.md)
    - Other ideas for the application  
- [ ] Fix user for mysql @ raise2vm and raise service use  
- [ ] Check panel management backup info and logs backups  
- [ ] RCN zombi processes ==@Nikos==
[https://mail.google.com/mail/u/0/?tab=rm&ogbl#inbox/FMfcgzQcpwvDFGkNXdwMkVBhWlCfHTld](https://mail.google.com/mail/u/0/?tab=rm&ogbl#inbox/FMfcgzQcpwvDFGkNXdwMkVBhWlCfHTld)  
- [ ] e-consent  
- [x] **Blockchain**
==Database choose==
Generic schema
- [ ] ==Statistics==  
- [ ] Update sto UI ==@Petsani,==  
- [ ] Na doyme ta test toy enoll-accelup giati argoyn  
- [ ] Na ftiaxoyme flow gia to bussines logic kai na veltiosoyme ton kodika  
- [ ] Neo project που θα κάνει enhance το app από Οκτώβριο/Νοέμβριο  
- [ ] Όταν στέλνει Email για project να κόβεται το text αν ξεπερνάει τους 2000 χαρακτήρες  
[https://mail.google.com/mail/u/0/#inbox/FMfcgzQXJGmqlVwZbDjfLxhLfzLmkCQf](https://mail.google.com/mail/u/0/#inbox/FMfcgzQXJGmqlVwZbDjfLxhLfzLmkCQf)
- [ ] Review documents  
[https://drive.google.com/open?id=1ZqakhlPOYzVpMNIuDiZR8XY3K9K-Kzdi&usp=drive_fs](https://drive.google.com/open?id=1ZqakhlPOYzVpMNIuDiZR8XY3K9K-Kzdi&usp=drive_fs)  
- [ ] Suggested New Features 4/9/2025
[https://mail.google.com/mail/u/0/?ui=2#inbox/FMfcgzQbgJRqcjQKrjqqDJclwgcFXxnK](https://mail.google.com/mail/u/0/?ui=2#inbox/FMfcgzQbgJRqcjQKrjqqDJclwgcFXxnK)  
- [ ] Exoyme kati gia email contact sto consent confirmation. To see ==@Nikos== requests  
- [ ] To check if backup is taken properly  
- [ ] Na steilo Niko token gia postman
- [ ] EMQX 5.8.9
[https://docs.emqx.com/en/emqx/v5.8/admin/api-docs.html](https://docs.emqx.com/en/emqx/v5.8/admin/api-docs.htmlhttps://docs.emqx.com/en/emqx/v5.8/getting-started/new-features.htmlhttps://github.com/emqx/emqx/tree/v5.8.9)
https://docs.emqx.com/en/emqx/v5.8/getting-started/new-features.html
https://github.com/emqx/emqx/tree/v5.8.9**
**  
- [ ] Get RAISE installer/RCN ==security== suggestions ==@Nikos, also Hernandez sent email==
[https://mail.google.com/mail/u/0/?tab=rm&ogbl#inbox/FMfcgzQcqHXNpPLrzMVHcwrldzpPhhJB](https://mail.google.com/mail/u/0/?tab=rm&ogbl#inbox/FMfcgzQcqHXNpPLrzMVHcwrldzpPhhJBhttps://mail.google.com/mail/u/0/?tab=rm&ogbl#inbox/FMfcgzQcqbVqWrPwxStStLzTgvDZRRXz)
https://mail.google.com/mail/u/0/?tab=rm&ogbl#inbox/FMfcgzQcqbVqWrPwxStStLzTgvDZRRXz  
- [ ] RAISE Architecture draw.io [https://drive.google.com/file/d/180BgZ3nkKciSbHpNjbQWC0OrmYDHu02n/view?usp=sharing](https://drive.google.com/file/d/180BgZ3nkKciSbHpNjbQWC0OrmYDHu02n/view?usp=sharing)  
- [ ] Dataset hash  
- [ ] New script languages  
- [ ] Mεταφορα dataset apo node se node ==Evelina==, το έχουν αφήσει 18/12  
θα το δουμε στο technical meet  
- [ ] Check blockchain [https://github.com/AUTH-ASSOS/raise-fabric/compare/Adjust_endpoints](https://github.com/AUTH-ASSOS/raise-fabric/compare/Adjust_endpoints)  
- [ ] OpenAire graph, Katertsidis, tha mas xtypaei o emeis kai tha dinyome metadata gia to dataset  
Create endpoint to serve data for UoM graph ==Evelina==  
**Openaire Knowledge Graph**  
**Goal**: Send experiment and dataset details to Openaire Knowledge Graph using the OAI-PMH guidelines  
**Links**:  
- OAI-PMH Implementation Guidelines (openarchives.org) [https://www.openarchives.org/OAI/2.0/guidelines.htm](https://www.openarchives.org/OAI/2.0/guidelines.htm)  
- OpenAIRE Guidelines for Data Archives — OpenAIRE Guidelines documentation [https://guidelines.openaire.eu/en/latest/data/index.html](https://guidelines.openaire.eu/en/latest/data/index.html)  
- Overview | OpenAIRE Graph Documentation [https://graph.openaire.eu/docs/](https://graph.openaire.eu/docs/)  
**– Currently in planning (****από το προηγούμενο** **project)**  
Nikos from UOWM has been trying to see what information will go to the XMLs needed to be send to OPENAIRE  
We need to “translate” the required information to what we already keep in the database  
Create the endpoint  
If needed add extra info in the RAI PID metadata  
- [ ] Csv descriptive statistics (Json object το αποθηκεύουμε στη db)  
- [ ] Να ενημερώνουμε τη σελίδα με τα στατιστικά για experiments  
- [ ] Create an empty PID first, then get from node the results and write in the block chain PID number along with results  
==@Michalis== ==@Evelina== flow gia blockchain:  
A PID is reserved by the node: Once the results are ready, the node calls the RCH and asks for a temporary PID (which is created as empty from the PID provider). The node rights the block to the Blockchain, containing the reserved PID. The results with the Blockchain transaction id (or the hash) are sent from the node to the registration service of the RCH. The PID is updated with the metadata of the experiment and the results and it is registered in the RCH results registry.  
- [ ] Να βάλουμε κάπου στο portal ή αλλού οδηγίες για το **πως κάποιος χρησιμοποιεί τα** **scripts** **και τα** **experiments**  
- [ ] Να βάλουμε properties για τα dataset: inheritedFrom, related dataset, relevant dataset  
- [ ] Να βάλουμε τη λειτουργία των dataset access requests και στα scripts  
- [ ] Blockchain flow  
Στο blockchain που θα γράφουμε το PID, μπορούμε να γράφουμε και το hash του zip που κατεβάζει ο ερευνητής με τα αποτελέσματα μόλις τρέξει το πείραμα? Τα αποτελέσματα ενός πειράματος μένουν στο node. Από εκεί τα κατεβάζει ο ερευνητής. Αν κάποια στιγμή το node βγει εκτός, ο μοναδικός τρόπος να πιστοποιήσει ο ερευνητής ότι τα αποτελέσματα είναι αυτά είναι το hash του zip και αυτό που είναι γραμμένο στο blockchain να είναι το ίδιο.  
ή κάτι αντίστοιχο για να διασφαλίσουμε ότι μπορούν να πιστοποιηθούν τα αποτελέσματα, ακόμη και αν το node βγει εκτός και να ενημερώνουμε τον ερευνητή ότι πρέπει να κρατήσει το zip ίσως ή, να μαζεύουμε εμείς όλα τα αποτελέσματα κάπου (που νομίζω είναι too much σε αυτή τη φάση)
Μπορούμε να γράφουμε το zip σε κάποιο storage τύπου amazon s3 glasier που είναι και φθηνό ή σε δικό μας minio server. Πάντως γίνεται, το βλέπουμε…
\> Από \<[https://app.slack.com/client/T01G0UHD76U/D01FB9ZLGTD](https://app.slack.com/client/T01G0UHD76U/D01FB9ZLGTD)\>  
- [ ] Node registration  
- [ ] **Projects** which contains many experiments  
- [ ] Relative papers for datasets in metadata  
- [ ] Datasets details to have a PID for ethical approval  
- [x] EPIC GR NET production user ==EVELINA==

- [ ] Infrastructures add properties:  
- [ ] IsAvailable (boolean)
- [ ] Organization add property  
- [ ] IsPublicSearchAvailable Organization is available for public search
Associastions to include member type eg "parkinson", then on llb reading to dynamically calculate the number of members belonging to several types
Create an enum with member types and associate this with a table in database.
Add readonly property in services categories etc.  
We will add some readonly rows and then we will leave it open to cosumers.  
When a user defined entity of the above is removed we will check if it used by someon else. If not we will remove it also from the db.
(Initial idea: Services, equipment categories, equipment subcategories, will be added hardcoded by super admin.  
Devices will be added by consumers.)

