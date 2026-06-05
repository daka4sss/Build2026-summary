# Microsoft Build 2026 BRK241 "From prototype to production: build and run agents at scale" — Detailed Summary

**Speakers**: Tina Schackman (Corporate Vice President, Microsoft Foundry), Jeff Holland (Partner Director, Foundry agent platform)
**Session URL**: https://build.microsoft.com/en-US/sessions/BRK241
**Source**: Official WebVTT transcript (medius.microsoft.com CAPTION)

---

## Overview

This session walks through the full agent development lifecycle — "from prototype to production" — across roughly 45 minutes of mostly live demo. It demonstrates three phases end to end: the Build phase (local development), the Deploy phase (hosting in Foundry Agent Service), and the Operate phase (observability, evaluation, and autonomous self-improvement). The core thesis is that Microsoft Foundry is not merely a build platform but "the operating system for your enterprise AI transformation."

At the top, Tina framed the "new era of AI agents" with three shifts. (1) Building is no longer the hard part — with coding agents such as GitHub Copilot, GitHub Copilot CLI, and Claude Code, any developer can stand up a powerful agent within minutes; the question has shifted from "can I build it?" to "can I run it reliably at enterprise scale?" (2) Agents' capabilities have exploded — they are no longer static routers shuffling requests between a fixed set of tools, but general-purpose systems that can spawn new agents with full access to their compute environment, create new skills, and generate new memory. (3) Agents are teammates, not tools — they take on significant business outcomes and do whatever is needed to get them done, chatting not only with people but also with other agents. Businesses that win don't just build one super-powerful agent; they put AI at the core of every function with a coordinated system of long-running agents. Tina stressed that AI systems are never done: they run on production learning loops, and the system compounds the more it runs, tuning models, harness, context, and memory — all with the developer in control of every single change.

The demo scenario was an "Autonomous Fiber Outage Response Agent." Microsoft runs the world's largest cloud infrastructure, and sometimes a fiber cable gets cut near a data center. A sensor detects the outage and triggers the agent; the agent wakes up, looks up information through Foundry Toolbox — worksite reliability and location data via Fabric IQ, supplier conversation history via Work IQ, work orders and supplier agreements from PDF documents via document intelligence / content understanding — then dispatches a field rep, files a ticket in Dynamics 365 (D365), and publishes the latest status to Teams. Tina noted Microsoft's own Azure networking operations team runs a similar agentic system in real life, so the scenario is grounded in reality.

---

## 1. Demo scenario and the developer's challenges (00:00)

Tina set the stage by explaining the three shifts of the agent era, then outlined the architecture of the fiber outage response agent. The processing flow the agent performs:

- Sensor → trigger that wakes the agent
- Access to tools via Foundry Toolbox
- Fabric IQ: query worksite uptime/reliability and location information
- Work IQ: query supplier conversation history
- Document intelligence / Content Understanding: convert PDF work orders and contracts into an AI-readable format for reference
- Dispatch a field rep to respond to the incident
- File a ticket to be tracked in Dynamics 365 (D365)
- Publish the latest real-time status into Teams

Jeff took over and announced he would run the demo through three developer phases — Build, Deploy, and Operate — as a continuous learning and improvement loop. He hit a hiccup when his own screen was projected instead of the planned slide, and handled it with humor: "Visualize this slide in your mind. Our marketing team made a great one." He summarized the build-phase challenges verbally: how do I choose the right framework, the right model, and how do I make sure my agent has access to the right context — all the knowledge in the organization — integrated, secured with the right identity, and ready to run in natural interfaces (chat or voice)? He emphasized that many of these pieces already exist in the ecosystem, but Foundry's goal is to bring them all together in a single platform so developers don't have to jump between many different tools.

---

## 2. Build phase — local agent development (00:06–00:18)

### Choosing the development environment

Jeff introduced **Visual Studio Code + GitHub Copilot** as his "personal favorite combo," while emphasizing that Foundry works with any tool — Claude Code, GitHub Copilot CLI, Cursor, Visual Studio, and others.

