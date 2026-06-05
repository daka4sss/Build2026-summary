# Microsoft Build 2026 BRK231 "Deploy. Observe. Learn. Reinforcement learning for production agents" — Detailed Summary

**Speakers**: Alicia Frame (Product Lead, Model Customization, Microsoft Foundry) / Omkar More (Engineering, Microsoft Foundry)
**Session URL**: https://build.microsoft.com/en-US/sessions/BRK231
**Source**: Official WebVTT transcript (medius.microsoft.com CAPTION)

---

## Overview

This session introduced the post-training techniques available on Microsoft Foundry for making production agents better, cheaper, and faster, walked through across a four-part demo arc. The techniques shown were (1) supervised fine-tuning (SFT) via distillation of teacher-model traces, (2) reinforcement fine-tuning (RFT) with real tool calls, and (3) a low-level training API ("PyTorch as a service") for fully custom recipes — closing with (4) a natural-language fine-tuning skill.

Because agents consume 20–30x more tokens per turn than chat, continuing to run frontier models unchanged makes cost explode. The key to economically sustainable agent operation is using fine-tuning to lift small models that are 10–30x cheaper up to equivalent performance. The thread running through every demo is the value proposition of "baking your IP and domain knowledge into the model weights, and keeping it as yours rather than handing it to the frontier labs."

The session closed by demonstrating a **fine-tuning skill** that lets you drive the entire fine-tuning workflow in natural language (built into GitHub Copilot for Azure, or available standalone), pointing toward a democratized future where anyone can try fine-tuning.

---

## 1. Why fine-tuning now (0:00)

Just after the session opened, Alicia made a half-apologetic announcement that "it''s a little noisy in here, so there are headsets in the back," then moved into the main topic. She framed the agenda as: about five minutes of slides on what fine-tuning is and why fine-tune, then four demos — distillation for cheaper/faster agents, reinforcement learning to "learn from your mistakes" when the teacher isn''t smart enough, the new low-level interactive training API, and finally coding agents for fine-tuning via the fine-tuning skill.

The following numbers were shared as the backdrop for agent adoption:
- **A third of enterprise software apps say they''ll embed agentic AI within two years** (Alicia predicted the real number is higher and sooner)
- **Half of teams already have some kind of production agent today**
- Agents consume **20–30x more tokens per turn** than an old-fashioned chat interaction

This "token explosion from agents" is exactly what creates the need for fine-tuning. The primary value of fine-tuning was framed along three axes:

1. **Quality improvement**: Baking the instructions from your prompt into the model weights themselves, so the agent calls the right tool at the right time with the right inputs.
2. **Cost reduction**: The targets of fine-tuning are small models **10–30x cheaper** than a frontier model (e.g., GPT-4.1 nano, Qwen models). If something is 30x cheaper, your budget still balances even when it consumes 30x the tokens.
3. **Latency reduction**: Small models stream tokens faster. Agentic workflows respond more quickly, improving user experience (Alicia noted everyone has "sat there and watched Claude churn" while bored).

Alicia also noted that about half of developers say they want to replace their out-of-the-box models with fine-tuning — a reversal from the "out-of-the-box models are amazing, I don''t need this" sentiment of a few years ago — driven by cost compounding in the agentic loop, quality, and latency.

---

## 2. How fine-tuning works and where it fits in Foundry (2:01)

The overall Microsoft Foundry platform picture was presented. On a foundation of over **11,000 models**, the agent runtime, deploy/host, observe, and tool-granting capabilities are stacked, plus tooling to **Evaluate** agents (know if they''re doing what you want) and **Optimize** them (improve based on what you''ve observed). This talk focused on the **Evaluate and Optimize** box.

The technical background of fine-tuning:
- **Pre-training**: Learning next-token prediction on a massive amount of unlabeled data (the most expensive part)
- **Instruction tuning (SFT)**: Learning task-specific responses from prompt-and-response pair data
- **Alignment tuning**: Steering output direction using human preference data and reward models

Putting these three steps together gives you a frontier model. Fine-tuning is the "cheat code" that skips the most expensive, hardest pre-training step — you pick up a generic, off-the-shelf base model and add just SFT, alignment, or both, getting a head start in the customization journey while adding your own data and creating your own IP.

The optimization journey was described as proceeding in order: "prompt engineering → context management (grounding/RAG and memory) → tools → Evaluate → fine-tuning." This talk focused on the right-hand side of that optimization curve.

