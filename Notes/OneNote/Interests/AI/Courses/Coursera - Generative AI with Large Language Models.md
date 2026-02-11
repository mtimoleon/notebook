Models use cases

- ==Autoencoding== models are pre-trained using masked language modeling.

They correspond to the encoder part of the original transformer architecture, and are often ==used with sentence classification== ==or token classification==. 

- ==Autoregressive== models are pre-trained using causal language modeling. 

Models of this type make use of the decoder component of the original transformer architecture, and often ==used for text generation==. 

- ==Sequence-to-sequence== models use both the encoder and decoder part off the original transformer architecture. Sequence-to-sequence models are often ==used for translation, summarization, and question-answering==.
    
![Exported image](Exported%20image%2020260209130250-0.png)  
![Exported image](Exported%20image%2020260209130254-1.png)   ![Exported image](Exported%20image%2020260209130255-2.png)  

Week 1 resources  
Below you'll find links to the research papers discussed in this weeks videos. You don't need to understand all the technical details discussed in these papers - **you have already seen the most important points you'll need to answer the quizzes** in the lecture videos.  
==However, if you'd like to take a closer look at the original research, you can read the papers and articles via the links below.==
 
**Generative AI Lifecycle**

- **Generative AI on AWS: Building Context-Aware, Multimodal Reasoning Applications** ==- This O'Reilly book dives deep into all phases of the generative AI lifecycle including model selection, fine-tuning, adapting, evaluation, deployment, and runtime optimizations.==

**Transformer Architecture**

- **Attention is All You Need** ==- This paper introduced the Transformer architecture, with the core “self-attention” mechanism. This article was the foundation for LLMs.==
- **BLOOM: BigScience 176B Model** ==- BLOOM is a open-source LLM with 176B parameters trained in an open and transparent way. In this paper, the authors present a detailed discussion of the dataset and process used to train the model. You can also see a high-level overview of the model== ==here====.==
- **Vector Space Models** ==- Series of lessons from DeepLearning.AI's Natural Language Processing specialization discussing the basics of vector space models and their use in language modeling.==

**Pre-training and scaling laws**

- **Scaling Laws for Neural Language Models** ==- empirical study by researchers at OpenAI exploring the scaling laws for large language models.==

**Model architectures and pre-training objectives**

- **What Language Model Architecture and Pretraining Objective Work Best for Zero-Shot Generalization?** ==- The paper examines modeling choices in large pre-trained language models and identifies the optimal approach for zero-shot generalization.==
- **HuggingFace Tasks** **and** **Model Hub** ==- Collection of resources to tackle varying machine learning tasks using the HuggingFace library.==
- **LLaMA: Open and Efficient Foundation Language Models** ==- Article from Meta AI proposing Efficient LLMs (their model with 13B parameters outperform GPT3 with 175B parameters on most benchmarks)==

**Scaling laws and compute-optimal models**

- **Language Models are Few-Shot Learners** ==-== ==This paper investigates the potential of few-shot learning in Large Language Models.==
- **Training Compute-Optimal Large Language Models** ==- Study from DeepMind to evaluate the optimal model size and number of tokens for training LLMs. Also known as “Chinchilla Paper”.==
- **BloombergGPT: A Large Language Model for Finance** ==- LLM trained specifically for the finance domain, a good example that tried to follow chinchilla laws.== ![Exported image](Exported%20image%2020260209130257-3.png)  

[FLAN paper](FLAN%20paper.md)

![Exported image](Exported%20image%2020260209130259-4.png)  
![Exported image](Exported%20image%2020260209130300-5.png)  
![Exported image](Exported%20image%2020260209130302-6.png)  
![Exported image](Exported%20image%2020260209130304-7.png)

Week 2 Resources  
Below you'll find links to the research papers discussed in this weeks videos. You don't need to understand all the technical details discussed in these papers - **you have already seen the most important points you'll need to answer the quizzes** in the lecture videos.  
==However, if you'd like to take a closer look at the original research, you can read the papers and articles via the links below.==
 
**Generative AI Lifecycle**

- **Generative AI on AWS: Building Context-Aware, Multimodal Reasoning Applications** ==- This O'Reilly book dives deep into all phases of the generative AI lifecycle including model selection, fine-tuning, adapting, evaluation, deployment, and runtime optimizations.==

**Multi-task, instruction fine-tuning**