### Foundry Toolkit for VS Code (GA)

The **Foundry Toolkit extension** for VS Code is now **generally available (GA)** (08:32). The extension brings the pieces needed for the entire flow into the editor without ever leaving it:

- Creating agents
- Tracing and observability
- Evaluations (Evals)
- Model management

To create a new agent, Jeff showed two options — start from a sample, or his preference: "Generate with Copilot." He generated a field-operations agent from a natural-language prompt ("help me create an agent that can act with our field operations team... make sure they have the right information, whether from Work IQ, Fabric IQ, or Foundry IQ"). A download pop-up for the extension/model appeared mid-generation, and Jeff quipped "this is as live as it gets" while letting it proceed. He highlighted that the extension automatically integrates Foundry best practices: it bakes in a set of skills out of the box, and while you can install those skills standalone into your coding agent, the extension wires them into the workload automatically so the generated agent follows the right best practices.

### Microsoft Agent Framework 1.0 (GA)

The generated code uses the **Microsoft Agent Framework** (in Python). Key points:

- Phenomenal at multi-step and multi-agent workflows
- **New capability: the harness** inside Agent Framework — a secure environment that lets the agent execute shell commands and read, write, and execute code, all managed by the harness
- The **GitHub Copilot SDK** and **Claude Agent SDK** can be plugged in as additional harnesses
- Agents are no longer limited to executing predefined, preconfigured tools; they can dynamically perform investigations, code writing, and code authoring along the way

### Foundry Toolbox (GA soon)

The central tool-management feature, **Foundry Toolbox**, was demonstrated from within VS Code — "if there's one feature I want you to remember when it comes to tools, it is Foundry Toolbox" (11:33):

- Configure, for a single agent or a collection of agents, the set of tools needed for the task
- A single spot to manage them all, handling authentication across integrations
- Integrations shown: Foundry IQ (indexed documents such as supplier contracts and supplier agreements), Web IQ and web search, Fabric IQ (site reliability/uptime data surfaced through Microsoft Fabric), Work IQ (history and access to tools from Teams and Outlook via the Microsoft Graph)
- **Guardrails** can be set — e.g., configure so that personally identifiable information (PII) does not leak from any of these tools
- **Tool Search feature**: because not every tool is relevant for every task, turning on tool search means that when the agent talks to Toolbox through its single **MCP-compatible endpoint**, only the tools relevant to that specific task are returned — optimizing context utilization and the context window and keeping the agent focused on its most immediate needs
- **Content Understanding tool** (one of thousands of available tools): uses a specialized model to convert a PDF document — a contract, a specification, etc. — that has tabular data and is not very agent-readable into an agent/AI-readable format, extracting tables, markdown, figures, or even raw JSON. (Jeff noted a dedicated Content Understanding session the next day.)

### Local debugging (F5 debug)

Jeff demonstrated the "magical gesture" of **F5 debug** (14:21): the agent spins up locally on localhost and connects to Toolbox via a single MCP-compatible endpoint — he showed how simple the integration line is. He set a breakpoint ahead of time; when he asked the local agent, on-site, about downtime and the right connection type to use, the breakpoint was hit and he could inspect the request and response, seeing the events streaming in and out of the agent — all inside VS Code, "my home the entire time."

### Enabling voice mode (one click)

Motivated by a practical concern — a contractor repairing a site is wearing leather work gloves, so a glove-driven chat interface "is not a good experience" — Jeff demonstrated making the agent voice-enabled. He first deployed the agent into Foundry (taking the code he ran locally and deploying it into his Foundry account), then switched to a pre-deployed version. Making it voice-enabled was a single click: "Here's the magic voice mode. Done." (16:26) Foundry automatically wraps industry-leading voice models, which can be specialized/selected if desired. He then spoke to the agent: "Hey, can you pull up the fiber termination spec for the Quincy N site and tell me which connector I should use on the B side panel?" The agent reached into the tools, iterated through Toolbox with little status updates, and answered in real time — "B side panel connector family: LC/UPC duplex required on B side panel." Responses streamed back in real time over an open **WebSocket** voice connection.

