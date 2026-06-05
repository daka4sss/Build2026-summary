# Microsoft Build 2026 BRK235 "Local models, developer control, and the future of AI runtimes" — Detailed Summary

**Speakers**:
- **Michael** — Co-founder of Ollama. Presents the product vision and real-world examples in the first half of the session.
- **Parth** — Works on agents at Ollama. Delivers the live demos in the second half of the session.

**Session URL**: https://build.microsoft.com/en-US/sessions/BRK235
**Source**: Official WebVTT transcript (medius.microsoft.com CAPTION)

---

## Overview

This session is a presentation and live demo by **Ollama** co-founder Michael and agents lead Parth, centered on open models and hybrid (local + cloud) execution. (Although the catalog title is "Local models, developer control, and the future of AI runtimes," the speakers frame the talk as "open models for agents" and how hybrid local/cloud models work together to make agents a reality.)

The core thesis is that **open models have entered a practical, production phase for agents**. In the first half, Michael covers what Ollama is, the rapid capability evolution of open models, and real-world deployments at national laboratories and large enterprises. In the second half, Parth runs live demos: integration with a coding agent (GitHub Copilot CLI), "hybrid execution" that processes sensitive data locally, and setting up a personal agent (Open Claw). The session closes with audience Q&A (edge devices, VRAM/unified memory, inference engines, and recommended models).

The consistent message is: **you can now run agents using close-to-frontier intelligence while keeping your data on your own machine (preserving privacy). Hard tasks go to the cloud, sensitive tasks stay local — and you can switch between the two seamlessly.**

---

## 1. Introduction — What is Ollama (0:00)

Parth introduces himself as working on agents at Ollama, and Michael as one of the co-founders of Ollama. When asked "Has anyone here heard of Ollama before?", a large portion of the room raised their hands, indicating strong awareness.

**What Ollama is**:
- The easiest way for developers to access open models and use them with their own tools.
- Lets you **run a model in a single command** and start chatting with it right away.
- The recently introduced `ollama launch` command **injects open models directly into your favorite tools** (integrating them into harnesses such as Claude Code, VS Code, and GitHub Copilot).
- For application developers, it provides **OpenAI- and Anthropic-API compatibility**, plus great SDKs for Python and JavaScript to build on top of.
- **Built for agents from the beginning** — Ollama is specifically tested for tool calling and structured outputs, and offers one-line agent setup for bringing all these models to the Ollama platform.

---

## 2. Scale and Partnerships (1:51)

- Currently **over 8 million active developers** use Ollama.
- Ollama partners with major model labs and hardware companies to continuously bring new model launches and hardware optimizations to the platform.
- On the morning of the talk (during Build 2026), **Google DeepMind announced the "Gemma 4 12B" unified model**, and it is **already available on Ollama** and usable for agentic applications. (The transcript renders it as "Jemma 412 B"; this is taken to mean Gemma 4 12B.)

---

## 3. Ollama Cloud — Augmenting Local Inference (2:21)

Starting this year, Ollama added **Ollama Cloud** to augment the local-inference piece.

- **Your data is never trained on; it has zero data retention.**
- It runs **frontier models on data-center-grade hardware**.
- If you don't have enough compute locally, you can scale with Ollama and still run the models you want.
- An example use case cited is **parallel agents** — accomplishing difficult work that smaller models couldn't do on their own.
- Each model comes with the **maximum context window** from the model providers themselves.
- This is a **completely optional service** — it's up to the user whether to use it.

---

## 4. The Capability Evolution of Open Models (3:18)

Showing a SWE-bench Verified score "for illustration purposes," the speakers emphasize that open models are increasingly **enabling mainstream use cases at significantly lower prices**.

- Not cutting-edge research like DNA synthesis or frontier coding applications, but **mainstream, everyday tasks** that open models are now able to handle.
- Users get the flexibility to customize their models and run them with the parameters that fit their goals.

