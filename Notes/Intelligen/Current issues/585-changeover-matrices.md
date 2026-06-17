---
categories:
  - "[[Work]]"
created: 2026-06-10
product: scpCloud
component:
status: open
tags:
  - issues/intelligen
---
## Context

## Notes
- [x] [GET] GetRecipeAttributePath in RecipeAttributeController
      Route: GET /planning/{workspaceId}/recipe-attribute/{id}/path
      Accepts recipeAttributeId as id in the route and returns RecipeAttributePathDto.
- [x] [POST] GetRecipeAttributeChangeoverMatrices in RecipeAttributeController
      Route: POST /planning/{workspaceId}/recipe-attribute/{id}/changeover-matrix/filtered-ordered-list
      Accepts recipeAttributeId as id in the route, FilterOrderDto in the body, offset and limit as query params,
      and returns a list of ChangeoverMatrixTableDto items, where each item includes id, name and concurrencyToken.
- [x] [POST] UpdateChangeoverMatrixName in ChangeoverMatrixController
      Route: POST /planning/{workspaceId}/changeover-matrix/{id}/update-name
      Accepts ChangeoverMatrixNameUpdateDto, including id, name and concurrencyToken.
      The DTO id must match the route id.
- [x] [POST] CreateChangeoverMatrix in 
      Route: POST /planning/{workspaceId}/changeover-matrix
      Accepts ChangeoverMatrixCreateDto, including recipeAttributeId and name.
- [x] [DELETE] DeleteChangeoverMatrices in ChangeoverMatrixController
      Route: DELETE /planning/{workspaceId}/changeover-matrix
      Accepts RequestByIdParentChildrenDto, where:
	- parentId = recipeAttributeId
	- arentConcurrencyToken = the RecipeAttribute concurrencyToken
	- children = list of ChangeoverMatrix ids to delete
- [x] [GET] GetChangeoverMatrixPanelById in ChangeoverMatrixController
      Route: GET /planning/{workspaceId}/changeover-matrix/panel/{id}
      Accepts changeoverMatrixId as id in the route and returns ChangeoverMatrixPanelDto.
      ChangeoverMatrixPanelDto should include TimeUnits and ChangeoverMatrix (ChangeoverMatrixDto, which includes ulong ConcurrencyToken, int Id, string Name, id RecipeAttributeId, string RecipeAtrributeName, list of RecipeAttributeValueDto RecipeAttributeValues, bool IsSymmetrical, bool ConsiderInIdleStateIfIdleFor, Time UsedIdleLimit and ChangeoverMatrixValues, a list of ChangeoverMatrixValueDto. Each ChangeoverMatrixValueDto includes RecipeAttributeValue From, RecipeAttributeValue  To and Time ChangeoverTime).
- [x] [POST] UpdateChangeoverMatrixValues in ChangeoverMatrixController
      Route: POST /planning/{workspaceId}/changeover-matrix/{id}/update-values
      Accepts changeoverMatrixId as id in the route, concurrencyToken, changeoverMatrixId, isSymmetrical, considerInIdleStateIfIdleFor, usedIdleLimitUnitId, usedIdleLimitValue and changeoverMatrixValues (a list of values, each including recipeAttributeFromId, recipeAttributeToId, changeoverTimeValue and changeoverTimeUnitId) in the request body.
      The DTO id must match the route id.
- [x] [POST] UpdateChangeoverMatrixIdentification in ChangeoverMatrixController
      Route: POST /planning/{workspaceId}/changeover-matrix/{id}/update-identification
      Accepts changeoverMatrixId as id in the route,  concurrencyToken, changeoverMatrixId and name in the request body.
      The DTO id must match the route id. (edited)
- [x] GetOperationPanelById θέλω να προστεθεί στο OperationPanelDto `List ChangeoverMatrixDto`. 
      Βέβαια δεν τα χρειάζομαι όλα από το ChangeoverMatrixDto, παρά μόνο id, name, recipeAttributeName. 
- [x] List EnumerationDto OperationDurationModes να προστεθεί με id 4 η επιλογή BasedOnChangeoverMatrix. 
- [x] UpdateOperationDuration στο OperationDurationUpdateDto να προστεθεί int changeoverMatrixId και πάλι nullable.
- [x] OperationDto να προστεθεί int changeoverMatrixId, που θα είναι nullable.  

- [ ] Recipe, duration, new radio BasedOnChangeOverMatrix και μέσα να μπορείς να επιλέξεις ποιο durationChangeOverMatrix θέλεις. 
      Πάντως αυτή τη στιγμή, αν το hasRateBasedDuration είναι false, περνάει από το FE και πετάει error το BE
      - Aυτό λογικά ούτε από το FE έπρεπε να περνάει γιατί είναι hard validation violation (η τιμή θα πρέπει να είναι πάντα >= 0 αλλά strictly > 0 αν το Has Rate Based Duration είναι true.
        - Number και >=0 όποιο radio button κι αν είναι επιλεγμένο και είτε είναι ή όχι checked το Has Rate Based Duration
        - >0 μόνο αν είναι επιλεγμένο το συγκεκριμένο radio button και Has Rate Based Duration είναι checked;

## Links
