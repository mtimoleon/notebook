Clipped from: [https://nordicapis.com/best-practices-api-error-handling/](https://nordicapis.com/best-practices-api-error-handling/)
 
## Making a Good Error Code

Good error codes must pass **three basic criteria** in order to truly be helpful. A quality error code should include:

- **An HTTP Status Code**, so that the source and realm of the problem can be ascertained with ease;
- **An Internal Reference ID** for documentation-specific notation of errors. In some cases, this can replace the HTTP Status Code, as long as the internal reference sheet includes the HTTP Status Code scheme or similar reference material.
- **Human readable messages** that summarize the context, cause, and general solution for the error at hand.
 
##### Include Standardized Status Codes

##### Give Context

##### Human Readability

```

< HTTP/1.1 400 Bad Request￼\< Date: Wed, 31 May 2017 19:01:41 GMT
< Server: Apache/2.4.25 (Ubuntu)
< Connection: close
< Transfer-Encoding: chunked
< Content-Type: application/json
{ "error" : "Bad Request - Your request is missing parameters. Please verify and resubmit. Issue Reference Number BR0x0071" }
```
## Good Error Examples

### Twitter

Twitter API is a great example of descriptive error reporting codes. Let’s attempt to send a GET request to retrieve our mentions timeline.  
[https://api.twitter.com/1.1/statuses/mentions_timeline.json](https://api.twitter.com/1.1/statuses/mentions_timeline.json)  
When this is sent to the Twitter API, we receive the following response:  
```
HTTP/1.1 400 Bad Request￼x-connection-hash:￼xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
set-cookie:
guest_id=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
Date:￼Thu, 01 Jun 2017 03:04:23 GMT
Content-Length:￼62
x-response-time:￼5￼strict-transport-security:
max-age=631138519
Connection:￼keep-alive
Content-Type:￼application/json; charset=utf-8
Server:￼tsa_b￼ 
{"errors":[{"code":215,"message":"Bad Authentication data."}]}
```

### Facebook

First, let’s pass a GET request to ascertain some details about a user:  
[https://graph.facebook.com/v2.9/me?fields=id%2Cname%2Cpicture%2C%20picture&access_token=xxxxxxxxxxx](https://graph.facebook.com/v2.9/me?fields=id%2Cname%2Cpicture%2C%20picture&access_token=xxxxxxxxxxx)  
This request should give us a few basic fields from this user’s Facebook profile, including id, name, and picture. Instead, we get this error response:  
```
{
 "error": {
	"message": "Syntax error \"Field picture specified more than once. This is only possible before version 2.1\" at character 23: id,name,picture,picture",
  "type": "OAuthException",
  "code": 2500,
  "fbtrace_id": "xxxxxxxxxxx"
	}
}
```

### Bing

To show a complex failure response code, let’s send a poorly formed (essentially null) GET request to Bing. 
```
HTTP/1.1 200￼Date:￼Thu, 01 Jun 2017 03:40:55 GMT￼Content-Length:￼276￼Connection:￼keep-alive￼Content-Type:￼application/json; charset=utf-8￼Server:￼Microsoft-IIS/10.0￼X-Content-Type-Options:￼nosniff￼ ￼{"SearchResponse":{"Version":"2.2","Query":{"SearchTerms":"api error codes"},"Errors":[{"Code":1001,"Message":"Required parameter is missing.","Parameter":"SearchRequest.AppId","HelpUrl":"http\u003a\u002f\u002fmsdn.microsoft.com\u002fen-us\u002flibrary\u002fdd251042.aspx"}]}}￼
```

### Spotify

Though 5XX errors are somewhat rare in modern production environments, we do have some examples in bug reporting systems. [One such report](https://github.com/spotify/web-api/issues/515) noted a 5XX error generated from the following call:  
GET /v1/me/player/currently-playing  
This resulted in the following error:  
[2017-05-02 13:32:14] production.ERROR: GuzzleHttp\Exception\ServerException: 
```
Server error: `GET [https://api.spotify.com/v1/me/player/currently-playing](https://api.spotify.com/v1/me/player/currently-playing)` resulted in a `502 Bad Gateway` response:￼{￼ "error" : {￼ "status" : 502,￼ "message" : "Bad gateway."￼ }￼}  
```
So what makes this a good error code? While the 502 Bad gateway error seems opaque, the additional data in the **header response** is where our value is derived. By noting the error occurring in production and its addressed variable, we get a general sense that the issue at hand is one of the server gateway handling an exception rather than anything external to the server. In other words, we know the request entered the system, but was rejected for an internal issue at that specific exception address.  
When addressing this issue, it was noted that 502 errors are not abnormal, suggesting this to be an issue with server load or gateway timeouts. In such a case, it’s almost impossible to note granularly all of the possible variables — given that situation, this error code is about the best you could possibly ask for.