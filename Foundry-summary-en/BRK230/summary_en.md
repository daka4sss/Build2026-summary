# Microsoft Build 2026 BRK230 "Build smarter AI systems in Foundry as models and costs evolve" — Detailed Summary

**Speakers**:
- **Yina Arenas** — Product Lead for Microsoft Foundry
- **Naomi Moneypenny** — Microsoft Foundry, responsible for shipping all of the models (live demos)
- Demo code authored by: Nithya (mentioned by name only)

**Session URL**: https://build.microsoft.com/en-US/sessions/BRK230
**Source**: Official WebVTT transcript (medius.microsoft.com CAPTION)

---

## Overview

This roughly 45-minute session uses live demos to explain a methodology for building and sustaining "smart AI systems" on Microsoft Foundry amid a landscape of continuously evolving AI models and costs. The audience is developers building and operating agentic (autonomous) AI systems in the enterprise.

The session frames the problem as a shift away from the simple approach of a year ago — "pick the model, wire it up, and ship it" — toward the complex reality of long-running agentic systems that have to continuously improve. As the answer, it consistently argues for a single philosophy: "define your evaluation (eval) first, then optimize the entire system through hill climbing (continuous improvement)."

The talk progresses in a four-phase structure: "Selection -> Evaluation -> Optimization -> Scaling/Operations." Using an internal travel-request app (a Trip Planning Agent) as the demo scenario, the speakers walk through an improvement loop that starts from a GPT-4.1 baseline and moves through switching to a multi-model router, custom evaluation, and fine-tuning.

---

## 1. Opening: Problem statement and the guiding framework (around 0:00)

Yina opens by naming three challenges that developers face.

- **Difficulty of model selection**: New models arrive every day, and benchmarks do not guarantee a fit for your own scenario.
- **Unpredictability of cost**: You can do analysis while building, but when you put it into production and see the bill, it is painful.
- **The constantly shifting landscape**: The moment you finally finish a system, the next model arrives and the next tool is out, and you have to keep adapting.

The proposed answer to all of these is an **eval-first** mindset. The talk completely inverts the traditional "build first, QA at the end" approach, arguing that you should instead **define your success criteria and evaluation first and use them as a measuring stick to continuously improve**. This is positioned as the single most important takeaway of the entire session: by shifting evaluation left, you build a resilient solution that is decoupled from the evolving model, changing tools, and shifting context.

Yina lists the value that Microsoft Foundry provides as a platform:

- **Building with GitHub Copilot CLI** as the starting point
- **Foundry IQ**: Context and knowledge grounding for agents
- **Work IQ**: Connection to Microsoft 365 productivity data
- **Fabric IQ**: Connection to structured data
- **Web IQ**: Use of the world's knowledge on the web
- **Foundry-hosted agents** as the execution runtime
- **A365 (Agent 365)** for governance

The point is that Foundry is governed across the entire agentic lifecycle — not just for running inference or for a single point solution — so you can build, deploy, and operate at scale and continuously improve the whole system. Once your evaluations are defined, a set of optimization categories tells you which levers you can pull, and that is how the rest of the talk is structured: selection, evaluation, optimization, and scaling, framed around the model ecosystem.

---

## 2. Select phase: Model catalog and new announcements (around 4:56)

Naomi explains the philosophy of model selection. Models should not be treated as "pick one model for all use cases" but rather as an **ongoing system-design decision made per task**. The model lifecycle is continuously accelerating, and Foundry is always bringing the latest and best models. In any AI application, models are the raw materials; what matters is not the model itself but whether it is the right model for the job at hand.

### State of the Foundry model catalog

- Provides **more than 11,000 models** (both OSS and closed)
- Offers a consistent, unified API and built-in enterprise curation, enabling faster experimentation and a faster path to production
- Flagship models: OpenAI, Anthropic (Claude)
- A deep partnership with **Hugging Face** (Jeff was in the room and was given a shout-out) populates a large number of OSS models into the catalog