**Stages in the evolution of model capabilities**:
1. **Pure general chat** (in the past)
2. Acquiring **reasoning / thinking** abilities
3. Using **individual tools and multiple tools**
4. **Long-horizon tasks** — tasks that can run for hours and days. This is just starting to happen now, and much more "unlock" is expected going forward.

---

## 5. Real-World Deployments (5:00)

Because Ollama is **private (runs on your own machine)**, its use is cited even in published papers.

**Research institution cases**:
- **Lawrence Berkeley National Laboratory (LBNL)**: An accelerator assistant system that autonomously executes physics research for X-rays. It has a **routing layer** that chooses between cloud models and Ollama to do its inference. This is Ollama powering their X-ray research.
- **NASA Glenn Research Center**: Crew health and performance probabilistic risk assessment. Uses Ollama to categorize a diverse set of Mars-mission tasks into **18 predefined human-system task categories** for future missions.
- **US Department of Energy / Brookhaven National Laboratory (BNL)**: Integrates Ollama to facilitate log data analysis. Combined with LangChain, it lets users use a GUI to summarize log information and retrieve specifics on issues and solutions through natural language.

**Enterprise cases (where sensitive data cannot go to the cloud)**:
- **Multinational media company**: Processes highly sensitive financial documents such as quarterly earnings reviews and SEC filings. Because this data cannot be sent to other cloud AI models or providers, they use Ollama.
- **Leading industrial manufacturer**: Built an internal assistant on Ollama to help design machine parts — for their mechanical engineers doing CAD design.
- **Automotive manufacturer**: Runs Ollama directly on the factory floor, leveraging RAG (retrieval-augmented generation) over their knowledge base and an inspection system for factory technicians.

---

## 6. Live Demo 1 — Seamless Local/Cloud Chat (7:32)

From here Parth takes over the demos.

- Demonstrates the "classic bread and butter" of chatting with a model in Ollama.
- A big focus is **keeping the local and cloud experiences feel exactly the same**. For larger tasks you use a bigger (cloud) model, almost the same way you'd use a local model.

---

## 7. Live Demo 2 — `ollama launch` and GitHub Copilot CLI Integration (8:16)

The **`ollama launch`** command, introduced earlier this year, is a way to connect open models to your favorite tools and applications.

- Supports personal agents (**Open Claw**, **Hermes**) as well as a plethora of agentic harnesses for coding agents and coding work.
- The list includes **Claude Code, Codex, Copilot CLI, Droid, Pi**, and many more, with many more coming.

**Copilot CLI demo**:
- Just type `ollama launch copilot` and pick the model you want.
- In the demo, **Kimi K2.6** running on the cloud is used (a local model could be picked just as easily).
- A favorite feature of the Copilot CLI is that you can **directly pick which issue to work on**. Parth tells it to fetch an issue, the model thinks (the thinking runs long), and it figures out exactly what's going on in the issue.
- Without ever leaving the terminal, real work is done with open models (e.g., "Are there any open PRs referencing this?", "No", then start working on a fix).
- The team makes sure underlying technologies like **sub-agents and web search** reliably work; multiple sub-agents are spun up to explore the codebase and propose potential fixes. It produces a plan and can then execute on it to get the work done.

---

## 8. Live Demo 3 — Hybrid Execution and Local Processing of Sensitive Data (10:35)

The importance of **hybrid execution** is emphasized.

- The **very-close-to-frontier-intelligence cloud models** Ollama serves are awesome for your most difficult coding and agentic tasks.
- But there's a lot of data you want to keep **extremely private**, processed locally.