- **Scaling Instruction-Finetuned Language Models** ==- Scaling fine-tuning with a focus on task, model size and chain-of-thought data.==
- **Introducing FLAN: More generalizable Language Models with Instruction Fine-Tuning** ==- This blog (and article) explores instruction fine-tuning, which aims to make language models better at performing NLP tasks with zero-shot inference.==

**Model Evaluation Metrics**

- **HELM - Holistic Evaluation of Language Models** ==- HELM is a living benchmark to evaluate Language Models more transparently.==
- **General Language Understanding Evaluation (GLUE) benchmark** ==- This paper introduces GLUE, a benchmark for evaluating models on diverse natural language understanding (NLU) tasks and emphasizing the importance of improved general NLU systems.==
- **SuperGLUE** ==- This paper introduces SuperGLUE, a benchmark designed to evaluate the performance of various NLP models on a range of challenging language understanding tasks.==
- **ROUGE: A Package for Automatic Evaluation of Summaries** ==- This paper introduces and evaluates four different measures (ROUGE-N, ROUGE-L, ROUGE-W, and ROUGE-S) in the ROUGE summarization evaluation package, which assess the quality of summaries by comparing them to ideal human-generated summaries.==
- **Measuring Massive Multitask Language Understanding (MMLU)** ==- This paper presents a new test to measure multitask accuracy in text models, highlighting the need for substantial improvements in achieving expert-level accuracy and addressing lopsided performance and low accuracy on socially important subjects.==
- **BigBench-Hard - Beyond the Imitation Game: Quantifying and Extrapolating the Capabilities of Language Models** ==- The paper introduces BIG-bench, a benchmark for evaluating language models on challenging tasks, providing insights on scale, calibration, and social bias.==

**Parameter- efficient fine tuning (PEFT)**

- **Scaling Down to Scale Up: A Guide to Parameter-Efficient Fine-Tuning** ==- This paper provides a systematic overview of Parameter-Efficient Fine-tuning (PEFT) Methods in all three categories discussed in the lecture videos.==
- **On the Effectiveness of Parameter-Efficient Fine-Tuning** ==- The paper analyzes sparse fine-tuning methods for pre-trained models in NLP.==

**LoRA**

- **LoRA Low-Rank Adaptation of Large Language Models** ==- This paper proposes a parameter-efficient fine-tuning method that makes use of low-rank decomposition matrices to reduce the number of trainable parameters needed for fine-tuning language models.==
- **QLoRA: Efficient Finetuning of Quantized LLMs** ==- This paper introduces an efficient method for fine-tuning large language models on a single GPU, based on quantization, achieving impressive results on benchmark tests.==

**Prompt tuning with soft prompts**

- **The Power of Scale for Parameter-Efficient Prompt Tuning** ==- The paper explores "prompt tuning," a method for conditioning language models with learned soft prompts, achieving competitive performance compared to full fine-tuning and enabling model reuse for many tasks.==
![Exported image](Exported%20image%2020260209130308-8.png) ![Exported image](Exported%20image%2020260209130310-9.png) ![Exported image](Exported%20image%2020260209130312-10.jpeg) ![Exported image](Exported%20image%2020260209130313-11.png)

KL-Divergence, or Kullback-Leibler Divergence, is a concept often encountered in the field of reinforcement learning, particularly when using the Proximal Policy Optimization (PPO) algorithm. It is a mathematical measure of the difference between two probability distributions, which helps us understand how one distribution differs from another. In the context of PPO, KL-Divergence plays a crucial role in guiding the optimization process to ensure that the updated policy does not deviate too much from the original policy.  
In PPO, the goal is to find an improved policy for an agent by iteratively updating its parameters based on the rewards received from interacting with the environment. However, updating the policy too aggressively can lead to unstable learning or drastic policy changes. To address this, PPO introduces a constraint that limits the extent of policy updates. This constraint is enforced by using KL-Divergence.  
To understand how KL-Divergence works, imagine we have two probability distributions: the distribution of the original LLM, and a new proposed distribution of an RL-updated LLM. KL-Divergence measures the average amount of information gained when we use the original policy to encode samples from the new proposed policy. By minimizing the KL-Divergence between the two distributions, PPO ensures that the updated policy stays close to the original policy, preventing drastic changes that may negatively impact the learning process.  
A library that you can use to train transformer language models with reinforcement learning, using techniques such as PPO, is TRL (Transformer Reinforcement Learning). In [this link](https://huggingface.co/blog/trl-peft) you can read more about this library, and its integration with PEFT (Parameter-Efficient Fine-Tuning) methods, such as LoRA (Low-Rank Adaption). The image shows an overview of the PPO training setup in TRL