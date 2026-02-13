---
created: 2025-03-06
component:
  - PID
---

[https://chatgpt.com/c/67ca0793-ded8-8012-a041-babb1c7c8f44](https://chatgpt.com/c/67ca0793-ded8-8012-a041-babb1c7c8f44)
 
[https://www.perplexity.ai/search/pid-signposting-DtxUdAyvSkidmT79rd5_yw](https://www.perplexity.ai/search/pid-signposting-DtxUdAyvSkidmT79rd5_yw)
   
**Flow:**
1. **PID Registration:** A research object (dataset, publication, etc.) is assigned a Persistent Identifier (PID), such as a DOI.  Metadata about the object is registered with a PID provider (e.g., DataCite, Crossref).
2. **PID Resolution (Initial Request):** A client (user, browser, application) attempts to resolve the PID by sending an HTTP request to the PID resolver (e.g., `https://doi.org/10.1234/...).`
3. **Content Negotiation (Machine Client):**
    * **Client Includes `Accept` Header:** If the client is a machine and *wants* metadata, it sends an `Accept` header specifying the desired format (e.g., `Accept: application/vnd.datacite.datacite+json`).
    * **Server Responds with Metadata:** The PID resolver recognizes the `Accept` header and, using content negotiation, responds with the metadata in the requested format (if supported). This might involve a redirect to a metadata server.
    * **Client Receives Metadata:** The client receives the structured metadata (JSON, XML, etc.) and can process it.
4. **Landing Page (Human Client):**
    * **Client Sends No `Accept` Header:** If the client is a browser (typically a human user), it usually doesn't send a specific `Accept` header for metadata. It primarily accepts `text/html`.
    * **Server Responds with Landing Page:** The PID resolver serves an HTML landing page that provides information about the research object.
5. **Signposting (Concurrent with Landing Page):**
    * **Linkset Discovery:** Whether the client is a human or a machine, the HTTP response (especially for the landing page) *also* includes signposting information:
        * **HTTP `Link` Header:** The HTTP response includes a `Link` header that points to a linkset document (e.g., `Link: \<https://example.org/.well-known/linkset\>; rel="linkset"`).
        * **HTML `\<link\>` Tag:** The HTML landing page includes a `\<link\>` tag in the `\<head\>` that points to the same linkset document.
    * **Linkset Contains Relationships:** The linkset document describes relationships between the PID and related resources, such as:
        * Metadata in various formats (which can be retrieved via content negotiation).
        * Data files.
        * License information.
        * Other related PIDs.
    * **Client Discovers Related Resources:** A client that understands signposting can parse the linkset document to discover these related resources and retrieve them as needed.
**Practical Implementation Flow (with Angular, Apache, and Backend):**
1. **Request Comes In:** A request arrives at your server for a PID (e.g., `https://yourdomain.org/doi/10.1234/abc`).
2. **Apache Processing:**
    * **Check `Accept` Header:** Apache inspects the `Accept` header.
    * **Metadata Request:** If the `Accept` header indicates a metadata format (e.g., `application/json`), Apache reverse proxies the request to your backend API.
    * **Landing Page Request:** If the `Accept` header is absent or `text/html`, Apache serves the Angular application.
    * **Add `Link` Header:** Regardless of the `Accept` header, Apache *also* adds an HTTP `Link` header pointing to the linkset file (e.g., `\<https://yourdomain.org/.well-known/linkset.json\>; rel="linkset"`).
3. **Angular Application (Landing Page):**
    * **Display Information:** The Angular app displays information about the research object (fetched from your backend or embedded in the HTML).
    * **Add `\<link\>` Tag:** The Angular app dynamically adds a `\<link\>` tag to the `\<head\>` of the HTML document, pointing to the same linkset file.
4. **Backend API (Metadata and Linkset):**
    * **Serve Metadata:** When requested (via content negotiation), the backend API serves the metadata in the appropriate format.
    * **Serve Linkset File:** The backend API also serves the linkset file itself.  The linkset file should contain URLs that can be resolved to metadata by the backend, using content negotiation.
**In essence, the PID resolver uses content negotiation to decide whether to return the landing page or metadata. In addition, the landing page *and* the response to the request for metadata include signposting links to a linkset file, which allows clients to discover related resources.**
```
   

```
### **PID Resolution, Content Negotiation, \& Signposting Flow (Diagram)**
```mermaid
graph LR
    A[Client (Browser/Machine)] --\> B(PID Resolver (e.g., doi.org));
    B -- Accept Header Present --\> C[Content Negotiation];
    B -- Accept Header Absent --\> D[Serve Landing Page (HTML)];
    C -- Supported Format --\> E[Metadata (JSON/XML)];
    C -- Unsupported Format --\> D;
    D --\> F[Add HTTP Link Header];
    F --\> G[Angular App Renders HTML w/ \<link\> Tag];
    E --\> F;
    G --\> H[Linkset Discovery];
    H --\> I[Related Resources (Metadata, Data, etc.)];
    style A fill:#f9f,stroke:#333,stroke-width:2px
    style B fill:#ccf,stroke:#333,stroke-width:2px
    style C fill:#ccf,stroke:#333,stroke-width:2px
    style D fill:#ccf,stroke:#333,stroke-width:2px
    style E fill:#ffc,stroke:#333,stroke-width:2px
    style F fill:#ccf,stroke:#333,stroke-width:2px
    style G fill:#ffc,stroke:#333,stroke-width:2px
    style H fill:#ccf,stroke:#333,stroke-width:2px
    style I fill:#ffc,stroke:#333,stroke-width:2px
```
---
### **Apache Configuration (`.htaccess`)**
This configuration handles both content negotiation proxying and dynamic `Link` header injection for FAIR Signposting, using a single set of rules.
**Assumptions:**
* Your API backend serves metadata at `/api/metadata/{DOI}` (e.g., `/api/metadata/10.1234/abc`).
* Linkset files are served at `/api/linksets/{DOI}.linkset.json` (e.g., `/api/linksets/10.1234/abc.linkset.json`).
* You've enabled `mod_rewrite` and `mod_headers` modules.
```apache
\<IfModule mod_rewrite.c\>
    RewriteEngine On
    # 1. Extract DOI for reuse in headers and proxy
    RewriteRule ^doi/(.+)$ - [E=DOI:$1]
    # 2. Content Negotiation: Proxy metadata requests
    RewriteCond %{HTTP:Accept} application/json [OR]
    RewriteCond %{HTTP:Accept} application/xml
    RewriteRule ^doi/(.+)$ /api/metadata/%{ENV:DOI} [P,L]
    # 3. Serve linksets from the backend, regardless of content negotiation
    RewriteRule ^\.well-known/linkset\.json$ /api/linksets/%{ENV:DOI}.linkset.json [P,L]
    # 4. Always set the Link header to the linkset
    Header set Link "\<https://yourdomain.org/.well-known/linkset.json\>; rel=\"linkset\"; type=\"application/linkset+json\""
\</IfModule\>
```
---
### **Angular Component (Dynamic `\<link\>` Addition)**
Here’s an improved example Angular component. Note: Always sanitize URLs to prevent XSS:
```typescript
import { Component, OnInit, Renderer2, Inject, OnDestroy } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { DOCUMENT } from '@angular/common';
import { DomSanitizer, SafeResourceUrl } from '@angular/platform-browser';
@Component({
    selector: 'app-pid-landing',
    templateUrl: './pid-landing.component.html',
    styleUrls: ['./pid-landing.component.css'] // Add your styles here
})
export class PidLandingComponent implements OnInit, OnDestroy {
    private linkElement: HTMLLinkElement | null = null;
    public pid: string = ''; // Store the PID
    constructor(
        private route: ActivatedRoute,
        private router: Router,
        private renderer: Renderer2,
        @Inject(DOCUMENT) private document: Document,
        private sanitizer: DomSanitizer
    ) { }
    ngOnInit(): void {
        this.route.params.subscribe(params =\> {
            this.pid = params['pid'];
            this.updateSignpostingLink();
        });
    }
    ngOnDestroy(): void {
        this.removeSignpostingLink();
    }
    private updateSignpostingLink(): void {
        this.removeSignpostingLink();
        const linksetURL = this.sanitizer.bypassSecurityTrustResourceUrl(`https://yourdomain.org/.well-known/linkset.json`);
        if (!linksetURL) {
            console.error('Invalid URL');
            return;
        }
        this.linkElement = this.renderer.createElement('link');
        this.renderer.setAttribute(this.linkElement, 'rel', 'linkset');
        this.renderer.setAttribute(this.linkElement, 'type', 'application/linkset+json');
        this.renderer.setAttribute(this.linkElement, 'href', linksetURL.toString());
        this.renderer.appendChild(this.document.head, this.linkElement);
    }
    private removeSignpostingLink(): void {
        if (this.linkElement) {
            this.renderer.removeChild(this.document.head, this.linkElement);
            this.linkElement = null;
        }
    }
}
```
---
**Explanation of improvements**
1. **Error Handling**: The Angular component includes error handling in `sanitizer`.
2. **`OnDestroy` hook**: Prevents memory leaks.
3. **Type Safety**: More explicit use of Typescript
---
### **Backend API (Example - Node.js with Express)**
This API serves the linkset files dynamically based on the DOI.
```javascript
const express = require('express');
const app = express();
const port = 3000;
// Example: Serve a static JSON, but in real case it is pulled from the DB
app.get('/api/linksets/:doi.linkset.json', (req, res) =\> {
    const doi = req.params.doi;
    const linkset = {
        "links": [
            {
                "href": `https://yourdomain.org/doi/${doi}`,
                "rel": "self",
                "type": "text/html"
            },
            {
                "href": `https://yourdomain.org/api/metadata/${doi}`,
                "rel": "describedby",
                "type": "application/json"
            }
        ]
    };
    res.json(linkset);
});
app.get('/api/metadata/:doi', (req, res) =\> {
    const doi = req.params.doi;
    const metadata = {
        "doi": doi,
        "title": `Example Metadata for ${doi}`
    };
    res.json(metadata);
});
app.listen(port, () =\> {
    console.log(`Example app listening at http://localhost:${port}`);
});
```
---
**Important Considerations:**
* **URL Structure:** Adjust the URLs to match your specific setup.
* **Security:** Always sanitize URLs and data to prevent XSS and other vulnerabilities.
* **Error Handling:** Implement robust error handling in all components.
* **CORS:** Configure CORS properly on your backend API.
* **Testing:** Thoroughly test your configuration to ensure everything works as expected.