### Build-phase feature status recap (Tina)

Tina recapped the features Jeff showed: Microsoft Agent Framework is now version 1.0, production ready, with a built-in harness well integrated with skills, memory, and middleware, plus plug-in integrations for the GitHub Copilot SDK and Claude Agent SDK. Foundry Toolkit for VS Code is generally available. Toolbox in Foundry is generally available soon, providing one single managed endpoint for all the tools that make agents powerful, with the right governance and policy in place; skills are now a first-class integration with Toolbox. Voice Live integration with Foundry Agent Service is generally available today for prompt agents and in public preview for hosted agents. And — "super excited to announce" — Hosted Agents in Foundry Agent Service is generally available soon: process-level sandbox isolation, sub-second cold start, zero idle-time cost, framework agnostic, now even supporting long-running autonomous agents such as Open Claw and Hermes agents, all with durable state execution and file system access.

---

## 3. Deploy phase — Hosted Agents and long-running execution (00:18–00:27)

Jeff moved to the Deploy phase, framing the next set of challenges: the agents truly transforming how we work are not just reactive — they are long-running, maintaining and building context over time, accomplishing tasks that might take days or even weeks. He needs to do this securely (these agents, with the agent harness, may be reading and writing code, so instances must be isolated from each other), get them in front of users through the interfaces they care about (without making everyone add ten new browser bookmarks), and make each agent feel more like a proactive teammate.

He switched to a different flavor of the agent on his laptop — **Phibe (Fibe)**, a "Claude-like" agent that monitors networking telemetry and uptime over time (21:08).

### Routines (Public Preview)

**Routines** is the new Foundry feature that makes agents proactive instead of reactive:

- Set up events that proactively wake the agent on different tasks
- Jeff configured a simple **heartbeat**: "every hour, wake up, check the investigation log, see if there are any anomalies; if there are, follow the skills you have to alert the right person and issue the right subcontractor"
- The Azure networking team does this in real life — when an incident affects networking, an agent can automatically act, wait for human approval as necessary, and get someone on site to repair it
- Over the prior period, the routine had been firing off a number of runs on its own

### Hosted Agents — session isolation (GA soon)

For long-running agents, security is critical. Jeff posed the problem: imagine subcontractor A and subcontractor B both interacting with Fibe; if Fibe reads and writes files containing subcontractor A's sensitive data and saves them locally, subcontractor B's agent could get creative and pull those files — leaking context and code-execution state, "a nightmare." The new **hosted agent capability** (GA soon) solves this: every conversation and every routine can kick off its own dedicated, isolated workspace session, so everything the agent does happens separately from every other conversation, while still keeping durable, persistent state (23:23).

### Durable Task Scheduler integration

Jeff opened a session that had been idle since 11:00 AM and inspected the file-system state captured when it went idle — the agent had written a number of breadcrumb files (anomaly analysis, vendor contact, investigation records), "just like a Claude-like agent on my machine, but now doing so securely in the cloud." Key points:

- While idle, "I'm not paying any money"; when the agent needs to wake again, the session resumes and all state (the investigation files) is handed back to the agent to continue its work
- He extended the out-of-the-box sessions with the **Durable Task Scheduler** (via the Microsoft Agent Framework extension for Durable Task), allowing him to monitor state even when all sessions are idle
- Example: Fibe found something and needed human approval, sitting two or three hours waiting for approval, all sessions idle but Durable Task tracking the instance waiting for approval. Everything runs serverlessly. When Jeff clicked **Approve**, Durable Task got the approval and resumed the session; refreshing the Foundry session view showed the session woke back up with all prior investigation files restored and continued the work — long-running, secure management at scale with human intervention, without rehydrating/restarting state every time

### Publishing to Teams / Microsoft 365 Copilot

