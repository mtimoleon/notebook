Clipped from: [https://en.wikipedia.org/wiki/Topological_sorting](https://en.wikipedia.org/wiki/Topological_sorting)

(Redirected from [Topological sort](https://en.wikipedia.org/w/index.php?title=Topological_sort&redirect=no))

[Jump to navigation](https://en.wikipedia.org/wiki/Topological_sorting#mw-head) [Jump to search](https://en.wikipedia.org/wiki/Topological_sorting#searchInput)

"Dependency resolution" redirects here. For other uses, see [Dependency (disambiguation)](https://en.wikipedia.org/wiki/Dependency_\(disambiguation\)).  
In [computer science](https://en.wikipedia.org/wiki/Computer_science), a **topological sort** or **topological ordering** of a [directed graph](https://en.wikipedia.org/wiki/Directed_graph) is a [linear ordering](https://en.wikipedia.org/wiki/Total_order) of its [vertices](https://en.wikipedia.org/wiki/Vertex_\(graph_theory\)) such that for every directed edge _uv_ from vertex _u_ to vertex _v_, _u_ comes before _v_ in the ordering. For instance, the vertices of the graph may represent tasks to be performed, and the edges may represent constraints that one task must be performed before another; in this application, a topological ordering is just a valid sequence for the tasks. Precisely, a topological sort is a graph traversal in which each node _v_ is visited only after all its dependencies are visited_._ A topological ordering is possible if and only if the graph has no [directed cycles](https://en.wikipedia.org/wiki/Directed_cycle), that is, if it is a [directed acyclic graph](https://en.wikipedia.org/wiki/Directed_acyclic_graph) (DAG). Any DAG has at least one topological ordering, and [algorithms](https://en.wikipedia.org/wiki/Algorithm) are known for constructing a topological ordering of any DAG in [linear time](https://en.wikipedia.org/wiki/Linear_time). Topological sorting has many applications especially in ranking problems such as [feedback arc set](https://en.wikipedia.org/wiki/Feedback_arc_set). Topological sorting is possible even when the DAG has [disconnected components](https://en.wikipedia.org/wiki/Connectivity_\(graph_theory\)).

## Examples

The canonical application of topological sorting is in [scheduling](https://en.wikipedia.org/wiki/Job_shop_scheduling) a sequence of jobs or tasks based on their [dependencies](https://en.wikipedia.org/wiki/Dependency_graph). The jobs are represented by vertices, and there is an edge from _x_ to _y_ if job _x_ must be completed before job _y_ can be started (for example, when washing clothes, the washing machine must finish before we put the clothes in the dryer). Then, a topological sort gives an order in which to perform the jobs. A closely related application of topological sorting algorithms was first studied in the early 1960s in the context of the [PERT](https://en.wikipedia.org/wiki/Program_Evaluation_and_Review_Technique) technique for scheduling in [project management](https://en.wikipedia.org/wiki/Project_management).[[1]](https://en.wikipedia.org/wiki/Topological_sorting#cite_note-Jarnagin-1) In this application, the vertices of a graph represent the milestones of a project, and the edges represent tasks that must be performed between one milestone and another. Topological sorting forms the basis of linear-time algorithms for finding the [critical path](https://en.wikipedia.org/wiki/Critical_path_method) of the project, a sequence of milestones and tasks that controls the length of the overall project schedule.  
In computer science, applications of this type arise in [instruction scheduling](https://en.wikipedia.org/wiki/Instruction_scheduling), ordering of formula cell evaluation when recomputing formula values in [spreadsheets](https://en.wikipedia.org/wiki/Spreadsheet), [logic synthesis](https://en.wikipedia.org/wiki/Logic_synthesis), determining the order of compilation tasks to perform in [makefiles](https://en.wikipedia.org/wiki/Makefile), data [serialization](https://en.wikipedia.org/wiki/Serialization), and resolving symbol dependencies in [linkers](https://en.wikipedia.org/wiki/Linker_\(computing\)). It is also used to decide in which order to load tables with foreign keys in databases.

|   |   |
|---|---|
|[![Directed acyclic graph 2.svg](Exported%20image%2020260209134125-0.png)](https://en.wikipedia.org/wiki/File:Directed_acyclic_graph_2.svg)|The graph shown to the left has many valid topological sorts, including:<br><br>- 5, 7, 3, 11, 8, 2, 9, 10 (visual top-to-bottom, left-to-right)<br>- 3, 5, 7, 8, 11, 2, 9, 10 (smallest-numbered available vertex first)<br>- 5, 7, 3, 8, 11, 10, 9, 2 (fewest edges first)<br>- 7, 5, 11, 3, 10, 8, 9, 2 (largest-numbered available vertex first)<br>- 5, 7, 11, 2, 3, 8, 9, 10 (attempting top-to-bottom, left-to-right)<br>- 3, 7, 8, 5, 11, 10, 2, 9 (arbitrary)|

## Algorithms

The usual algorithms for topological sorting have running time linear in the number of nodes plus the number of edges, asymptotically,

![displaystyle OleftVrightleftEright.](Exported%20image%2020260209134126-1.jpeg)

### Kahn's algorithm

Not to be confused with [Kuhn's algorithm](https://en.wikipedia.org/wiki/Kuhn%27s_algorithm).  
One of these algorithms, first described by [Kahn (1962)](https://en.wikipedia.org/wiki/Topological_sorting#CITEREFKahn1962), works by choosing vertices in the same order as the eventual topological sort.[[2]](https://en.wikipedia.org/wiki/Topological_sorting#cite_note-Kahn-2) First, find a list of "start nodes" which have no incoming edges and insert them into a set S; at least one such node must exist in a non-empty acyclic graph. Then:  
_L_ ← Empty list that will contain the sorted elements￼_S_ ← Set of all nodes with no incoming edge￼￼**while** _S_ **is not** empty **do**￼ remove a node _n_ from _S_￼ add _n_ to _L_￼ **for each** node _m_ with an edge _e_ from _n_ to _m_ **do**￼ remove edge _e_ from the graph￼ **if** _m_ has no other incoming edges **then**￼ insert _m_ into _S_￼￼**if** _graph_ has edges **then**￼ **return** error _(graph has at least one cycle)_￼**else** ￼ **return** _L_ _(a topologically sorted order)_￼  
If the graph is a [DAG](https://en.wikipedia.org/wiki/Directed_acyclic_graph), a solution will be contained in the list L (the solution is not necessarily unique). Otherwise, the graph must have at least one cycle and therefore a topological sort is impossible.  
Reflecting the non-uniqueness of the resulting sort, the structure S can be simply a set or a queue or a stack. Depending on the order that nodes n are removed from set S, a different solution is created. A variation of Kahn's algorithm that breaks ties [lexicographically](https://en.wikipedia.org/wiki/Lexicographic_order) forms a key component of the [Coffman–Graham algorithm](https://en.wikipedia.org/wiki/Coffman%E2%80%93Graham_algorithm) for parallel scheduling and [layered graph drawing](https://en.wikipedia.org/wiki/Layered_graph_drawing).

### Depth-first search

An alternative algorithm for topological sorting is based on [depth-first search](https://en.wikipedia.org/wiki/Depth-first_search). The algorithm loops through each node of the graph, in an arbitrary order, initiating a depth-first search that terminates when it hits any node that has already been visited since the beginning of the topological sort or the node has no outgoing edges (i.e. a leaf node):  
_L_ ← Empty list that will contain the sorted nodes￼**while** exists nodes without a permanent mark **do**￼ select an unmarked node _n_￼ visit(_n_)￼￼**function** visit(node _n_)￼ **if** _n_ has a permanent mark **then**￼ **return**￼ **if** _n_ has a temporary mark **then**￼ **stop** _(not a DAG)_￼￼ mark _n_ with a temporary mark￼￼ **for each** node _m_ with an edge from _n_ to _m_ **do**￼ visit(_m_)￼￼ remove temporary mark from _n_￼ mark _n_ with a permanent mark￼ add _n_ to head of _L_￼  
Each node _n_ gets _prepended_ to the output list L only after considering all other nodes which depend on _n_ (all descendants of _n_ in the graph). Specifically, when the algorithm adds node _n_, we are guaranteed that all nodes which depend on _n_ are already in the output list L: they were added to L either by the recursive call to visit() which ended before the call to visit _n_, or by a call to visit() which started even before the call to visit _n_. Since each edge and node is visited once, the algorithm runs in linear time. This depth-first-search-based algorithm is the one described by [Cormen et al. (2001)](https://en.wikipedia.org/wiki/Topological_sorting#CITEREFCormenLeisersonRivestStein2001);[[3]](https://en.wikipedia.org/wiki/Topological_sorting#cite_note-CLRS-3) it seems to have been first described in print by Tarjan in 1976.[[4]](https://en.wikipedia.org/wiki/Topological_sorting#cite_note-Tarjan-4)

### Parallel algorithms

On a [parallel random-access machine](https://en.wikipedia.org/wiki/Parallel_random-access_machine), a topological ordering can be constructed in _O_(log2 _n_) time using a polynomial number of processors, putting the problem into the complexity class **NC****2**.[[5]](https://en.wikipedia.org/wiki/Topological_sorting#cite_note-Cook-5) One method for doing this is to repeatedly square the [adjacency matrix](https://en.wikipedia.org/wiki/Adjacency_matrix) of the given graph, logarithmically many times, using [min-plus matrix multiplication](https://en.wikipedia.org/wiki/Min-plus_matrix_multiplication) with maximization in place of minimization. The resulting matrix describes the [longest path](https://en.wikipedia.org/wiki/Longest_path_problem) distances in the graph. Sorting the vertices by the lengths of their longest incoming paths produces a topological ordering.[[6]](https://en.wikipedia.org/wiki/Topological_sorting#cite_note-DNS-6)  
An algorithm for parallel topological sorting on [distributed memory](https://en.wikipedia.org/wiki/Distributed_memory) machines parallelizes the algorithm of Kahn for a [DAG](https://en.wikipedia.org/wiki/Directed_acyclic_graph)

![GV,E](Exported%20image%2020260209134127-2.jpeg)

.[[7]](https://en.wikipedia.org/wiki/Topological_sorting#cite_note-SMDD-7) On a high level, the algorithm of Kahn repeatedly removes the vertices of indegree 0 and adds them to the topological sorting in the order in which they were removed. Since the outgoing edges of the removed vertices are also removed, there will be a new set of vertices of indegree 0, where the procedure is repeated until no vertices are left. This algorithm performs

![displaystyle D1](Exported%20image%2020260209134129-3.jpeg)

iterations, where D is the longest path in G. Each iteration can be parallelized, which is the idea of the following algorithm.  
In the following it is assumed that the graph partition is stored on p processing elements (PE) which are labeled

![displaystyle 0,dots ,p1](Exported%20image%2020260209134134-4.jpeg)

. Each PE i initializes a set of local vertices

![displaystyle Q_i1](Exported%20image%2020260209134135-5.jpeg)

with [indegree](https://en.wikipedia.org/wiki/Indegree) 0, where the upper index represents the current iteration. Since all vertices in the local sets

![displaystyle Q_01,dots ,Q_p11](Exported%20image%2020260209134136-6.jpeg)

have indegree 0, i.e. they are not adjacent, they can be given in an arbitrary order for a valid topological sorting. To assign a global index to each vertex, a [prefix sum](https://en.wikipedia.org/wiki/Prefix_sum) is calculated over the sizes of

![displaystyle Q_01,dots ,Q_p11](Exported%20image%2020260209134138-7.jpeg)

. So each step, there are

![textstyle sum _i0p1Q_i](Exported%20image%2020260209134139-8.jpeg)

vertices added to the topological sorting.

[

![Exported image](Exported%20image%2020260209134140-9.gif)



](https://en.wikipedia.org/wiki/File:Parallel_Topological_Sorting.gif)

Execution of the parallel topological sorting algorithm on a DAG with two processing elements.  
In the first step, PE j assigns the indices

![textstyle sum _i0j1Q_i1,dots ,leftsum _i0jQ_i1righ...](Exported%20image%2020260209134142-10.jpeg)

to the local vertices in

![displaystyle Q_j1](Exported%20image%2020260209134147-11.jpeg)

. These vertices in

![displaystyle Q_j1](Exported%20image%2020260209134148-12.jpeg)

are removed, together with their corresponding outgoing edges. For each outgoing edge

![u,v](Exported%20image%2020260209134149-13.jpeg)

with endpoint v in another PE

![displaystyle l,jneq l](Exported%20image%2020260209134150-14.jpeg)

, the message

![u,v](Exported%20image%2020260209134151-15.jpeg)

is posted to PE l. After all vertices in

![displaystyle Q_j1](Exported%20image%2020260209134152-16.jpeg)

are removed, the posted messages are sent to their corresponding PE. Each message

![u,v](Exported%20image%2020260209134153-17.jpeg)

received updates the indegree of the local vertex v. If the indegree drops to zero, v is added to

![displaystyle Q_j2](Exported%20image%2020260209134203-18.jpeg)

. Then the next iteration starts.  
In step k, PE j assigns the indices

![textstyle a_k1sum _i0j1Q_ik,dots ,a_k1leftsum _i0j...](Exported%20image%2020260209134204-19.jpeg)

, where

![a_k1](Exported%20image%2020260209134205-20.jpeg)

is the total amount of processed vertices after step

![k1](Exported%20image%2020260209134206-21.jpeg)

. This procedure repeats until there are no vertices left to process, hence

![textstyle sum _i0p1Q_iD10](Exported%20image%2020260209134207-22.jpeg)

. Below is a high level, [single program, multiple data](https://en.wikipedia.org/wiki/SPMD) pseudo code overview of this algorithm.  
Note that the [prefix sum](https://en.wikipedia.org/wiki/Prefix_sum#Parallel_algorithms) for the local offsets

![textstyle a_k1sum _i0j1Q_ik,dots ,a_k1leftsum _i0j...](Exported%20image%2020260209134208-23.jpeg)

can be efficiently calculated in parallel.  
**p** processing elements with IDs from 0 to _p_-1￼**Input:** G = (V, E) DAG, distributed to PEs, PE index j = 0, ..., p - 1￼**Output:** topological sorting of G￼￼**function** traverseDAGDistributed￼ δ incoming degree of local vertices _V_￼ _Q_ = {_v_ ∈ _V_ | δ[_v_] = 0} // All vertices with indegree 0￼ nrOfVerticesProcessed = 0￼￼ **do** ￼ **global** build prefix sum over size of _Q_ // get offsets and total amount of vertices in this step￼ offset = nrOfVerticesProcessed + sum(Qi, i = 0 to j - 1) // _j_ is the processor index￼ **foreach** u **in** Q ￼ localOrder[u] = index++;￼ **foreach** (u,v) in E **do** post message (_u, v_) to PE owning vertex _v_￼ nrOfVerticesProcessed += sum(|Qi|, i = 0 to p - 1)￼ deliver all messages to neighbors of vertices in Q ￼ receive messages for local vertices V￼ remove all vertices in Q￼ **foreach** message (_u, v_) received:￼ **if** --δ[v] = 0￼ add _v_ to _Q_￼ **while** global size of _Q_ \> 0￼￼ **return** localOrder￼  
The communication cost depends heavily on the given graph partition. As for runtime, on a [CRCW-PRAM](https://en.wikipedia.org/wiki/CRCW_PRAM) model that allows fetch-and-decrement in constant time, this algorithm runs in

![textstyle mathcal Oleftfrac mnpDDelta log nright](Exported%20image%2020260209134209-24.jpeg)

, where D is again the longest path in G and Δ the maximum degree.[[7]](https://en.wikipedia.org/wiki/Topological_sorting#cite_note-SMDD-7)

## Application to shortest path finding

The topological ordering can also be used to quickly compute [shortest paths](https://en.wikipedia.org/wiki/Shortest_path_problem) through a [weighted](https://en.wikipedia.org/wiki/Weighted_graph) directed acyclic graph. Let V be the list of vertices in such a graph, in topological order. Then the following algorithm computes the shortest path from some source vertex s to all other vertices:[[3]](https://en.wikipedia.org/wiki/Topological_sorting#cite_note-CLRS-3)

- Let d be an array of the same length as V; this will hold the shortest-path distances from s. Set _d_[_s_] = 0, all other _d_[_u_] = ∞.
- Let p be an array of the same length as V, with all elements initialized to nil. Each _p_[_u_] will hold the predecessor of _u_ in the shortest path from s to u.
- Loop over the vertices u as ordered in V, starting from s:
    - For each vertex v directly following u (i.e., there exists an edge from u to v):
        - Let w be the weight of the edge from u to v.
        - Relax the edge: if _d_[_v_] \> _d_[_u_] + _w_, set
            - _d_[_v_] ← _d_[_u_] + _w_,
            - _p_[_v_] ← _u_.
    
Equivalently:

- Let d be an array of the same length as V; this will hold the shortest-path distances from s. Set _d_[_s_] = 0, all other _d_[_u_] = ∞.
- Let p be an array of the same length as V, with all elements initialized to nil. Each _p_[_u_] will hold the predecessor of u in the shortest path from s to u.
- Loop over the vertices u as ordered in V, starting from s:
    - For each vertex v into u (i.e., there exists an edge from v to u):
        - Let w be the weight of the edge from v to u.
        - Relax the edge: if _d_[_u_] \> _d_[_v_] + _w_, set
            - _d_[_u_] ← _d_[_v_] + _w_,
            - _p_[_u_] ← _v_.
    
On a graph of n vertices and m edges, this algorithm takes Θ(_n_ + _m_), i.e., [linear](https://en.wikipedia.org/wiki/Linear_time), time.[[3]](https://en.wikipedia.org/wiki/Topological_sorting#cite_note-CLRS-3)

## Uniqueness

If a topological sort has the property that all pairs of consecutive vertices in the sorted order are connected by edges, then these edges form a directed [Hamiltonian path](https://en.wikipedia.org/wiki/Hamiltonian_path) in the [DAG](https://en.wikipedia.org/wiki/Directed_acyclic_graph). If a Hamiltonian path exists, the topological sort order is unique; no other order respects the edges of the path. Conversely, if a topological sort does not form a Hamiltonian path, the DAG will have two or more valid topological orderings, for in this case it is always possible to form a second valid ordering by swapping two consecutive vertices that are not connected by an edge to each other. Therefore, it is possible to test in linear time whether a unique ordering exists, and whether a Hamiltonian path exists, despite the [NP-hardness](https://en.wikipedia.org/wiki/NP-hard) of the Hamiltonian path problem for more general directed graphs (i.e. cyclic directed graphs).[[8]](https://en.wikipedia.org/wiki/Topological_sorting#cite_note-VM-8)

## Relation to partial orders

Topological orderings are also closely related to the concept of a [linear extension](https://en.wikipedia.org/wiki/Linear_extension) of a [partial order](https://en.wikipedia.org/wiki/Partial_order) in mathematics. A partially ordered set is just a set of objects together with a definition of the "≤" inequality relation, satisfying the axioms of reflexivity (_x_ ≤ _x_), antisymmetry (if _x_ ≤ _y_ and _y_ ≤ _x_ then _x_ = _y_) and [transitivity](https://en.wikipedia.org/wiki/Transitive_relation) (if _x_ ≤ _y_ and _y_ ≤ _z_, then _x_ ≤ _z_). A [total order](https://en.wikipedia.org/wiki/Total_order) is a partial order in which, for every two objects _x_ and _y_ in the set, either _x_ ≤ _y_ or _y_ ≤ _x_. Total orders are familiar in computer science as the comparison operators needed to perform [comparison sorting](https://en.wikipedia.org/wiki/Comparison_sort) algorithms. For finite sets, total orders may be identified with linear sequences of objects, where the "≤" relation is true whenever the first object precedes the second object in the order; a comparison sorting algorithm may be used to convert a total order into a sequence in this way. A linear extension of a partial order is a total order that is compatible with it, in the sense that, if _x_ ≤ _y_ in the partial order, then _x_ ≤ _y_ in the total order as well.  
One can define a partial ordering from any DAG by letting the set of objects be the vertices of the DAG, and defining _x_ ≤ _y_ to be true, for any two vertices _x_ and _y_, whenever there exists a [directed path](https://en.wikipedia.org/wiki/Directed_path) from _x_ to _y_; that is, whenever _y_ is [reachable](https://en.wikipedia.org/wiki/Reachability) from _x_. With these definitions, a topological ordering of the DAG is the same thing as a linear extension of this partial order. Conversely, any partial ordering may be defined as the reachability relation in a DAG. One way of doing this is to define a DAG that has a vertex for every object in the partially ordered set, and an edge _xy_ for every pair of objects for which _x_ ≤ _y_. An alternative way of doing this is to use the [transitive reduction](https://en.wikipedia.org/wiki/Transitive_reduction) of the partial ordering; in general, this produces DAGs with fewer edges, but the reachability relation in these DAGs is still the same partial order. By using these constructions, one can use topological ordering algorithms to find linear extensions of partial orders.

## Relation to scheduling optimisation

By definition, the solution of a scheduling problem that includes a precedence graph is a valid solution to topological sort (irrespective of the number of machines), however, topological sort in itself is _not_ enough to optimally solve a scheduling optimisation problem. Hu's algorithm is a popular method used to solve scheduling problems that require a precedence graph and involve processing times (where the goal is to minimise the largest completion time amongst all the jobs). Like topological sort, Hu's algorithm is not unique and can be solved using DFS (by finding the largest path length and then assigning the jobs).

## See also

- [tsort](https://en.wikipedia.org/wiki/Tsort), a Unix program for topological sorting
- [Feedback arc set](https://en.wikipedia.org/wiki/Feedback_arc_set), a set of edges whose removal allows the remaining subgraph to be topologically sorted
- [Tarjan's strongly connected components algorithm](https://en.wikipedia.org/wiki/Tarjan%27s_strongly_connected_components_algorithm), an algorithm that gives the topologically sorted list of strongly connected components in a graph
- [Pre-topological order](https://en.wikipedia.org/wiki/Pre-topological_order)

## References

\> Jarnagin, M. P. (1960), _Automatic machine methods of testing PERT networks for consistency_, Technical Memorandum No. K-24/60, Dahlgren, Virginia: U. S. Naval Weapons Laboratory  

1. \> Jarnagin, M. P. (1960), _Automatic machine methods of testing PERT networks for consistency_, Technical Memorandum No. K-24/60, Dahlgren, Virginia: U. S. Naval Weapons Laboratory  
    
2. \> Kahn, Arthur B. (1962), "Topological sorting of large networks", _Communications of the ACM_, **5** (11): 558–562, [doi](https://en.wikipedia.org/wiki/Doi_\(identifier\)):[10.1145/368996.369025](https://doi.org/10.1145%2F368996.369025), [S2CID](https://en.wikipedia.org/wiki/S2CID_\(identifier\)) [16728233](https://api.semanticscholar.org/CorpusID:16728233)  
    
3. \> [Cormen, Thomas H.](https://en.wikipedia.org/wiki/Thomas_H._Cormen); [Leiserson, Charles E.](https://en.wikipedia.org/wiki/Charles_E._Leiserson); [Rivest, Ronald L.](https://en.wikipedia.org/wiki/Ronald_L._Rivest); [Stein, Clifford](https://en.wikipedia.org/wiki/Clifford_Stein) (2001), "Section 22.4: Topological sort", _Introduction to Algorithms_ _(2nd ed.), MIT Press and McGraw-Hill, pp. 549–552,_ _ISBN_ _0-262-03293-7_  
    
4. \> [Tarjan, Robert E.](https://en.wikipedia.org/wiki/Robert_Tarjan) (1976), "Edge-disjoint spanning trees and depth-first search", _Acta Informatica_, **6** (2): 171–185, [doi](https://en.wikipedia.org/wiki/Doi_\(identifier\)):[10.1007/BF00268499](https://doi.org/10.1007%2FBF00268499), [S2CID](https://en.wikipedia.org/wiki/S2CID_\(identifier\)) [12044793](https://api.semanticscholar.org/CorpusID:12044793)  
    
5. \> [Cook, Stephen A.](https://en.wikipedia.org/wiki/Stephen_Cook) (1985), "A Taxonomy of Problems with Fast Parallel Algorithms", _Information and Control_, **64** (1–3): 2–22, [doi](https://en.wikipedia.org/wiki/Doi_\(identifier\)):[10.1016/S0019-9958(85)80041-3](https://doi.org/10.1016%2FS0019-9958%2885%2980041-3)  
    
6. \> Dekel, Eliezer; Nassimi, David; Sahni, Sartaj (1981), "Parallel matrix and graph algorithms", _SIAM Journal on Computing_, **10** (4): 657–675, [doi](https://en.wikipedia.org/wiki/Doi_\(identifier\)):[10.1137/0210049](https://doi.org/10.1137%2F0210049), [MR](https://en.wikipedia.org/wiki/MR_\(identifier\)) [0635424](https://www.ams.org/mathscinet-getitem?mr=0635424)  
    
7. \> Sanders, Peter; Mehlhorn, Kurt; Dietzfelbinger, Martin; Dementiev, Roman (2019), _Sequential and Parallel Algorithms and Data Structures: The Basic Toolbox__, Springer International Publishing,_ _ISBN_ _978-3-030-25208-3_  
    
8. \> Vernet, Oswaldo; Markenzon, Lilian (1997), ["Hamiltonian problems for reducible flowgraphs"](http://pantheon.ufrj.br/bitstream/11422/2585/4/02_97_000575787.pdf) (PDF), _Proceedings: 17th International Conference of the Chilean Computer Science Society_, pp. 264–267, [doi](https://en.wikipedia.org/wiki/Doi_\(identifier\)):[10.1109/SCCC.1997.637099](https://doi.org/10.1109%2FSCCC.1997.637099), [hdl](https://en.wikipedia.org/wiki/Hdl_\(identifier\)):[11422/2585](https://hdl.handle.net/11422%2F2585), [S2CID](https://en.wikipedia.org/wiki/S2CID_\(identifier\)) [206554481](https://api.semanticscholar.org/CorpusID:206554481)  
    

\> Kahn, Arthur B. (1962), "Topological sorting of large networks", _Communications of the ACM_, **5** (11): 558–562, [doi](https://en.wikipedia.org/wiki/Doi_\(identifier\)):[10.1145/368996.369025](https://doi.org/10.1145%2F368996.369025), [S2CID](https://en.wikipedia.org/wiki/S2CID_\(identifier\)) [16728233](https://api.semanticscholar.org/CorpusID:16728233)  
\> [Cormen, Thomas H.](https://en.wikipedia.org/wiki/Thomas_H._Cormen); [Leiserson, Charles E.](https://en.wikipedia.org/wiki/Charles_E._Leiserson); [Rivest, Ronald L.](https://en.wikipedia.org/wiki/Ronald_L._Rivest); [Stein, Clifford](https://en.wikipedia.org/wiki/Clifford_Stein) (2001), "Section 22.4: Topological sort", _Introduction to Algorithms_ _(2nd ed.), MIT Press and McGraw-Hill, pp. 549–552,_ _ISBN_ _0-262-03293-7_  
\> [Tarjan, Robert E.](https://en.wikipedia.org/wiki/Robert_Tarjan) (1976), "Edge-disjoint spanning trees and depth-first search", _Acta Informatica_, **6** (2): 171–185, [doi](https://en.wikipedia.org/wiki/Doi_\(identifier\)):[10.1007/BF00268499](https://doi.org/10.1007%2FBF00268499), [S2CID](https://en.wikipedia.org/wiki/S2CID_\(identifier\)) [12044793](https://api.semanticscholar.org/CorpusID:12044793)  
\> [Cook, Stephen A.](https://en.wikipedia.org/wiki/Stephen_Cook) (1985), "A Taxonomy of Problems with Fast Parallel Algorithms", _Information and Control_, **64** (1–3): 2–22, [doi](https://en.wikipedia.org/wiki/Doi_\(identifier\)):[10.1016/S0019-9958(85)80041-3](https://doi.org/10.1016%2FS0019-9958%2885%2980041-3)  
\> Dekel, Eliezer; Nassimi, David; Sahni, Sartaj (1981), "Parallel matrix and graph algorithms", _SIAM Journal on Computing_, **10** (4): 657–675, [doi](https://en.wikipedia.org/wiki/Doi_\(identifier\)):[10.1137/0210049](https://doi.org/10.1137%2F0210049), [MR](https://en.wikipedia.org/wiki/MR_\(identifier\)) [0635424](https://www.ams.org/mathscinet-getitem?mr=0635424)  
\> Sanders, Peter; Mehlhorn, Kurt; Dietzfelbinger, Martin; Dementiev, Roman (2019), _Sequential and Parallel Algorithms and Data Structures: The Basic Toolbox__, Springer International Publishing,_ _ISBN_ _978-3-030-25208-3_  
\> Vernet, Oswaldo; Markenzon, Lilian (1997), ["Hamiltonian problems for reducible flowgraphs"](http://pantheon.ufrj.br/bitstream/11422/2585/4/02_97_000575787.pdf) (PDF), _Proceedings: 17th International Conference of the Chilean Computer Science Society_, pp. 264–267, [doi](https://en.wikipedia.org/wiki/Doi_\(identifier\)):[10.1109/SCCC.1997.637099](https://doi.org/10.1109%2FSCCC.1997.637099), [hdl](https://en.wikipedia.org/wiki/Hdl_\(identifier\)):[11422/2585](https://hdl.handle.net/11422%2F2585), [S2CID](https://en.wikipedia.org/wiki/S2CID_\(identifier\)) [206554481](https://api.semanticscholar.org/CorpusID:206554481)  

## Further reading

- [D. E. Knuth](https://en.wikipedia.org/wiki/D._E._Knuth), [The Art of Computer Programming](https://en.wikipedia.org/wiki/The_Art_of_Computer_Programming), Volume 1, section 2.2.3, which gives an algorithm for topological sorting of a partial ordering, and a brief history.