---

## 3. Demo 1 — SFT via distillation (cheaper and faster) (9:16)

### Scenario setup

The scenario shared across all demos was a retail **customer service agent (refund processing)**. A customer calls in asking for a refund on an item; the agent must decide whether the request was valid, whether the item can be returned, and whether it should be replaced or refunded — using these tools:
- `get_order_details` — retrieve order details
- `get_fulfillment_status` — check fulfillment status
- `check_resolution_policy` — check refund policy
- `process_payment` — process payment

Getting it wrong can cost the retailer a lot of money — and a lot of customers. Online returns were about **$900 billion of business in the US last year**, making it critical to get this scenario right.

### Demo flow

1. **Build a hosted agent in Foundry**: Used GPT-5.4 as its base model. Foundry''s agent hosting supports any agent framework you want — Semantic Kernel, LangGraph, etc. Omkar tried it with an example: a customer asking to return an unused yoga mat, which the agent resolved. Alicia noted the Foundry UI is a simple, no-code way to do this, but it''s all possible from code too.
2. **Inspecting traces**: Foundry-hosted agents automatically capture the conversation traces. The user view shows the request and final outcome; the trajectories view shows which tools were invoked — in this case `get order details`, then `fulfillment status`, then `check resolution policy`, then the final outcome. The "Traces" tab showed the agent had been running for the last few days with **about a thousand-odd traces** captured.
3. **Baseline evaluation**: Before any fine-tuning, the question is "can I just replace my large model with a smaller model?" Using the SDK, Omkar ran an evaluation comparing GPT-5.4, o4-mini, GPT-4.1-mini, and GPT-4.1-nano. Foundry supports out-of-the-box LLM-based graders (task resolution, intent resolution) or your own graders backed by an LLM or pure Python. He used a Python grader scoring three fronts:
   - Whether the refund decision was right (weighted **50%**)
   - Dollar-amount accuracy — e.g., refunding $500 for a $50 item (weighted **30%**)
   - Output format, important because downstreams depend on it (weighted **20%**)
   - Result: o4-mini and GPT-5.4 did reasonably okay at around **65%** quality score; 4.1-mini and nano performed really poorly — confirming you can''t just drop in the smaller model to save cost and latency. Anything generated from the SDK is automatically registered in the UI for a nice view.
4. **Distillation (SFT)**: From the traces, the **"Create Dataset"** button converts raw traces into datasets usable for evaluation, RFT, or SFT. It does smart things: removes duplicates, drops non-interesting conversations, and redacts PII before training. About **1,400 traces** were available; the recommendation is at least about a thousand samples. He used a thousand samples and started the SFT wizard, selecting GPT-4.1-mini/nano.
   - **Training type (SKU)**: Standard; **Developer Preview** (Alicia''s favorite — **50% off** vs. standard tier, running on low-priority VMs so it can take a bit longer); and the **Data Zone SKU** (US data-residency guarantees, **newly introduced at Build today**).
   - Datasets were preloaded from the converted traces; auto-deploy after job completion and a few hyperparameters were available — all completed in a few clicks from the UI ("easy mode").
   - **Continuous fine-tuning** is supported for further refinement with more data.
5. **Post-SFT evaluation**: On the Monitor tab, loss was reducing and accuracy increasing. Beyond the final model, **checkpoints** are captured for interesting cases where reward increased before the last step. The deployed fine-tuned model was evaluated: **fine-tuned GPT-4.1-mini came out on top at 74%**, outperforming o4-mini and GPT-5.4 at a fraction of the cost — faster, cheaper, and slightly smarter.
   - The default graders (**intent resolution, task completion**) were also included to confirm fine-tuning hadn''t eroded the base model''s capabilities — guarding against the fear that you make a model better at one thing but worse at others.

---

## 4. Interlude — the "teacher isn''t smart enough" problem and the need for RFT (21:14)

74% is not enough for the business (26% of $900 billion = over $100 billion lost to spurious refunds). The inherent limit of distillation (SFT) is that you can never get smarter than your teacher — the source of the training data, the mark you''re trying to hit, is the teacher''s performance. Breaking through that ceiling is what **Reinforcement Learning (RL) / Reinforcement Fine-Tuning (RFT)** does.

