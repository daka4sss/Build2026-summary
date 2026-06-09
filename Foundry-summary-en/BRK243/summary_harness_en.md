# BRK243 — Claws & the Agent Harness in Microsoft Foundry (Build 2026)
## Theme: The Agent Harness — from coding agents & claws to scaled enterprise agents

**Session**: Microsoft Build 2026, BRK243 — *"Claws and agent harness in Microsoft Foundry"* (Day 2 breakout)
**Speakers**: Sean Henry (Microsoft Foundry / Agent Framework lead, host), Glenn (Hermes demo), Amanda (Autopilot Agents / Teams & M365 publishing)
**Session URL**: https://build.microsoft.com/en-US/sessions/BRK243
**Focus of this write-up**: the **agent harness** — what it is, and the three concrete ways Foundry lets you ship one (off-the-shelf harness, custom harness, and getting the agent where users work).
**Sources**: official WebVTT transcript + Build 2026 primary sources (devblogs, Microsoft Learn, GitHub). Every status below was adversarially re-verified against primary docs; see Appendix.

---

## 1. Executive Summary

BRK243 reframes a year of agent progress into one organizing idea: the **agent harness** — *"the shell, the set of tools you put around your agent so it can perform longer, more complicated tasks."* Sean's analogy: if the model is the **motor**, the harness is the **car** (wheels, steering, seats) that makes the motor useful. The lesson of the session is that the harness/​"claw" techniques pioneered on coding agents (GitHub Copilot, Claude Code, Cursor) and on local "claw" agents (OpenClaw and its descendants) now generalize to **scaled enterprise applications**, and Foundry productizes every layer needed to run them.

Three demos map to three deployment paths:

1. **Off-the-shelf harness** — Glenn ran **Hermes** (a claw-style agent, *not* an OpenClaw fork) on **Foundry Hosted Agents**: a per-session VM sandbox, AG-UI proxy over the network, Azure default credential, a Work IQ MCP connector into SharePoint, and **agent-created Routines** that perform nightly maintenance/backup and let the sandbox scale to zero when idle.
2. **Custom harness in code** — Sean built one with the **Microsoft Agent Framework (MAF)**, which reached **1.0 GA on April 2, 2026**. MAF now exposes a first-class **agent harness** (`AsAgentHarness`/harness builder) with built-in tools, context compaction, planning, sub-agents, and middleware — plus a harness-console TUI and a one-line **AG-UI** endpoint via Copilot Kit, deployable to Foundry, Azure Functions/Container Apps, or anywhere.
3. **Meet users where they work** — Amanda showed **one-click Publish to Teams & M365 Copilot** from the Foundry portal, and introduced a **third agent category — Autopilot Agents** — which (unlike assistive and autonomous agents) own a **user account** (email alias, Teams messages, Word docs) and act on their own behalf. **Microsoft Scout** is the first out-of-box Autopilot agent; the **Workstream Manager** is a customizable code sample for Teams group chats.

**The status story** (the single most important nuance): the *framework* (MAF 1.0, its harness, providers, tools, middleware, Handoff orchestration, and the GitHub Copilot SDK integration) is **GA**. The *Foundry runtime around it* (Hosted Agents, Routines, Procedural Memory, source-code deploy, Autopilot publishing, Agent Optimizer) is largely **Public/Private Preview at Build**, with several items (Hosted Agents GA, Agent Optimizer public preview, hosted-agent tracing GA) explicitly **targeted for the 30 days after Build / later in June 2026**. CodeAct/Hyperlight is **alpha**.

---

## 2. Key Update (feature-level)

> Status legend: **GA** = generally available · **PuP** = Public Preview · **PrP** = Private Preview · **Alpha** = pre-preview · **Demo** = session demo, not a separately shipped product.

### 2.1 Microsoft Agent Framework — the harness, in code (GA)

