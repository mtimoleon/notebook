---
title: "HTTP: The HTTP/2 protocol"
source: "https://thevalleyofcode.com/lesson/http/http-2/"
author:
published:
created: 2026-02-09
description: "The HTTP/2 protocol - The protocol of the Web: Hyper Text Transfer Protocol"
tags:
  - "clippings"
---
HTTP: The HTTP/2 protocol

Join the [AI Workshop](https://thevalleyofcode.com/go/ai/) to learn more about AI and how it can be applied to web development. Next cohort starting March 1st, 2026

The AI-first [Web Development BOOTCAMP](https://thevalleyofcode.com/go/bootcamp/) cohort starts February 24th, 2026. 10 weeks of intensive training and hands-on projects.

---

> I suggest reading the [HTTP tutorial](https://thevalleyofcode.com/http) first

HTTP/2 is the current version of the HTTP protocol. Released in 2015 by the IETF (Internet Engineering Task Force) committee, it’s now widely adopted thanks to its unique features.

HTTP/2 is way more performant than HTTP/1.1, the last version of HTTP that was available at the time.

The performance improvement offered by HTTP/2 was so compelling that it was very quickly adopted - with a simple change in the Web Server (since HTTP/2 is 100% backwards compatible with HTTP/1.1), your websites and web apps now work much faster automatically, which in turn is beneficial for your users and also for SEO purposes (as speed is a crucial factor for ranking).

How can HTTP/2 be much faster than HTTP/1.1? The reasons are many, all oriented towards reducing the inefficiencies of the previous version, and introducing features that can allow browsers to be more capable of serving resources quicker.

The main features of the new version of the protocol are:

- request and response multiplexing
- efficient compression of HTTP headers
- server push
- binary communication

## Multiplexing

Before HTTP/2, only one response could be served at a time per TCP connection.

> TCP is the underlying protocol on top of which HTTP is built. TCP stays at the transport layer, while HTTP at the application level.

HTTP/2 enabled request/response multiplexing on top of a single TCP connection, allowing the server to serve multiple requests with the same connection resulting in a much faster communication.

This is the single change that will be a great benefit for your application, and makes several optimization techniques obsolete, including image sprites (which is used to combine several images in a single one, which is then “demultiplexed” by using a special CSS technique) and domain sharding, another hack used to work around the browser limit on the number of simultaneous connections to the same domain.

## Headers compression

HTTP Headers on pages and resources can grow quite big, considering a normal use of cookies and other header values. Compression enables HTTP to have a lighter footprint, reducing the amount of data exchanged between the client and the server.

## Server push

Server push is a feature that allows the server to send multiple responses to a single request. Since the server knows that when requesting a resource a client will then request other complementary resources (think CSS, JS, images linked to a page) a server can decide to send them immediately.

Instead of sending the HTML, waiting for the browser to parse it and fire other requests to get the assets, the server can push them altogether.

A server can also decide to send resources that might be needed in future requests, pre-optimizing the next page load and putting it in the client cache.

> Note that server push can have its own drawbacks as well - for example, you risk sending too much data to the client that might not be needed (maybe it’s already available on the client as cached), so use with caution

## Binary communication

HTTP/1.1 used text-based communication. HTTP/2 uses binary communication, which has a few advantages, including being more efficient to parse, less error prone and also more compact.

## What’s the evolution for the future?

**HTTP/3** is under development, and will be adapted from *HTTP-over-QUIC*, an experimental project.

QUIC is a protocol based on UDP (rather than TCP) at the transport layer, which means that HTTP/3 will be based on a completely different tech stack compared to HTTP/2 and HTTP/1.x.

◀︎ [HTTP/3](https://thevalleyofcode.com/lesson/http/http3/)

▶︎ [Caching in HTTP](https://thevalleyofcode.com/lesson/http/http-caching/)

#### Lessons in this unit:

| 0: | [Introduction](https://thevalleyofcode.com/lesson/http/) |
| --- | --- |
| 1: | [An HTTP request](https://thevalleyofcode.com/lesson/http/an-http-request/) |
| 2: | [HTTP Methods](https://thevalleyofcode.com/lesson/http/http-methods/) |
| 3: | [HTTP Status Codes](https://thevalleyofcode.com/lesson/http/http-status-codes/) |
| 4: | [HTTP Client/Server communication](https://thevalleyofcode.com/lesson/http/http-clientserver-communication/) |
| 5: | [HTTP Request Headers](https://thevalleyofcode.com/lesson/http/http-request-headers/) |
| 6: | [HTTP Response Headers](https://thevalleyofcode.com/lesson/http/http-response-headers/) |
| 7: | [HTTPS](https://thevalleyofcode.com/lesson/http/https/) |
| 8: | [HTTP/2](https://thevalleyofcode.com/lesson/http/http2/) |
| 9: | [HTTP/3](https://thevalleyofcode.com/lesson/http/http3/) |
| 10: | ▶︎ [The HTTP/2 protocol](https://thevalleyofcode.com/lesson/http/http-2/) |
| 11: | [Caching in HTTP](https://thevalleyofcode.com/lesson/http/http-caching/) |
| 12: | [The curl guide to HTTP requests](https://thevalleyofcode.com/lesson/http/http-curl/) |
| 13: | [The HTTP Request Headers List](https://thevalleyofcode.com/lesson/http/http-request-headers/) |
| 14: | [The HTTP Response Headers List](https://thevalleyofcode.com/lesson/http/http-response-headers/) |
| 15: | [HTTP vs HTTPS](https://thevalleyofcode.com/lesson/http/http-vs-https/) |
| 16: | [The HTTPS protocol](https://thevalleyofcode.com/lesson/http/https/) |
| 17: | [An introduction to REST APIs](https://thevalleyofcode.com/lesson/http/rest-api/) |
| 18: | [What is an RFC?](https://thevalleyofcode.com/lesson/http/rfc/) |
| 19: | [How to generate a local SSL certificate](https://thevalleyofcode.com/lesson/http/how-to-generate-local-ssl-cert/) |