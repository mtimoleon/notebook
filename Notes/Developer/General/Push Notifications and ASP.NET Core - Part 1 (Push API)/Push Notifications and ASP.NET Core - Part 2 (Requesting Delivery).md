---
title: "Push Notifications and ASP.NET Core - Part 2 (Requesting Delivery)"
source: "https://www.tpeczek.com/2018/01/push-notifications-and-aspnet-core-part.html"
author:
  - "[[Tomasz Pęczek]]"
published: 2018-01-04
created: 2026-02-09
description: "Push API and Web Push Protocol specifications allow for delivering push notifications even when client is offline. This post shows how to request delivery of push message."
tags:
  - "clippings"
---
January 4, 2018 asp.net core, http, push notifications, web push, web push protocol [3 comments](https://www.tpeczek.com/2018/01/push-notifications-and-aspnet-core-part.html#disqus_thread)

This is my second post about *Push Notifications*:

- [Part 1 (Push API)](https://www.tpeczek.com/2017/12/push-notifications-and-aspnet-core-part.html)
- Part 2 (Requesting Delivery)
- [Part 3 (Replacing Messages & Urgency)](https://www.tpeczek.com/2018/01/push-notifications-and-aspnet-core-part_18.html)
- [Part 4 (Queueing requesting delivery in background)](https://www.tpeczek.com/2018/03/push-notifications-and-aspnet-core-part.html)
- [Part 5 (Special Cases)](https://www.tpeczek.com/2019/02/push-notifications-and-aspnet-core-part.html)

In [previous one](https://www.tpeczek.com/2017/12/push-notifications-and-aspnet-core-part.html) I've focused on general flow and [Push API](http://www.w3.org/TR/push-api/). This time I'm going to focus on requesting *push message* delivery.

In simple words requesting push message delivery is performed by sending a POST request to the subscription `endpoint`. Of course the devil is in details, which in this case spread across four different RFCs.

## Preparing push message delivery request

We already know that we should perform a POST a request and we know the URL. If you have read previous post you also know that we will need to use VAPID for authentication and encrypt the message payload. But that's not all. The [Web Push Protocol](https://tools.ietf.org/html/rfc8030) specifies one required attribute: *Time-To-Live*. The purpose of this attribute is to inform the *push service* for how long it should retain the message (zero is acceptable value and means that push service is allowed to remove message immediately after delivery). Taking this attribute into account the push message can be represented by following class.

```
public class PushMessage
{
    private int? _timeToLive;

    public string Content { get; set; }

    public int? TimeToLive
    {
        get { return _timeToLive; }

        set
        {
            if (value.HasValue && (value.Value < 0))
            {
                throw new ArgumentOutOfRangeException(nameof(TimeToLive),
                    "The TTL must be a non-negative integer");
            }

            _timeToLive = value;
        }
    }

    public PushMessage(string content)
    {
        Content = content;
    }
}
```

The Time-To-Live attribute should be delivered via `TTL` header, which brings us to following initial code for preparing the request.

```
public class PushServiceClient
{
    private const string TTL_HEADER_NAME = "TTL";
    private const int DEFAULT_TIME_TO_LIVE = 2419200;

    ...

    private HttpRequestMessage PreparePushMessageDeliveryRequest(PushSubscription subscription,
        PushMessage message)
    {
        HttpRequestMessage pushMessageDeliveryRequest =
            new HttpRequestMessage(HttpMethod.Post, subscription.Endpoint)
        {
            Headers =
            {
                {
                    TTL_HEADER_NAME,
                    (message.TimeToLive ?? DEFAULT_TIME_TO_LIVE).ToString(CultureInfo.InvariantCulture)
                }
            }
        };

        return pushMessageDeliveryRequest;
    }
}
```

If we would try to send this request, it would result in 400 or 403 (depending on push service) telling that we are not authorized for requesting push messages delivery. It's time to take a look at how VAPID works.

## Authentication

The [VAPID specification](https://tools.ietf.org/html/rfc8292) is using [JSON Web Tokens](https://tools.ietf.org/html/rfc7519). In order to authenticate with the push service the application is supposed to sign the token with *Application Server Private Key* and include it in the request. The final form of JWT included in request should be as follows.

```
<Base64 encoded JWT header JSON>.<Base64 encoded JWT body JSON>.<Base64 encoded signature>
```

One of easiest ways of representing JWT header and body in C# is through `Dictionary<TKey, TValue>`. The header in case of VAPID is constant.

```
private static readonly Dictionary<string, string> _jwtHeader = new Dictionary<string, string>
{
    { "typ", "JWT" },
    { "alg", "ES256" }
};
```

The JWT body should contain following claims:

- *Audience* (`aud`) - The origin of the push resource (this binds token to a specific push service).
- *Expiry* (`exp`) - The time after which the token expires. The maximum is 24 hours but typically half of that is used. The value should be expiration moment expressed as a Unix epoch time.

Additionally application may include *Subject* (`sub`) claim which should contain a contact information for the application server (as `mailto:` or `https:` URI).

The signature should be a [JSON Web Signature](https://tools.ietf.org/html/rfc7515) using *[ECDSA ES256 algorithm](https://tools.ietf.org/html/rfc7518#section-3.4)*.

Now to put this all into code.

```
public class VapidAuthentication
{
    private string _subject;
    private string _publicKey;
    private string _privateKey;

    private static readonly DateTime _unixEpoch = new DateTime(1970, 1, 1, 0, 0, 0);
    private static readonly Dictionary<string, string> _jwtHeader = ...;

    ...

    private string GetToken(string audience)
    {
        // Audience validation removed for brevity
        ...

        Dictionary<string, object> jwtBody = GetJwtBody(audience);

        return GenerateJwtToken(_jwtHeader, jwtBody);
    }

    private Dictionary<string, object> GetJwtBody(string audience)
    {
        Dictionary<string, object> jwtBody = new Dictionary<string, object>
        {
            { "aud", audience },
            { "exp", GetAbsoluteExpiration() }
        };

        if (_subject != null)
        {
            jwtBody.Add("sub", _subject);
        }

        return jwtBody;
    }

    private static long GetAbsoluteExpiration()
    {
        TimeSpan unixEpochOffset = DateTime.UtcNow - _unixEpoch;

        return (long)unixEpochOffset.TotalSeconds + 43200;
    }

    private string GenerateJwtToken(Dictionary<string, string> jwtHeader, Dictionary<string, object> jwtBody)
    {
        string jwtInput = UrlBase64Converter.ToUrlBase64String(Encoding.UTF8.GetBytes(JsonConvert.SerializeObject(jwtHeader)))
            + "."
            + UrlBase64Converter.ToUrlBase64String(Encoding.UTF8.GetBytes(JsonConvert.SerializeObject(jwtBody)));

        // Signature generation removed for brevity
        ...

        return jwtInput + "." + UrlBase64Converter.ToUrlBase64String(jwtSignature);
    }
}
```

The above code doesn't contain the signature generation part as it wouldn't be readable, please take a look at it [here](https://github.com/tpeczek/Demo.AspNetCore.PushNotifications/blob/20180104/Demo.AspNetCore.PushNotifications.Services.PushService/Client/Authentication/VapidAuthentication.cs). The implementation uses `ECDsaSigner` class from [BouncyCastle](https://www.bouncycastle.org/) project and some byte array padding routines. This cryptography can be a little expensive (taking into consideration the possible number of subscriptions) so it's important to remember that the JWT can be cached per Audience with absolute expiration corresponding to Expiry claim.

Currently there are two ways of including the JWT in the request. One is the *WebPush* authentication scheme and the other is *vapid* authentication scheme. The *vapid* authentication scheme is the one from final specification while *WebPush* comes from draft version. The *vapid* scheme is very simple as it uses only `Authorization` header.

```
Authorization: vapid t=<JWT>, k=<Base64 encoded Application Server Public Key>
```

So the value can be generated as easily as in below snippet.

```
public class VapidAuthentication
{
    ...

    public string GetVapidSchemeAuthenticationHeaderValueParameter(string audience)
    {
        return String.Format("t={0}, k={1}", GetToken(audience), _publicKey);
    }

    ...
}
```

Unfortunately not all push services support the latest specification (at moment of writing this I had no success with using *vapid* scheme with Chrome). The *WebPush* scheme seems to be still support even by push services which already support *vapid* so I'm going to use it here. The *WebPush* scheme is a little more complicated as it transfer the needed information by using two separated headers.

```
Authorization: WebPush <JWT>
Crypto-Key: p256ecdsa=<Base64 encoded Application Server Public Key>
```

This means that both values needs to be exposed separately.

```
public class VapidAuthentication
{
    public readonly struct WebPushSchemeHeadersValues
    {
        public string AuthenticationHeaderValueParameter { get; }

        public string CryptoKeyHeaderValue { get; }

        public WebPushSchemeHeadersValues(string authenticationHeaderValueParameter,
            string cryptoKeyHeaderValue) : this()
        {
            AuthenticationHeaderValueParameter = authenticationHeaderValueParameter;
            CryptoKeyHeaderValue = cryptoKeyHeaderValue;
        }
    }

    ...

    public WebPushSchemeHeadersValues GetWebPushSchemeHeadersValues(string audience)
    {
        return new WebPushSchemeHeadersValues(GetToken(audience), "p256ecdsa=" + _publicKey);
    }

    ...
}
```

The authentication can now be plugged into the request preparation code.

```
public class PushServiceClient
{
    ...

    private const string WEBPUSH_AUTHENTICATION_SCHEME = "WebPush";
    private const string CRYPTO_KEY_HEADER_NAME = "Crypto-Key";

    ...

    private HttpRequestMessage PreparePushMessageDeliveryRequest(PushSubscription subscription,
        PushMessage message, VapidAuthentication authentication)
    {
        // Authentication validation removed for brevity
        ...

        HttpRequestMessage pushMessageDeliveryRequest = ...;
        pushMessageDeliveryRequest = SetAuthentication(pushMessageDeliveryRequest,
            subscription, authentication);

        return pushMessageDeliveryRequest;
    }

    private static HttpRequestMessage SetAuthentication(HttpRequestMessage pushMessageDeliveryRequest,
        PushSubscription subscription, VapidAuthentication authentication)
    {
        Uri endpointUri = new Uri(subscription.Endpoint);
        string audience = endpointUri.Scheme + @"://" + endpointUri.Host;

        VapidAuthentication.WebPushSchemeHeadersValues webPushSchemeHeadersValues =
            authentication.GetWebPushSchemeHeadersValues(audience);

        pushMessageDeliveryRequest.Headers.Authorization = new AuthenticationHeaderValue(
            WEBPUSH_AUTHENTICATION_SCHEME,webPushSchemeHeadersValues.AuthenticationHeaderValueParameter);

        pushMessageDeliveryRequest.Headers.Add(CRYPTO_KEY_HEADER_NAME,
            webPushSchemeHeadersValues.CryptoKeyHeaderValue);

        return pushMessageDeliveryRequest;
    }
}
```

This is a request which can be send as payload is optional, but it would be nice to be able to have it.

## Payload encryption

For privacy purposes the payload of push message must be encrypted. The [Web Push Encryption](https://tools.ietf.org/html/rfc8291) specification depends on Encrypted Content-Encoding for HTTP, which I've been [writing about](https://www.tpeczek.com/2017/02/supporting-encrypted-content-encoding.html) in the past. Thanks to that I already have a ready to use [implementation](https://github.com/tpeczek/Lib.Net.Http.EncryptedContentEncoding), the tricky part is generating the input keying material.

When a subscription is being created on client side, the client generates a new *P-256* key pair and an *authentication secret* (a hard-to-guess random value). The public key from that key pair and authentication secret are shared with the application server. Whenever application wants to send a push message it should generate a new *EDCH* key pair on the P-256 curve. The public key from this pair should be used as the keying material identificator for `aes128gcm` while private key should be used together with client public key to generate EDCH agreement (called *shared secret*). The client is capable of generating same EDCH agreement based on his private key and application public key. In order to increase security the shared secret is combined with authentication secret by calculating two HMAC SHA-256 hashes. First is a hash of shared secret with authentication secret and the result is used to hash *info* parameter which is defined as follows:

```
"WebPush: info" || 0x00 || Client Public Key || Application Public Key || 0x01
```

The result is truncated to 32 bytes and used as keying material for `aes128gcm`. Using BouncyCastle allows for quite clean implementation.

```
public class PushServiceClient
{
    ...

    private static readonly byte[] _keyingMaterialInfoParameterPrefix =
        Encoding.ASCII.GetBytes("WebPush: info");

    ...

    private static byte[] GetKeyingMaterial(PushSubscription subscription,
        AsymmetricKeyParameter applicationServerPrivateKey, byte[] applicationServerPublicKey)
    {
        IBasicAgreement ecdhAgreement = AgreementUtilities.GetBasicAgreement("ECDH");
        ecdhAgreement.Init(applicationServerPrivateKey);

        byte[] userAgentPublicKey = UrlBase64Converter.FromUrlBase64String(subscription.Keys["p256dh"]);
        byte[] authenticationSecret = UrlBase64Converter.FromUrlBase64String(subscription.Keys["auth"]);
        byte[] sharedSecret = ecdhAgreement.CalculateAgreement(
            ECKeyHelper.GetECPublicKeyParameters(userAgentPublicKey)).ToByteArrayUnsigned();
        byte[] sharedSecretHash = HmacSha256(authenticationSecret, sharedSecret);
        byte[] infoParameter = GetKeyingMaterialInfoParameter(userAgentPublicKey,
            applicationServerPublicKey);

        byte[] keyingMaterial = HmacSha256(sharedSecretHash, infoParameter);
        Array.Resize(ref keyingMaterial, 32);

        return keyingMaterial;
    }

    private static byte[] GetKeyingMaterialInfoParameter(byte[] userAgentPublicKey,
        byte[] applicationServerPublicKey)
    {
        // "WebPush: info" || 0x00 || ua_public || as_public || 0x01
        byte[] infoParameter = new byte[_keyingMaterialInfoParameterPrefix.Length
            + userAgentPublicKey.Length + applicationServerPublicKey.Length + 2];

        Array.Copy(_keyingMaterialInfoParameterPrefix, infoParameter,
            _keyingMaterialInfoParameterPrefix.Length);

        int infoParameterIndex = _keyingMaterialInfoParameterPrefix.Length + 1;

        Array.Copy(userAgentPublicKey, 0, infoParameter, infoParameterIndex,
            userAgentPublicKey.Length);

        infoParameterIndex += userAgentPublicKey.Length;

        Array.Copy(applicationServerPublicKey, 0, infoParameter, infoParameterIndex,
            applicationServerPublicKey.Length);

        infoParameter[infoParameter.Length - 1] = 1;

        return infoParameter;
    }

    private static byte[] HmacSha256(byte[] key, byte[] value)
    {
        byte[] hash = null;

        using (HMACSHA256 hasher = new HMACSHA256(key))
        {
            hash = hasher.ComputeHash(value);
        }

        return hash;
    }
}
```

This enables adding content to the push message.

```
public class PushServiceClient
{
    ...

    private HttpRequestMessage PreparePushMessageDeliveryRequest(PushSubscription subscription,
        PushMessage message, VapidAuthentication authentication)
    {
        ...

        HttpRequestMessage pushMessageDeliveryRequest = ...;
        pushMessageDeliveryRequest = SetAuthentication(pushMessageDeliveryRequest,
            subscription, authentication);
        pushMessageDeliveryRequest = SetContent(pushMessageDeliveryRequest, subscription, message);

        return pushMessageDeliveryRequest;
    }

    ...

    private static HttpRequestMessage SetContent(HttpRequestMessage pushMessageDeliveryRequest,
        PushSubscription subscription, PushMessage message)
    {
        if (String.IsNullOrEmpty(message.Content))
        {
            pushMessageDeliveryRequest.Content = null;
        }
        else
        {
            AsymmetricCipherKeyPair applicationServerKeys = ECKeyHelper.GenerateAsymmetricCipherKeyPair();
            byte[] applicationServerPublicKey =
                ((ECPublicKeyParameters)applicationServerKeys.Public).Q.GetEncoded(false);

            pushMessageDeliveryRequest.Content = new Aes128GcmEncodedContent(
                new StringContent(message.Content, Encoding.UTF8),
                GetKeyingMaterial(subscription, applicationServerKeys.Private, applicationServerPublicKey),
                applicationServerPublicKey,
                4096
            );
        }

        return pushMessageDeliveryRequest;
    }

    ...
}
```

Done with all the encryption! The request can now be send.

```
public class PushServiceClient
{
    ...

    private readonly HttpClient _httpClient = new HttpClient();

    ...

    public async Task RequestPushMessageDeliveryAsync(PushSubscription subscription, PushMessage message,
        VapidAuthentication authentication)
    {
        HttpRequestMessage pushMessageDeliveryRequest = PreparePushMessageDeliveryRequest(subscription,
            message, authentication);

        HttpResponseMessage pushMessageDeliveryRequestResponse =
            await _httpClient.SendAsync(pushMessageDeliveryRequest);

        // TODO: HandlePushMessageDeliveryRequestResponse(pushMessageDeliveryRequestResponse);
    }

    ...
}
```

The last thing that remains is handling response from the push service.

## Handling response

There is a variety of erroneous response codes we can receive from the push service as those aren't standardized. The only two which specification mention openly are 400 and 403, but even those two aren't used consistently by implementations. The only thing we can be sure about is status code indicating success, which is *201 Created*. In all other cases best that can be done is probably throwing an exception.

```
public class PushServiceClient
{
    private static void HandlePushMessageDeliveryRequestResponse(
        HttpResponseMessage pushMessageDeliveryRequestResponse)
    {
        if (pushMessageDeliveryRequestResponse.StatusCode != HttpStatusCode.Created)
        {
            throw new PushServiceClientException(pushMessageDeliveryRequestResponse.ReasonPhrase,
                pushMessageDeliveryRequestResponse.StatusCode);
        }
    }
}
```

There is one more information which can be retrieved from the successful response - the `Location` header contains URI of created message. This is it for requesting push message delivery.

I encourage you to play with the [demo application](https://github.com/tpeczek/Demo.AspNetCore.PushNotifications). It contains everything described here and I'm planning new things to come soon (for example JWT caching).