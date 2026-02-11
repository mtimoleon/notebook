Clipped from: [https://en.wikipedia.org/wiki/Round-robin_scheduling](https://en.wikipedia.org/wiki/Round-robin_scheduling)

[Jump to navigation](https://en.wikipedia.org/wiki/Round-robin_scheduling#mw-head) [Jump to search](https://en.wikipedia.org/wiki/Round-robin_scheduling#searchInput)

This article is about scheduling in computing. For other uses, see [Round-robin (disambiguation)](https://en.wikipedia.org/wiki/Round-robin_\(disambiguation\)).

[

![Exported image](Exported%20image%2020260209134215-0.jpeg)



](https://en.wikipedia.org/wiki/File:Round_Robin_Schedule_Example.jpg)

A Round Robin preemptive scheduling example with quantum=3  
**Round-robin** (**RR**) is one of the algorithms employed by [process](https://en.wikipedia.org/wiki/Process_scheduler) and [network schedulers](https://en.wikipedia.org/wiki/Network_scheduler) in [computing](https://en.wikipedia.org/wiki/Computing).[[1]](https://en.wikipedia.org/wiki/Round-robin_scheduling#cite_note-ostep-1-1)[[2]](https://en.wikipedia.org/wiki/Round-robin_scheduling#cite_note-Zander-2) As the term is generally used, [time slices](https://en.wikipedia.org/wiki/Preemption_\(computing\)#Time_slice) (also known as time quanta)[[3]](https://en.wikipedia.org/wiki/Round-robin_scheduling#cite_note-3) are assigned to each process in equal portions and in circular order, handling all processes without [priority](https://en.wiktionary.org/wiki/priority) (also known as [cyclic executive](https://en.wikipedia.org/wiki/Cyclic_executive)). Round-robin scheduling is simple, easy to implement, and [starvation](https://en.wikipedia.org/wiki/Resource_starvation)-free. Round-robin scheduling can be applied to other scheduling problems, such as data packet scheduling in computer networks. It is an [operating system](https://en.wikipedia.org/wiki/Operating_system) concept.[[4]](https://en.wikipedia.org/wiki/Round-robin_scheduling#cite_note-4)  
The name of the algorithm comes from the [round-robin](https://en.wikipedia.org/wiki/Round-robin_\(disambiguation\)) principle known from other fields, where each person takes an equal share of something in turn.

## Process scheduling

To [schedule processes](https://en.wikipedia.org/wiki/Process_scheduler) fairly, a round-robin scheduler generally employs [time-sharing](https://en.wikipedia.org/wiki/Time-sharing), giving each job a time slot or _quantum_[[5]](https://en.wikipedia.org/wiki/Round-robin_scheduling#cite_note-McConnell2004-5) (its allowance of CPU time), and interrupting the job if it is not completed by then. The job is resumed next time a time slot is assigned to that process. If the process terminates or changes its state to waiting during its attributed time quantum, the scheduler selects the first process in the ready queue to execute. In the absence of time-sharing, or if the quanta were large relative to the sizes of the jobs, a process that produced large jobs would be favored over other processes.  
Round-robin algorithm is a pre-emptive algorithm as the scheduler forces the process out of the CPU once the time quota expires.  
For example, if the time slot is 100 milliseconds, and _job1_ takes a total time of 250 ms to complete, the round-robin scheduler will suspend the job after 100 ms and give other jobs their time on the CPU. Once the other jobs have had their equal share (100 ms each), _job1_ will get another allocation of [CPU](https://en.wikipedia.org/wiki/CPU) time and the cycle will repeat. This process continues until the job finishes and needs no more time on the CPU.

- **Job1 = Total time to complete 250 ms (quantum 100 ms)**.
 
1. First allocation = 100 ms.
2. Second allocation = 100 ms.
3. Third allocation = 100 ms but _job1_ self-terminates after 50 ms.
4. Total CPU time of _job1_ = 250 ms

Consider the following table with the arrival time and execute time of the process with the quantum time of 100 ms to understand the round-robin scheduling:  
Process name Arrival time Execute time

|   |   |   |
|---|---|---|
||||
|P0|0|250|
|P1|50|170|
|P2|130|75|
|P3|190|100|
|P4|210|130|
|P5|350|50|

[

![Round Robin Scheduling](Exported%20image%2020260209134216-1.jpeg)



](https://en.wikipedia.org/wiki/File:RoundRobin.jpg)

Another approach is to divide all processes into an equal number of timing quanta such that the quantum size is proportional to the size of the process. Hence, all processes end at the same time.

## Network packet scheduling

Main article: [Network scheduler](https://en.wikipedia.org/wiki/Network_scheduler)  
In [best-effort](https://en.wikipedia.org/wiki/Best-effort) [packet switching](https://en.wikipedia.org/wiki/Packet_switching) and other [statistical multiplexing](https://en.wikipedia.org/wiki/Statistical_multiplexing), round-robin scheduling can be used as an alternative to [first-come first-served](https://en.wikipedia.org/wiki/First-come_first-served) queuing.  
A multiplexer, switch, or router that provides round-robin scheduling has a separate queue for every data flow, where a data flow may be identified by its source and destination address. The algorithm allows every active data flow that has data packets in the queue to take turns in transferring packets on a shared channel in a periodically repeated order. The scheduling is [work-conserving](https://en.wikipedia.org/w/index.php?title=Work-conserving&action=edit&redlink=1), meaning that if one flow is out of packets, the next data flow will take its place. Hence, the scheduling tries to prevent link resources from going unused.  
Round-robin scheduling results in [max-min fairness](https://en.wikipedia.org/wiki/Max-min_fairness) if the data packets are equally sized, since the data flow that has waited the longest time is given scheduling priority. It may not be desirable if the size of the data packets varies widely from one job to another. A user that produces large packets would be favored over other users. In that case [fair queuing](https://en.wikipedia.org/wiki/Fair_queuing) would be preferable.  
If guaranteed or differentiated quality of service is offered, and not only best-effort communication, [deficit round-robin](https://en.wikipedia.org/wiki/Deficit_round_robin) (DRR) scheduling, [weighted round-robin](https://en.wikipedia.org/wiki/Weighted_round_robin) (WRR) scheduling, or [weighted fair queuing](https://en.wikipedia.org/wiki/Weighted_fair_queuing) (WFQ) may be considered.  
In [multiple-access](https://en.wikipedia.org/wiki/Multiple_access) networks, where several terminals are connected to a shared physical medium, round-robin scheduling may be provided by [token passing](https://en.wikipedia.org/wiki/Token_passing) [channel access](https://en.wikipedia.org/wiki/Channel_access) schemes such as [Token Ring](https://en.wikipedia.org/wiki/Token_Ring), or by [polling](https://en.wikipedia.org/wiki/Polling_\(computer_science\)) or resource reservation from a central control station.  
In a centralized wireless packet radio network, where many stations share one frequency channel, a scheduling algorithm in a central base station may reserve time slots for the mobile stations in a round-robin fashion and provide fairness. However, if [link adaptation](https://en.wikipedia.org/wiki/Link_adaptation) is used, it will take a much longer time to transmit a certain amount of data to "expensive" users than to others since the channel conditions differ. It would be more efficient to wait with the transmission until the channel conditions are improved, or at least to give scheduling priority to less expensive users. Round-robin scheduling does not utilize this. Higher throughput and [system spectrum efficiency](https://en.wikipedia.org/wiki/System_spectrum_efficiency) may be achieved by channel-dependent scheduling, for example a [proportionally fair](https://en.wikipedia.org/wiki/Proportionally_fair) algorithm, or [maximum throughput scheduling](https://en.wikipedia.org/wiki/Maximum_throughput_scheduling). Note that the latter is characterized by undesirable [scheduling starvation](https://en.wikipedia.org/wiki/Scheduling_starvation). This type of scheduling is one of the very basic algorithms for Operating Systems in computers which can be implemented through a circular queue data structure.

## See also

- [Multilevel queue](https://en.wikipedia.org/wiki/Multilevel_queue)

## References

\> Arpaci-Dusseau, Remzi H.; Arpaci-Dusseau, Andrea C. (2014), _Operating Systems: Three Easy Pieces [Chapter: Scheduling Introduction]_ _(PDF), Arpaci-Dusseau Books_  

1. \> Arpaci-Dusseau, Remzi H.; Arpaci-Dusseau, Andrea C. (2014), _Operating Systems: Three Easy Pieces [Chapter: Scheduling Introduction]_ _(PDF), Arpaci-Dusseau Books_  
    
2. [Guowang Miao](https://en.wikipedia.org/wiki/Guowang_Miao), Jens Zander, Ki Won Sung, and Ben Slimane, Fundamentals of Mobile Data Networks, Cambridge University Press, [ISBN](https://en.wikipedia.org/wiki/ISBN_\(identifier\)) [1107143217](https://en.wikipedia.org/wiki/Special:BookSources/1107143217), 2016.
3. \> Stallings, William (2015). _Operating Systems: Internals and Design Principles_. Pearson. p. 409. [ISBN](https://en.wikipedia.org/wiki/ISBN_\(identifier\)) [978-0-13-380591-8](https://en.wikipedia.org/wiki/Special:BookSources/978-0-13-380591-8).  
    
4. \> Nash, Stacey L. (2022-06-11). ["Best scheduling software of 2022"](https://www.popsci.com/gear/best-scheduling-software/). _Popular Science_. Retrieved 2022-07-07.  
    
5. \> [Silberschatz, Abraham](https://en.wikipedia.org/wiki/Abraham_Silberschatz); Galvin, Peter B.; Gagne, Greg (2010). "Process Scheduling". _Operating System Concepts_ _(8th ed.)._ _John Wiley & Sons_ _(Asia). p. 194._ _ISBN_ _978-0-470-23399-3__. 5.3.4 Round Robin Scheduling_  
    

\> Stallings, William (2015). _Operating Systems: Internals and Design Principles_. Pearson. p. 409. [ISBN](https://en.wikipedia.org/wiki/ISBN_\(identifier\)) [978-0-13-380591-8](https://en.wikipedia.org/wiki/Special:BookSources/978-0-13-380591-8).  
\> Nash, Stacey L. (2022-06-11). ["Best scheduling software of 2022"](https://www.popsci.com/gear/best-scheduling-software/). _Popular Science_. Retrieved 2022-07-07.  
\> [Silberschatz, Abraham](https://en.wikipedia.org/wiki/Abraham_Silberschatz); Galvin, Peter B.; Gagne, Greg (2010). "Process Scheduling". _Operating System Concepts_ _(8th ed.)._ _John Wiley & Sons_ _(Asia). p. 194._ _ISBN_ _978-0-470-23399-3__. 5.3.4 Round Robin Scheduling_