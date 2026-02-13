---
created: 2024-01-19
component:
  - PID
---

[https://epic.grnet.gr/](https://epic.grnet.gr/)  
[https://epic.grnet.gr/docs/](https://epic.grnet.gr/docs/)  
PID generation  
API - PID generation[#](https://epic.grnet.gr/docs/generate#api---pid-generation)  
Every identifier consists of two parts: its prefix and a unique local name under the prefix known as its suffix  
Copy

|
|
```
     \< PREFIX \> / \< SUFFIX \> (e.g. 11239/123456745).    
```

Any suffix - local name must be unique under its local namespace. The uniqueness of a prefix and a local name under that prefix ensures that any identifier is globally unique within the context of the System.  
Depending on the service there are two ways to generate the SUFFIX a) automatic and b) manual  
Automatic generation of SUFFIX[#](https://epic.grnet.gr/docs/generate#automatic-generation-of-suffix)  
The API supports the automatic generation of a local name - suffix by using a generator via a POST Request. This generator uses UUIDs to guarantee the uniqueness of created handles. The syntax follows the following pattern  
SUFFIX = prefix - UUID - suffix  
where

- prefix: Optional: a string of UTF-8 encoded printable unicode characters to put before the UUID.
- UUID: UUID stands for Universally Unique IDentifier, GUID for Globally Unique IDentifier. A universally unique identifier (UUID) is an identifier standard used in software construction, standardized by the Open Software Foundation (OSF) as part of the Distributed Computing Environment (DCE). The intent of UUIDs is to enable distributed systems to uniquely identify information without significant central coordination.
- suffix: Optional: a string of UTF-8 encoded printable unicode characters to put after the UUID.

The Result[#](https://epic.grnet.gr/docs/generate#the-result)  
The result of the automatic generation  
GRNET-0000-0000-000A-5-TEST  
Manual generation of SUFFIX[#](https://epic.grnet.gr/docs/generate#manual-generation-of-suffix)  
Its up to the user to decide the names of the PIDs. You may use

- a number
- a string
- a UUID
- a pattern based on the community context

In all examples in this manual we use a UUID generator.  
EXAMPLE [https://epic.grnet.gr/docs/get#example](https://epic.grnet.gr/docs/get#example)  
11239/05C3DB56-5692-11E3-AF8F-1C6F65A666B5  
The server response:

|   |
|---|
|```<br>[  <br>    {  <br>    "idx":1,  <br>    "type":"URL",  <br>    "parsed_data":"http://www.grnet.gr/",  <br>    "data":"aHR0cDovL3d3dy5ncm5ldC5nci8=",  <br>    "timestamp":"2013-11-26T11:58:14Z",  <br>    "ttl_type":0,  <br>    "ttl":86400,  <br>    "refs":[],  <br>    "privs":"rwr-"  <br>    },  <br>    {  <br>    "idx":2,  <br>    "type":"URL",  <br>    "parsed_data":"https://www.grnet.gr/en/node/64",  <br>    "data":"aHR0cHM6Ly93d3cuZ3JuZXQuZ3IvZW4vbm9kZS82NA==",  <br>    "timestamp":"2013-11-26T11:58:14Z",  <br>    "ttl_type":0,  <br>    "ttl":86400,  <br>    "refs":[],  <br>    "privs":"rwr-"  <br>    },  <br>    {  <br>    "idx":3,  <br>    "type":"INST",  <br>    "parsed_data":"CLARIN-EL",  <br>    "data":"Q0xBUklOLUVM",  <br>    "timestamp":"2013-11-26T11:58:14Z",  <br>    "ttl_type":0,  <br>    "ttl":86400,  <br>    "refs":[],  <br>    "privs":"rwr-"  <br>    },  <br>      <br>    {  <br>    "idx":100,  <br>    "type":"HS_ADMIN",  <br>    "parsed_data":{  <br>    "adminId":"0.NA/11239",  <br>    "adminIdIndex":300,  <br>    "perms":{  <br>    "add_handle":true,  <br>    "delete_handle":true,  <br>    "add_naming_auth":false,  <br>    "delete_naming_auth":false,  <br>    "modify_value":true,  <br>    "remove_value":true,  <br>    "add_value":true,  <br>    "read_value":true,  <br>    "modify_admin":true,  <br>    "remove_admin":true,  <br>    "add_admin":true,  <br>    "list_handles":false  <br>    }  <br>    },  <br>    "data":"B/MAAAAKMC5OQS8xMTIzOQAAASw=",  <br>    "timestamp":"2013-11-15T14:25:58Z",  <br>    "ttl_type":0,  <br>    "ttl":86400,  <br>    "refs":[],  <br>    "privs":"rwr-"  <br>    }  <br>]<br>```|

Check the above at [https://hdl.handle.net/](https://hdl.handle.net/) or [https://doi.org](https://doi.org)  
Following is the result of the information contained in PID

[![Handle.net Logo](Exported%20image%2020260211204441-0.png)](https://www.handle.net/)  

|   |   |   |   |
|---|---|---|---|
|Handle Values for: 11239/05C3DB56-5692-11E3-AF8F-1C6F65A666B5||||
|Index|Type|Timestamp|Data|
|**1**|**URL**|2013-11-26 11:58:14Z|[http://www.grnet.gr/](http://www.grnet.gr/)|
|**2**|**URL**|2013-11-26 11:58:14Z|[https://www.grnet.gr/en/node/64](https://www.grnet.gr/en/node/64)|
|**100**|**HS_ADMIN**|2013-11-26 11:58:14Z|handle=0.NA/11239; index=300; [create hdl,delete hdl,read val,modify val,del val,add val,modify admin,del admin,add admin]|
|**3**|**INST**|2013-11-26 11:58:14Z|CLARIN-EL|

[Handle Proxy Server Documentation](https://hdl.handle.net/help.html)  
[Handle.net Web Site](https://www.handle.net/)  
Please contact [hdladmin@cnri.reston.va.us](mailto:hdladmin@cnri.reston.va.us?subject=Handle%20Questions%20and%20Comments) for your handle questions and comments.  
In our system we can have as url either the central hub or the rai resolver relative page to get data  
Από [https://epic.grnet.gr/docs/generate](https://epic.grnet.gr/docs/generate)