**SCHEDULING QUERIES, INCLUDES and CONDITIONS**
 
In order to get data from db we need to perform 3 queries on scheduling board.

1. Query to get scheduling board with campaigns ordered by order number
2. Query to get recipes and campaign containing data only to procedure entries
3. Query to get full campaigns
 
The above queries work as data addition (do not get member values if they already exist in context) if they performed in the same context  
(See _Relationship fixup @_ [https://learn.microsoft.com/en-us/ef/core/change-tracking/relationship-changes#relationship-fixup](https://learn.microsoft.com/en-us/ef/core/change-tracking/relationship-changes#relationship-fixup))
 
For optimization we can join 1 & 2 queries in some cases (Unschedule and resolve conflicts queries). This way we have one query less to the db and the amount of data is not  
too much to "burden" the query we perform instead.
   

|   |   |   |   |   |
|---|---|---|---|---|
|||Recipe|Campaign<br><br>  <br><br>To Procedures Entries|Campaign<br><br>  <br><br>In Full|
|Schedule|Unscheduled Campaigns|✔️ where campaign != scheduled|✔️ where campaign != scheduled|✔️ where campaign == scheduled|
||Campaign|✔️ where campaign == reference campaign|✔️ where campaign == reference campaign|✔️ where campaign != reference campaign|
||From Campaign|✔️ where order \>= reference order|✔️ where order \>= reference order|✔️ where order \< reference order|
||To Campaign|✔️ where order \<= reference order|✔️ where order \<= reference order|✔️ where order \> reference order|
|Reschedule|All Campaigns|✔️|✔️||
||Campaign|✔️ where campaign == reference campaign|✔️ where campaign == reference campaign|✔️ where campaign != reference campaign|
||From Campaign|✔️ where order \>= reference order|✔️ where order \>= reference order|✔️ where order \< reference order|
||To Campaign|✔️ where order \<= reference order|✔️ where order \<= reference order|✔️ where order \> reference order|
|Unschedule|All Campaigns||✔️||
||Campaign||✔️all instead of (where campaign == reference campaign)|✔️ where campaign != reference campaign|
||From Campaign||✔️all instead of (where order \>= reference order)|✔️ where order \< reference order|
||To Campaign||✔️all instead of (where order \<= reference order)|✔️ where order \> reference order|
|Resolve Conflicts|Batch||✔️all instead of (where order \> batch.Campaign order)|✔️ where order \<= batch.Campaign order|
||Campaign||✔️all instead of (where order \> reference order)|✔️ where order \<= reference order|
||From Campaign|||✔️|
||To Campaign||✔️all instead of (where order \> reference order)|✔️ where order \<= reference order|