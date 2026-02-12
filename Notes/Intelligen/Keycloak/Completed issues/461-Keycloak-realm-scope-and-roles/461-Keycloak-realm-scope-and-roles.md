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
Ξ£ΟΞ½ΞΏΟΞ· Ξ΄ΞΉΞ±Ο†ΞΏΟΟΞ½ Ο„ΞΏΟ… realm-export-with-roles ΟƒΞµ ΟƒΟ‡Ξ­ΟƒΞ· ΞΌΞµ Ο„ΞΏ Ο€ΟΞΏΞ·Ξ³ΞΏΟΞΌΞµΞ½ΞΏ export:
	1. Ξ ΟΞΏΟƒΞΈΞ®ΞΊΞ· realm role
β€“ Ξ ΟΞΏΟƒΟ„Ξ―ΞΈΞµΟ„Ξ±ΞΉ Ξ½Ξ­ΞΏ realm role test realm role ΟƒΟ„Ξ· Ξ»Ξ―ΟƒΟ„Ξ± roles.realm. 
realm-export-with-roles
	2. Scope mapping Ο„ΞΏΟ… ΟΟΞ»ΞΏΟ… ΟƒΟ„ΞΏ client scpCloud
β€“ ΞΞ­ΞΏ entry ΟƒΟ„ΞΏ scopeMappings Ο€ΞΏΟ… Ξ±Ο€ΞΏΞ΄Ξ―Ξ΄ΞµΞΉ Ο„ΞΏ realm role test realm role ΟƒΟ„ΞΏ client scope Ο„ΞΏΟ… scpCloud, ΟΟƒΟ„Ξµ ΟΟ„Ξ±Ξ½ ΞΏ Ο‡ΟΞ®ΟƒΟ„Ξ·Ο‚ Ξ΄ΞΉΞ±ΞΈΞ­Ο„ΞµΞΉ Ο„ΞΏΞ½ ΟΟΞ»ΞΏ, Ξ½Ξ± ΞΌΟ€ΞΏΟΞµΞ― Ξ½Ξ± ΞµΞΊΞ΄ΞΏΞΈΞµΞ― ΟƒΟ„ΞΏ token Ο„ΞΏΟ… ΟƒΟ…Ξ³ΞΊΞµΞΊΟΞΉΞΌΞ­Ξ½ΞΏΟ… client. 
realm-export-with-roles
β€“ Ξ£Ο„ΞΏ Ο€ΟΞΏΞ·Ξ³ΞΏΟΞΌΞµΞ½ΞΏ export Ο…Ο€Ξ®ΟΟ‡Ξµ ΞΌΟΞ½ΞΏ mapping Ξ³ΞΉΞ± offline_access. 
realm-export (1)
	3. Client-scope mappings Ξ³ΞΉΞ± Ο„ΞΏ account console
β€“ Ξ ΟΞΏΟƒΟ„Ξ―ΞΈΞµΟ„Ξ±ΞΉ clientScopeMappings ΟΟƒΟ„Ξµ Ο„ΞΏ account-console Ξ½Ξ± Ξ»Ξ±ΞΌΞ²Ξ¬Ξ½ΞµΞΉ Ο„ΞΏ role manage-account ΞΌΞ­ΟƒΟ‰ Ο„ΞΏΟ… client scope account. 
realm-export-with-roles
	4. Ξ‘Ξ»Ξ»Ξ±Ξ³Ξ® ΟƒΟ„ΞΏ built-in client scope profile
β€“ include.in.token.scope Ξ±Ξ»Ξ»Ξ¬Ξ¶ΞµΞΉ ΟƒΞµ "true" (Ξ®Ο„Ξ±Ξ½ "false"), Ξ¬ΟΞ± attributes Ο„ΞΏΟ… profile ΞΌΟ€ΞΏΟΞΏΟΞ½ Ξ½Ξ± ΞΌΟ€Ξ±Ξ―Ξ½ΞΏΟ…Ξ½ ΟƒΟ„ΞΏ token ΟΟ„Ξ±Ξ½ Ξ¶Ξ·Ο„ΞµΞ―Ο„Ξ±ΞΉ Ο„ΞΏ scope. 
realm-export-with-roles

realm-export (1)
	5. Ξ•Ξ½ΞΉΟƒΟ‡Ο…ΞΌΞ­Ξ½Ξ± Ξ΄ΞΉΞΊΞ±ΞΉΟΞΌΞ±Ο„Ξ± ΟƒΟ„ΞΏ service account Ο„ΞΏΟ… scp-admin-service
β€“ Ξ Ο‡ΟΞ®ΟƒΟ„Ξ·Ο‚ service-account-scp-admin-service Ξ±Ο€ΞΏΞΊΟ„Ξ¬ client roles ΟƒΟ„ΞΏ realm-management (view-users, query-users, manage-users). 
realm-export-with-roles
β€“ Ξ£Ο„ΞΏ Ο€ΟΞΏΞ·Ξ³ΞΏΟΞΌΞµΞ½ΞΏ export Ξ΄ΞµΞ½ Ο…Ο€Ξ®ΟΟ‡Ξ±Ξ½ Ξ±Ο…Ο„Ξ¬ Ο„Ξ± client roles ΟƒΟ„ΞΏΞ½ Ξ―Ξ΄ΞΉΞΏ service account. 
realm-export (1)

+ roles.realm. "name": "test realm role",

	β€Ά Full export Ξ±Ο€Ο Ο„ΞΏ Keycloak cli
	```
	/opt/keycloak/bin/kc.sh export --realm ScpCloud --dir /opt/keycloak/data/export --users realm_file
	```
	β€Ά Restore
	```
	/opt/keycloak/bin/kc.sh import --realm ScpCloud --dir /opt/keycloak/data/export --strategy OVERWRITE_EXISTING
	```