| # | Feature | What's new at Build 2026 | Status |
|---|---------|--------------------------|--------|
| 1 | **Microsoft Agent Framework (MAF) 1.0** | AutoGen + Semantic Kernel converged into one supported, multi-language framework (Python + .NET parity); the foundation everything else builds on. | **GA** (Apr 2, 2026) |
| 2 | **Built-in harness providers** | `FileMemoryProvider` (session file memory), `FileAccessProvider`, `TodoProvider`, `AgentModeProvider` (plan vs. execute), `AgentSkillsProvider` (filesystem skill discovery), `BackgroundAgentsProvider` (parallel child agents) ship inside the GA harness. | **GA** (in MAF 1.0) |
| 3 | **Built-in harness tools** | Out-of-the-box hosted **web search** (disable via `DisableWebSearch`) and **shell execution** (.NET, sandboxed `ShellExecutor`) — the "give the agent a computer" pattern. | **GA** (in MAF 1.0) |
| 4 | **Harness middleware** | `ToolApprovalAgent` (human-in-the-loop), `OpenTelemetryAgent` (GenAI-spec tracing), pluggable storage backends, via the `.Use()`/`.AsBuilder()` pipeline. | **GA** (in MAF 1.0) |
| 5 | **Handoff orchestration pattern** | Multi-agent directed routing with framework-injected handoff tools, declarative topology, .NET + Python. | **GA** |
| 6 | **GitHub Copilot SDK integration** | Run MAF agents on the GitHub Copilot SDK backend (shell exec, file ops, MCP); graduated from preview to release. | **GA** |
| 7 | **CodeAct (`agent-framework-hyperlight`)** | Model writes one Python program calling tools via `call_tool(...)`, executed per-call in a **Hyperlight micro-VM**. Reported −52.4% latency, −63.9% tokens. Python only. | **Alpha** |
| 8 | **AG-UI endpoint (Copilot Kit)** | Expose any MAF agent as a streaming UI endpoint (`MapAGUI`, SSE, approval/state middleware); demoed via Copilot Kit. | **PuP** |

### 2.2 Foundry runtime — hosting the harness (mostly Preview)

| # | Feature | What's new at Build 2026 | Status |
|---|---------|--------------------------|--------|
| 9 | **Foundry Hosted Agents** | Framework-agnostic hosted runtime (MAF, GitHub Copilot SDK, LangGraph, custom code); per-session VM-isolated sandbox + durable filesystem; dedicated Entra identity & endpoint per agent; 20 regions. | **PuP** at Build → **GA targeted ≤30 days** (~early Jul 2026) |
| 10 | **Scale-to-zero + stateful resume** | 15-min idle timeout deprovisions compute but persists `$HOME` and `/files`; auto-restore on resume; 30-day inactivity hard-delete; default 50 concurrent sessions/sub/region. | **Preview** |
| 11 | **Invocations (WebSocket) protocol** | `invocations_ws` bidirectional protocol for real-time **voice** agents (pair w/ Pipecat, LiveKit, Voice Live). | **Preview** (North Central US only) |
| 12 | **A2A endpoint** | Expose any Foundry agent as an open **A2A** endpoint; Entra-authenticated, no anonymous access. | **PuP** |
| 13 | **Deploy from source code (zip)** | Deploy hosted agents from a source zip with `remote_build` vs `bundled` dependency modes (250 MB limit); preview feature header. | **Preview** |
| 14 | **Routines** | Named automations that trigger a Foundry agent on **cron** (5-min min) or **one-shot timer**; run history; **agents can create their own** (the BRK243 nightly-maintenance pattern). | **PuP** |
| 15 | **Procedural Memory** | Agents learn "how to do the work" across runs; reported **+7–14%** absolute success-rate gains at near-baseline cost. | **PuP** |
| 16 | **Tracing & evaluation for hosted agents** | One OpenTelemetry pipeline over model calls, tool calls, and sub-agent hops; Application Insights auto-injected. | **GA later in Jun 2026** |
| 17 | **Agent Optimizer** | Closed loop: evaluate an agent → generate & rank improved configs (Instruction / Skill / Model / Tool-descriptions) → deploy winner via `azd ai agent optimize`. | **PrP** at Build → **PuP ≤30 days** |

### 2.3 Enterprise distribution — agents where users work