- Any agent Jeff built can be made available to the entire team and published easily to **Teams and Microsoft 365 Copilot** (26:15) — the option walks through the deployment steps
- He switched to an already-deployed version running as an autonomous agent in Teams, with its own identity and even its own email address — `fibe@notareal.co`
- He asked Fibe, "what are some of the active incidents that you're working on right now?" — the same agent running inside Foundry either resumed his session or started a new one and did the work required to come back with a status update

### Deploy-phase feature status recap (Tina)

Tina recapped: Routines in Foundry Agent Service is in public preview — the developer decides what needs to happen, and Foundry queues, executes, and tracks every run, turning reactive one-off tasks into proactive continuous agents. Publishing to Microsoft 365 Teams and Copilot is generally available soon — identity, policy, and permissions all flow through automatically. In addition, developers can now publish Foundry agents as **Autopilot agents** into Teams, in public preview — these agents can take on their own IDs, email addresses, and even Teams presence, so they can initiate a conversation or follow up on action items, all governed end to end in **Agent 365**.

---

## 4. Operate phase — observability and the self-improvement loop (00:28–00:38)

Tina handed off to the "hard part": Operate — making sure the agent runs well and can self-improve. Jeff called this "the last and maybe the best chapter of it all" (28:55), admitting he was a little under the weather and hoping his voice would hold out for another ten minutes, "feeding off your energy." He framed the optimization-phase challenge: building and prototyping cool agents takes hours or days, but how do you make the thing trusted in production — understanding how people use the agent, which signals are happening, what's succeeding or failing, and where to improve? With so many components (the underlying model, Toolbox and its tools, your own code, the instructions in your code), which variable should you tune when there's an issue? It can be overwhelming and time-consuming.

### Trace Replay View (GA soon)

In the Fibe agent, Jeff opened the view of all conversations and clicked into one request, surfacing the new **trace replay view** (30:16):

- See the conversation — what was asked and answered — plus the full trajectory the request took: the agent first reasoned on the model (about 20 seconds), then called a tool, reasoned again, called another tool
- Click into any step to inspect the exact inputs and outputs
- View the trace not only on a time axis but on a **token axis** — where tokens are consumed throughout the request
- **Replay** the entire conversation, e.g. at **8x speed**, to watch each phase the agent went through and see what the user saw throughout

### Rubric — auto-generated custom evaluation criteria (Public Preview)

Jeff motivated the improvement with real feedback: in the earlier voice demo, the agent answered with a bullet-point list — "a very LLM way of doing things" — which sounded robotic when read aloud. He wanted a more voice-natural response, but which variable to tune? He jumped to the terminal ("my best friend in the world") and ran the first command using the **Azure Developer CLI (AZD)**:

1. **`azd ai agent eval init`** (32:17) initializes the agent project and gets it ready to run evaluations against a benchmark
   - If you don't already have an eval dataset (many people talk about evals but don't have one — "I'm not going to judge you"), Foundry can generate one automatically: it looks through historic traces and additional signals about the agent and uses an LLM to suggest an initial starting-point dataset based on how the agent is actually being interacted with
   - For evaluation logic, Foundry has built-in evaluators (tool selection, tool input/output, retrieval evaluation, fluency, etc.); when the right combination is unclear, eval init helps generate the right combination — and you might even want a **custom rubric**
2. The generated **rubric** is not a single dimension; an LLM suggested several weighted dimensions it recognized as likely important:
   - Correct tool use (e.g., when asked about uptime, the agent should use Fabric IQ) — weighted highest
   - Safety warning
   - Voice Optimized Conciseness
3. Jeff customized it: the suggested "Voice Optimized Conciseness" had a weight of 3; based on the feedback he heard, he **bumped it up to 10** so the evaluator weighs voice optimization much more heavily
4. Developers can modify and customize the rubric as needed, yielding a personalized evaluator for the specific scenario

### Agent Optimizer (Private Preview)

Jeff then ran "my favorite CLI command in the world," **`azd ai agent optimize`** (35:22):