How RFT works (whiteboard explanation):
- You send the same prompt to the model multiple times, and the model generates multiple **rollouts** (sample responses) — here, three possible samples.
- The grader you defined scores each sample.
- The quality of your grader determines whether this works at all — if everything is graded all-right or all-wrong, there''s nowhere to go. You need a grader that grades the outcome you want **and** leaves room for improvement.
- The quality scores are fed into the trainer; you reinforce the correct answers and learn from them.
- Over time the model learns to reason — in this case through chaining multiple different tool calls together.

**Key prerequisite**: RFT works when the task is **verifiable**. If you can''t grade it, you can''t learn from it. Refunds are gradable (you can say "yes, you should have refunded that" or "no, that was terrible"), making this a perfect scenario.

---

## 5. Demo 2 — Reinforcement Fine-Tuning (RFT) (23:19)

### Difference from SFT

In SFT you copy the teacher model''s full tool-call trajectory (which tools, in what order, with what responses). In RFT you don''t give that trajectory — SFT is "learning by seeing or copying what a smarter person is doing," whereas RFT gives the training process itself the ability to invoke the tools on the fly, takes the tool responses, grades them against the grader from the evaluation flow, and reasons continuously to make better decisions. In short, you give the model the tools to answer the questions and the model figures it out on its own.

### SDK-based demo steps

1. **Training data structure**: Again sourced from the traces, but the training/validation data now contains only the actual user message plus some ground truth used by the grader (e.g., the final amount to be refunded) — it does **not** contain which tools to call or the message body to return.
2. **Customizing the RFT grader**: You can reuse the evaluation grader or tweak it. Omkar added **tool coverage** (e.g., don''t give a high score to a response where `get orders` was never invoked). Alicia stressed this matters for avoiding **reward hacking** — a failure mode they hit during development was the model learning "I will never call a tool," because it was getting penalized for calling the wrong tool.
3. **Tool environment setup**: All tools were hosted on an **Azure Function App** and can be invoked as real tool calls — "your RL harness or RL environment." **MCP servers** or anywhere else your tools are hosted can also be used.
4. **Running the RFT job**: From Foundry you get RFT-specific hyperparameters, especially for a reasoning model like **o4-mini** — including **reasoning effort** (low/medium/high), which sets how much chain of thought the model does and directly affects token cost — plus number of epochs, evaluation interval, etc. The Function App tools are wired in as the real tools used during training (results are actually used rather than copied as in SFT).
5. **Monitoring via the Monitor tab**:
   - **Rewards (train/validation)**: The primary metric — confirm both are increasing over time (evidence of healthy learning); here both looked good.
   - **Reasoning token mean per step**: The model spends a lot of reasoning effort early in training, then it comes down — evidence that the final fine-tuned checkpoint uses far less reasoning than the base model, with implications for token cost.
   - **Tool calls per rollout**: If the model decides to stop calling tools and you see a dip, that signals something wrong with the run (reward hacking) and you''d iterate on the grader.
6. **Post-RFT evaluation**: **Fine-tuned o4-mini came out on top at 84%** — a huge bump from around 73–75%, with intent resolution and task completion increasing or staying stable. The more effort you put in (getting graders right, longer runs), the more substantial the outcome. And o4-mini is still a smaller, substantially cheaper model than the GPT-5.4 teacher — staying true to "better, cheaper, faster." Alicia tied this back to the keynote''s "hill climbing" narrative — "we''re on our way up the hill."

### Real-world adoption examples (presented by Alicia)

| Company | Technique | Result |
|---|---|---|
| **Decagon AI** | Distillation + fine-tuning on Foundry | Powered their customer-support-agent-as-a-service by switching to smaller, cheaper, faster models |
| **Discovery Bank** | Distillation + fine-tuning | Cut their banking-app response latency from **6 seconds to 1.5 seconds** |
| **Docusign** | Distillation | One of Foundry''s biggest token customers; **50% cost reduction** in AI document processing |

These were emphasized as production usage, "not just demo-ware."

---

## 6. Demo 3 — Interactive Training API (low-level API / "PyTorch as a service") (32:42)

At 84% there''s still maybe ~$90 billion lost. For those who want more control — data scientists / AI scientists who want to define their own rollout environment, their own algorithm, full control over hyperparameters — Alicia gave a sneak peek of the new **interactive training API**.

### Managed fine-tuning vs. training API