| # | Feature | What's new at Build 2026 | Status |
|---|---------|--------------------------|--------|
| 18 | **Autopilot Agents (3rd agent type)** | After *assistive* and *autonomous*: an agent with its **own Entra identity + user account** (email, calendar, OneDrive, Teams) that acts on its own behalf. | **PuP** |
| 19 | **Microsoft Scout** | First out-of-box Autopilot agent; always-on, own governed Entra identity, **Work IQ** as context engine. | **PrP / experimental** (Frontier) |
| 20 | **Workstream Manager sample** | Customizable Autopilot **code sample** for Teams group chats: onboarding, `/access` control, open-item tracking, `/workstreamsummary`, history Q&A. | **PuP** (code sample) |
| 21 | **Auto Entra identity + Agent 365 registration** | Every Foundry agent automatically gets an Entra agent identity and appears in the Agent 365 registry on creation; Entra network controls & Conditional Access GA in Agent 365. | **GA** (core) / **Preview** (autopilot publish flow) |
| 22 | **Publish to Teams & M365 Copilot** | One-click publish from the Foundry portal: scope to self or submit to M365 Admin Center for org-wide approval; both Teams + Copilot UIs out-of-the-box. | **GA flow** (autopilot push via code sample) |
| — | **Hermes on Hosted Agents** (BRK243 demo) | Off-the-shelf claw-style harness on Foundry: sandbox, AG-UI proxy, Work IQ→SharePoint, agent-created maintenance Routines, scale-to-zero. | **Demo** |

---

## 3. Update detail

### 3.1 What an agent harness is — the conceptual spine

Sean's definition: an agent harness is **the shell of tools around an agent that lets it perform longer, more complicated tasks**. The components he enumerated map almost one-to-one onto what MAF and Foundry now ship:

| Harness component | What it does | Where it lands in the product |
|---|---|---|
| **Agent loop** | Context + tools → call LLM → execute requested tools → feed results back → loop to goal. The "motor." | MAF `AIAgent` / chat client |
| **Context management** | Keep the growing window contained, incl. **context compaction**. | MAF compaction (Learn: *conversations/compaction*) |
| **Skills & tools** | Text-based **skills** + tools over MCP/OpenAPI/code; especially "give the agent a computer" (file I/O, code, shell). | `AgentSkillsProvider`, built-in web-search & shell tools |
| **Multi-agent orchestration** | Coordinate specialists (browse, code, synthesize). | MAF workflows + **Handoff** pattern |
| **Memory & session persistence** | Remember across sessions → **runtime can stay stateless** → host anywhere for long-running work. | `FileMemoryProvider`; Foundry **Procedural Memory**; Hosted-agent durable state |
| **Lifecycle hooks** | Before/after agent, LLM, and tool calls — where you apply policy. | MAF agent pipeline / `.Use()` middleware |
| **Human-in-the-loop** | Ask a human before higher-risk actions (write files, run code). | `ToolApprovalAgent` / `approval_mode` / `ApprovalRequiredAIFunction` |

### 3.2 Microsoft Agent Framework 1.0 — building a custom harness

MAF is Microsoft's SDK for AI apps and agents in **Python and C# (feature parity)**. It went to **preview in October 2025** and reached **1.0 GA on April 2, 2026**, converging **AutoGen** and **Semantic Kernel** into one supported platform. (Current Python release at time of research: `python-1.8.0`, Jun 4 2026; .NET package `Microsoft.Agents.AI` on NuGet; experimental work isolated under "AF Labs.")

MAF is three layers:

- **Agent loop** — the `AIAgent` construct talks to Foundry models/tools and hosts in Foundry, but also connects to OpenAI, Anthropic, Gemini, Bedrock, or local models via Ollama, and to any tool over MCP/OpenAPI/code. Connectors abstract other agent providers: Foundry prompt agents, Copilot Studio, Claude Code, GitHub Copilot CLI, or anything over **A2A**.
- **Workflows** — built-in multi-agent constructs: sequential, **handoff** (context moves with control), author-critic, and **Magentic** (a Microsoft Research planner-with-sub-agents pattern). Plus full custom **directed** workflows, mixing agents with plain code, authorable in code or declaratively in **YAML**.
- **Agent harness** — the new top layer. Slap a harness onto any agent (`chatClient.AsAgentHarness()`), and it inherits built-in tools (file system, code/shell execution), context construction (prompts + skills + memory chained intelligently), planning, specialized sub-agents, and **extensive middleware** (context compaction, tool selection, permission policies).

**Built-in providers (GA):** `FileMemoryProvider`, `FileAccessProvider`, `TodoProvider`, `AgentModeProvider` (plan vs. execute), `AgentSkillsProvider` (discover skills from the filesystem), `BackgroundAgentsProvider` (delegate to parallel child agents).
**Built-in tools (GA):** hosted **web search** (toggle off with `DisableWebSearch`) and **shell execution** (.NET, via a sandboxed `ShellExecutor`).
**Middleware (GA):** `ToolApprovalAgent` for human-in-the-loop, `OpenTelemetryAgent` emitting the full GenAI-spec OpenTelemetry trace, and pluggable storage backends — all attached via the `.Use()`/`.AsBuilder()` agent pipeline.

