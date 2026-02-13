---
created: 2024-08-26
component:
  - PID
---

```
DATASET PID
{
  "url":  "\<string\>", //Not updateable or only if there is a     policy decision to update naming of urls  
  "registration-date":  "\<ISO 8601 standard date\>",
  "dataSet": {
    
    "dvc-id": "\<dvc commit string\>", //Not updateable as it will be used for experiment registration
    "raiNodeId": "\<uuid string\>"  //Not updateable as it will be used for experiment registration
  },
  "metadata": {
    "contributor": [//As defined by RAiD, NEED TO CAPTURE AS SUCH IN THE PORTAL - //UPDATEABLE by PID owner //https://metadata.raid.org/en/latest/core/contributors.html#
//Check the values below if they are compliant with raid
      {
        "id": "ABCDEFGHIJKLMNOPQ",
        "schemaUri": "ABCDEFGHIJKLMNOPQR",
        "role": "ABCDE",
        "position": "ABCDEFGHIJKLMNOPQRSTUVWX",
        "leader": true,
        "contact": true
      }
    ],
    "organisation": [//As defined by RAiD, NEED TO CAPTURE AS SUCH IN THE PORTAL - //UPDATEABLE by PID owner//https://metadata.raid.org/en/latest/core/organisations.html#organisation-role
//Check the values below if they are compliant with raid      {
        "id": "ABCDEFGHIJKLMNOP",
        "schemaUri": "ABCDEFGHIJKLMNOPQRSTUVWXY",
        "role": "ABCDEFGHIJKLMNOPQRSTUVWXY"
      },
    ],

        "description": "\<string\>", //UPDATEABLE by RAISE automatically if dataset owner updates description - Not by PID owner    
        "title": "\<string\>", //UPDATEABLE by RAISE automatically if dataset owner updates description - Not by PID owner    
        "license": "\<string\>", 
        "isPublic": "\<boolean\>", 
        "RCH-RCN-available": "\<boolean\>", //Popular dataset or moved to RCH RCN when a RCN is going down with planned transference
        "provenance": "\<provenance object\>" //To be described, capture, transformation, DMP, .... information //Not UPDATEABLE
 }
}
```

```
PID STRUCTURE
{
  "url": "ABCDEFGHIJKLMNOPQRSTU",
  "experiment-requestor": {
    "id": "ABCDEFGHIJKLMNOPQRSTU",
    "schemaUri": "ABCDEFGHIJ"
  },
  "registration-date": "ABCDEFGHIJKLMNOPQRSTUVW",
  "dataSet": {
    "id": 25.15999/"ABCDEFGHIJKLMNOPQRSTUVWXYZABC"
  },
  "processingScript": {
    "id": "ABCDEFGHIJKLMNOP"
  },
  "processingResult": {
    "id": "ABCDEFGHIJKLMNOPQRSTUVW"
  },
  "metadata": {
    "experimentTitle": "ABCDEFGHIJKLMNOPQRSTUVWX",
    "experimentDescription": "ABCDEFGHIJKLMNOPQRSTUV",
    "published": false,
    "pidOwner": {
      "id": "ABCDEFGHIJKLMNOPQRSTUVWXYZA",
      "schemaUri": "ORCID"
    },
    "contributor": [
      {
        "id": "ABCDEFGHIJKLMN",
        "schemaUri": "ORCID",
        "position": {
          "id": "ABCDEFGHIJKLMNOPQRSTUVWXYZAB",
          "schemaUri": "ABCDEFGHIJKLMNOPQRSTUVWX"
        },
        "leader": null,
        "contact": "Yes",
        "role": {
          "id": "ABCDEFGHIJKL",
          "schemaUri": "ABCDEFGHIJKL"
        }
      },
     ],
    "organisation": [
      {
        "id": "ABCDEFGHIJKLMNOPQRSTUVWXY",
        "schemaUri": "ABCDEFGHIJKLM",
        "role": {
          "id": "ABCDEFGHIJKLMNOPQRSTUVWXYZABC",
          "schemaUri": "ABCDEFGHIJKLMNOPQRSTUV",
          "startDate": "ABCDEFGHIJKLMN",
          "endDate": "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        }
      },
     ],
    "experimentSession": {
      "relatedExperiments": [
        "ABCDEFGHIJKLMNO",
        "ABCDEFGHIJKLMNOPQRSTUV",
        "ABCDEFGHIJKLMNOPQRST",
        "ABCDEFGHIJKLMNOP",
        "ABCDEFGHIJ",
        "ABCD"
      ],
      "datasetUsageContract": [],
      "preferredExperiment": "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    },
    "sequentialScript": {
      "sequential": false,
      "sequentialStepsRai": [
        "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
      ]
    }
  }
}
```

