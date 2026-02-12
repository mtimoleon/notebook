---
categories:
  - "[[Clippings]]"
  - "[[Work]]"
title: Round-robin scheduling - Wikipedia
source: https://en.wikipedia.org/wiki/Round-robin_scheduling
author:
  - "[[Wikipedia]]"
created: 2026-02-12
description:
tags:
  - clippings
  - wikipedia
  - intelligen
---
This article is about scheduling in computing. For other uses, see [Round-robin (disambiguation)](https://en.wikipedia.org/wiki/Round-robin_\(disambiguation\) "Round-robin (disambiguation)").

![](https://upload.wikimedia.org/wikipedia/commons/thumb/7/76/Round_Robin_Schedule_Example.jpg/960px-Round_Robin_Schedule_Example.jpg)

A Round Robin preemptive scheduling example with quantum=3

**Round-robin** (**RR**) is one of the algorithms employed by [process](https://en.wikipedia.org/wiki/Process_scheduler "Process scheduler") and [network schedulers](https://en.wikipedia.org/wiki/Network_scheduler "Network scheduler") in [computing](https://en.wikipedia.org/wiki/Computing "Computing").<sup id="cite_ref-ostep-1_1-0" class="reference"><a href="https://en.wikipedia.org/wiki/#cite_note-ostep-1-1"><span class="cite-bracket">[</span>1<span class="cite-bracket">]</span></a></sup><sup id="cite_ref-Zander_2-0" class="reference"><a href="https://en.wikipedia.org/wiki/#cite_note-Zander-2"><span class="cite-bracket">[</span>2<span class="cite-bracket">]</span></a></sup> As the term is generally used, [time slices](https://en.wikipedia.org/wiki/Preemption_\(computing\)#Time_slice "Preemption (computing)") (also known as time quanta)<sup id="cite_ref-3" class="reference"><a href="https://en.wikipedia.org/wiki/#cite_note-3"><span class="cite-bracket">[</span>3<span class="cite-bracket">]</span></a></sup> are assigned to each process in equal portions and in circular order, handling all processes without [priority](https://en.wiktionary.org/wiki/priority "wikt:priority") (also known as [cyclic executive](https://en.wikipedia.org/wiki/Cyclic_executive "Cyclic executive")). Round-robin scheduling is simple, easy to implement, and [starvation](https://en.wikipedia.org/wiki/Resource_starvation "Resource starvation")\-free. Round-robin scheduling can be applied to other scheduling problems, such as data packet scheduling in computer networks. It is an [operating system](https://en.wikipedia.org/wiki/Operating_system "Operating system") concept.

The name of the algorithm comes from the [round-robin](https://en.wikipedia.org/wiki/Round-robin_\(disambiguation\) "Round-robin (disambiguation)") principle known from other fields, where each person takes an equal share of something in turn.

## Process scheduling

\[[edit](https://en.wikipedia.org/w/index.php?title=Round-robin_scheduling&action=edit&section=1 "Edit section: Process scheduling")\]

To [schedule processes](https://en.wikipedia.org/wiki/Process_scheduler "Process scheduler") fairly, a round-robin scheduler generally employs [time-sharing](https://en.wikipedia.org/wiki/Time-sharing "Time-sharing"), giving each job a time slot or *quantum*<sup id="cite_ref-McConnell2004_4-0" class="reference"><a href="https://en.wikipedia.org/wiki/#cite_note-McConnell2004-4"><span class="cite-bracket">[</span>4<span class="cite-bracket">]</span></a></sup> (its allowance of CPU time), and interrupting the job if it is not completed by then. The job is resumed next time a time slot is assigned to that process. If the process terminates or changes its state to waiting during its attributed time quantum, the scheduler selects the first process in the ready queue to execute. In the absence of time-sharing, or if the quanta were large relative to the sizes of the jobs, a process that produced large jobs would be favored over other processes.

Round-robin algorithm is a pre-emptive algorithm as the scheduler forces the process out of the CPU once the time quota expires.

For example, if the time slot is 100 milliseconds, and *job1* takes a total time of 250 ms to complete, the round-robin scheduler will suspend the job after 100 ms and give other jobs their time on the CPU. Once the other jobs have had their equal share (100 ms each), *job1* will get another allocation of [CPU](https://en.wikipedia.org/wiki/CPU "CPU") time and the cycle will repeat. This process continues until the job finishes and needs no more time on the CPU.

- **Job1 = Total time to complete 250 ms (quantum 100 ms)**.
1. First allocation = 100 ms.
2. Second allocation = 100 ms.
3. Third allocation = 100 ms but *job1* self-terminates after 50 ms.
4. Total CPU time of *job1* = 250 ms

Consider the following table with the arrival time and execute time of the process with the quantum time of 100 ms to understand the round-robin scheduling:

| Process name | Arrival time | Execute time |
| --- | --- | --- |
| P0 | 0 | 250 |
| P1 | 50 | 170 |
| P2 | 130 | 75 |
| P3 | 190 | 100 |
| P4 | 210 | 130 |
| P5 | 350 | 50 |

![Round Robin Scheduling](https://upload.wikimedia.org/wikipedia/commons/thumb/5/50/RoundRobin.jpg/960px-RoundRobin.jpg)

Round Robin Scheduling

Another approach is to divide all processes into an equal number of timing quanta such that the quantum size is proportional to the size of the process. Hence, all processes end at the same time.

## Network packet scheduling

\[[edit](https://en.wikipedia.org/w/index.php?title=Round-robin_scheduling&action=edit&section=2 "Edit section: Network packet scheduling")\]

Main article: [Network scheduler](https://en.wikipedia.org/wiki/Network_scheduler "Network scheduler")

In [best-effort](https://en.wikipedia.org/wiki/Best-effort "Best-effort") [packet switching](https://en.wikipedia.org/wiki/Packet_switching "Packet switching") and other [statistical multiplexing](https://en.wikipedia.org/wiki/Statistical_multiplexing "Statistical multiplexing"), round-robin scheduling can be used as an alternative to [first-come first-served](https://en.wikipedia.org/wiki/First-come_first-served "First-come first-served") queuing.

A multiplexer, switch, or router that provides round-robin scheduling has a separate queue for every data flow, where a data flow may be identified by its source and destination address. The algorithm allows every active data flow that has data packets in the queue to take turns in transferring packets on a shared channel in a periodically repeated order. The scheduling is [work-conserving](https://en.wikipedia.org/wiki/Work-conserving_scheduler "Work-conserving scheduler"), meaning that if one flow is out of packets, the next data flow will take its place. Hence, the scheduling tries to prevent link resources from going unused.

Round-robin scheduling results in [max-min fairness](https://en.wikipedia.org/wiki/Max-min_fairness "Max-min fairness") if the data packets are equally sized, since the data flow that has waited the longest time is given scheduling priority. It may not be desirable if the size of the data packets varies widely from one job to another. A user that produces large packets would be favored over other users. In that case [fair queuing](https://en.wikipedia.org/wiki/Fair_queuing "Fair queuing") would be preferable.

If guaranteed or differentiated quality of service is offered, and not only best-effort communication, [deficit round-robin](https://en.wikipedia.org/wiki/Deficit_round_robin "Deficit round robin") (DRR) scheduling, [weighted round-robin](https://en.wikipedia.org/wiki/Weighted_round_robin "Weighted round robin") (WRR) scheduling, or [weighted fair queuing](https://en.wikipedia.org/wiki/Weighted_fair_queuing "Weighted fair queuing") (WFQ) may be considered.

In [multiple-access](https://en.wikipedia.org/wiki/Multiple_access "Multiple access") networks, where several terminals are connected to a shared physical medium, round-robin scheduling may be provided by [token passing](https://en.wikipedia.org/wiki/Token_passing "Token passing") [channel access](https://en.wikipedia.org/wiki/Channel_access "Channel access") schemes such as [Token Ring](https://en.wikipedia.org/wiki/Token_Ring "Token Ring"), or by [polling](https://en.wikipedia.org/wiki/Polling_\(computer_science\) "Polling (computer science)") or resource reservation from a central control station.

In a centralized wireless packet radio network, where many stations share one frequency channel, a scheduling algorithm in a central base station may reserve time slots for the mobile stations in a round-robin fashion and provide fairness. However, if [link adaptation](https://en.wikipedia.org/wiki/Link_adaptation "Link adaptation") is used, it will take a much longer time to transmit a certain amount of data to "expensive" users than to others since the channel conditions differ. It would be more efficient to wait with the transmission until the channel conditions are improved, or at least to give scheduling priority to less expensive users. Round-robin scheduling does not utilize this. Higher throughput and [system spectrum efficiency](https://en.wikipedia.org/wiki/System_spectrum_efficiency "System spectrum efficiency") may be achieved by channel-dependent scheduling, for example a [proportionally fair](https://en.wikipedia.org/wiki/Proportionally_fair "Proportionally fair") algorithm, or [maximum throughput scheduling](https://en.wikipedia.org/wiki/Maximum_throughput_scheduling "Maximum throughput scheduling"). Note that the latter is characterized by undesirable [scheduling starvation](https://en.wikipedia.org/wiki/Scheduling_starvation "Scheduling starvation"). This type of scheduling is one of the very basic algorithms for Operating Systems in computers which can be implemented through a circular queue data structure.

## See also

\[[edit](https://en.wikipedia.org/w/index.php?title=Round-robin_scheduling&action=edit&section=3 "Edit section: See also")\]

- [Multilevel queue](https://en.wikipedia.org/wiki/Multilevel_queue "Multilevel queue")
- `[SCHED_RR](https://en.wikipedia.org/wiki/SCHED_RR "SCHED RR")`

## References

\[[edit](https://en.wikipedia.org/w/index.php?title=Round-robin_scheduling&action=edit&section=4 "Edit section: References")\]

1. **[^](https://en.wikipedia.org/wiki/#cite_ref-ostep-1_1-0 "Jump up")** Arpaci-Dusseau, Remzi H.; Arpaci-Dusseau, Andrea C. (2014), [*Operating Systems: Three Easy Pieces \[Chapter: Scheduling Introduction\]*](https://pages.cs.wisc.edu/~remzi/OSTEP/cpu-sched.pdf) (PDF), Arpaci-Dusseau Books
2. **[^](https://en.wikipedia.org/wiki/#cite_ref-Zander_2-0 "Jump up")** [Guowang Miao](https://en.wikipedia.org/wiki/Guowang_Miao "Guowang Miao"), Jens Zander, Ki Won Sung, and Ben Slimane, Fundamentals of Mobile Data Networks, Cambridge University Press, [ISBN](https://en.wikipedia.org/wiki/ISBN_\(identifier\) "ISBN (identifier)") [1107143217](https://en.wikipedia.org/wiki/Special:BookSources/1107143217 "Special:BookSources/1107143217"), 2016.
3. **[^](https://en.wikipedia.org/wiki/#cite_ref-3 "Jump up")** Stallings, William (2015). *Operating Systems: Internals and Design Principles*. Pearson. p. 409. [ISBN](https://en.wikipedia.org/wiki/ISBN_\(identifier\) "ISBN (identifier)") [978-0-13-380591-8](https://en.wikipedia.org/wiki/Special:BookSources/978-0-13-380591-8 "Special:BookSources/978-0-13-380591-8").
4. **[^](https://en.wikipedia.org/wiki/#cite_ref-McConnell2004_4-0 "Jump up")** [Silberschatz, Abraham](https://en.wikipedia.org/wiki/Abraham_Silberschatz "Abraham Silberschatz"); Galvin, Peter B.; Gagne, Greg (2010). "Process Scheduling". *[Operating System Concepts](https://en.wikipedia.org/wiki/Operating_System_Concepts "Operating System Concepts")* (8th ed.). [John Wiley & Sons](https://en.wikipedia.org/wiki/John_Wiley_%26_Sons "John Wiley & Sons") (Asia). p. 194. [ISBN](https://en.wikipedia.org/wiki/ISBN_\(identifier\) "ISBN (identifier)") [978-0-470-23399-3](https://en.wikipedia.org/wiki/Special:BookSources/978-0-470-23399-3 "Special:BookSources/978-0-470-23399-3"). 5.3.4 Round Robin Scheduling

## Further reading

\[[edit](https://en.wikipedia.org/w/index.php?title=Round-robin_scheduling&action=edit&section=5 "Edit section: Further reading")\]

- [Optimized Round Robin CPU Scheduling Algorithm](https://dl.acm.org/doi/10.1145/3484824.3484917)
- [Round robin Scheduling in C++](https://www.studytonight.com/cpp-programs/cpp-program-for-round-robin-scheduling-algorithm)
- [Round robin Scheduling in C](https://www.ccbp.in/blog/articles/round-robin-program-in-c)

![](https://en.wikipedia.org/wiki/Special:CentralAutoLogin/start?useformat=desktop&type=1x1&usesul3=1)