In the demo Sean built a **research agent** (custom tools incl. web-page→markdown, reasoning-effort, file/memory locations, telemetry sink, background web-search sub-agent), drove it through a **harness-console TUI** (plan mode, to-do list, session export, human-in-the-loop prompts), then exposed the same agent over an **AG-UI** endpoint in ~one line (`MapAGUI`) consumed by a **Copilot Kit** front-end (which rendered charts "for free"). Finally he deployed it to Foundry via a **responses endpoint** and the **Agent Inspector** in the Foundry Toolkit. Deploy targets include Foundry hosting, Azure Functions, Azure Container Apps, and (if you must) AWS.

> **Status nuance — AG-UI:** the Build announce roundup didn't headline AG-UI, but the Agent Framework Integrations index lists **AG-UI = Preview** (package `Microsoft.Agents.AI.Hosting.AGUI.AspNetCore` is a `-preview` build). On Hosted Agents, AG-UI is served via the **Invocations** protocol (raw SSE) because it is not OpenAI-compatible.

### 3.3 CodeAct + Hyperlight — execution as one program (Alpha)

A new execution mode where the model writes a **single Python program** that calls tools via `call_tool(...)`, run inside a fresh, locally isolated **Hyperlight micro-VM per call**. It ships in the new `agent-framework-hyperlight` (**alpha**, Python-only, `--pre`/`--prerelease` install) and reports a **52.4% latency reduction** (27.81s→13.23s) and **63.9% token reduction** (6,890→2,489) on a representative workload. Treat as pre-preview, not yet in the main GitHub README.

### 3.4 Foundry Hosted Agents — the runtime (Public Preview → GA in ~30 days)

The runtime path Glenn's Hermes demo relied on. **Framework-agnostic** (MAF, GitHub Copilot SDK, LangGraph, or custom code). Key mechanics from the Learn concept doc:

- **Per-session sandbox** — each session runs in its own **VM-isolated** sandbox with dedicated compute/memory and a durable filesystem (`$HOME` + files uploaded via `/files`). Sizes 0.5 / 1 / 2 vCPU; up to **20 GiB** session disk (~20% reserved).
- **Scale-to-zero with stateful resume** — **15-minute idle timeout** deprovisions compute while persisting session state; state auto-restores when the same session ID is referenced. Sessions hard-delete after **30 days** of inactivity. Default **50** concurrent active sessions per subscription per region (raise via support). *This is exactly the "always available but not always paid for" model Glenn engineered, and the ~15-min/~30-day numbers he cited.*
- **Identity & endpoints** — each agent gets a dedicated **Entra agent identity** and endpoint at deploy time.
- **Protocols** — **Responses** (OpenAI-compatible) and **Invocations** (schema-free) in all regions; **Invocations (WebSocket)** `invocations_ws` for real-time voice in **preview, North Central US only**; **A2A** incoming endpoint (`…/endpoint/protocols/a2a`) in **public preview**, Entra-authenticated; plus **Activity** (Teams/M365).
- **Deploy from source code (zip)** — push a source zip (250 MB) with `remote_build` vs `bundled` dependency modes, gated by `Foundry-Features: CodeAgents=V1Preview,HostedAgents=V1Preview`. Private ACR in a BYO vnet is on the road to GA.

**Status:** the Learn doc still says *"Hosted agents are currently in preview,"* while the Build 2026 agent-service blog says they are *"reaching general availability in the next 30 days."*

### 3.5 Routines, Procedural Memory, Tracing — the operational layer

- **Routines (Public Preview)** — the "new… in preview" feature Glenn pointed at. Two trigger types: **schedule** (5-field cron, 5-min minimum) and **timer** (one-shot, ISO 8601 / `30m`/`2h`). Two actions: `invoke_agent_responses_api`, `invoke_agent_invocations_api`. Preview limits: one trigger + one action per routine, no event triggers, 8 regions, 3 retries (30s per-attempt timeout). Agents bound to routines must have a configured agent identity (prompt-only agents are rejected). Crucially, **agents can create routines for themselves** — which is why Glenn's maintenance routines had auto-generated names and ran nightly curation/backup.
- **Procedural Memory (Public Preview)** — agents accumulate *how-to* knowledge across runs (+7–14% success at near-baseline cost), complementing session/user memory and underpinning the stateless-runtime + durable-state design.
- **Tracing & evaluation for hosted agents (GA later in June 2026)** — a single OpenTelemetry pipeline across model calls, tool calls, and sub-agent hops; Application Insights connection string auto-injected and protocol libraries emit OTel by default.