| Item | Managed Fine-tuning (demos 1 & 2) | Training API (demo 3) |
|---|---|---|
| User actions | Pick model and technique, provide data, submit job | config → invoke rollout → compute loss → update weights → update grader (full control) |
| Service boundary | Everything happens inside a closed loop you can''t touch | Your code lives outside the loop (control the whole algorithm) |
| GPU infrastructure | Managed by the service | Managed by the service (you don''t deal with it) |
| Best fit | Most cases / most people | AI/data scientists, researchers |

Alicia noted that for anyone who has tried (and failed) to use **Pearl** to set up GPU clusters and orchestrate synchronous/asynchronous, aggregated/disaggregated training, Foundry abstracts away all that pain — "you focus on the algorithm, we manage the compute."

### API primitives

- `sample` API: Run sampling (forward pass) on a base LLM preloaded on GPUs
- forward-backward pass API: Compute gradients (runs on the training node)
- `sync` API: Sync the LoRAs from the training node to the sampling node
- `sync_checkpoint` API: Save the checkpoint for training later on

Behind the scenes, a **two-node setup** runs — a **training node** (runs forward-backward pass, computes gradients) and a **sampling node**. Distributed training with LoRA is managed transparently, abstracting away "nickel issues" and vLLM issues you''d otherwise have to deal with. A recipe runs as steps: take the dataset → generate multiple samples per request (e.g., 10 or 20) via the `sample` API → run your own grader on the samples → the GRPO step (compute advantages, take the mean of samples, see which are better) → forward-backward pass to compute gradients → sync. All of this is **within Foundry** — runs appear as Foundry runs, models are usable like any other Foundry model with hosted agents and evaluation.

### Flexibility highlights

- **Custom graders**: Can be written in C# or any language, not limited to what the high-level APIs support
- **Custom tool integration**: Not bound to MCP servers — you have full control over invoking tools in the sampling process, even tools in formats incompatible with the high-level APIs, and you can interact with a real environment (execute the rollout, call real tools in the real world, see what happens)
- **Algorithm choice**: GRPO (default), plus PPO, DPO, and others
- **Curriculum learning**: Start with a very simple task and graduate to larger, harder tasks
- **Mid-flight changes**: Change the sampling strategy or algorithm while a run is in progress (the "interactive" part)

### Local dashboard

The training API''s orchestration runs locally on your own machine (a CPU laptop in the demo, or an Azure VM for long-running sessions) — the launcher script starts a tmux session, and all the fine-grained logs live on your machine. Foundry ships a small local dashboard for real-time detailed metrics:
- Rewards and accuracy (increasing, like the managed runs)
- Entropy (reducing is normal)
- Gradient ("grand") norm (reducing)
- **KL divergence** (the number-one investigation for reward hacking — "couldn''t see that before; now I can")
- GRPO group composition (improving over time)

### Demo result

Running RFT with the low-level API on **Qwen3 32B** (an OSS model), the result **beat even the fine-tuned o4-mini (84%) on the leaderboard** — the highest score. Qwen3 32B is a much cheaper, smaller model than o4-mini, satisfying "cheaper, faster, and smarter" all at once.

---

## 7. Demo 4 — Fine-tuning Skill (fine-tuning in natural language) (41:54)

### Background / pain points

Common complaints the team hears:
- "I don''t even have the data to train these models."
- "I tried fine-tuning once, made the model worse, and I''m never doing this again."
- (Implied) "I don''t want to learn the API or SDK."

In response, the team added a **fine-tuning skill**, and since Alicia called it "a PM skill," she ran this demo herself.

### Overview of the fine-tuning skill

Use your favorite coding agent and natural language to describe what you want, and it figures it out — building graders, calling Foundry''s APIs, etc. Alicia candidly admitted she didn''t trust **Claude** and **Copilot CLI** to do it live on the fly (and a non-fine-tuned model is slow), so she ran it ahead of time. It is part of the **GitHub Copilot for Azure** skill, or can be downloaded as a **standalone fine-tuning skill**, making fine-tuning accessible so "anyone can fine-tune."

### Demo flow (pre-recorded)

