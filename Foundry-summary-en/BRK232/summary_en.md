# Microsoft Build 2026 BRK232 "Post-Training and Deploying Open Source Reasoning Models in Foundry" — Detailed Summary

**Speakers**:
- **Chris** (last name not stated): Microsoft Foundry product manager. Hosts the session and frames the overall narrative; self-identifies as a product manager.
- **Vijay** (last name not stated): Engineer who presents the post-training / training-technology demos (distillation, SFT, RFT, the Loom low-level API).
- **Manoj** (last name not stated): Engineer who presents the deployment demos (Foundry Managed Compute, model import, observability).
(None of the last names can be determined from the transcript.)

**Session URL**: https://build.microsoft.com/en-US/sessions/BRK232
**Source**: Official WebVTT transcript (medius.microsoft.com CAPTION)

---

## Overview

This is a technical, demo-driven session that walks through the full workflow of taking an open-source reasoning model, **post-training** it on Microsoft Foundry, and deploying it into production as part of an agent.

The central message is that **"deploying a model into production is just the beginning."** Agents make many iterative tool calls, so continuing to run a frontier model unchanged causes inference costs to climb steeply. The speakers show how to combine **Supervised Fine-Tuning (SFT)** and **Reinforcement Fine-Tuning (RFT)** — seeded by production traces and distillation — to lift a smaller, cheaper open-source model up to frontier-model quality, so that **costs stay flat while quality stays flat or even increases over time**.

On the deployment side, the session announces **Foundry Managed Compute**, a new offering that hosts open-source and custom models serverlessly and at scale on Foundry-managed GPUs. The core thesis is that the entire continuous-improvement loop — evaluate -> fine-tune -> deploy -> observe -> collect new traces -> repeat — can be closed end-to-end on the single Foundry platform.

---

## 1. Session introduction — the cost problem of the agent era (00:00)

Chris opens by setting up the cost challenge that comes with the rapid adoption of agents.

- Agents are extremely impactful and are changing the way everyone works; the speaker has shipped agents both with external customers (enterprises and startups) and with internal Microsoft teams.
- A consistent lesson: **deploying a model into production is just the beginning**. Like any software application, agents must be continuously learned from and improved to perform at scale across edge cases that were not anticipated.
- Agents are **extremely "token hungry"** compared to regular chatbots. As cognitive work is offloaded to agents in the cloud, token consumption rises substantially, because agents perform **multiple iterative tool calls**, rationalize over data fetched from enterprise systems and databases, and validate policies (00:01).
- Because each tool call and reasoning loop increases cost, **as you scale your agents you scale up your bill as well** (00:02).
- The proposed solution is **post-training / fine-tuning** (used interchangeably): it teaches the model the business domain, how to use the organization's tools, and how to interact with its systems, eliminating costly erroneous interactions (00:02-00:03).
- Frontier models are highly intelligent and usually perform well, but **their "thinking" and "course correcting" while rationalizing over the available tools costs money**. Fine-tuning makes the model choose the best tools in the right order for the best outcome at the lowest price — i.e., **faster, better, cheaper** agents using Foundry (00:03).

---

## 2. Model selection and the philosophy of evaluation (00:04)

Chris explains how to choose the right model on Foundry.

- Choosing a model is increasingly complicated because **new models come out all the time**; Foundry hosts "all of the models you could possibly want," open-source and proprietary, and continuously adds more (00:04).
- The right way to pick a model is the **scientific method — "guess and check"** — and the critical checking step is, in scientific terms, **evaluation** (00:04-00:05).
- The demo uses a **customer-service retail scenario**: a customer wants to return a recently purchased product. The agent must interact in a friendly way, honor all policies, do order look-ups, and confirm the customer actually received the product (00:05).
  - This can be done with a frontier model like the **GPT-5 Series**, which is very good at figuring things out, or with a smaller open-source model like **Qwen ("Quen") 14B** (transcript also says "Qwen 314B"), which can still reason about what to do but may be less powerful (00:06).