### 3.6 Agent Optimizer — closing the eval loop (Private → Public Preview in ~30 days)

A closed-loop optimizer for Foundry Agent Service: it **evaluates** a hosted agent, **generates and ranks improved configurations**, and **deploys the winner** via `azd`. Four optimization targets: **Instruction** (rewrite system prompts), **Skill** (generate reusable playbooks), **Model** (compare deployments for quality/cost), and **Tool Descriptions** (improve function-calling). CLI: `azd ai agent optimize`, `azd ai agent optimize apply --candidate [ID]`, `azd ai agent eval init/run`. Runs complete in minutes with no extra infra. At Build it was **private preview** (`aka.ms/Agent-Optimizer-Private-Preview`) with **public preview targeted within 30 days**.

### 3.7 Enterprise distribution — getting agents where users work (Amanda's segment)

**One-click Publish to Teams & M365 Copilot.** From the Foundry portal, once an agent is deployed: a single **Publish to Teams and M365 Copilot** drop-down → name the agent and fill end-user-facing details → choose **scope to self** (instant) or **submit to the M365 Admin Center** for org-wide approval (also "download and customize"). One publish yields **both** Teams and Copilot UIs out-of-the-box.

**Three agent types — the key conceptual update:**

| Type | Acts as | Can do |
|---|---|---|
| **Assistive** | An extension of *you* | Personal-productivity tasks via Work IQ tools (send email/Teams on your behalf) |
| **Autonomous** | Itself, in the background | Triggered by non-human events; can hold permissions on Azure resources — **but cannot** use the user-context Work IQ actions |
| **Autopilot** *(new)* | **Itself, with a real user account** | Has its own Entra identity **+ user account**: email alias, send Teams messages, create Word docs — i.e. *any* action that normally requires a user account |

**Autopilot Agents (Public Preview)** close the gap: they always act on their own behalf *and* have a user account, so they can collaborate in shared spaces. The create→approve→hire flow (push Foundry hosted agent to Agent 365 → approve in M365 Admin Center → others "hire" it) currently has **no UI** and is done via the **FoundryA365** C# code sample (prereqs: M365 E7, .NET 9, Docker, `azd`). Per the integration matrix, **Prompt** and **Hosted** agent types support autopilot publishing; **Workflow** agents do not. Every Foundry agent already auto-registers in the **Agent 365** registry with an Entra identity (Entra network controls + Conditional Access are **GA** in Agent 365).

**Microsoft Scout** is the first out-of-box Autopilot agent — always-on, own governed Entra identity, **Work IQ** as the context engine — available as a **private/experimental** release through the Frontier program (Work IQ APIs themselves GA Jun 16, 2026).

**Workstream Manager** is the customizable Autopilot **code sample** (public preview) demoed by Amanda: designed to live in **Teams group chats**, with manager onboarding (who may talk to it), `/access add|remove|list` control, 📌 open-item tracking with emoji reactions, `/workstreamsummary run` digests, Q&A from conversation history, built-in Work IQ tools, and context-aware group-chat replies (it deliberately does *not* answer every message). Pre-wired to Word, Excel, Outlook, SharePoint.

### 3.8 Hermes on Foundry Hosted Agents — the off-the-shelf demo (recap)

Glenn's demo combined the shipped components above into a "claw-style" experience. Hermes has the qualities of claws (memory, owns its environment, tools, autonomy, long-running, a comms channel, plus a "collective wisdom / constant self-improvement" layer) but is **not an OpenClaw fork**. The setup: a local **Hermes TUI** connected over an **AG-UI proxy** to a Hermes instance on **Foundry Hosted Agents**; **`DefaultAzureCredential`** for auth; a **Work IQ MCP** connector reaching **SharePoint**; a **session-ID-scoped filesystem** (change the session ID → brand-new VM/filesystem from the snapshot); **idle shutdown** so you "always have Hermes but don't pay for it always"; and **agent-created Routines** doing nightly skill-curation, stale-skill deletion, and blob-storage backup. His architectural point — *state creates uniqueness, and uniqueness is painful to recover* — is why he externalized maintenance to Routines and relied on the ~30-day sandbox retention plus nightly backup. (Hermes itself is a proof-of-concept demo artifact, not a shipped GA/preview product; its underlying capabilities are the Hosted Agents + Routines rows above.)

