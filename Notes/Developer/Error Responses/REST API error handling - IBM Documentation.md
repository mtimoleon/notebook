---
title: "IBM MQ"
source: "https://www.ibm.com/docs/en/ibm-mq/9.0.x?topic=api-rest-error-handling"
author:
published:
created: 2026-02-09
description: "The REST API reports errors by returning an appropriate HTTP response code, for example 404 (Not Found), and a JSON response. Any HTTP response code that is not in the range 200 - 299 is considered an error."
tags:
  - "clippings"
---
Last Updated: 2025-09-04

The REST API reports errors by returning an appropriate HTTP response code, for example 404 (Not Found), and a JSON response. Any HTTP response code that is not in the range 200 - 299 is considered an error.

## The error response format
The response is in JSON format in UTF-8 encoding. It contains nested JSON objects:
- An outer JSON object that contains a single JSON array called `error`.
- Each element in the array is a JSON object that represents information about an error. Each JSON object contains the following properties:
	type
	String.
	The type of error.
	messageId
	String.
	A unique identifier for the message of the form `MQWBnnnnX`. This identifier has the following elements:
	`MQWB`
	A prefix showing that the message originated in the MQ Rest API.
	`nnnn`
	A unique number identifying the message.
	`X`
	A single letter denoting the severity of the message:
	- `I` if a message is purely informational.
	- `W` if a message is warning of an issue.
	- `E` if a message indicates that an error occurred.
	- `S` if a message indicates that a severe error occurred.
	message
	String.
	A description of the error.
	explanation
	String.
	An explanation of the error.
	action
	String.
	A description of steps that can be taken to resolve the error.
	qmgrName
	![[z/OS]](https://www.ibm.com/docs/en/SSFKSJ_9.0.0/administer/ngzos.gif)This field is only available for z/OS® where the queue manager is a member of the queue-sharing group. You must have specified the commandScope optional query parameter, or the queueSharingGroupDisposition attribute.
	String.
	The name of the queue manager that experienced the error.
	![[V9.0.4 Oct 2017]](https://www.ibm.com/docs/en/SSFKSJ_9.0.0/administer/ng904.gif)This field is not applicable for the messaging REST API.
	This field is only available when type is `pcf`, `java`, or `rest`.
	Number.
	The MQ completion code associated with the failure.
	![[V9.0.4 Oct 2017]](https://www.ibm.com/docs/en/SSFKSJ_9.0.0/administer/ng904.gif)reasonCode
	This field is only available when type is `pcf`, `java`, or `rest`.
	Number.
	The MQ reason code associated with the failure.
	exceptions
	This field is only available when type is `java`.
	Array.
	An array of chain Java or JMS exceptions. Each element of the exceptions array contains a stackTrace string array.
	The stackTrace string array contains the details of each exception split into lines.

![[z/OS]](https://www.ibm.com/docs/en/SSFKSJ_9.0.0/administer/ngzos.gif)

## Errors with queue sharing groupsIn a queue sharing group, it is possible to specify an optional query parameter of commandScope for certain commands. This parameter allows the command to be propagated to other queue managers in the queue sharing group. Any one of these commands can fail independently, resulting in some commands succeeding and some commands failing for the queue sharing group.

In cases where a command partially fails, an HTTP error code of 500 is returned. For each queue manager that generated a failure, information on that failure is returned as an element in the `error` JSON array. For each queue manager that successfully ran the command, the name of the queue manager is returned as an element in a `success` JSON array.

## Examples- The following example shows the error response to an attempt to get information about a queue manager that does not exist:
	```
	"error": [
	   {
	      "type": "rest",
	      "messageId": "MQWB0009E",
	      "message": "MQWB0009E: Could not query the queue manager 'QM1'",
	      "explanation": "The MQ REST API was invoked specifying a queue manager name which cannot be located.",
	      "action": "Resubmit the request with a valid queue manager name or no queue manager name, to retrieve a list of queue managers. " 
	   }
	]
	```
	Copy to clipboard
- ![[z/OS]](https://www.ibm.com/docs/en/SSFKSJ_9.0.0/administer/ngzos.gif)The following example shows the error response to an attempt to delete a queue in a queue sharing group that does not exist for some queue managers:
	```
	"error" : [
	  {
	    "type": "rest",
	    "messageId": "MQWB0037E",
	    "message": "MQWB0037E: Could not find the queue 'missingQueue' - the queue manager reason code is 3312 : 'MQRCCF_UNKNOWN_OBJECT_NAME'",
	    "explanation": "The MQ REST API was invoked specifying a queue name which cannot be located.",
	    "action": "Resubmit the request with the name of an existing queue, or with no queue name to retrieve a list of queues.",  
	    "qmgrName": "QM1"
	  },
	  {
	    "type": "rest",
	    "messageId": "MQWB0037E",
	    "message": "MQWB0037E: Could not find the queue 'missingQueue' - the queue manager reason code is 3312 : 'MQRCCF_UNKNOWN_OBJECT_NAME'",
	    "explanation": "The MQ REST API was invoked specifying a queue name which cannot be located.",
	    "action": "Resubmit the request with the name of an existing queue, or with no queue name to retrieve a list of queues.",  
	    "qmgrName": "QM2"
	  }
	],
	"success" : [{"qmgrName": "QM3"}, {"qmgrName": "QM4"}]
	```
	Copy to clipboard

## Errors with MFT requestsIf MFT REST API services are not enabled, and you invoke the MFT REST API, you receive the following exception:

```
{"error": [{
  "action": "Enable the Managed File Transfer REST API and resubmit the request.",
  "completionCode": 0,
  "explanation": "Managed File Transfer REST calls are not permitted as the service is disabled.",
  "message": "MQWB0400E: Managed File Transfer REST API is not enabled.",
  "msgId": "MQWB0400E",
  "reasonCode": 0,
  "type": "rest"
}]}
```

Copy to clipboard

If MFT REST API services are enabled and the coordination queue manager is not set in the mqwebuser.xml file, you receive the following exception:

```
{"error": [{
  "action": "Set the coordination queue manager name and restart the mqweb server.",
  "completionCode": 0,
  "explanation": "Coordination queue manager name must be set before using Managed File Transfer REST services.",
  "message": "MQWB0402E: Coordination queue manager name is not set.",
  "msgId": "MQWB0402E",
  "reasonCode": 0,
  "type": "rest"
}]}
```