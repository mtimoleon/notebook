---
created: 2024-03-23
component:
  - PID
---

Our pid should hava some records. These records will be:
 
|   |   |   |   |
|---|---|---|---|
|Index|Type|TimeStamp|Data|
|1|URL||[https://pid.raise-sience.eu/record/\<number\>](https://pid.raise-sience.eu/record/<number>)|
|700500|700050|2022-03-07 15:55:44Z|\< this can be the pid create datetime in our server like 20220307160746\>|
|2|==\<SESSION_TYPE\>==||\<The stringified json of session\>|
|3|==\<AUTHORS_TYPE\>==||\<The stringified json of authors array\>|
|4|==\<DATASET_TYPE\>==||\<The stringified json of dataset\>|
|5|==\<SCRIPT_TYPE\>==||\<The stringified json of processing script\>|
|6|==\<RESULT_TYPE\>==||\<The stringified json of processing result\>|
|7|==\<EXPIRIMENT_TYPE\>==||\<The expiriment id as string\>|
|100|HS_ADMIN||\<realtive info for admin rights etc\>|

For the types we need to identify well known types from: [https://dtr-test.pidconsortium.eu/#](https://dtr-test.pidconsortium.eu/#)  
If any of the well known types is suitable for us we use it, else we use the type that corresponds to string ([https://dtr-test.pidconsortium.eu/#objects/21.T11148/3df63b7acb0522da685d](https://dtr-test.pidconsortium.eu/#objects/21.T11148/3df63b7acb0522da685d)).  
For the strignified data above, use these structures:

- **Session**

```
}
```

- **Authors**

`}]`

- **DataSet**

```
}
```
 - **Script**

```
}
```

- **Result**

```
}
```
 
```
{  
"id" : \<string\>,  
"createdAt": \<string (ISO)\>  
[{  
"id": \<string\>,  
"orcidId": \<string\>,  
"rorId": \<string\>,  
"sourceId": \<string\>,  
{  
"id":  \<string\>,   
"hash:  \<string\>,  
"sourceId": \<string\>,
```
 
```
{  
"id":  \<string\>,   
"hash:  \<string\>,  
{  
"id":  \<string\>,   
"hash:  \<string\>,  
"sourceId": \<string\>,
```
 
```
Following you can find the result json with the full resolved raise pid:  
[https://jsoneditoronline.org/#left=cloud.107979bdbe43433fa1e2f2d707dff337&right=local.tojamu](https://jsoneditoronline.org/#left=cloud.107979bdbe43433fa1e2f2d707dff337&right=local.tojamu)  
{  
  "session": {  
    "id": "\<uuid string\>",  
    "createdAt": "\<2024-01-01T10:00:00 //ISO8601 UTC date-time\>",  
    "metadata": {}  
  },  
  "authors": [  
    {  
      "id": "\<uuid string\>",  
      "fullName": "\<string\>",  
      "publicUrl": "\<string\>",  
      "orcidId": "\<Open Researcher and Contributor ID\>",  
      "rorId": "\<The affiliation, institution or organization with which the author is associated\>",  
      "sourceId": "\<string\>",  
      "metadata": {}  
    }  
  ],  
  "dataSet": {  
    "id": "\<uuid string\>",  
    "description": "\<string\>",  
    "hash": "\<string\>",  
    "sourceId": "\<string\>",  
    "isPublic": "\<boolean\>",  
    "physicalStoreAddress": "\<url string\>",  
    "raiNodeId": "\<uuid string\>",  
    "baseDataSetId": "\<uuid string\>",  
    "authors": "[{\<author object\>}]",  
    "metadata": {  
      "usesCount": "\<number\>"  
    }  
  },  
  "processingScript": {  
    "id": "\<uuid string\>",  
    "description": "\<string\>",  
    "hash": "\<string\>",  
    "isPublic": "\<boolean\>",  
    "raiNodeId": "\<uuid string\>",  
    "physicalStoreAddress": "\<url string\>",  
    "metadata": {  
      "scriptLanguage": "\<string\>",  
      "enableStorage": "\<boolean\>",  
      "encryptedCode": "\<string\>"  
    }  
  },  
  "processingResult": {  
    "id": "\<uuid string\>",  
    "description": "\<string\>",  
    "content": "\<string\>",  
    "hash": "\<string\>",  
    "sourceId": "string",  
    "raiNodeId": "\<uuid string\>",  
    "physicalStoreAddress": "\<url string\>",  
    "metadata": {  
      "enableStorage": "\<boolean\>"  
    }  
  },  
  "experimentId": "\<string\>",  
  "raiNode": {  
    "id": "\<uuid string\>",  
    "publicUrl": "\<url string\>"  
  }  
}
```