# Microsoft Build 2026 — Microsoft Foundry Core Sessions (English Index & Overview)

**Scope:** 12 **Microsoft Build 2026** sessions (June 2026, San Francisco) on Microsoft Foundry and the broader model/runtime ecosystem that together tell the end-to-end story of building, shipping, governing, and proving the value of enterprise AI agents — plus open/local model execution.
**Compiled:** 2026-06-06
**Source:** Each summary is grounded in the session's official WebVTT transcript (medius.microsoft.com CAPTION route), cross-checked against `transcript_raw.vtt` for accurate timestamps.
**Format:** Every per-session summary follows the same structure — Speakers → Overview → numbered timestamped sections → Summary (core messages + announced-features table + next actions).

---

## The Big Picture

Build 2026's Foundry narrative is the maturation of agentic AI from "pick a model and ship" into a **full production operating system for agents**. Across these 11 sessions a single, coherent lifecycle emerges:

> **Select models → Ground them in context → Build & deploy agents → Connect tools/data → Observe, govern, and prove ROI → Continuously learn (post-train) and improve.**

Four themes recur in nearly every session:

1. **Eval-first, hill-climbing discipline.** Evaluations are treated not as last-mile QA but as a *product specification and IP*. You define success criteria first, measure continuously, and improve the whole system against them (BRK230, BRK252, BRK250).
2. **Task decomposition over monolithic models.** A "microservices" mindset — route each task to the right-sized model, distill/fine-tune small models to frontier quality at ~10x lower cost (BRK230, BRK231, BRK232).
3. **Context is the bottleneck, not raw model power.** Agents fail from missing enterprise knowledge; Microsoft IQ / Foundry IQ supply Work, Web, Fabric, and Foundry context with secure agentic retrieval (BRK240, BRK246, BRK242).
4. **Any-framework openness + enterprise governance.** Open-source specs and OpenTelemetry-based tracing make agents observable and controllable regardless of framework, while Agent 365 brings identity, security, and admin control (BRK250, BRK251, BRK252, BRK243, BRK241).

---

## Sessions by Theme

### A. Models, Runtimes, Cost & Post-Training
The economic and quality engine room — selecting, routing, distilling, reinforcement-tuning, and locally running models.

- **BRK230** — Build smarter AI systems in Foundry as models and costs evolve
- **BRK232** — Post-Training and Deploying Open Source Reasoning Models in Foundry
- **BRK231** — Deploy. Observe. Learn. Reinforcement learning for production agents
- **BRK235** — Local models, developer control, and the future of AI runtimes (Ollama; open/local + hybrid execution)

### B. Building Agents: Context, Tools & Scale
Turning models into agents that have the right knowledge, the right tools, and a path to production.

- **BRK240** — Build context-aware agents: From data to decisions
- **BRK246** — Foundry IQ: Fuel agents with enterprise knowledge and agentic retrieval
- **BRK242** — Turn your agents into action: Connect tools, APIs, and documents
- **BRK241** — From prototype to production: build and run agents at scale
- **BRK243** — Claw and agent harness in Microsoft Foundry

### C. Observe, Govern & Prove Value
Making agents trustworthy, controllable, secure, and ROI-accountable in the enterprise.

- **BRK250** — Observe and control agents across any framework with open source tools
- **BRK252** — From observability to ROI for AI agents on any framework
- **BRK251** — Build secure and enterprise-ready agents with Agent 365

---

## Session Index