The Foundry portal includes a leaderboard that benchmarks models across dimensions such as quality, safety, throughput, and cost; trade-off charts to select models by your own priorities; and the ability to compare models side by side across open-source and closed providers (responses, latency, etc.) — useful for prototyping. You can also "save as an agent," which unlocks adding tools, knowledge, memory, and guardrails, plus setting metrics (e.g., task adherence, intent resolution, relevance) that Foundry evaluates each time the agent is invoked, with traces, spans/durations, and LLM-as-a-judge pass/fail outputs.

### New announcements

**Claude on Azure (running on GB300 hardware)** — A new announcement. Claude Opus 4.8 was added to the Foundry catalog the previous week, and now Naomi announces that "Claude is finally running on Azure." It runs on Azure GB300, the highest-end hardware available, and brings the full Anthropic lifecycle and development tools directly to users from Azure. Gauging the audience reaction, Naomi joked that "at least one person was excited about Claude," drawing laughter.

**Microsoft AI first-party models (GA, live the same day as the Build 2026 keynote)** — The team pushed these live during Mustafa's keynote that morning. They form a full multimodal application stack across thinking, image, code, and audio. **Image 2.5** was highlighted in particular as one of the latest models, with an emphasis on running these first-party models efficiently and in well-handled cost-optimization scenarios.

**Expanded partnership with NVIDIA** — Adding the following to Foundry:
- **NVIDIA Nemotron** vision and reasoning models
- **NVIDIA Cosmos** (for physical AI)
- **NVIDIA Earth-2** weather models
- A separate pre-recorded session with a "very cool" demo on physical AI is recommended

The point is enabling a unified platform where developers can build, run, and scale AI systems that reason, act, and respond to real-world conditions — extending beyond software workloads into physical AI.

**The rise of purpose-built models** — Domain-specific models are expanding for geospatial, robotics, biomedical, material science, code search, media, and more. As a concrete example, **Aurora 1.5** is introduced as a cutting-edge weather modeling system that uses satellite imagery and atmospheric data and can scale where traditional models cannot.

**Foundry Labs** — A new channel that delivers cutting-edge experimental models primarily from Microsoft Research. The strategy is to cover both ends of the spectrum: production-grade frontier models with strict operational requirements on one side, and the experimental research frontier on the other.

---

## 3. Setting up the demo scenario and measuring the baseline (around 13:14)

The demo proceeds around an **employee trip planning app (Trip Planning App)**. This app reproduces a typical enterprise scenario: understand the intent, make decisions based on the prompts/rules, and return an output to the user.

Yina stresses the takeaway again: you have to start with what success looks like — your success criteria for correctness, compliance, and user behavior — and from there comes the notion of **hill climbing** (as shown in the keynote): because you have a clear understanding of your success criteria, you can continuously improve against it. The typical developer workflow starts with a scenario and an understanding of success, then prototyping with the latest and greatest model to establish a baseline.

All of the demos were built with agents, and the code is available in a GitHub repo via an **aka.ms** link shown during the session (the speakers show outputs rather than walking through the code line by line). Yina also gives a shout-out to Nithya, "the mastermind behind all of the demos."

### Baseline setup

- Initial data: about **20 seed rows** of data
- Model: **GPT-4.1** (one frontier model applied to every task)
- Evaluation metrics: built-in evaluators such as task adherence and task completion

**Result (baseline)**:
- Quality score: **0.59** (target: **0.8**)
- Cost per task: expensive / high
- Latency: acceptable ("not bad")

Naomi characterizes using one frontier model for every job — including the cheap ones — as "using a Ferrari for a grocery run." The baseline is just the starting point of the hill climb; what matters is that the gap to the target (0.59 vs. 0.8) makes it clear where to improve. The job is not to guess but to look at this methodically.

---

## 4. Optimization via model router: Task decomposition and routing (around 17:45)

