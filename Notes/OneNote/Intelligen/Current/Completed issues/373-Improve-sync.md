Το βρήκα το πρόβλημα. Φαίνεται ότι όταν στο sync υπολογίζουμε τα overlapping batches δεν σκεφτήκαμε (σκέφτηκα) την περίπτωση να είχαμε ένα μακρύ batch με conflict με το επόμενο batch, το οποίο να κονταίνει και άρα να μην κάνει πια overlap (ούτε conflict) με το επόμενο. Επειδή δεν κάνει overlap δεν θα ανανεωθούν τα eocData του.
 
Η συνήθης κατάσταση είναι το batch να μακραίνει, αλλά παίζοντας με το revert των updates είχα την αντίθετη περίπτωση και έτσι είδα το πρόβλημα
 
Έχω μια καλή λύση νομίζω. Αν σώζουμε τα Start/End των batches κατά το sync ==(αυτό γίνεται στο batchcontents)==, μπορούμε να τσεκάρουμε το overlap και με τα δύο ζεύγη (Start/End και SyncStart/SyncEnd)  
Δηλαδή μας ενδιαφέρει να κάνουμε update τα batches που είτε τώρα κάνουν overlap είτε κάναν overlap στο προηγούμενο sync
 
Gia concurrency token poy den yparxei sto scheduling board ta svino sto production  
Gia concurrencty token poy allaxe vgazo olo  
Gia ta concurrency token poy den exoyn allaxei stelnei mono ta eocdata gia batches poy exoyn lower priority (precedence)
      



![[373-Improve-sync - Ink.svg|641x372]]


![[image-9.png]]


- [ ] full-sync  na ginei  full-production-sync 
- [ ] kai republish-all neo endpoint

