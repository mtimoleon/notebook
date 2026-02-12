---
categories:
  - "[[Work]]"
created: 2022-03-29T20:39
tags:
  - intelligen
---
![[ScheduleTiming.docx]]

GOAL: 
- Calculate operation timing within a batch according to the following duration and scheduling links options:
- Durations can be: constant, same as some other operation, same as the difference between the end of some operation and the start of some other operation.
- Scheduling links can be: according to batch start, with respect to another operation as SS (start-to-start), FS (finish-to-start), SF (start-to-finish), FF (finish-to-finish) (the first letter corresponds to the reference operation and the second to the operation in question).
- METHODOLOGY: 
- Determining the timing for an operation requires determining the start time and duration for that operation. We split the two calculations and create a dependency graph where the nodes are start time and duration calculations for all operations. Eventually, all nodes must be calculated in order to determine the entire schedule. The order in which the calculations will take place is determined by the graph edges, denoting the dependencies between calculations. If the graph contains cycles the problem is unsolvable.
- ALGORITHM:
- For each operation A, two nodes are created in the dependency graph: Ad (A duration) and As (A start). The nodes refer to determining the duration and start of operation A respectively.
- The duration-related edges of the dependency graph are added as follows. For each operation A:
	o If A has a constant duration, no edges are added to Ad (i.e. Ad has no dependencies).
	o If Aβ€™s duration matches that of another operation B, an edge is created Bd -> Ad.
	o If Aβ€™s duration is set to the difference between the end of operation C and the start of operation B, then three edges as created as follows: Bs -> Ad, Cs -> Ad, Cd -> Ad.
- The precedence-related edges are added as follows. For each operation A:
	o If A starts with batch start, no edges are added to As.
	o If A starts with respect to another operation B then depending on the link type:
		Β§ SS: Bs -> As.
		Β§ FS: Bs -> As, Bd -> As.
		Β§ SF: Bs -> As, Ad -> As.
		Β§ FF: Bs -> As, Bd -> As, Ad -> As.
- Then we do a topological sort of the above graph which gives us a list of the nodes that satisfies the dependency constraints. If there are cycles the sorting algorithm will fail. Some tweaking of the algorithm may be necessary to report on the actual cycle.
- For each node of the list we do the following:
	o If it is a duration node (e.g. Ad):
		Β§ If A has a constant duration the duration is set to that value.
		Β§ If Aβ€™s duration matches that of another operation B, it is set to Bd.
		Β§ If Aβ€™s duration is set to the difference between the end of operation C and the start of operation B, then it is set to (Cs + Cd) β€“ Bs.
	o If it is a start node (e.g. As):
		Β§ If A starts with batch start, the start is set to the batch start.
		Β§ If A is SS with respect to operation B, the start is set to Bs.
		Β§ If A is FS with respect to operation B, the start is set to (Bs + Bd).
		Β§ If A is SF with respect to operation B, the start is set to (Bs - Ad).
		Β§ If A is FF with respect to operation B, the start is set to (Bs + Bd - Ad).