Yina presents applying **microservices architecture thinking** to AI system design: rather than processing the whole solution with a single model, decompose the work into jobs to be done and assign the most appropriate model to each. For each job, you choose the right prompt, the right model, the right tool, and the right context. The smaller the model you can use, the faster and more cost-optimized it is. Decomposition is described as the first optimization move.

### Foundry model router

- Supported models: **28 different models**
- Examples of supported models: GPT-5.4, the GPT-5.5 family, Claude Opus models
- Built-in automatic failover to improve the customer experience
- Agentic support
- **New today**: Governance policies now let administrators **control which models the model router is allowed to select**, so a solution can be restricted to just the desired models (public announcement)
- Roadmap: opening up the ability to customize and fine-tune the router itself, and to bring in fine-tuned models

### Building your own router

As an alternative to the built-in router, you can build a router yourself: use a small model (e.g., GPT-4.1 Nano or Mistral Small) to classify intent against a set of rules, then route each job to the model that specifically handles it.

In the demo, the simple router decomposes the employee travel request into different intents/tasks and recommends a model per task. Synthetic data is then generated from Foundry: starting from the original 20 seed rows, a target of 170 rows is generated, and 50 of those are selected and used for the evaluation run.

**Score after the multi-model router**:
- Quality improved
- **Cost per task significantly improved** (reaching close to where it needs to be)
- Latency remains an area to keep working on

Naomi closes the selection discussion with three questions for model selection: (1) Capability — can it even do the job at all? (2) The bar for production — can it meet latency and cost requirements in production? (3) Can you afford to run it at scale? Benchmarks can help, but they should not make the decision for you — evaluate on your own workload, not on the beautiful published benchmarks.

---

## 5. Evaluate phase: Custom and rubric-based evaluation (around 22:41)

Yina re-emphasizes the session's most important message: evaluation is not just QA — it is your **product spec**, and as you hill climb, it becomes your **intellectual property (IP)**. It defines which trade-offs matter to you and is the measuring stick for every change you make, including changes you must react to (for example, when a model is no longer available in the catalog, you re-run the evals to confirm a new component still meets expectations). For the trip planner, relevant dimensions include correctness, policy compliance (company travel policy — per-diem limits, business-class rules for trips over seven hours, etc.), tool call validity, escalation accuracy (when to hand off to a human), and safety and privacy.

### The three-layer structure of evaluation

Foundry's evaluation catalog includes:

1. **Built-in evaluators**: Quality (e.g., intent adherence, relevance, task completion) and risk and safety (hallucination detection, harmful content)
2. **Agentic evaluators**: Evaluate the agent's behavior across multiple turns
3. **Custom evaluators**: Three kinds — prompt, code, and rubric

### New announcement: Rubric-based evaluators

- Announced today at Microsoft Build
- Reads an existing agent's definition (prompt/configuration and seed trajectory samples) and has an **LLM automatically generate the evaluation dimensions (rubric)**
- The weight of each dimension can be edited manually (e.g., raising policy compliance from a weight of 5 to 8) and re-run
- After the run, a cluster analysis visualizes where the agent hallucinated and where it did not produce an adequate final answer
- Available from both the UI and from code

**Demo result**: For the concierge starter / travel agent, **seven dimensions** were auto-generated as the rubric (policy compliance, correctness, tool call validity, escalation accuracy, safety, privacy, etc.). A generic LLM-as-a-judge evaluation could not properly measure policy compliance; a custom evaluator grounded in domain knowledge (the travel policy file) was needed. Naomi grounds the evaluation against a scale file that clearly outlines the travel policy. The result showed that while the multi-model router improved the policy-adherence score from a quality perspective, the target was still missed (the cell was still "red") — identifying the concrete problem that **policy compliance is still insufficient**. This illustrates that the quality definition is critical and may itself shift over time as you learn more about the scenario.

---

## 6. Optimization phase: Joint optimization of cost, latency, and quality (around 28:53)

Under the thesis that "cost reduction in AI rarely comes from just choosing a cheaper model — it comes from **architectural decisions**," the talk walks through multiple levers. Optimization is itself the hill climb: you do not push only on cost, or only on quality, or only on latency — you improve the system meaningfully across all dimensions, iteratively.

