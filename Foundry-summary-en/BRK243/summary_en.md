# Microsoft Build 2026 BRK243 "Claw and agent harness in Microsoft Foundry" — Detailed Summary

**Speakers**:
- **Sean Henry** — Microsoft Foundry team (host; Agent Framework lead)
- **Glenn** (surname not stated) — Microsoft Foundry team (Hermes demo)
- **Amanda** (surname not stated) — Microsoft Foundry team (Autopilot Agents / Teams integration)

**Session URL**: https://build.microsoft.com/en-US/sessions/BRK243
**Source**: Official WebVTT transcript (medius.microsoft.com CAPTION)

---

## Overview

This Microsoft Build 2026 Day 2 breakout session gives a detailed, technical walkthrough of how to build and deploy more advanced, sophisticated agents on Microsoft Foundry.

The central theme is the concept of the "agent harness" and the concrete ways to realize it on Microsoft Foundry. The session is organized around three approaches: (1) a demo running **Hermes**, an open-source claw-style agent, on **Foundry Hosted Agents**; (2) a code demo building a custom harness with the **Microsoft Agent Framework**; and (3) a demo of one-click publishing a built agent to **Teams / M365 Copilot**, including the newly announced **Autopilot Agents**.

Throughout the session, network problems ("conference Internet") caused several live-demo hiccups, but the presenters recovered on the fly and still conveyed the core concepts.

---

## 1. Foundry's layered architecture and where this session fits (00:00)

Sean opens the Day 2 session, introducing himself and his colleagues Glenn and Amanda, all of whom work on Microsoft Foundry — Microsoft's AI platform for using models and building applications and agents. He frames the talk as a deep dive into deploying more advanced and sophisticated agents into Foundry, building on the Foundry overview that Tina and Jeff gave the previous day (Day 1).

Sean explains Foundry's architecture as three layers:

1. **Intelligence layer**: the models. In Foundry, thousands of models are available, hundreds of them usable with agents.
2. **Runtime layer**: how agents are hosted, deployed, and managed in Foundry.
3. **Human and agent collaboration layer**: where agents actually meet you where you work — through surfaces like Teams or M365 Copilot — so they can help you work better every day.

All of these layers are wrapped in a layer of **trust, security, manageability, observability, and evaluations** — everything needed to run agents in production. Sean stresses that Foundry lets you choose the level of simplicity or control you want: you can start with very simple **prompt agents** built in the portal, or move to **more advanced agents written in code**, where you bring in your own libraries and connect them into other systems. This session focuses on the latter — mainly the agent runtime and some of the agent collaboration layer.

Sean then reflects on the past six months. He gave a similar session at Ignite six months earlier, and a lot has changed since. Frontier models have gotten very, very good at coding, shifting the role of software development so that coding agents do most of the actual coding while humans supervise and make sure the right thing is built. Tools like **GitHub Copilot, Claude Code, and Cursor** have made software engineers far more powerful. Then **open claw** appeared — an agent that runs locally on your machine with your credentials, that you interact with over messaging, and that runs constantly waiting for you. A second generation of these claw-style applications followed (Hermes, discussed later). The lesson of the session: take the agent-harness and claw techniques learned on top of coding agents and claws, and apply them everywhere to scaled enterprise applications.

---

## 2. What is an agent harness — defining the concept (03:41)

Sean defines the session's central concept. There are dozens of definitions for "agent harness," and he offers his own:

> An agent harness is the shell — the set of tools that you put around your agent in order to make it able to perform longer, more complicated tasks.

**Car analogy**: if the agent is the motor (the engine), the harness is the car — wheels, steering wheel, seats, and all the things that make the motor actually useful. The motor by itself is not very useful, but you still need that core piece.

### Components of an agent harness

