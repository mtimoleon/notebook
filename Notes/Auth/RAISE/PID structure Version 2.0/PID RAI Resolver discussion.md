---
created: 2024-09-04
component:
  - PID
---

==2024-08-01 PID RAI Resolver==  
01 August 2024  
08:08  
 

- Decision to implement experiment session
    - Have like project (workspace) - page to display
    - Same purpose, same dataset - SOTON's work
- PID simple, next version retro compatible extended schemas
- AUTH to check Gorka's Jsons ([multiple PIDS proposal](https://aristotleuniversity.sharepoint.com/:f:/s/RAISE-HE2/Er6Z40lPi9RCqkipv0woEfYB0WOHxAh7M5yxAhDI602-Vw?e=rEQHLU))
- Ilektra to call a telco once PID schemas are revised, with CERTH (RAISE metadata), OpenAIRE (Elli), UoWM
    - Know current Portal implementation to publish through OAI-PMH
    - Know what's OKG compulsory
    - See how to capture RAISE dataset PID required information (to be captured in the portal) and make it useful for extending OKG extra information
        - ```
            "contributor": ["" ], //As defined by RAiD, NEED TO CAPTURE AS SUCH IN THE PORTAL - //UPDATEABLE by PID owner //https://metadata.raid.org/en/latest/core/contributors.html#
            ```
            
        - ```
            "organisation": [""], //As defined by RAiD, NEED TO CAPTURE AS SUCH IN THE PORTAL - //UPDATEABLE by PID owner//https://metadata.raid.org/en/latest/core/organisations.html#organisation-role
            ```
            
        - ```
            "description": "\<string\>", //UPDATEABLE by RAISE automatically if dataset owner updates description - Not by PID owner    
            ```
            
        - ```
            "title": "\<string\>", //UPDATEABLE by RAISE automatically if dataset owner updates description - Not by PID owner    
            ```
            
        - ```
            "license": "\<string\>", 
            ```
            
        - ```
            "isPublic": "\<boolean\>", 
            ```
            
        - ```
            "RCH-RCN-available": "\<boolean\>", //Popular dataset or moved to RCH RCN when a RCN is going down with planned transference
            ```
            
        - ```
            "provenance": "\<provenance object\>" //To be described, capture, transformation, DMP, .... information //Not UPDATEABLE
            ```
            
- `Other questions:`

- `Add pid-owner to dataset, results, processing scripts PIDs?`
- ```
    Add creator (similar to "experiment-requestor" in
    ```
    

[2024-06-09-Proposal_Rai_PID_dividedGE.json](https://aristotleuniversity.sharepoint.com/:u:/s/RAISE-HE2/EW3D8x_ECShHgl-2NhQ3EmcB-U67R9mvf6yiItZavC2utQ?e=xR8uNb)

```
) to dataset, results, processing scripts PIDs
 
```
 - [x] `Prio first to take over Portal and them implement Experiment session, PID schemas and so on.`  
   
 

- Moved my pseudo schema to formal json schema
    - [https://vocabulary.raid.org/contributor.schemaUri/215](https://vocabulary.raid.org/contributor.schemaUri/215) like links are broken from RAiD
    - ==5.4 contributor.leader =\> seek for Yes / Null =\> Why no boolean True / False?==
    - ==Should also implemented changes to title / description and similar to allow internationalisation, best practices and so on (== [https://metadata.raid.org/en/latest/core/descriptions.html](https://metadata.raid.org/en/latest/core/descriptions.html)==)==
- [JSON-LD] Need to consider suggestion to tag our schema elements with schema.org to make or PID information compatible with semantic web usage
    - Done some test with Chat GPT. Doesn't look straight forward, the aim is to try to fit into the definition of schema.org, I guess that it would be possible to define RAISE vocabulary, maybe extending schema.org, but I'm not an expert on this and we need to have PID schema ready ASAP.
    - [https://graph.openaire.eu/docs/data-model/entities/data-source/](https://graph.openaire.eu/docs/data-model/entities/data-source/)
    - [https://api.openaire.eu/vocabularies/dnet:provenanceActions](https://api.openaire.eu/vocabularies/dnet:provenanceActions)
- Mapping of Portal metadata schema (OpenAire Knowledge Graph) and planning of the PID
    - Asked by Illias (INTRA) to make compatible the information that we're defining as needed for PID, and that has been defined as neccesary to capture by CERTH
      
    
- 2025-01-09