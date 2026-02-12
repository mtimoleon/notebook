---
categories:
  - "[[Work]]"
  - "[[Issues]]"
created: 2025-03-17T16:46
tags:
  - intelligen
  - gantt
status: completed
product: Gantt
---

- [x] The bars array should be an array of arrays:  
bars: [ [ {bar1}, {bar2}, {bar3} ], [ {bar1}, {bar2}, {bar3} ] , β€¦ ]  
|____actual________| |_____baseLine(n)___|, |___bL(n-1)___|  
Index 0 is the actual and all the othes are baseline (n, n-1, n-2, β€¦ 1)  
The actual is on top of all  
For our eoc data the bar is the operation task and the actual is the start/end  
The tracked start/end will be the baseline  
So for eoc chart data we will have only one baseline and the actual  
- [x] Check to see what to do with operation breaks
   

- [x] z-Index  
.bar-chart-grid-primary-gridline-internal = 1 -\> 100  
.bar-chart-grid-secondary-gridline-internal = 1 -\> 100  
.resize-handle = 1 -\> 100  
.backdrop-bar-internal = 2 -\> 200  
.central-resizer-handle = 3 -\> 300
 
.normal-bar-internal = 5 -\> 500  
.overlay-bar-internal = 5 -\> 500  
.bar-chart-drop-row = 7 -\> 700  
.bar-chart-grid-arrows = 9 -\> 900  
dragElementRef = 10 -\> 1000
 
rowIndex  
barLayerIndex (actual = 0, baseline(n) = 1, β€¦)  
barIndex  
globalBarIndex
 
- [x] Color blending
 ![Exported image](Exported%20image%2020260209140132-0.png)   
Cn = 0.8 * Cn-1 + 0.2 * B  
Cn+1 = 0.8 * Cn + 0.2 * B
 
Cn+1 = 0.8 (0.8* Cn-1 + 0.2* B) + 0.2 * B
 
Co = 1  
C1 = 0.8 * 1 + 0.2*B  
C2 = 0.8*(0.8 * 1 + 0.2*B) + 0.2*B = β€¦
 
- [x] Fix server planned/tracked start date  
- [x] Create cache in gantt.jsx and pass as argument to helper method getBlendedColors  
- [x] Rename to planningData, trackingData
 
- [x] info.row.bars epistrefei panta array of arrays eno mporei na exoyme steilei flaten row bars dld ena array me ola
 
- [x] Giati sto right click stelnei kai operations poy den temnontai ?