| Component | Description |
|-----------|-------------|
| **Agent loop** | The core. Give the agent context plus available tools, call the LLM for a response, it often asks to execute tools, you execute them and feed the results back, and loop until the agent reaches its goal. This is the "engine" / "motor." |
| **Context management** | As prompts, messages, tools, and skills are added, the context grows. The harness proactively keeps the context contained, including **context compaction** — looking at everything in the context window and compacting it to something more manageable. |
| **Skills & tools** | Tools have always existed; **skills** (text-based capabilities added to the agent) are now much more common. Tools come over **MCP, OpenAPI**, or directly through code. Especially powerful are tools that "give an agent a computer": file-system read/write, writing and executing code, and running programs — which lets agents do more human-like tasks. |
| **Multi-agent orchestration** | The harness manages and orchestrates specialized agents together (e.g., for web browsing, code execution, or document synthesis). |
| **Memory & session persistence** | The agent remembers things about you and things it has learned across sessions, improving over time. Importantly, this lets the **runtime stay stateless**, so it can be hosted across different environments and deployments — critical for agents that run for long periods. |
| **Lifecycle hooks** | Extension points to connect the agent to existing applications at all cycles: before/after the agent runs, before/after it calls the LLM, and before/after it calls tools — where you apply your own policy and logic. |
| **Human-in-the-loop** | As agents grow more powerful, the harness provides channels for the agent to ask a human before higher-risk tool calls or executions (e.g., writing files or executing code). |

Sean notes these are the core capabilities seen across all agent harnesses, and the rest of the session shows several ways to get agent harnesses deployed into Foundry. He invites Glenn up to talk about getting Hermes deployed into Foundry.

---

## 3. Demo 1 — Hermes on Foundry Hosted Agents (07:55)

Glenn comes up to add color on what "claw-style" / "claw-like" means before getting into demos. The key pattern he wants to show: you take a harness that has memory and **owns its environment** (its sandbox or VM), has tools and autonomy, can execute for long periods deciding what actions to take, and typically has a communication platform to reach you where you want (Telegram, Slack, and so on). **Open claw** popularized this architecture, and many things are literally claws or flavors of claw (e.g., nano-claw and various things with "claw" in the name).

**Hermes** has the qualities of claws as described — many of the same features and ingredients — but it is **not literally an open-claw clone or fork**; the Hermes maintainers do a lot of their own things. Hermes is an agent you can deploy and run; it has all those ingredients, can run in many environments (today, Foundry Hosted Agents), can appear in the communication channels you want, and is especially focused on a bottom layer of **collective wisdom / constant self-improvement** — the more you do your particular tasks with Hermes, the better it gets at them.

### What Glenn set out to show

Most claw-like architectures today are optimized for running on a machine the agent owns. Recalling the early-cloud "pets versus cattle" analogy, these agents are **pets** — you literally name them; they are the most pet-like thing invented since the beginning of cloud computing. Glenn's goal was a Hermes setup where the **back end is on Foundry** but the agent is **always available** — he can always talk to Hermes, yet it **shuts down when idle** so he is not paying for it all the time.

### Demo setup (on Foundry Hosted Agents)

```
Local machine: Hermes TUI (terminal UI)
    | via an AGUI proxy over the network
Hermes instance on Foundry Hosted Agents
    | uses local Azure default credential to authenticate
Foundry model (same Foundry credentials)
    | MCP toolbox connection
WorkIQ SharePoint (MCP server)
```

Glenn lives in the terminal, so that is where he wants Hermes. He is **not using Open Shell** today; Foundry Hosted Agents has a **built-in sandbox**, which he relies on. The Hermes TUI runs on his machine but, on startup, connects to a Hermes agent running on Foundry Hosted Agents. He can say hello and have it do things; it uses a model running on Foundry, authenticating with his local Azure default credential and then the same Foundry credentials to get the model.

