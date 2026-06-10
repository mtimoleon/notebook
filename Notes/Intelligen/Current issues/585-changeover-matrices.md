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
- [ ] [POST] GetRecipeAttributeChangeoverMatrices in RecipeAttributeController
      Route: POST /planning/{workspaceId}/recipe-attribute/{id}/changeover-matrix/filtered-ordered-list
      Accepts recipeAttributeId as id in the route, FilterOrderDto in the body, offset and limit as query params,
      and returns a list of ChangeoverMatrixTableDto items, where each item includes id, name and concurrencyToken.
- [ ] [POST] UpdateChangeoverMatrixName in ChangeoverMatrixController
      Route: POST /planning/{workspaceId}/changeover-matrix/{id}/update-name
      Accepts ChangeoverMatrixNameUpdateDto, including id, name and concurrencyToken.
      The DTO id must match the route id.
- [ ] [POST] CreateChangeoverMatrix in 
      Route: POST /planning/{workspaceId}/changeover-matrix
      Accepts ChangeoverMatrixCreateDto, including recipeAttributeId and name.
- [ ] [DELETE] DeleteChangeoverMatrices in ChangeoverMatrixController
      Route: DELETE /planning/{workspaceId}/changeover-matrix
      Accepts RequestByIdParentChildrenDto, where:
	- parentId = recipeAttributeId
	- arentConcurrencyToken = the RecipeAttribute concurrencyToken
	- children = list of ChangeoverMatrix ids to delete

## Links