- Foundry collects all the **telemetry** needed to monitor production performance, and you can drill into the details of any individual **trace**: you can see the agent go back and forth, execute tools to understand the customer/order context, reason over the data, and loop — and **the cost increases with each chat turn and tool call** (00:06-00:07). The smaller the model you can use to hit your quality bar, the higher the probability of doing it cost-efficiently.
- **Defining the evaluator is the most important step.** "Evaluators are the product spec." As a product manager, you must **define your success criteria before deploying anything to production** — not just a quality bar, but ensuring policies are honored, the right tools are called, and more. This is a **multi-dimensional optimization technique** (00:08-00:09).
  - Foundry offers **built-in evaluators** plus the ability to create **custom evaluators**.
  - The speaker urges a mindset shift: instead of deploying first and then monitoring whether things go well, **define up front what "going well" looks like**, which enables you to **continuously hill-climb** to high-quality output (00:09).
  - **Benchmarks** (frontier-lab or open-source) are only information someone else chose to publish — a good starting point, but you must **test models on your own scenarios and your own data** to hit your success criteria (00:10).
- The demo defines a **unified custom metric, "retail quality,"** and compares multiple agent generations. The early agent versions "weren't really that great" against this metric (00:10-00:11).
- The concrete demo goal is stated (00:11-00:12): a frontier model was already at **76% quality out of the box** ("not bad, not great"); the team wants **90% or better** to ship to production. Starting instead from a small, very cost-efficient model — **10x lower cost than the frontier model** — quality was a bit worse ("going in the wrong direction"). The talk shows how **SFT + RFT** on that open-source model reaches the target quality bar. Chris hands off to Vijay (00:12).

---

## 3. Post-training theory — how SFT and RFT work (00:12)

Vijay takes the stage and systematically explains the technical background of post-training.

### Two key keywords

- **Post-training** is a term popularized by labs like **OpenAI and Anthropic ("Tropic")**. It is an **umbrella term** that encompasses fine-tuning, reinforcement fine-tuning, RLHF, and so on (00:13).

### The three phases of model training

Any model (OpenAI, open-source, MAI, Anthropic) goes through **three distinct, independently varying cycles** — not a contiguous process; you can start and continue from anywhere. The three knobs you vary are **data, compute, and model architecture/parameters** (00:13-00:14).

| Phase | What happens | Scale |
|---|---|---|
| **Pre-training** | The model learns about the world and "how to be intelligent." Orders of magnitude more data and compute; huge parameter count; all weights changed. | Largest data / compute |
| **Mid-training** | Infuses specialized knowledge — language, coding, etc. | Medium |
| **Post-training** | The model gets good at the specific work you need it to do (e.g., agent workflows). | Smallest / cheapest |

Most models are inherently good because of strong post-training; today's focus is post-training as a specialized topic (00:14-00:15).

### What post-training is

On a conceptual slide (00:15-00:17): the **left side** is where you source/distill your **data** — from **production traces** (the in-production agent), **human preferences (RLHF)**, or **synthetic data**. The **right side** is what you want the model to become — e.g., **safer** than the base model, or better at a particular task such as **coding or your agentic workflow**.

Even as base models keep improving, **they do not know the rules of your specific engagement** — your support-ticket flow, your manufacturing or healthcare workflow, your specific sequence. The way to fix this is to apply the same techniques the labs use, in your own setup. There are two objectives: make the model **more accurate / better at task completion**, and make it **cheaper** (large models are good but expensive to serve due to parameter size and compute) (00:16). The speaker notes real cases where people **unwittingly spent $1M or even $5M** because token costs are so high; post-training is the way to reduce that (00:17).

### The post-training recipe

Post-training has **multiple recipes**; you pick one. Today's recipe is **distillation from traces -> fine-tuning (SFT) -> RFT** (00:17-00:18).