He then asks Hermes whether it can see a SharePoint file called **`build_demos.docx`** — the actual demo script from Tina and Jeff's Day 1 session — but **the MCP connection fails** ("networking is bad"). Glenn narrates the failure while pointing out that the toolbox connection (shown at the top as **WorkIQ SharePoint MCP**) is real: his Hermes instance is deployed to the cloud, has a toolbox connection, and uses its identity plus his to connect to a WorkIQ MCP and normally reach SharePoint. It just fails live in this demo.

### Files, skills, and session IDs

As you work with Hermes, it **generates files, skills, and context** — the more you work on your tasks (e.g., via SharePoint), the more it accumulates on disk, which can eventually cause problems.

Glenn switches to his Foundry page showing the agent he was connecting to. It has a **Foundry agent endpoint** that the TUI connects to. He launched the TUI via a **shell script** that sets environment variables and points the TUI at the back end, including a string **`george-build-hermes`** — the **session ID** for Foundry. **Every session ID controls the file system the agent gets access to.** Changing it (e.g., to **`jeff-build-hermes`**) produces a **brand-new Hermes**: a brand-new file system, a brand-new VM, recreated from the **snapshot** deployed when the Hermes agent was created.

On the file-system lifecycle: Foundry Hosted Agents keep the sandbox file system around for about **30 days after inactivity** — if untouched for 30 days, the file system is deleted; otherwise it stays around as long as you keep using it.

### New feature: Routines (Preview)

The Foundry agent page shows a new feature called **Routines**, currently **in preview**. Hermes has a set of **maintenance routines**: it curates skills, deletes old/stale skills, and so on. Because Glenn does not want the sandbox running forever, the agent **shuts down after ~15 minutes of idle time**, and routines **spin it back up** when it is time to do maintenance.

Routines let an agent **react to external stimuli** — they can prompt an agent to go do something. To create one in the portal you select an **agent**, a **session**, give it a **prompt**, and give it a **recurrence**. Importantly, **agents can create routines themselves** to come back into the same session. Glenn did not create the routines shown — each was created by an agent (which is why they have "weird names") so it could do maintenance on itself. When the new (`jeff-build-hermes`) instance launched for the first time, it **automatically created a new nightly-maintenance routine**: that nightly routine deletes old scheduled skills, curates files, and importantly **backs up Hermes** (creating an independent backup so the files are always on disk).

### The design lesson: decide how you handle state

Glenn switches to a slide to make his main point: **agent state creates unique environments.** Every Hermes instance, file system, and agent in a claw-like pattern becomes **unique by design** — you want uniqueness so it keeps its own skills and content and constantly learns, evolves, and gets better. But, as learned painfully while building cloud applications, **uniqueness causes pain when recovering and resuming from errors.** (Indeed, after his MCP failure, Glenn spun up a new instance and it just started working; it then knew that the SharePoint document had been authored by **Jeff Holland**.)

So you must **decide how to handle that state**. In Glenn's case he was content with a **nightly backup to Blob Storage** plus relying on Foundry Hosted Agents' ~30-day file-system retention. If you run on a VM and do not care, you can just run it forever; otherwise you externalize maintenance (as he did) or build something custom (the next demo).

Glenn closes by inviting people to find him afterward: **all his code is available** (currently a proof of concept that he keeps evolving), and he is happy to help anyone who wants to use Hermes, build similar setups, or use routines to trigger agents generically. He will be at the booth afterward. Sean adds that Glenn has been making **PRs directly into the Hermes repo** to improve it and make it work better with Foundry.

---

## 4. Microsoft Agent Framework overview (21:43)

Sean returns to focus on building your **own custom harness** with the **Microsoft Agent Framework** — Microsoft's library/SDK for building AI applications and agents in **Python and C#**.