### Cost-optimization levers (stackable, with compounding gains)

| Lever | Description |
|---|---|
| Routing | Route by workload to the appropriate model |
| Batch inference | Large cost savings via async jobs |
| Structured outputs | Cut wasted tokens |
| Caching | Avoid repeated work |
| Distillation | Transfer knowledge from a large model into a smaller one |

The key point is that the gains from every lever compound, so you want an architecture that lets you stack all of these optimizations together rather than relying on a single magic fix. (About three-quarters of the room raised hands when asked whether they think about cost.)

### New announcement: Azure Context Cache (Explicit Prompt Caching) — Private Preview

- Announced as **entering Private Preview today** (drew applause)
- Evolves from the prior journey of **implicit caching** to **explicit prompt caching**
- Caching has evolved from a low-level optimization into a core system capability of the AI platform, delivering consistent and guaranteed performance where possible
- Ownership of the cache belongs to **you (the user), not the inference provider** — it is your data; you can look at your deployments and your savings directly
- Delivers better privacy controls and better operational availability across long-running tasks

### Latency optimization

A faster system is engineered, not achieved by simply picking a faster model. Responsiveness can be improved at multiple stages:
- Route each task to a faster model
- Reserve capacity with **PTU (Provisioned Throughput Units)** for consistency under large workloads
- Use **priority processing** as a "toll road" for low-latency paths
- Remove wasted work with prompt caching, predicted outputs, structured outputs, and tighter token budgets
- **Streaming** for perceived speed
- **API gateways** to optimize traffic across regions
- The premise: "**production latency is engineered for, not hoped and wished for**"

### A staged approach to quality optimization

When quality is the constraint, use the levers in order from lightweight to heavyweight:

1. Prompt design (always start here — fastest and cheapest)
2. Better context / grounding with retrieval / tool use (RAG)
3. Decomposition and routing
4. Fine-tuning and distillation
5. Custom model training (heaviest, for highly specialized phases)

The key is not to jump to the heaviest solution first — start with the prompt, and incrementally stack benefits. (Yina notes there is a full session on agent optimization that automatically analyzes what is happening with an agent and helps optimize prompts and tools.)

---

## 7. Fine-tuning and post-training: Quality improvement via distillation demo (around 34:57)

To solve the low policy-compliance score, the speakers run a **distillation + fine-tuning** demo. The reason: they embed the knowledge of the travel policy into the model — using a bigger **teacher model** and teaching that knowledge into a smaller model so they can maintain the cost optimization they want.

### What was done

- Train on the travel-policy knowledge with a larger teacher model and transfer it into a smaller **GPT-4.1 Nano** model
- Fine-tuning is simple: select your endpoint, select your dataset, select your base/training model, and submit the training run in **fewer than 100 lines of Python code** (or a few clicks in the UI)
- Deploy into the **developer tier** — a cheap way to try multiple fine-tuned models and test them against your own data

**Result**: After fine-tuning, GPT-4.1 Nano (run "1.2") reached the **target quality score (0.8)** for the scenario, resolving policy compliance while preserving cost optimization. The Foundry fine-tuning experience also shows the loss curve and token accuracy from the run, and supports continuous fine-tuning as new trajectories arrive, with checkpoints you can inspect and bring in.

### Foundry's post-training menu (three-layer structure)

| Approach | Summary |
|---|---|
| Managed Fine-tuning | The simplest. You bring your data and Foundry handles everything — data preparation, training, monitoring, and deployment. Highest likelihood of success if you are not an ML professional; very low-effort. Choose SFT (supervised fine-tuning), DPO (direct preference optimization), or RL (reinforced fine-tuning) |
| Serverless RL API (launching here at Build) | You control the rewards and hyperparameters while Foundry handles the infrastructure. Produces a set of LoRA (lower) weights that are overlaid on top of your deployments. No cluster management required |
| Full-control RL | Full ownership of the code, distributed strategies, algorithms, and GPU cluster type. Foundry manages compute and orchestration. Use frameworks such as SLIME or VERL |

