==OIDC auth flows==

\> From \<[https://www.keycloak.org/docs/21.1.1/server_admin/#con-oidc-auth-flows_server_administration_guide](https://www.keycloak.org/docs/21.1.1/server_admin/#con-oidc-auth-flows_server_administration_guide)\>     

==Managing user sessions==  
[Edit this section](https://github.com/keycloak/keycloak/tree/main/docs/documentation/server_admin/topics/sessions.adoc)[Report an issue](https://issues.redhat.com/secure/CreateIssueDetails!init.jspa?pid=12313920&components=12323375&issuetype=1&priority=3&description=File:%20server_admin/topics/sessions.adoc)  
When users log into realms, Keycloak maintains a user session for each user and remembers each client visited by the user within the session. Realm administrators can perform multiple actions on each user session:

- View login statistics for the realm.
- View active users and where they logged in.
- Log a user out of their session.
- Revoke tokens.
- Set up token timeouts.
- Set up session timeouts.   
\> From \<[https://www.keycloak.org/docs/21.1.1/server_admin/#managing-user-sessions](https://www.keycloak.org/docs/21.1.1/server_admin/#managing-user-sessions)\>        

==2.2. JavaScript adapter==  
[Edit this section](https://github.com/keycloak/keycloak/tree/main/docs/documentation/securing_apps/topics/oidc/javascript-adapter.adoc)[Report an issue](https://issues.redhat.com/secure/CreateIssueDetails!init.jspa?pid=12313920&components=12323375&issuetype=1&priority=3&description=File:%20securing_apps/topics/oidc/javascript-adapter.adoc)  
Keycloak comes with a client-side JavaScript library that can be used to secure HTML5/JavaScript applications. The JavaScript adapter has built-in support for Cordova applications.  
A good practice is to include the JavaScript adapter in your application using a package manager like NPM or Yarn. The keycloak-js package is available on the following locations:

- NPM:  [https://www.npmjs.com/package/keycloak-js](https://www.npmjs.com/package/keycloak-js)
- Yarn:  [https://yarnpkg.com/package/keycloak-js](https://yarnpkg.com/package/keycloak-js)

Alternatively, the library can be retrieved directly from the Keycloak server at /js/keycloak.js and is also distributed as a ZIP archive.  
One important thing to note about using client-side applications is that the client has to be a public client as there is no secure way to store client credentials in a client-side application. This makes it very important to make sure the redirect URIs you have configured for the client are correct and as specific as possible.  
To use the JavaScript adapter you must first create a client for your application in the Keycloak Admin Console. Make sure public is selected for Access Type. You achieve this in Capability config by turning OFF client authentication toggle.  
==You also need to configure== ==Valid Redirect URIs== ==and== ==Web Origins. Be as specific as possible as failing to do so may result in a security vulnerability.==  
Once the client is created click on the Action tab in the upper right corner and select Download adapter config. Select Keycloak OIDC JSON for Format Option then click Download. The downloaded keycloak.json file should be hosted on your web server at the same location as your HTML pages.  
Alternatively, you can skip the configuration file and manually configure the adapter.  
The following example shows how to initialize the JavaScript adapter:
 \> From \<[https://www.keycloak.org/docs/latest/securing_apps/index.html#_javascript_adapter](https://www.keycloak.org/docs/latest/securing_apps/index.html#_javascript_adapter)\>        

1.3.1. OpenID Connect [https://www.keycloak.org/docs/latest/securing_apps/index.html](https://www.keycloak.org/docs/latest/securing_apps/index.html)  
[OpenID Connect](https://openid.net/connect/) (OIDC) is an authentication protocol that is an extension of [OAuth 2.0](https://datatracker.ietf.org/doc/html/rfc6749). While OAuth 2.0 is only a framework for building authorization protocols and is mainly incomplete, OIDC is a full-fledged authentication and authorization protocol. OIDC also makes heavy use of the [Json Web Token](https://jwt.io/) (JWT) set of standards. These standards define an identity token JSON format and ways to digitally sign and encrypt that data in a compact and web-friendly way.  
There are really two types of use cases when using OIDC. The first is an application that asks the Keycloak server to authenticate a user for them. After a successful login, the application will receive an _identity token_ and an _access token_. The _identity token_ contains information about the user such as username, email, and other profile information. The _access token_ is digitally signed by the realm and contains access information (like user role mappings) that the application can use to determine what resources the user is allowed to access on the application.  
==The second type of use cases is that of a client that wants to gain access to remote services. In this case, the client asks Keycloak to obtain an== _access token_ ==it can use to invoke on other remote services on behalf of the user. Keycloak authenticates the user then asks the user for consent to grant access to the client requesting it. The client then receives the== _access token_==. This== _access token_ ==is digitally signed by the realm. The client can make REST invocations on remote services using this== _access token_==. The REST service extracts the== _access token_==, verifies the signature of the token, then decides based on access information within the token whether or not to process the request.==
   
\> From \<[https://www.keycloak.org/docs/latest/securing_apps/index.html](https://www.keycloak.org/docs/latest/securing_apps/index.html)\>     

Technical overview  
OpenID is a decentralized authentication protocol that allows users to authenticate with multiple websites using a single set of credentials, eliminating the need for separate usernames and passwords for each website. OpenID is based on a simple idea: a user authenticates with an identity provider (IDP), who then provides the user with a unique identifier (called an OpenID). This identifier can then be used to authenticate the user with any website that supports OpenID.  
When a user visits a website that supports OpenID authentication, the website will redirect the user to their chosen IDP. The IDP will then prompt the user to authenticate themselves (e.g., by entering a username and password). Once the user is authenticated, the IDP will generate an OpenID and send it back to the website. The website can then use this OpenID to authenticate the user without needing to know their actual credentials.  
OpenID is built on top of several existing standards, including HTTP, HTML, and XML. OpenID relies on a number of technologies, including a discovery mechanism that allows websites to find the IDP associated with a particular OpenID, as well as security mechanisms to protect against phishing and other attacks.  
One of the key benefits of OpenID is that it allows users to control their own identity information, rather than relying on individual websites to store and manage their login credentials. This can be particularly important in cases where websites are vulnerable to security breaches or where users are concerned about the privacy of their personal information.  
OpenID has been widely adopted by a number of large websites and service providers, including Google, Yahoo!, and PayPal. The protocol is also used by a number of open source projects and frameworks, including Ruby on Rails and Django.  
**Logging in**  
The end user interacts with a relying party (such as a website) that provides an option to specify an OpenID for the purposes of authentication; an end user typically has previously registered an OpenID (e.g. alice.openid.example.org) with an OpenID provider (e.g.== openid.example.org).1  
The relying party typically transforms the OpenID into a canonical URL form (e.g. http://alice.openid.example.org/).

- With OpenID 1.0, the relying party then requests the HTML resource identified by the URL and reads an HTML link tag to discover the OpenID provider's URL (e.g. http://openid.example.org/openid-auth.php). The relying party also discovers whether to use a delegated identity (see below).
- With OpenID 2.0, the relying party discovers the OpenID provider URL by requesting the XRDS document (also called the Yadis document) with the content type application/xrds+xml; this document may be available at the target URL and is always available for a target XRI.==

There are two modes in which the relying party may communicate with the OpenID provider:

- checkid_immediate, in which the relying party requests that the OpenID provider not interact with the end user. All communication is relayed through the end user's user-agent without explicitly notifying the end user.==
- checkid_setup, in which the end user communicates with the OpenID provider via the same user-agent used to access the relying party.

The checkid_immediate mode can fall back to the checkid_setup mode if the operation cannot be automated.  
First, the relying party and the OpenID provider (optionally) establish a shared secret, referenced by an== associate handle, which the relying party then stores. If using the checkid_setup mode, the relying party redirects the end user's user-agent to the OpenID provider so the end user can authenticate directly with the OpenID provider.  
The method of authentication may vary, but typically, an OpenID provider prompts the end user for a password or some cryptographic token, and then asks whether the end user trusts the relying party to receive the necessary identity details.  
If the end user declines the OpenID provider's request to trust the relying party, then the user-agent is redirected back to the relying party with a message indicating that authentication was rejected; the relying party in turn refuses to authenticate the end user.  
If the end user accepts the OpenID provider's request to trust the relying party, then the user-agent is redirected back to the relying party along with the end user's credentials. That relying party must then confirm that the credentials really came from the OpenID provider. If the relying party and OpenID provider had previously established a shared secret, then the relying party can validate the identity of the OpenID provider by comparing its copy of the shared secret against the one received along with the end user's credentials; such a relying party is called stateful because it stores the shared secret between sessions. In contrast, a stateless or dumb relying party must make one more background request (check_authentication) to ensure that the data indeed came from the OpenID provider.  
After the OpenID has been verified, authentication is considered successful and the end user is considered logged into the relying party under the identity specified by the given OpenID (e.g. alice.openid.example.org). The relying party typically then stores the end user's OpenID along with the end user's other session information.==  
**Identifiers**  
To obtain an OpenID-enabled URL that can be used to log into OpenID-enabled websites, a user registers an OpenID identifier with an identity provider. Identity providers offer the ability to register a URL (typically a third-level domain, e.g. username.example.com) that will automatically be configured with OpenID authentication service.  
Once they have registered an OpenID, a user can also use an existing URL under their own control (such as a blog or home page) as an alias or "delegated identity". They simply insert the appropriate OpenID tags in the HTML13== or serve a Yadis document.14==  
Starting with OpenID Authentication 2.0 (and some 1.1 implementations), there are two types of identifiers that can be used with OpenID: URLs and XRIs.  
XRIs are a new form of Internet identifier designed specifically for cross-domain digital identity. For example, XRIs come in two forms—i-names and i-numbers—that are usually registered simultaneously as synonyms. I-names are reassignable (like domain names), while i-numbers are never reassigned. When an XRI i-name is used as an OpenID identifier, it is immediately resolved to the synonymous i-number (the CanonicalID element of the XRDS document). This i-number is the OpenID identifier stored by the relying party. In this way, both the user and the relying party are protected from the end user's OpenID identity ever being taken over by another party as can happen with a URL based on a reassignable DNS name.

 \> From \<https://en.wikipedia.org/wiki/OpenIDhttps://en.wikipedia.org/wiki/OpenID\>   
 
	
![[image-20.png]]

  ![[image-21.png]]

\> From \<[https://www.keycloak.org/docs/21.1.1/server_admin/#con-oidc-auth-flows_server_administration_guide](https://www.keycloak.org/docs/21.1.1/server_admin/#con-oidc-auth-flows_server_administration_guide)\>        
\> From \<[https://www.keycloak.org/docs/21.1.1/server_admin/#managing-user-sessions](https://www.keycloak.org/docs/21.1.1/server_admin/#managing-user-sessions)\>         
\> From \<[https://www.keycloak.org/docs/latest/securing_apps/index.html#_javascript_adapter](https://www.keycloak.org/docs/latest/securing_apps/index.html#_javascript_adapter)\>           
\> From \<[https://www.keycloak.org/docs/latest/securing_apps/index.html](https://www.keycloak.org/docs/latest/securing_apps/index.html)\>      
\> From \<[https://en.wikipedia.org/wiki/OpenID](https://en.wikipedia.org/wiki/OpenID)\>