**Credit card statement demo (fully local)**:
- A workflow Parth does at the end of every month (and quarterly): processing his credit card statement (a fake one for the demo).
- Uses a minimal harness called **Pi**. Pi is designed **not to bloat the system prompt** — it keeps everything minimal, which is perfect for local models.
- Uses **Qwen 3.6** running locally on his MacBook. He tells it: "Process this statement and show me how much I'm spending across the different categories." (The transcript renders the model as "Quant 3.6"; this is taken to mean Qwen 3.6.)
- The model writes code to process the PDF, does the math, and presents a spending breakdown. **None of the information ever leaves the computer.**
- With humor ("Seems like I'm spending a lot on travel, I guess I'm overdue for another vacation"), he emphasizes that local models can now do real work at a **"good enough"** level. "A big thing we've seen over the last few months is that local models are actually viable to do real work."

---

## 9. Live Demo 4 — Setting up the Personal Agent Open Claw (13:01)

Introduces the benefits of using local models with **personal agents** (Hermes, Open Claw).

- Because none of your information ever leaves and everything lives on your own computer, you can comfortably feed it information.
- Demonstrates that **Ollama can install Open Claw for you**. Running `ollama launch open claw` installs Open Claw, lets you choose a model, and completes setup.
- An end-to-end setup is shown: in **about 30 seconds, you go from absolutely nothing installed to a running Open Claw ready to do work for you**.

---

## 10. Q&A (13:40 onward)

### Q1. Any plans for edge-device (mobile) support? (14:14)
- The audience asks whether there are plans to integrate Ollama directly at the edge — on iPhone / Android and other devices that don't have laptop-class power.
- **Answer (Michael)**: Mobile devices aren't directly targeted yet. Some people have been experimenting with bringing Ollama to mobile, and it does run. Ollama is **enabled on Qualcomm Snapdragon devices**, which use the same chipset as mobile, and users have done this. For now the priority is **mainstream use cases for work**, so mobile is not a direct target yet.

### Q2. VRAM / unified memory, model sizes, and context length (15:30)
- The questioner saw a 262K context window in the demo and asks what kind of machine and specs that is, and whether it's a quantized model.
- **Answer (Parth)**:
  - Ollama has a recommended **default quantization** for most things, and in addition, with **MLX support** it can run **NVFP4**.
  - He personally uses a maxed-out Mac, so with smaller models he can run **full context length** and not have to worry much about compaction.
  - When running agentic workloads locally you tend to hit **hardware constraints** where you can't support the maximum context length.
  - **Unified memory** is great because it lets you have larger context lengths, with a slight speed trade-off versus a CUDA card, but you get to work with larger memory and **support harder and harder tasks**. Over time, unified memory will get better in performance and speed too.
  - **Hardware trend**: Most hardware partners are moving toward unified memory. It started with Apple; **NVIDIA and Microsoft just announced RTX Spark with up to 128 GB of unified memory**, and **AMD's Strix Halo platform also goes up to 128 GB**. Across the board, different hardware teams are moving toward unified memory.

### Q3. Apple Silicon and inference engine — still using llama.cpp? Any plans for your own engine? (17:37)
- **Answer (Parth)**: Ollama **has its own MLX inference engine**. On Apple devices, **using the MLX engine is highly recommended** (faster performance). To use it, you just pull one of the MLX models from the model registry.

### Q4. Best coding model on a 128 GB MacBook? (18:17)
- **Answer (Parth)**: A favorite (said with the caveat that he might be misremembering) is "1362070" plus **Gemma**, used in pairs to write smaller scripts. A bit underrated, but even **gpt-oss 120B** works really well for scripting and other tasks. (The transcript renders these as "1362070" — likely a specific Qwen-family model — and "GB2SS120B" — taken to mean gpt-oss-120B.)
- **Addition (Michael)**: The **Gemma 4 dense models** are actually really performant and can be run at full context length.

### Q5. How should you choose which model to use? (19:00 onward)
- **Answer (Parth)**: It depends on the task. Different models perform better for coding, personal agents, chat, or classification.
  - The best approach is to **try a bunch out**.
  - Going forward, when you use a specific harness via `ollama launch`, Ollama plans to surface **recommendations of the most up-to-date models best suited for that system**.
  - If you're building a bespoke app, the best thing is to try several, benchmark them, and pick the one you prefer most.