| ID | Title | Speakers | What it covers | Summary |
|----|-------|----------|----------------|---------|
| BRK230 | Build smarter AI systems in Foundry as models and costs evolve | Yina Arenas, Naomi Moneypenny | Four-phase (Select / Evaluate / Optimize / Scale) method: define evals first, then hill-climb across model selection, cost, latency, and quality instead of chasing single models. | [summary](BRK230/summary_en.md) |
| BRK232 | Post-Training and Deploying Open Source Reasoning Models in Foundry | Chris, Vijay, Manoj | Distillation + SFT + RFT to lift a small cheap model (Qwen 14B) to frontier (GPT-5.2) quality at ~10x lower cost, then deploy it as an agent in a continuous loop. | [summary](BRK232/summary_en.md) |
| BRK231 | Deploy. Observe. Learn. Reinforcement learning for production agents | Alicia Frame, Omkar More | Four demos of Foundry post-training (distillation/SFT, RFT with live tools, low-level training API, NL fine-tuning skill) to keep token-hungry agents economically viable while keeping IP in your own weights. | [summary](BRK231/summary_en.md) |
| BRK235 | Local models, developer control, and the future of AI runtimes | Michael (Ollama), Parth (Ollama) | Ollama's founders argue open models have reached a practical phase for agents, demoing hybrid local/cloud execution that keeps sensitive data on-device while using close-to-frontier cloud intelligence for hard tasks. | [summary](BRK235/summary_en.md) |
| BRK240 | Build context-aware agents: From data to decisions | Amanda Silver, Marco Casalaina | Introduces **Microsoft IQ** — a unified context layer (Work, Web, Foundry, Fabric IQ) — arguing agents fail from missing context, demoed via a refund agent grounded across all four IQs (through a live network outage). | [summary](BRK240/summary_en.md) |
| BRK246 | Foundry IQ: Fuel agents with enterprise knowledge and agentic retrieval | Pablo | Live tour of Foundry IQ: start easy (files → auto-generated MCP server in a minute), scale up via serverless provisioning, multi-source knowledge, bottom-of-stack security, and second-generation agentic retrieval. | [summary](BRK246/summary_en.md) |
| BRK242 | Turn your agents into action: Connect tools, APIs, and documents | Maria Nagaga, Joe Flick | **Toolbox** bundles tools of any type behind one governed MCP-compatible endpoint with token-saving Tool Search; **Content Understanding** turns messy multimodal docs into clean, grounded, agent-ready context. | [summary](BRK242/summary_en.md) |
| BRK241 | From prototype to production: build and run agents at scale | Tina Schackman, Jeff Holland | Live demo running an "Autonomous Fiber Outage Response Agent" through Build → Deploy → Operate, positioning Foundry as the end-to-end OS for running enterprise agents reliably at scale. | [summary](BRK241/summary_en.md) |
| BRK243 | Claw and agent harness in Microsoft Foundry | Sean Henry, Glenn, Amanda | Three paths to the agent-harness pattern: run Hermes on Foundry Hosted Agents, build a custom harness with the Microsoft Agent Framework, and one-click publish to Teams/M365 Copilot via Autopilot Agents. | [summary](BRK243/summary_en.md) |
| BRK250 | Observe and control agents across any framework with open source tools | Sarah Bird, Sandeep Atluri | A Responsible-AI identify → evaluate → control → monitor cycle, arguing app-specific evals plus framework-independent deterministic guardrails (not prompting) are what make agents trustworthy. | [summary](BRK250/summary_en.md) |
| BRK252 | From observability to ROI for AI agents on any framework | Sebastian, Felicia, Vivek | Foundry Observability across the full agent DevOps inner/outer loop: any-framework tracing, trace-grounded evaluation, automated optimization, and ROI tracking for non-deterministic agents. | [summary](BRK252/summary_en.md) |
| BRK251 | Build secure and enterprise-ready agents with Agent 365 | Neda, Kendra, Aarthi, Ray (Genspark) | Introduces **Agent 365**, a control plane making any agent (native, partner, custom, or external like Bedrock/Vertex) observed, governed, and secured via an SDK and the M365 Admin Center. | [summary](BRK251/summary_en.md) |

> Speaker surnames are listed where the transcript's self-introductions made them identifiable; some sessions only stated first names.

---

## Announcement Highlights by Session