- **Released to preview**: late last year, **October** (2025).
- **Version 1.0**: went GA "a couple of months ago" (early 2026).
- **Full feature parity** between .NET (C#) and Python.

It is composed of **three parts**, echoing the earlier slides.

### 1. Agent loop

The Microsoft Agent Framework AI-agent construct. It lets you build loops that talk to **Foundry models, Foundry tools, and host directly in Foundry**, but also connect to tools and capabilities from elsewhere in the AI ecosystem:

- **Multi-model**: connect directly to **OpenAI, Anthropic, Gemini, Bedrock**, and local models with **Ollama**.
- **Tools**: connect to any tool over **OpenAPI, MCP**, or directly through code.
- **Deploy anywhere**: **Foundry hosting (Foundry Hosted Agents), Azure Functions, Azure Container Apps**, and even **AWS** ("I don't know why you'd want to do that").
- **Agent connectors** (abstracting away other agent providers): **Foundry prompt agents** (built declaratively in Foundry), **Copilot Studio** agents, **Claude Code** agents, **GitHub Copilot CLI** agents, or connecting with the ecosystem using the **A2A (agent-to-agent) protocol**. Sean notes many people connect their agent systems through Microsoft Agent Framework into GitHub Copilot.

### 2. Workflows

Built-in constructs for building **multi-agent systems**:

| Pattern | Description |
|---------|-------------|
| Sequential | One agent talking to / handing off to another, with the context moving as well. |
| Author-Critic | Agents constantly refining their output. |
| **Magentic** | Built with **Microsoft Research**; a planning pattern where a **supervisor agent** generates a plan and **sub-agents** work through it. |
| Custom | A full **directed workflow** capability. Workflows can **combine agents with regular code** ("not everything needs to be an agent"), built through code or **declaratively in YAML**. |

### 3. Agent harnesses (latest addition)

The shell built on top of the agent, provided built-in:

- Common **tools**: file-system access, code execution, shell execution.
- **Built-in context building**: chaining prompts, skills, and agent memory together intelligently and handing it to the LLM.
- **Planning** capabilities: these systems often (not always) work much better with a planning phase, plus **sub-agents that specialize** in specific tasks.
- **Extensive middleware**: context compaction, tool selection (different algorithms for selecting tools), and defining **permissions and capabilities** (what tools an agent can access).

This lets you build deep-research agents, coding agents (like GitHub Copilot, Claude Code), and content-generation agents — goal-driven agents where you give an abstract goal and have the agent figure out its own plan to succeed. And because it is a framework, you can build your own custom harness and **mix and match** — build harnesses into workflows, and workflows into harnesses.

---

## 5. Demo 2 — Building a custom harness with Microsoft Agent Framework (25:54)

Sean does a coding demo (shown in C#, with everything also available in Python given full feature parity). His agent warns him the network is not great, but he gives it a try.

### Minimal harness

The first few lines set up the **chat client** — the core agent loop. The new capability is being able to **slap an agent harness on top of any agent**: take that chat client and call **`AsAgentHarness()`**. Two extra lines (shown as lines 79-80 in his code) are only needed **while in preview** and **will become optional at GA**, making agent creation very simple.

When you add the agent harness, the agent gets **all the tools built in for free**, plus **compaction for free**. Sean contrasts this with past Agent Framework usage, which was "a bunch of Lego bricks" you had to assemble yourself; with the harness approach, things are **already built** — you might take some bricks away or swap some out — so you can stand up a fully capable agent very quickly.

### Customization example (Research Agent)

A **research agent** example shows much more configuration:

- **Name and description** (metadata).
- **Tools** — e.g., a tool that converts a **web page into a Markdown file**.
- **Model-level options** — e.g., **reasoning effort**.
- **File access** — where to **store files**, where **memory** goes, which files to give it access to.
- **Telemetry** — it emits the **full complement of OpenTelemetry from the Gen AI spec**, so it can go up to Foundry or anywhere you want to view telemetry.
- **Background agents** — preconfigured agents, e.g., one that does **web search in the background**.

### Harness Console (TUI) demo run

To make agents easier to run, demo, and prototype, the team built a **harness console** — a TUI similar to what Glenn showed with Hermes — that helps you build and iterate on an agent before deploying it. In the console, Sean runs the research agent with some configuration plus **listeners, observers, and handlers** for the events the agent emits.

Prompt: **"Write a blog about Microsoft's Agent Framework announces at Build 2026."**

Observed behavior:

1. The agent enters **plan mode** (the console supports different modes: plan, plan-and-execute, showing the current to-do list, and showing exported sessions of everything it has done over time).
2. It calls a bunch of tools, figures out what mode it is in, figures out what background memory it needs, and **loads a bunch of skills** — including a pre-built **blog-outlining skill** — reads some files, and builds a **to-do list**, downloading a bit of information to build an outline.
3. **Human-in-the-loop**: while building the plan, the agent **asks what kind / type of blog** to build — an event coming off the agent harness that the console listens for. Sean polls the audience and answers **"developers building AI agents"** (rather than a general tech audience).
4. The agent continues building its plan. Sean flips to the code to show a plan from an earlier run (how it iterates a blog plan), then notes that once the plan is finished the agent asks **"are you OK if I execute on this plan?"**
5. Back in the console he **approves and executes**, and the agent starts writing the blog post — illustrating how harness agents run in the background and do work over long periods.

### AGUI support (add a web UI in a few lines)

Since customers usually do not want a TUI, the team did a lot of work with **AGUI** and the **CopilotKit** folks to make it easy to build UI on top of agents. As with ASP.NET in C#, you **enable AGUI on top of your agent** with just a couple of lines (similar in Python), which gives the agent an **AGUI endpoint**.

**AGUI** is an **open standard for UI that talks to agents**; several libraries can talk to it directly. **CopilotKit** provides a nice one. Sean shows a different agent (given a **sales CSV**) running in a CopilotKit UI, showing the same agent-harness behavior — tool calls appearing and completing (which you can hide in your end application) — executing in a nice UI. With CopilotKit's built-in controls, he gave the agent the ability to **build charts** with **no extra code** — just telling the agent it could generate those controls and charts produced the result essentially for free.

### Three ways to run the agent

| Option | Use |
|--------|-----|
| Directly in a workflow | No UI; runs in the background. |
| Harness console (TUI) | Building, iterating, prototyping, debugging. |
| AGUI + CopilotKit | End-user-facing web UI. |

### Deploying to Foundry and the Agent Inspector

Because it is "just an agent," it can be deployed directly to Foundry. Using the **agent host builder** you **create a responses endpoint**, and running through the responses endpoint lets you interact with it and your tools. Sean shouts out the **Foundry Toolkit Agent Inspector** — a great tool when building agents: you can see previous responses and events, **connect your agent directly from the tool, and debug it** there.

Deploying into Foundry takes a few minutes after hitting the deploy button; Sean had done one earlier in the day, so he shows the agent up and running in Foundry. Once deployed it is **just like any other agent**: he can interact with it and see **traces** and everything Foundry provides to **manage, monitor, and evaluate** it. He then hands off to Amanda to show how to get agents where customers actually work — in Teams and Copilot.

---

## 6. Demo 3 — One-click publish to Teams & M365 Copilot (34:59)

Amanda takes the stage to talk about "what comes next": you have a built agent, and now you want to put it to work in the surfaces you use every day rather than a standalone UI. Foundry provides **one-click publish to Teams and M365 Copilot**: once your agent is deployed, from the portal it is super simple — a one-click dropdown, fill out a few key details, and the agent is instantly available (if scoped to yourself), with an option to share it with your entire organization.

### Publish flow

1. In the Foundry portal, with a tested version you are happy with, click the **Publish** dropdown.
2. Select **"Publish to Teams and M365 Copilot."**
3. A dialog lets you **name the agent** and provide **key details** — these are what **end users see** (the actions it can perform, not internal implementation details).
4. On the next page, choose scope:
   - **Make it available just to yourself** — shows up immediately so you can start using it (good for testing).
   - **Submit it to the Microsoft Admin Center for approval** — once approved, it is available to everyone in your organization.
5. There is also an option to **Download and customize**.

After publishing, you get **both UIs out-of-the-box** — Teams and M365 Copilot — **without building anything else.**

Demo agent: a **SaaS customer and product support agent**. In M365 Copilot, Amanda asks **"what products we sell,"** and the agent lists information about the products. She notes she is only showing Copilot for this agent but will show Teams shortly with the same single experience.

---

## 7. New announcement — Autopilot Agents (39:46)

Amanda returns to the slides to introduce a new agent type, organizing Foundry's agents into three categories. Until recently there were two — assisted and autonomous — and all of them have a unique Entra agent identity, though they did not always **act using** that identity.

### Three agent types

| Type | Behavior | Identity / permissions |
|------|----------|------------------------|
| **Assisted (assistive) Agents** | Typically a personal-productivity agent given one of the **WorkIQ tools**; can send emails on your behalf, draft Teams messages on your behalf. Most of its functions are an **extension of you**. | Acts on the **user's behalf**. |
| **Autonomous Agents** | Typically runs in the background; can be **triggered from a non-human, chat-based trigger** and perform actions **on its own behalf**. Its identity can be assigned permissions, e.g., on an **Azure resource group** or a **storage account**. | Acts on **its own behalf**, but **cannot** do the WorkIQ-tool actions described for assistive agents. |
| **Autopilot Agents** (new) | Like autonomous agents, always acts on its own behalf — but it actually **has a user account**. | Has a **Microsoft 365 user account**, giving it its **own email-address alias**, the ability to **send Teams messages on its own behalf**, **create Word documents on its own behalf**, and perform **any action that typically requires a user account**. |

### About Autopilot Agents

Autopilot Agents were briefly demoed in the **Day 1 keynote**. The way to think about them: Foundry gives you the **platform to build any type of Autopilot Agent**, and **Scout** (the Foundry Autopilot agent announced earlier) is **one example of an out-of-the-box Autopilot agent**. This session exposes the developer-facing platform capability.

### Hero scenario: Workstream Manager Agent (group chat)

Foundry focused on a **hero scenario** called the **Workstream Manager Agent**, also available in the **breakout session's repo**. Amanda calls out **group-chat behaviors** as a key unlock. The sample agent:

- **Automatically tracks open items**.
- **Answers questions** about everything in your Teams chat.
- Has an **onboarding flow**.
- Has **smart group-chat behavior** — it does not respond to every message, only when needed, and **@-mentions back** when directly @-mentioned.

Demo flow:

1. After deploying the sample, go to the **Microsoft Admin Center -> Requests tab**, and once it loads, **approve the agent**.
2. Go to **Teams and "hire" it**.
3. Because Amanda created the instance, she receives an **onboarding message** asking **who it should be able to talk to** (by default only the creator can talk to it). She grants access to specific teammates (e.g., **Seth, Elijah**, and others), after which the agent can respond to them one-on-one and in group chats.
4. To verify control, she throws the Workstream Manager Agent into a chat with someone (**Burke**) who does **not** have access; the agent should **not** respond to them.

**Hiccup**: when Amanda @-mentioned the agent, the response was delayed ("Hopefully the agent woke up this morning"), but it eventually responded. In a group chat she also demonstrates the out-of-the-box behaviors: the agent signals it is **working on a response**, **@-mentions back** on direct mentions, and **does not respond to all messages** (e.g., when she asks other members of the chat to do things) — a critical behavior for agents in group chats. Running low on time, she wraps up and encourages the audience to start building with the code sample and tailor it to their team's needs and behavior preferences, then hands back to Sean.

---

## 8. Closing (44:03)

Sean wraps up, recapping the three things shown:

- Taking an **off-the-shelf agent harness** (Hermes) and deploying it into Foundry.
- Building **custom harnesses** with the Microsoft Agent Framework and running them in Foundry.
- Getting agents that are up in Foundry to **where your customers are** — in M365 and inside Teams — with a couple of different ways those agents can interact within your enterprise.

Resources and calls to action:

- **GitHub**: all the demo code is available (a link is in the session resources).
- **Agent League Hackathon**: still running until the **14th**, with fabulous prizes — grab the QR code to join.
- **More sessions** on Foundry and Agents are running, plus the previous day's sessions you can watch online.
- **Foundry & Agents booth**: come chat afterward; Sean has **stickers**. The team wants to hear what people want to build.

---

## Summary

### Core messages

- An **agent harness** is the shell around an agent — agent loop, context management/compaction, skills & tools (especially "giving an agent a computer"), multi-agent orchestration, memory & session persistence, lifecycle hooks, and human-in-the-loop — that lets agents perform longer, more complex tasks.
- Foundry supports three layers (intelligence, runtime, human-and-agent collaboration) wrapped in trust, security, manageability, observability, and evaluations, and lets you choose the level of simplicity or control.
- Three concrete paths to advanced agents on Foundry: run an off-the-shelf claw-style harness (**Hermes**) on **Foundry Hosted Agents**; build a custom harness with the **Microsoft Agent Framework** (`AsAgentHarness()`); and **publish to Teams / M365 Copilot** with one click, including the new **Autopilot Agents**.
- **State management is a first-class concern** for claw-like agents: uniqueness gives power but causes pain on recovery, so decide up front how state is persisted (backups, externalized maintenance via Routines, retention).

### Announced features

| Feature | Status | Description |
|---------|--------|-------------|
| **Microsoft Agent Framework v1.0** | **GA** | Official Python & C# SDK (full feature parity) for building agents and harnesses. Preview October 2025; GA early 2026. |
| **`AsAgentHarness()` API** | **GA** (with a couple of preview-only extra lines that become optional at GA) | Adds a full agent harness (built-in tools, context compaction, planning, middleware) on top of any agent. |
| **Routines (Foundry Hosted Agents)** | **Public Preview** | Schedule agents to react to external stimuli on a recurrence; agents can create their own routines to re-enter the same session for self-maintenance. |
| **AG-UI / AGUI support** | **Preview** (inferred) | Enable an AGUI endpoint in a couple of lines; CopilotKit provides rich UI (e.g., charts) with no extra code. |
| **Autopilot Agents** | **Public Preview** (inferred) | Agents with a Microsoft 365 user account — own email alias, send Teams messages, create Word docs, and any action requiring a user account. Scout is an out-of-the-box example. |
| **Publish to Teams & M365 Copilot** | **GA** (inferred) | One-click publish from the Foundry portal; generates both Teams and M365 Copilot UIs out-of-the-box; self-scope or submit to Microsoft Admin Center for org-wide approval. |
| **Workstream Manager Agent sample** | **Public Preview** (inferred) | Autopilot Agent group-chat hero scenario (open-item tracking, smart group-chat behavior, onboarding/allow-list); available in the session GitHub repo. |
| **Foundry Toolkit Agent Inspector** | Available (tooling) | Connect to an agent directly to debug it and inspect responses, events, and traces. |

### Next actions

- Try the sample code in the public GitHub repos (see session resources), including the **Workstream Manager Agent**.
- Create and experiment with **Routines** in the Foundry portal.
- Code with the Microsoft Agent Framework **`AsAgentHarness()`** API in C# or Python.
- Prototype an agent with a web UI using **AG-UI + CopilotKit**.
- Build a team-facing **Workstream Manager** with **Autopilot Agents**.
- Use the **Foundry Toolkit Agent Inspector** to debug and trace agents.
- Join the **Agent League Hackathon** (runs until June 14).
- Visit the Foundry & Agents booth (and grab stickers).