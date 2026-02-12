---
created: 2026-01-19T17:26
tags:
  - keycloak
  - intelligen
categories:
  - "[[Work]]"
  - "[[Issues]]"
status: completed
product: ScpCloud
---


- [x] Add planner role to the registered userοΏΌ This will take place during user registration when we create the user in keycloak from admin api after RegisterUserAsync
 
- [x] Check when I delete a user from admin if the workspaces/scheduling boards delete aswell, they delete alright  
- [x] For events coming to planning api bypass authorization, we already have it with ServerName != null in PlanningDbContext
 
- [ ] Should event commands be separated?  
When there is an event error we do not see it in UI only in backend logs if logged.
   
![Exported image](Exported%20image%2020260209135635-0.png)  
![Exported image](Exported%20image%2020260209135636-1.png)