- **BRK230** — Claude on Azure (GB300); Microsoft AI first-party models incl. Image 2.5; NVIDIA Nemotron/Cosmos/Earth-2; Aurora 1.5; Foundry Labs; model-router governance policies; **Rubric-based Evaluators**; **Azure Context Cache / Explicit Prompt Caching** (Private Preview); **Serverless RL API**; **Fireworks AI on Foundry** (GA).
- **BRK232** — **Foundry Managed Compute** (serverless GPU hosting, BYOW, custom containers); code-first Ray-based SFT/RFT with rollout visualization (Private Preview); low-level GPU API "Loom" (Private Preview); Responses API support for fine-tuned models.
- **BRK231** — **Data Zone SKU** (US data residency); **Interactive Training API** / "PyTorch as a service" (Preview); NL **fine-tuning skill** (GitHub Copilot for Azure / standalone).
- **BRK235** — `ollama launch` (inject open models into Claude Code / Copilot CLI / Codex / Droid / π / Open Claw / Hermes); **Ollama Cloud** (zero data retention, parallel agents); Ollama's own **MLX inference engine** (NVFP4); **Gemma 4 12B** available on Ollama; planned in-harness model recommendations.
- **BRK240** — **Microsoft IQ** (Work IQ, Web IQ, Foundry IQ, Fabric IQ); **Foundry IQ serverless developer tier** (new); Fabric IQ ontology auto-generation; Fabric Data Agent; agent templates / agent identity (Foundry-to-M365 blueprint).
- **BRK246** — **Serverless Foundry IQ** (Public Preview); **Web IQ** web grounding via MCP (Public Preview); automatic MCP server per knowledge base; **second-generation Agentic Retrieval**; Azure Content Understanding integration; Entra document-level security + Purview sensitivity labels.
- **BRK242** — **Toolbox**; **Tool Search**; unified MCP-compatible endpoint; **Browser Automation** (GA); **Content Understanding** (GA); Agentic Extraction, section-boundary classification, knowledge-sources extraction training, cost-reduced prebuilt analyzers (July); GPT-5 family extraction/classification engine.
- **BRK241** — **Microsoft Agent Framework 1.0** with Agent Harness (GA); **Foundry Toolkit for VS Code** (GA); **Voice Live** (GA); Hosted Agents (GA soon); Foundry Toolbox with Tool Search (GA soon); Tracing & Evaluation incl. Trace Replay View; Publish to Teams/M365 Copilot; **Routines**, Autopilot Agents, Rubric custom eval, Procedural Memory (Public Preview); Agent Optimizer (Private Preview).
- **BRK243** — **Microsoft Agent Framework v1.0** (GA); `AsAgentHarness()` API; **Routines** for Hosted Agents (Preview); AGUI/CopilotKit support; **Autopilot Agents**; Publish to Teams & M365 Copilot; Workstream Manager Agent sample; Foundry Toolkit Agent Inspector.
- **BRK250** — **ASSERT** (open-source eval generation); **ACS / Agent Control Specification** (open-source guardrail spec, new AGT module); Foundry continuous evaluation & agent optimizer; RL-based continuous-evaluation attacker (research); C2PA watermarking/signing; information flow control; Social Reasoning Bench.
- **BRK252** — **Rubric Evaluator**, **Multi-Turn Evaluation**, **User Simulation**, any-framework observability (Public Preview); Foundry Toolkit/MCP/Skill code-first observability; Traces-to-Data-Sets; **Agent Optimizer** & **Agent ROI** (Private Preview); OpenTelemetry memory semantics.
- **BRK251** — **Agent 365 SDK** (Python/Node.js); Agent 365 coding-agent skills; Agent Blueprint; Agent Identity (Entra-based); Work IQ MCP servers / Tools gateway; Registry Sync; Templates; Rules; shadow-AI detection expansion (22+ platforms via Defender); multi-tenant management.

---

## Folder Structure

```
Foundry-summary-en/
├── _index_foundry_en.md      # This file — English index & overview
└── {SESSION_ID}/
    └── summary_en.md         # Detailed English summary (same format as the Japanese summary_ja.md)
```

The source transcripts (`transcript_raw.vtt`, `transcript_clean.txt`) and the original Japanese summaries (`summary_ja.md`) live alongside each session under `../build-transcripts/{SESSION_ID}/`.
