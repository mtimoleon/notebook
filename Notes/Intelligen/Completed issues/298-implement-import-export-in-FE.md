---
categories:
  - "[[Work]]"
  - "[[Issues]]"
created: 2025-02-19T09:54
tags:
  - intelligen
status: completed
product: ScpCloud
---

- [x] One object:  

```
{
options: {
recipeTypes:[],
operationTypes:[],
equipmentTypes:[],
outageTemplates:[]
},
materials: [],
facilities:[],
recipes: []
}
```
 
- [x] Delete workspace  
	We do not check anything about the user rights?  
- [x] Each export will have its own dto structure, for example  
	for recipes will be:  

```
		{
		recipes:[]
		}
```

- [x] Fix grpcCalls interceptors  
- [x] Cleanup json serializers use in import export service  
	Implement workspace export (materials part) in import export service  
- [x] Get workspace id from request info provider into command handler not in server  
	for import workspace command