- It reads the system prompts/instructions the agent was given in its code, any configured skills, and the tool configuration, and can even treat the **target model** as a variable — e.g., **GPT 5.5 vs Anthropic Opus 4.8** — letting you specify which variables to vary
- You choose a model to drive the optimization process (he left it at GPT 5)
- It kicks off an automatic optimization loop (taking a couple dozen minutes) that adjusts the variables — modifying system prompts, tool descriptions, trying a different model — using leading data-science techniques to find candidate better versions of the agent scored against the custom rubric
- A hiccup: trying to show pre-run results, Jeff realized he had closed the Chrome tab earlier ("live demo gods, please be on our side for this last piece"), then pasted the URL to recover
- **Actual demo result**: the run found a candidate that boosts the evaluator **11%** (37:21). It identified **4 candidates**, each with different pros and cons; you can see what changed (the existing system prompt vs. a new system prompt that yields better behavior), dive into all the score details and eval sets it tested against, and then deploy the chosen candidate as the new default version of the agent to get the improvement on voice conciseness

### Procedural Memory (Public Preview)

- **Procedural memory** empowers the agent to learn the "playbook" across all sessions, so it doesn't have to start learning from scratch in every conversation
- With no manual rewrite of prompts or skills, the agent becomes smarter, safer, and cheaper the more it runs — all with the developer in control of every single change

### Operate-phase feature status recap (Tina)

Tina recapped: Tracing and evaluation for hosted agents is generally available soon — every LLM call, tool invocation, sub-second hop, and handoff is logged in one OpenTelemetry pipeline. Rubric for custom evaluation is now in public preview — it auto-generates context-aware criteria and weighted scoring to define what "good" looks like for both evaluation and optimization, so the developer doesn't start from scratch. Agent Optimizer for Foundry Agent Service is now in private preview — it turns production traces and evals into a set of ranked candidates by tweaking skills, prompt, tool configuration, and even models; ranked candidates are shown side by side across quality, cost, and latency, with the developer in control to choose the winning variant to promote, and trace-back, lineage, and rollback right there. Procedural memory in Foundry Agent Service is now in public preview.

---

## 5. Customer stories and closing (00:38–00:43)

After recapping the Operate features, Tina noted this is "not just a road-map promise": **over 80,000 customers are running on Foundry today** (40:19), already driving significant business outcomes with production agents:

- **Ecolab**: scaling mission-critical energy operations across 14 countries, leveraging identity, memory, governance, and observability right from Foundry Agent Service with full control over regulated operations
- **Twilio**: has deployed **Twilio Agent Connect**, its open-source framework that connects AI agents with the Twilio platform, all running on hosted agents in Foundry
- **KPMG**: building its global **KPMG Workbench** platform on hosted agents, leveraging tools and skills in Foundry Toolbox to supercharge its interactions with clients worldwide

Tina recapped the full 45 minutes: starting from a scenario the Azure networking operations team faces daily (a fiber cut near a data center), they built an agent locally with Microsoft Agent Framework as the orchestrator; connected it to Foundry Toolbox, Foundry IQ, memory, voice, document intelligence, and content understanding; hosted it as a hosted agent in an isolated, secure execution runtime; published it into Teams as a Copilot agent; and operated it autonomously, traced end to end in production, meaningfully getting better through every run. She closed with the promise: **"This is Microsoft Foundry. Build simply, deploy powerfully, operate with trust"** — available to every developer in the room today. Jeff and Tina pointed to related Build sessions (including one on observability immediately following) and the Foundry booth, and offered to take questions.

---

## Summary — announced new features and statuses

Core messages:

- Microsoft Foundry is positioned as the end-to-end "operating system" for enterprise AI transformation — not just a build platform — spanning Build, Deploy, and Operate as a continuous learning loop with the developer in control of every change.
- In the new agent era, building is no longer the hard part; agents are general-purpose, capability-expanding teammates, and the challenge has shifted to running them reliably at enterprise scale.
- Foundry brings the fragmented agent ecosystem into a single platform: any framework/tool (Claude Code, GitHub Copilot, Cursor, Visual Studio), a single MCP-compatible Toolbox endpoint, hosted isolation, Teams/M365 reach, and an automated trace -> evaluate -> optimize improvement loop.
- The system compounds the more it runs: tuning models, harness, context, and memory — improving the whole system rather than fine-tuning a single model — with full developer control, rollback, and lineage.