1. **Data distillation**: take all production traces, **filter and distill down** to exactly the traces you want, and form a dataset (the demo's automated dataset-creation does this by default, but you can do it yourself).
2. **SFT (Supervised Fine-Tuning)**: bring in an **expert pattern to mimic** — desired tone, format, tool-call patterns. The "expert" can be a real human or expert-formulated data (Box 1 = demonstration). A **loss function** (the "pink grading" in Box 3) measures how close the model's answer is to the expert answer — rewarding exact and partial matches — and **shifts the model weights** toward the right behavior. SFT teaches the model **what to do / to mimic** (00:18-00:19).
3. **RFT (Reinforcement Fine-Tuning)**: an **order of magnitude more complex**, but with the "biggest bang for the buck," and best for **verifiable tasks** (coding, math, policy compliance — anything you can verify and prove). Example: to process a refund, the model must call many sequences and honor many policies **in the right order**; in RFT **each step is rewarded**, so the model learns not just to mimic but to **navigate paths to reach the right answer intuitively** (00:19-00:20).

The demo combines **RFT + SFT + distillation** to reach the goal.

---

## 4. Demo — running SFT/RFT jobs with a code-first approach (00:20)

Vijay runs a live demo. A small hiccup: right at the start the PC locked ("It's got locked up," 00:20), but it recovered quickly.

### Closing the loop from production traces

- Starting from agents: the agent uses a powerful model, **GPT-5.2 ("GPT 52")**, which likely gives the best performance. You learn from how the best models do by pulling the **production traces** and **creating a dataset** from them (00:20-00:21).
- This is the **continuous loop**: put the agent in production -> take the traces -> distill the expensive large model -> kick off fine-tuning. A fine-tuning job can be started right from there; datasets had been created previously for the demo (00:21).

### Workbench (compute instance)

- For custom jobs, you provision a **box in the cloud — the "Workbench" / compute instance** — where the machine is already set up: no need to pip install dependencies or wire up connectivity. You click **Connect** and it opens a **VS Code** environment so you can start coding right away (00:22).

### The recipe in code

- The notebook implements the recipe: start from the **base model**, pull **agent traces**, run **SFT**, then **RFT**, then **monitor and evaluate** (00:22-00:23).
- You configure the ingredients: the **business APIs** to call, the **graders**, and the **GPU clusters** (node count defines how fast the job runs). You install the SDK, configure the job, and kick it off (00:23-00:24).

### Running the SFT job

- The **SFT job** takes data from the trained dataset; experts/data scientists can bring their own code. You set up compute clusters, pick the model, and start the SFT job (00:24).
- An SFT job generally produces a model that feeds into RFT; for the demo's sake they don't wait for it to finish. Once kicked off, it shows a **job link** to navigate to (00:24-00:25).

### Running the RFT job and distributed execution with Ray

- **RFT** is more sophisticated than SFT: you configure how **reward verification** happens. The core concepts are **sampling, training, and rollout** — take a customer-agent prompt, create **multiple samples**, pick a sample, generate **multiple trajectories** (different orders / sequences of calls / ways of responding), and **grade each** (as shown on the slide). You choose GPU count and cluster **topology**, submit, and get a job link (00:25-00:26).
- The RFT job runs on an **authenticated Ray endpoint** — a **Ray cluster** of GPU and CPU nodes. **Ray is the distributed engine** that takes the Python code and distributes it across nodes (00:26).
- You can open the **Ray dashboard** directly: all nodes are active, and you can see **CPU and GPU resource usage** per node (00:26-00:27).
- You can drill into the job to see, **per node and per actor, what methods and functions are being called** — **complete visibility into what the job is doing**. It is **"not just a fire-and-forget API"**; advanced users / data scientists / developers can be meticulous about what happens at each node in each cluster, and view **cluster-level monitoring** (how many nodes, etc.) (00:27).

### Debugging rollouts

- The "more interesting stuff" is the **rollouts** (00:27): you can watch rollouts in progress and see that rewards are increasing; some samples are graded well and some are not.
- To see why something is not graded well, the demo selects **prompt 8**: for the picked sample you see **which tools were called and in what order** — it clearly **missed calling some functions**, so it got lower rewards / a lower grade (00:28).
- You can do a **side-by-side comparison** with a good run. Using **Rollout 16** (reason-for-cancellation case), one run got the right tool calls and the other didn't — letting you see **per rollout why it is rewarded higher or lower**, and understand how the model is behaving. This is the power of Foundry's complete visibility (00:28-00:29).

---

## 5. Results comparison — quality and cost improvements from post-training (00:29)

After the rollouts, Vijay reviews the evaluation results.

- An **eval** shows, per evaluated sample, the **pass rate / quality** of the trained model (00:29-00:30). You pick a trained model and confirm the number looks good.
- The comparison across models demonstrates the cost-saving thesis:

| Model | Condition | Pass rate |
|---|---|---|
| **GPT-5.2** (frontier) | Base model | High (reference baseline) |
| **Qwen 14B** | Base model (no training) | Low (almost zero / fails) |
| **Qwen 14B** | After SFT | Rises |
| **Qwen 14B** | After SFT + RFT (distillation + SFT + RFT) | Rises further, approaching target |

- GPT-5.2 as a base model does better than the base Qwen 14B, but the smaller model is **significantly cheaper and faster**. Applying **post-training (distillation + fine-tuning + RFT)** drives the score up subsequently — **post-trained models have better pass rates and better rewards** than untrained ones (00:30).
- For one specific sample, the 14B initially scored almost zero (and even GPT-5.2 "did OK / still failed but with a better score"); after SFT of the smaller model the score climbs to where you want it (00:30-00:31).
- **Post-training can be done in a loop** — each step individually or as a loop — and you **monitor and evaluate** to get it right (00:31).

---

## 6. The low-level GPU API "Loom" — submit GPU jobs from a laptop (00:31)

Vijay introduces, in addition to the code-first experience, a new **low-level GPU API** (code name **Loom**).

### Motivation

- The code-first experience requires you to **provision a cluster, manage Ray, bring your code, and own the infrastructure** — debugging node-to-node communication, network topology, and data-streaming performance. This is **expert, heavy-duty work** (00:31-00:32).
- Not everyone in an organization has GPUs, but **everyone has a laptop**. The new API lets you **bring your RL logic on your laptop / CPU and kick off a job that runs on the server**, with the server managing all the infrastructure (00:32).

### Loom characteristics

- Code name **Loom**: it **manages the GPU cluster, images, environments, and networking for you** (00:32).
- You only need to understand **four GPU primitives** (the core GPU constructs of model training) (00:33):
  1. **Forward pass**
  2. **Backward pass**
  3. **Optimizing for a loss function** (gradient optimization)
  4. **Sampling of rollouts**
- Everything on the **left side runs on CPU** (your client logic on the laptop/notebook), and the **right side runs on the GPU cluster**; these four calls are what you export and manage (00:33).

### Use case — curriculum learning

- The fine control is useful when, for example, teaching a model **linear algebra / mathematics**: you don't throw the hardest problem first — you teach **basic arithmetic (addition, subtraction) first and gradually climb up to algebra, calculus, linear algebra** — **curriculum learning** implemented as custom client-side logic (00:33-00:34).
- The higher-level API code sample is **basic to understand** yet gives **maximum control**: no cluster to manage — you just bring the code on your laptop. You can do **both SFT and RFT** with this API (00:34).

### Integration with Foundry's Fine-tune UI

- Jobs submitted via the code-first training harness show up under **Train** (custom training; supports pre-training, mid-training, and more — "very powerful"), whereas jobs submitted via the **higher-level/Loom API show up under Fine-tune**, as both SFT and RFT (00:34).
- From there everything is the same: you can view **logs, all the checkpoints** (every checkpoint produced during training can be deployed), and a **dashboard to compare runs**. The telemetry — **reward function going up, entropy going down, group composition climbing** — is **as rich in the API-first path as in the code-first path** (00:34-00:35).
- A **private-preview sign-up link** is offered at the end for both new capabilities (code-first and the low-level API). Chris takes over for deployment (00:35-00:36).

---

## 7. Foundry Managed Compute — new deployment capability (00:36)

Chris connects training to deployment; Manoj runs the demo.

### From training to deployment

- A trained model must be **deployed so it can run as an API and be integrated into an agent** (00:36).
- **Foundry Managed Compute** is announced at Build today: **"one of the key things we're proud to announce at Build today is our Foundry Managed Compute"** (00:36).

### What Foundry Managed Compute enables

- A **serverless, scalable** solution for deploying **any open-source or custom models** on **Foundry-managed GPUs**, with automatic optimization and scale-out (00:37).
- **Model sources supported**:
  - **Serverless trained models** (models trained within Foundry).
  - Models **trained on your laptop or another model platform** — you **bring your own weights (BYOW)** regardless of where they were trained.
  - **Custom models with custom containers** featuring highly optimized runtimes, e.g., **speculative decoding** or **draft models**, to speed up inference (00:37).
- Manoj presents (00:38): you deploy both **base models** (to run evals and measure performance) and **fine-tuned models**.

### Deployment flow demo

- In the **model catalog**, base models can be deployed in different ways. For example, the **Fireworks** collection models can be deployed to a **Provisioned Throughput Unit (PTU)** — a managed offering giving predictable performance at a guaranteed throughput SLA (00:38-00:39).
- The other option is **Managed Compute** — deploying to **Foundry-managed GPUs**. Manoj selects **Qwen 32B ("Quen 32 billion")** and picks **Managed Compute** as the deployment option (00:39).
- Because you pay for the GPUs, you choose how to manage/pay for the deployment via **deployment templates** trading off GPU count vs. context length (00:39-00:40):
  - **2 GPUs** with enough KV cache to **maximize context length** (the slide's larger context option, e.g., 128K).
  - **1 GPU** — the **smallest footprint** — with a **40K context length**.
- **Fine-tuned models** appear in the list and are **auto-registered** when a job runs them. If you trained your fine-tuned model elsewhere, you can **import it into the project** with a command (00:40-00:41):
  - The most important thing to specify is the **base model / model architecture** you're bringing, so Foundry can pick the **right containers and deployment configuration**.
  - You also specify **model name, model version**, and whether it is a **full-weight model or an adapter**; this generates a command you copy/paste and run to import the model.
- **Deploying a base model and a fine-tuned model is identical — "no difference whatsoever."** You select **Global Managed Compute** and the same deployment templates / accelerator selection (00:41).

### Responses API support

- The deployed model can be tried in the **Playground** and called programmatically (00:42).
- The code snippet shown uses the **Chat Completions API**, which is **stateless** — you manage state yourself. To use the model in an agent (with state management and other capabilities), you add it to an agent (00:42-00:43).
- The same fine-tuned model added to an agent supports **tool calling** — e.g., asking about **NBA games** pulls **real-time information** to answer (00:43).
- The model also supports the **Responses API**, which **tracks your responses (stateful)**. In the demo, a query — **"remember what's my favorite color"** — is answered correctly even though the chat history is not passed, only the previous response, because the service recollects the prior turn (00:43-00:44).

### Observability and cost management

- After deployment, **observability, monitoring, and cost management** matter. With Managed Compute, **cost management is available out of the box** and **all metrics can be tracked** (00:44).
- The demo shows a **chart tracking total tokens consumed by the Qwen model**; charts can be **added to a dashboard** for rich monitoring (00:44).
- For cost management, Manoj **filters by the Qwen model** and views its cost. Hands back to Chris (00:44-00:45).

---

## 8. Wrap-up and getting-started guide (00:45)

Chris closes the session.

- **"Training models without deploying them is a waste of time,"** so having multiple cost-efficient, scalable ways to deploy is critically important (00:45).
- Recap of takeaways:
  1. **Many models** are available for your workload — Foundry has them all (open-source and proprietary). Choose them, add to your agent, and **evaluate them on your workload** (00:45).
  2. If a model hits your price/performance, deploy it; if not, **fine-tune, iterate, and improve continuously**.
  3. Use the **new reinforcement-learning capabilities** — both the **low-level API** and **full control with any open-source framework** like **Slime ("Slime Girl"), TRL**, leveraging the **power of Ray** for distribution and monitoring (00:45).
  4. **Browse and monitor the quality of rollouts and samples** to deeply understand model performance, and deploy cost-efficiently.
  5. Operate models with control via the **new serverless Foundry Managed Compute** offering on **one or many GPUs, auto-scaling with different context lengths** (00:46).
  6. Foundry **automatically collects all telemetry** needed to monitor costs and to **create new datasets to learn from**, closing the continuous-improvement loop after deployment (00:46).
- **Getting started**: "You can get started tonight." **All the repo samples are published**, and the **slides** are available afterward from the same location as all sessions. Chris points to many other Foundry sessions and thanks the audience (00:46).

---

## Summary — features, statuses, and next actions

### Core messages

- **Deploying a model to production is just the beginning.** The real value is in the continuous learn-and-improve loop: evaluate -> fine-tune -> deploy -> observe -> collect traces -> repeat.
- **Agents are token-hungry**, so scaling agents with frontier models scales the bill; **post-training a smaller open-source model** keeps cost flat while keeping or raising quality.
- **Evaluators are the product spec** — define what "good" means up front and continuously **hill-climb**, testing on your own data rather than relying on published benchmarks.
- The demo recipe is **distillation (from production traces) -> SFT -> RFT**, which lifts **Qwen 14B** from near-zero to near-frontier (GPT-5.2) quality at roughly **10x lower cost**.
- The whole lifecycle — training (code-first on Ray or the low-level Loom API), deployment (Foundry Managed Compute), and observability — lives on the **single Foundry platform**.

### Announced features

| Feature | Status | Description |
|---|---|---|
| **Foundry Managed Compute** | **Announced at Build (available)** | Serverless, scalable hosting of open-source and custom models on Foundry-managed GPUs. Supports BYOW (bring your own weights), custom containers (speculative decoding / draft models), auto-scaling, and GPU-count vs. context-length templates (e.g., 2 GPUs / max context, 1 GPU / 40K). |
| **Code-first RFT/SFT (Ray-based)** | **New capability — Private Preview (sign-up link at session end)** | Run SFT/RFT directly from the Workbench (VS Code compute instance) on an authenticated Ray cluster, with full per-node/per-actor visibility and rollout-level debugging. |
| **Low-level GPU API ("Loom", code name)** | **New capability — Private Preview (sign-up link at session end)** | Write RL logic on your laptop/CPU and submit jobs that the service runs on a managed GPU cluster. Only four GPU primitives to understand (forward pass, backward pass, loss optimization, rollout sampling). Supports SFT and RFT; enables client-side curriculum learning. |
| **RFT rollout visualization** | Part of the code-first experience | Inspect each training sample's tool-call order and rewards in the UI; side-by-side compare good vs. bad rollouts (e.g., prompt 8 vs. Rollout 16) to diagnose grading. |
| **Responses API support for fine-tuned models** | Available | Deployed fine-tuned models support both the (stateless) Chat Completions API and the (stateful) Responses API, which tracks prior responses server-side. |

### Next actions

- **Sign up for Private Preview**: use the link shown at the end of the session to request access to the code-first (Ray-based) capability and the Loom low-level API.
- **Get the sample repository**: all repo samples shown in the session are already published ("get started tonight").
- **Get the slides**: available afterward from the same location as all Build session materials.
- **Explore related sessions**: Chris points to many other Foundry sessions on deploying and managing agents and models.

### Technical conclusion

The data shown indicates that **Qwen 14B**, weak as a standalone base model, can — through a pipeline of **distillation from production traces -> SFT -> RFT** — approach **GPT-5.2-level quality while costing roughly 10x less**. For enterprises operating agents at scale, this positions **post-training as a practical strategy to reconcile cost control with quality maintenance**, with the full evaluate-fine-tune-deploy-observe loop closed on Foundry.