```
SCRIPT PID
{
    "url": "\<string\>", //Not updateable or only if there is a policy decision to update naming of urls  
    "registration-date":  "\<ISO 8601 standard date\>", 
    "processingScript": { 
      "rai-swhid": "\<rai-swhid string\>",//Not updateable as it will be used for experiment registration - Need to ask TCR to check SwHid implementation
      "rai-gitlab": "\<string\>" 
    },      
    "metadata": { //UPDATEABLE by RAISE automatically if code owner updates it. Not PID owner            
          "isAvailableWithoutPermissionRequest": "\<boolean\>", //UPDATEABLE by RAISE automatically if script owner updates description - Not by PID owner 
          "title":"\<string\>", //UPDATEABLE by RAISE automatically if script owner updates description - Not by PID owner 
          "description": "\<string\>", //UPDATEABLE by RAISE automatically if script owner updates description - Not by PID owner 
          "scriptLanguage": "\<string\>"//UPDATEABLE by RAISE automatically if script owner updates description - Not by PID owner 
      }
}
```

```
RESULTS PID
{
    "url": "\<string\>", //Not updateable or only if there is a policy
                         decision to update naming of urls 
    "registration-date":  "\<ISO 8601 standard date\>", //Not updateable
    "dvc-id": "\<dvc commit string\>", //Not updateable as it will be
                                       used for experiment registration
    "raiNodeId": "\<uuid string\>", //Not updateable as it will be used 
                                    for experiment registration
    "metadata": { 
        "availableFairRepo":"\<boolean\>", //UPDATEABLE by RAISE 
                                         automatically, dvc-id should 
                                         be the same in both places?
        "title": "\<string\>", //UPDATEABLE by PID Owner
        "description": "\<string\>", //UPDATEABLE by PID Owner        
        "registered_as_dataset":{  //UPDATEABLE by RAISE 
                                   automatically - someone request 
                                   in portal to register certain
                                   results as dataset for further research, or complex script execution registers auto results in RCH for aggregation tasks
          "registered": "\<boolean\>",
          "dvc-id":"\<dvc commit string\>",
          "raiNodeId": "\<uuid string\>"
        }    
      }
}  
```

RAI PID: 21.T15999/raise-dev/{recordNumber}  
DATASET PID: 21.T15999/raise-dev/dataset/{datasetId}  
SCRIPT PID: 21.T15999/raise-dev/script/{scriptId}  
RESULT PID: 21.T15999/raise-dev/result/{resultId}
   

**DataCite XML to JSON Mapping**  
[https://support.datacite.org/docs/datacite-xml-to-json-mapping](https://support.datacite.org/docs/datacite-xml-to-json-mapping)
 
[https://support.datacite.org/docs/datacite-content-resolver#the-accept-header](https://support.datacite.org/docs/datacite-content-resolver#the-accept-header)
   

This is GE proposal of 2024-06-09 at  
[https://aristotleuniversity.sharepoint.com/sites/RAISE-HE2/Shared%20Documents/Forms/AllItems.aspx?id=%2Fsites%2FRAISE%2DHE2%2FShared%20Documents%2FWP3%20%28UOWM%29%2FT3%2E5%5FRAI%5FFinder%5FService%2F0%2E%2DPID%20Json%20Schema%2F2024%2D06%2D09%2DProposal%5FGE%2Ejson&viewid=bcb468a8%2D4ce6%2D43c1%2Daa65%2D8b6dbe8def49&parent=%2Fsites%2FRAISE%2DHE2%2FShared%20Documents%2FWP3%20%28UOWM%29%2FT3%2E5%5FRAI%5FFinder%5FService%2F0%2E%2DPID%20Json%20Schema](https://aristotleuniversity.sharepoint.com/sites/RAISE-HE2/Shared%20Documents/Forms/AllItems.aspx?id=%2Fsites%2FRAISE%2DHE2%2FShared%20Documents%2FWP3%20%28UOWM%29%2FT3%2E5%5FRAI%5FFinder%5FService%2F0%2E%2DPID%20Json%20Schema%2F2024%2D06%2D09%2DProposal%5FGE%2Ejson&viewid=bcb468a8%2D4ce6%2D43c1%2Daa65%2D8b6dbe8def49&parent=%2Fsites%2FRAISE%2DHE2%2FShared%20Documents%2FWP3%20%28UOWM%29%2FT3%2E5%5FRAI%5FFinder%5FService%2F0%2E%2DPID%20Json%20Schema)