---

## Summary

### Core messages

- **Open models have entered a practical phase for agents** — for mainstream tasks, you can use close-to-frontier intelligence at low cost.
- **Local x cloud hybrid is the key** — hard work goes to the cloud, sensitive data stays local, and you can switch seamlessly within a **single, identical experience**.
- **Privacy is a major differentiator** — you can run agents while keeping data on your own machine (zero-data-retention Ollama Cloud; fully-local Pi / Open Claw demos).
- **Hardware evolution (unified memory) boosts local execution** — 128 GB-class devices like RTX Spark and Strix Halo make harder tasks tractable locally.

### Announced features

| Feature | Status | Description |
|---------|--------|-------------|
| Ollama | Available (8M+ developers) | Platform to run open models locally; OpenAI/Anthropic API compatible; built for agents (tool calling, structured outputs). |
| `ollama launch` | Available (introduced this year) | Command that injects open models into tools such as Claude Code, Copilot CLI, Codex, Droid, Pi, Open Claw, and Hermes; more coming. |
| Ollama Cloud | Available (added this year) | Runs frontier models on data-center-grade hardware with zero data retention; supports parallel agents; optional; max provider context windows. |
| MLX inference engine (Ollama's own) | Available | Faster on Apple devices; supports NVFP4 quantization; pull MLX models from the model registry. |
| Gemma 4 12B (unified model) | Available on Ollama (announced same morning by Google DeepMind) | Usable for agentic applications immediately; Gemma 4 dense models also noted as highly performant. |
| Better model recommendations in `ollama launch` | Planned | Will surface the most up-to-date models best suited for a given harness/system. |

### Deployments (in production)

- Lawrence Berkeley National Laboratory (autonomous X-ray physics-research accelerator; cloud/Ollama routing layer)
- NASA Glenn Research Center (categorizing Mars-mission tasks into 18 human-system categories)
- Brookhaven National Laboratory / US Department of Energy (LangChain + Ollama log analysis)
- Multinational media company (processing sensitive financial documents and SEC filings)
- Leading industrial manufacturer (CAD machine-part design assistant)
- Automotive manufacturer (factory-floor RAG and inspection system)

### Other models / harnesses / hardware mentioned

- Models: **Kimi K2.6** (cloud), **Qwen 3.6** (local), **gpt-oss 120B**, plus a Qwen-family coding model.
- Harnesses: **GitHub Copilot CLI, Claude Code, Codex, Droid, Pi, Open Claw, Hermes**.
- Hardware: **NVIDIA / Microsoft RTX Spark (up to 128 GB unified memory)**, **AMD Strix Halo (up to 128 GB)**, **Qualcomm Snapdragon** (mobile chipset; Ollama runs on it).

### Note on transcription accuracy

The transcript is speech-recognition based, so some model names ("1362070", "GB2SS120B", "Jemma 412 B", "Quant 3.6") may differ from the exact product names; this summary notes the inferred names where applicable.

---

## Next actions

- Try `ollama launch <harness>` (e.g., `ollama launch copilot`, `ollama launch open claw`) to inject an open model into your preferred tool, choosing between a local or cloud model.
- For privacy-sensitive workflows (e.g., financial documents), run a local model with a minimal harness such as Pi to keep all data on your own machine.
- On Apple Silicon, pull an MLX model from the Ollama registry and use the MLX inference engine for faster performance.
- For hard or long-horizon tasks, enable Ollama Cloud (zero data retention, max context window) to scale beyond local compute, including parallel agents.
- When choosing a model, try several, benchmark them for your specific task (coding / personal agent / chat / classification), and watch for upcoming in-harness model recommendations.
- Consider unified-memory hardware (RTX Spark, AMD Strix Halo, up to 128 GB) to run larger models and longer context lengths locally.
- Check out the newly available Gemma 4 12B / Gemma 4 dense models on Ollama for agentic and full-context-length use.