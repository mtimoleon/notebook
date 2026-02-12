---
categories:
  - "[[Work]]"
  - "[[Issues]]"
created: 2025-10-07T10:07
tags:
  - intelligen
  - keycloak
status: completed
product: ScpCloud
component: Keycloak
---
Σύνοψη διαφορών του realm-export-with-roles σε σχέση με το προηγούμενο export:
	1. Προσθήκη realm role
– Προστίθεται νέο realm role test realm role στη λίστα roles.realm. 
realm-export-with-roles
	2. Scope mapping του ρόλου στο client scpCloud
– Νέο entry στο scopeMappings που αποδίδει το realm role test realm role στο client scope του scpCloud, ώστε όταν ο χρήστης διαθέτει τον ρόλο, να μπορεί να εκδοθεί στο token του συγκεκριμένου client. 
realm-export-with-roles
– Στο προηγούμενο export υπήρχε μόνο mapping για offline_access. 
realm-export (1)
	3. Client-scope mappings για το account console
– Προστίθεται clientScopeMappings ώστε το account-console να λαμβάνει το role manage-account μέσω του client scope account. 
realm-export-with-roles
	4. Αλλαγή στο built-in client scope profile
– include.in.token.scope αλλάζει σε "true" (ήταν "false"), άρα attributes του profile μπορούν να μπαίνουν στο token όταν ζητείται το scope. 
realm-export-with-roles

realm-export (1)
	5. Ενισχυμένα δικαιώματα στο service account του scp-admin-service
– Ο χρήστης service-account-scp-admin-service αποκτά client roles στο realm-management (view-users, query-users, manage-users). 
realm-export-with-roles
– Στο προηγούμενο export δεν υπήρχαν αυτά τα client roles στον ίδιο service account. 
realm-export (1)

+ roles.realm. "name": "test realm role",

	• Full export από το Keycloak cli
	```
	/opt/keycloak/bin/kc.sh export --realm ScpCloud --dir /opt/keycloak/data/export --users realm_file
	```
	• Restore
	```
	/opt/keycloak/bin/kc.sh import --realm ScpCloud --dir /opt/keycloak/data/export --strategy OVERWRITE_EXISTING
	```