---

## 4. Appendix — all sources

### 4.1 Provided / primary blogs (Build 2026)
- **Microsoft Agent Framework at Build 2026 (announce roundup)** — https://devblogs.microsoft.com/agent-framework/microsoft-agent-framework-at-build-2026-announce/
- **The agent harness in Agent Framework (deep dive)** — https://devblogs.microsoft.com/agent-framework/agent-harness-in-agent-framework/
- **Build AI agents with GitHub Copilot SDK and Microsoft Agent Framework** — https://devblogs.microsoft.com/agent-framework/build-ai-agents-with-github-copilot-sdk-and-microsoft-agent-framework/
- **Introducing Agent Optimizer in Foundry Agent Service (Build 2026)** — https://devblogs.microsoft.com/foundry/agent-optimizer-build2026/
- **From building agents to working with them — enterprise agent distribution in Microsoft Foundry** — https://devblogs.microsoft.com/foundry/from-building-agents-to-working-with-them-enterprise-agent-distribution-in-microsoft-foundry/
- **Build and run agents at scale with Microsoft Foundry at Build 2026** — https://devblogs.microsoft.com/foundry/agent-service-build2026/
- **What's New in Hosted Agents in Foundry Agent Service (Build 2026)** — https://devblogs.microsoft.com/foundry/hosted-agents-build26/
- **Microsoft Build 2026: Be yourself at work (keynote; introduces Scout)** — https://blogs.microsoft.com/blog/2026/06/02/microsoft-build-2026-be-yourself-at-work/

### 4.2 Microsoft Learn (primary docs)
- **What are hosted agents? (preview)** — https://learn.microsoft.com/azure/foundry/agents/concepts/hosted-agents
- **Deploy a hosted agent from source code (preview)** — https://learn.microsoft.com/azure/foundry/agents/how-to/deploy-hosted-agent-code
- **Automate agents with routines (preview)** — https://learn.microsoft.com/azure/foundry/agents/how-to/use-routines
- **What is the agent optimizer? (preview)** — https://learn.microsoft.com/azure/foundry/agents/concepts/agent-optimizer-overview
- **Publish agents from Foundry to M365 Copilot/Teams** — https://learn.microsoft.com/azure/foundry/agents/how-to/publish-copilot
- **Foundry agents in Microsoft Agent 365 (autopilot create/approve/hire)** — https://learn.microsoft.com/azure/foundry/agents/how-to/agent-365
- **AG-UI integration (Agent Framework)** — https://learn.microsoft.com/en-us/agent-framework/integrations/ag-ui/
- **Context compaction reference (Agent Framework)** — https://learn.microsoft.com/en-us/agent-framework/agents/conversations/compaction
- **Agent pipeline / middleware architecture (Agent Framework)** — https://learn.microsoft.com/en-us/agent-framework/agents/agent-pipeline

### 4.3 GitHub
- **Microsoft Agent Framework (Python + .NET source/samples)** — https://github.com/microsoft/agent-framework
- **FoundryA365 autopilot agent C# sample** — https://github.com/microsoft-foundry/foundry-samples/tree/main/samples/csharp/foundry-autopilot-agent

### 4.4 Session
- **BRK243 — Claws and agent harness in Microsoft Foundry** — https://build.microsoft.com/en-US/sessions/BRK243 (transcript: `build-transcripts/Sessions/BRK243/transcript_clean.txt`)

### 4.5 Verification note
This summary was produced by fanning out web/Learn/GitHub research and **adversarially verifying** every feature claim (3 independent refutation attempts per claim; a claim is dropped only if ≥2 of 3 refute). 22 of 25 candidate features survived. The most material corrections applied above vs. first-pass extraction: **AG-UI** status corrected to **Preview** (not "unclear"); **Scout** corrected to **private/experimental (Frontier)**; and the consistent **GA-framework vs. Preview-runtime** split is called out throughout. Reported CodeAct benchmarks and the +7–14% Procedural-Memory figure are Microsoft's own published numbers.
