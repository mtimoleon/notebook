---
categories:
  - "[[Work]]"
created: 2026-07-27
product: scpCloud
component:
status: open
tags:
  - issues/intelligen
---
Inventory chart
Material chart
resource chart
​
https://webplanningbff.yellowpond-08b25858.westeurope.azurecontainerapps.io/planning/148/scheduling-board/176/material/173/material-profile?materialProfileTypeId=3


na mpei null id sta items poy erxontai apo to FE kai meta sto BE na mi katharizo ti lista alla na ti diorthono, prota delete, meta update kai telos insert ta nea. Meta normalization toy orderNumber.

line-chart-\<the visibility ordeing item id\>
equipment-id
​staff-id

What to do with visibility ordering and line charts in production app. Currently only Labor is used in line charts.
- [x] Κατά το χτίσιμο των γραμμών του eoc ή και του πίνακα της σελίδας visibility, aν ένα storage unit για παράδειγμα αλλάξει μονάδες και δεν συμφωνεί με αυτό που έχουμε στη βάση τότε silently θα το γυρνάμε στη reference τιμή αυτού που είναι στη βάση με την κατάλληλη μετατροπή. Έτσι κατα το save πχ της λίστας θα γραφτεί στην νέα τιμή και θα συμφωνεί με τη βάση.

- [x] na ftiaxnv to ορδερινγ κατα το update, δηλαδή αν είναι 1,3,4,6 -> 1,2,3,4 να διώξει τα κενά.