The recommendation is to start with the simplest approach and move right as the scenario demands — which is why defining success criteria (evaluations) is so important. Once you have a customized model, you can bring it into Foundry and run it. For open-source models, you can use **Fireworks on Foundry** (Managed Compute) or your own compute clusters.

### New announcement: GA partnership with Fireworks AI

- Announced as **GA (generally available) today**
- Zero-day access to optimized frontier models
- Best-in-class inferencing performance
- Native integration into the Azure enterprise stack (the key differentiator versus using Fireworks directly is deep integration across the enterprise stack Foundry offers)

The Managed Compute partnership with Hugging Face also continues to be strengthened. Thousands of models from Hugging Face, NVIDIA, and Microsoft Research are brought in and run efficiently on optimized runtimes such as **vLLM, SGLang, and NVIDIA NIM**, with Foundry managing the accelerators while you can bring your own capacity — all using the same auth, the same API endpoints, and the same SDK.

---

## 8. Scaling/Operations: Production observability and closing (around 40:48)

Once selection, evaluation, and optimization are done, the next challenge is operating the system **with discipline** — which means observability. When you take something from prototype to production, the observability piece is critical.

### Foundry's observability stack

- **Tracing**: End-to-end visibility across prompts and tool calls
- **Evaluation (continuous)**: Continuous monitoring of quality, safety, and agent behavior
- **Azure Monitor integration**: Real-time signals for cost and latency
- **Copilot assistance**: A demo where, within the Foundry portal, you can pick a metric (e.g., time to last byte) and ask Copilot directly, "How do I improve this?" — and it shows the answer in place

Yina emphasizes operating with control: monitoring, versioning, governing, and the ability to roll back, fully integrated into your CI/CD pipeline — all supported through Foundry's integration with GitHub. The closing message: build the system, not just the prompt; the days of pure prompt engineering are gone.

---

## Summary

### Core messages of the session

1. **Eval-first**: Define your success criteria and evaluation first, and treat them as your "product spec and IP"
2. **Task decomposition x multi-model**: Do not process everything with one large model — use microservices thinking to select the right model per task
3. **Compounding optimization**: The levers for cost, latency, and quality multiply in effect when stacked
4. **Continuous improvement**: Build a system with a "measurable improvement loop" that can withstand the changes of the model lifecycle

### Announced features

| Feature | Status | Description |
|---|---|---|
| Claude on Azure (GB300) | GA / New | Claude running on Azure infrastructure (GB300, highest-end hardware); integration with the Anthropic development tool suite. Claude Opus 4.8 added to the catalog the previous week |
| Microsoft AI first-party models (Image 2.5, etc.) | GA | Released live the same day as the Build keynote; full multimodal stack across thinking, image, code, audio |
| NVIDIA Nemotron / Cosmos / Earth-2 | Catalog addition | Models for physical AI and weather AI |
| Aurora 1.5 (weather model) | Available | Cutting-edge weather model using satellite imagery and atmospheric data |
| Foundry Labs | New | A channel delivering experimental models from Microsoft Research |
| Model router governance policies | New announcement | Administrators can restrict which models the router may select |
| Rubric-based Evaluators | New announcement | Auto-generates evaluation dimensions from an agent definition |
| Azure Context Cache / Explicit Prompt Caching | Private Preview | A user-owned prompt cache foundation |
| Serverless RL API | New announcement (launching at Build) | Run RL fine-tuning with no cluster management; produces LoRA weights |
| Fireworks AI on Foundry | GA | High-performance inference for OSS models with native Azure enterprise integration |

### Next actions

- Developer portal: **ai.azure.com**
- Demo code repository: announced via an aka.ms link during the session (referenced from the BRK230 session page)
- Related sessions: deep dives on post-training, agentic solutions, and safety / responsible AI
- Community: the official Microsoft Foundry Discord
