---
categories:
  - "[[Work]]"
created: 2026-02-26
product:
component: Docker
tags:
  - documentation/intelligen
---



![[Intelligen-Notes-1773318667345.png|719]]

 
> [!IINFO] Docker
> 192.168.56.1 host.docker.internal
> ​192.168.56.1 gateway.docker.internal
> ​127.0.0.1 kubernetes.docker.internal

~~[ipereira@hovione.com](mailto:ipereira@hovione.com) operator 79eb3abe-d61e-472c-886b-1665f7d8dcbe
​[rbento@hovione.com](mailto:rbento@hovione.com) operator 64b414a7-0dda-44c5-b93d-2b818746b7a4~~


- PlanningEocChart.jsx:1285 και στα επόμενα
  επειδή το string είναι interpolated κάνει evaluation πριν φτάσει εκεί οπότε αν το operation είναι null θα σκάσει.
- Στο library έχουμε useUTC αλλά στο caption text δεν το λαμβάνει υπόψη.
- Νομίζω ότι δείχνεις tooltip και σε break bars; Το θέλουμε αυτό;
- Το tooltip χρειάζεται pointer events none για να μην κάνει flicker.
- .tooltip css class είναι generic και μπορεί να χαλάει άλλα tooltip. Καλύτερα .gantt-tooltip


Όταν ένα tooltip εμφανίζεται *πάνω* από το element που “hover-άρεις”, μπορεί να “κλέψει” τα pointer events.
Στο δικό σου `Tooltip.jsx` έχεις:
- όταν φαίνεται: `pointerEvents: "auto"` (`WebApps/CommonSpa/libraries/fluidence-gantt/components/Tooltip.jsx:209`)
- όταν κρύβεται: `pointerEvents: "none"`
Τι πάει στραβά:
1) Ο χρήστης έχει τον κέρσορα πάνω σε bar → γίνεται `onPointerMove/onPointerEnter` στο bar και καλείς `tooltipRef.current.show(...)`.
2) Το tooltip εμφανίζεται με `position: fixed` και μεγάλο `z-index` (CSS `z-index: 99999` στο `gantt.css`), άρα μπορεί να βρεθεί *κάτω από τον κέρσορα*.
3) Επειδή έχει `pointer-events: auto`, ο browser θεωρεί ότι τώρα ο κέρσορας είναι “πάνω στο tooltip”, όχι “πάνω στο bar”.
4) Το bar παίρνει `pointerleave` → εσύ καλείς `hide()` στο `onPointerLeave`.
5) Το tooltip εξαφανίζεται, ο κέρσορας ξαναβρίσκεται πάνω στο bar → ξαναεμφανίζεται.
Αυτό δημιουργεί flicker/τρέμουλο και “σπασμένο” hover.
Για tooltips που είναι καθαρά display (όχι clickable), η συνήθης λύση είναι:
- να έχει το tooltip **πάντα** `pointer-events: none` ώστε να μη μπορεί ποτέ να intercept-άρει hover/move/leave από το bar.
Αν κάποια στιγμή θες tooltip με clickable περιεχόμενο, τότε χρειάζεται διαφορετικό interaction model (π.χ. open on click, ή delay + hover state που λαμβάνει υπόψη και tooltip, κτλ.).


**Code quality / Performance**
- onPointerMove καλεί αρκετά “βαριά” computations σε κάθε mouse move (merge/subtract intervals + πολλαπλά getBoundingClientRect) μέσα στο BarChart.jsx (WebApps/CommonSpa/libraries/fluidence-gantt/components/BarChart.jsx:373 και χρήση στο :913), κάτι που μπορεί να κοστίσει σε μεγάλους πίνακες. Συνήθως θες throttle με requestAnimationFrame ή να κάνεις update μόνο όταν αλλάζει target bar / segment.
- Στο Tooltip.jsx χρησιμοποιείς autoUpdate μόνο σαν “scheduler” (ok), αλλά το positioning logic είναι custom και αρκετά “tight” (π.χ. const left = maxLeft; WebApps/CommonSpa/libraries/fluidence-gantt/components/Tooltip.jsx:110) → το tooltip θα “κολλάει” προς μια πλευρά, όχι ιδανικό οπτικά.


​```
c:\Code\ScpCloud>docker compose -f "C:\Code\ScpCloud\docker-compose.yml" - "C:\Code\ScpCloud\docker-compose. override.ym1" - "C:\Code\ScpCloud\docker-compose.azure.yml" build nosqldata
c:\Code\ScpCloud>docker compose -f "C:\Code\ScpCloud\docker-compose.yml" -f "C:\Code\ScpCloud\docker-compose.override.ym1" - "C:\Code\ScpCloud\docker-compose.azure.yml" build sqldata
c:\Code\ScpCloud>docker compose - "C:\Code\ScpCloud\docker-compose.yml" - "C:\Code\ScpCloud\docker-compose.override.ym1" - "C:\Code\ScpCloud\docker-compose.azure.yml" build sqldata
```
`docker push scpcloud.azurecr.io/nosqldata`
`az storage file copy --help`
​
`az storage file delete --share-name scpnosqldata-new --path "/_tmp"`




Docker compose command to build BE:

```bash
docker compose  -f "C:\Users\michael\developer\scpCloud\docker-compose.yml" -f "C:\Users\michael\developer\scpCloud\docker-compose.override.yml" -f "C:\Users\michael\developer\scpCloud\obj\Docker\docker-compose.vs.debug.g.yml" -f "C:\Users\michael\developer\scpCloud\docker-compose.vs.debug.yml" -p dockercompose15380257336922976358 --ansi never build admin-api keycloak mssqlscripts nosqldata planning-api production-api rabbitmq sqldata webadminbff webplanningbff webproductionbff
```

και μετά για up:
```shell
docker compose  -f "C:\Users\michael\developer\scpCloud\docker-compose.yml" -f "C:\Users\michael\developer\scpCloud\docker-compose.override.yml" -f "C:\Users\michael\developer\scpCloud\obj\Docker\docker-compose.vs.debug.g.yml" -f "C:\Users\michael\developer\scpCloud\docker-compose.vs.debug.yml" -p dockercompose15380257336922976358 up -d
```