1. **Auto-generating the grader**: She gave it the address of her hosted agent and described the goal — make a grader that checks the right tools are called, gives partial credit, and reports how well the model performs. Without learning the API/SDK or clicking the UI, the skill built the grader (full credit for asking clarification or getting the answer right, partial credit for getting some tool calls) and graded the teacher model (GPT-5.4): **mean score 8.37, pass@8 of about 78%**.
2. **Auto-running the distillation job**: She told it to kick off a distillation run with the goal of "cheaper and faster," exporting/filtering/de-duping the agent traces and running a **fine-tuning autopilot** run. The autopilot decides which models to run, which algorithm to pick, and runs a couple of experiments based on the data and description. In parallel she had it run the same honesty check on the smaller, cheaper base models. The result: a **fine-tuned GPT-4.1-mini** winner (it picked mini and nano because she said "smaller and cheaper," choosing hyperparameters on its own), reaching almost the same mean score and a slightly higher pass@8 — the full distillation flow done in totally natural language.
3. **Fallback behavior**: If all the experiments just made things worse, the skill looks at the logs and decides what to do next — generate more data, try a different experiment — and iterates until it gets it right.

---

## 8. Summary, new features, and resources (45:37)

### Dispelling two myths

**Myth 1: "Frontier models keep getting smarter, so I don''t need to fine-tune."**
→ Yes, they get smarter — but also bigger, slower, and more expensive. As shown in the keynote and the demos, small, cheap fine-tuned models can outperform frontier-class models. And when you fine-tune, your IP, business knowledge, and domain go into **your** custom model — not into the frontier lab''s weights for them to make money off you.

**Myth 2: "Fine-tuning is expensive — you pay to train and pay to host."**
→ Developer-tier training is spot capacity at **50% off**; the **median SFT job costs about a dollar**; and developer-tier hosting has **no hosting fee**, making experimentation easy and providing the bridge to production where substantial cost savings appear as usage ramps.

### Announced features

| Feature | Status | Description |
|---|---|---|
| **Data Zone SKU** (US data-residency guarantees) | Newly introduced at Build 2026 (likely Public Preview) | Training-type SKU governing data residency in the US |
| **Interactive Training API** (low-level API / "PyTorch as a service") | Preview sign-up open (likely Private/limited Preview) | Low-level training primitives (sample, forward-backward pass, sync, sync_checkpoint) with managed GPU compute and full algorithm control |
| **Fine-tuning skill** (GitHub Copilot for Azure / standalone) | Available (status not explicitly stated) | Drive the fine-tuning workflow (graders, distillation autopilot) in natural language via a coding agent |
| Developer tier training (50% off, spot capacity) | Existing | Train on low-priority VMs at half the standard-tier cost |
| Developer tier hosting (no hosting fee) | Existing | Host fine-tuned models with no hosting fee for easy experimentation |
| Traces-to-Dataset conversion (auto PII redaction + de-dup) | Existing | "Create Dataset" converts hosted-agent traces into SFT/RFT/eval datasets |

### Next actions

1. Sample notebooks: the code shown in the demos is available in the public repo
2. Sign up for the Training API preview (announced in-session)
3. Hands-on labs: three sessions running the next day (do reinforcement learning yourself with the demo example)
4. Install the fine-tuning skill: GitHub Copilot for Azure skill or standalone download

---

## Summary

The session was structured as one consistent story: "once you''ve run a production agent and accumulated traces, use that data to make it cheaper, faster, and smarter." It offered a graduated set of options — SFT (easy, fast) → RFT (higher accuracy, somewhat more complex) → low-level Training API (full control, for researchers) — and provided an exit ramp with the fine-tuning skill so "anyone can do it in natural language."

Core messages:
- Agents consume 20–30x the tokens of chat, so running frontier models unchanged breaks the bank; fine-tuning small models that are 10–30x cheaper to frontier-equivalent quality is the path to sustainable agents.
- Distillation/SFT cannot exceed the teacher; RFT breaks that ceiling on verifiable tasks by learning from a grader, while RFT-specific telemetry (rewards, reasoning tokens, tool calls per rollout, KL divergence) detects and prevents reward hacking.
- The new interactive training API ("PyTorch as a service") exposes low-level primitives with managed GPU compute, real-tool environments, custom graders/algorithms, curriculum learning, and mid-flight changes — letting a fine-tuned Qwen3 32B beat fine-tuned o4-mini.
- Fine-tuning is cheap (median SFT ~$1, 50%-off developer training, no-fee developer hosting) and keeps your IP in your own weights rather than the frontier lab''s.

Most notable are the architecture that connects real tools (Function App / MCP server) into the RFT training loop in real time, and the low-level API''s ability to surface detailed metrics like KL divergence to detect and prevent reward hacking — meaning Foundry absorbs the biggest engineering challenges of using RL at production scale.