Announced features:

| Feature | Status | Description |
|---|---|---|
| Microsoft Agent Framework 1.0 (incl. Agent Harness) | **GA (production ready)** | Python framework optimized for multi-step/multi-agent workflows; secure harness for shell/code execution, integrated with skills, memory, middleware; GitHub Copilot SDK and Claude Agent SDK plug in as harnesses |
| Foundry Toolkit for VS Code | **GA** | Purpose-built developer experience to create agents, trace/observe, evaluate, and manage models without leaving the editor; auto-integrates Foundry best-practice skills with Copilot |
| Voice Live integration (prompt agents) | **GA** | One-click wrapping of industry-leading voice models with real-time WebSocket streaming |
| Hosted Agents in Foundry Agent Service | **GA soon** | Process-level sandbox isolation, sub-second cold start, zero idle cost, framework agnostic; supports long-running autonomous agents (Open Claw, Hermes) with durable state execution and file-system access |
| Tracing & Evaluation for Hosted Agents | **GA soon** | Every LLM call, tool invocation, sub-second hop, and handoff logged in one OpenTelemetry pipeline; includes Trace Replay View (time/token axes, 8x replay) |
| Foundry Toolbox | **GA soon** | Single managed MCP-compatible endpoint for all tools (Foundry IQ, Web IQ, Fabric IQ, Work IQ, Content Understanding); centralized auth, PII guardrails, and Tool Search for context-window optimization; skills as a first-class integration |
| Publish to Teams / Microsoft 365 Copilot | **GA soon** | Publish Foundry agents directly into Teams and Copilot; identity, policy, and permissions flow through automatically |
| Routines | **Public Preview** | Makes agents proactive and long-running via scheduled events/heartbeats; Foundry queues, executes, and tracks every run |
| Autopilot Agents (publish to Teams) | **Public Preview** | Agents get their own IDs, email addresses, and Teams presence; can initiate conversations and follow up on action items, governed end to end in Agent 365 |
| Voice Live integration (hosted agents) | **Public Preview** | Voice/speech scenarios for hosted agents |
| Rubric (auto-generated custom evaluation criteria) | **Public Preview** | Auto-generates context-aware, weighted scoring dimensions for evaluation and optimization, customizable by the developer; can auto-generate an eval dataset from historic traces |
| Procedural Memory | **Public Preview** | Agent learns the playbook across all sessions so it doesn't relearn from scratch; gets smarter, safer, cheaper the more it runs, with developer control over every change |
| Agent Optimizer | **Private Preview** | Turns production traces and evals into ranked candidate agents by tweaking skills, prompts, tool configuration, and models (e.g., GPT 5.5 vs Anthropic Opus 4.8); side-by-side quality/cost/latency comparison with rollback and lineage |

## Next actions

- Install the **Foundry Toolkit for VS Code** (GA) and start building agents — create, trace, evaluate, and manage models without leaving the editor.
- Use the **azd ai agent eval init** and **azd ai agent optimize** commands to automate evaluation and optimization, including auto-generating an eval dataset and a custom rubric from production traces.
- Integrate Foundry IQ, Fabric IQ, Work IQ, Web IQ, and Content Understanding through the single MCP-compatible **Foundry Toolbox** endpoint, and turn on **Tool Search** to optimize context utilization.
- Combine **Hosted Agents** with **Routines** to build long-running, proactive agents with session isolation and durable state (via the Durable Task Scheduler), and publish them to Teams / Microsoft 365 Copilot — optionally as **Autopilot agents** governed by Agent 365.
- Apply for the **Agent Optimizer** Private Preview to try the automated improvement loop driven by real production traces.