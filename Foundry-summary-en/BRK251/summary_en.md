# Microsoft Build 2026 BRK251 "Build secure and enterprise-ready agents with Agent 365" — Detailed Summary

**Speakers**:
- **Neda** (also transcribed as "Nada"; session moderator and host; affiliation not identifiable from the transcript)
- **Kendra** (Microsoft; Agent 365 product management; specific team not identifiable)
- **Aarthi** (also transcribed as "Aarthy"/"Aarti"; Microsoft; engineering; live demo presenter)
- **Ray** (Co-Founder of Genspark)

**Session URL**: https://build.microsoft.com/en-US/sessions/BRK251
**Source**: Official WebVTT transcript (medius.microsoft.com CAPTION)

---

## Overview

This session, "Build secure and enterprise-ready agents with Agent 365," introduces **Agent 365**, a control plane for running AI agents safely and reliably across the enterprise as agents proliferate rapidly inside organizations.

IDC predicts that by 2028 there will be **1.3 billion agents** in organizations — more than the number of countries in the world. Yet when the speaker asked the audience to raise their hands, nearly everyone said they were building or using agents today, while almost no one could say their agents were enterprise-ready, observed, secure, and governed ("OK, I have one," the speaker noted, after seeing a single raised hand).

Agent 365 is positioned to close that gap. The central thesis, repeated throughout, is that Agent 365 covers **not only Microsoft first-party agents but also third-party, custom, and external agents** built on any framework or cloud — LangChain, AWS, Google Gemini/Vertex AI, Amazon Bedrock, and more. The session is structured in three parts: conceptual explanation, live demos (SDK onboarding and the admin console), and a partner case study from Genspark.

---

## 1. The challenge of making agents enterprise-ready (0:00)

Neda framed the problem with audience show-of-hands quizzes. Agents come in several broad types:

- **SaaS agents**: pre-built agents that ship inside applications and that organizations start using out-of-the-box.
- **Endpoint / custom agents**: agents developers build themselves, including "open cloud agents" built with CLIs and various other frameworks.
- **Cloud agents**: agents built on different clouds, platforms, and frameworks.

Across this diverse mix, the operational questions that arise are:

- Can the organization **discover** all of these agents and **manage** them?
- Are the agents **behaving properly** — staying true to their intended intent rather than breaking from it, and not misusing the tools connected to them?
- Are they **over-sharing or leaking data**?
- Can they be **governed and audited** at the end of the day?

To handle this today, developers stitch together different frameworks and products. What is actually needed is for agents to be **observable** (registered in an inventory/registry), to have an **identity** (so any action can be attributed to a specific agent), to have **threat protection** (against new generative-AI risks such as prompt injection, intent breaking, and tool misuse), to have **data security** (no over-sharing/leaking), and to be in **governance and compliance**. Agent 365 is presented as the **control plane for any agent** in the organization that addresses all of this.

---

## 2. Agent 365 architecture and the three pillars (2:30)

Kendra took over to explain the Agent 365 concept and value. The single most important takeaway she stressed: Agent 365 provides all of its capabilities **not only for Microsoft agents, but also for third-party, custom, and external agents**.

### The three pillars

**Observed**: You cannot govern what you cannot see, and you cannot be confident you are protected if you do not know what agents exist. Agent 365 lets you see all agents across all platforms and understand adoption trends, usage trends, and which platforms agents are built on — plus surfaces the actions you need to take to mitigate risk and keep the agent ecosystem safe.

**Govern**: "Govern" can be a scary word, but here it is not about putting the brakes on innovation or adoption — it is meant to **speed up the pace of adoption and innovation**. Governance is about implementing guardrails so that, no matter how an agent is built or who built it, the proper protections are in place every time, based on the agent's risk factor.

**Secure**: Just as you would secure any employee, data asset, or app in your tenant, you must secure agents. With **Defender, Purview, and Entra**, you can block threats in real time and go further — deep hunting and investigation to understand what caused a risk, full logs in Purview showing every step an agent took during an incident, and identifying other agents with similar vulnerabilities so you can mitigate them **before** incidents occur.

### How Agent 365 covers all agents

Kendra ran a second quiz ("Does Microsoft Agent 365 support all agents?"). The key enabler is the **Agent 365 SDK** — which is **not** an agent-building SDK and does not host your agent; it purely **wraps your agent to make it discoverable within Agent 365**, providing an agent ID, full observability, full security policy enforcement, and access to productivity capabilities through the **Tools gateway**.

Foundationally, Agent 365 is the end-to-end governance platform that scales and operationalizes agent governance and management. Picturing it as a stool, the **legs** are the trusted enterprise security solutions that hold it up:

- **Microsoft Entra** — identity management
- **Defender** — risk assessment and real-time threat detection/blocking
- **Purview** — data governance
- **Microsoft Intune** — shadow AI detection

The agents Agent 365 covers fall into four categories:

1. **Microsoft native agents**: every agent built on Microsoft (across all Microsoft agent-building platforms, plus pre-built agents like **CoWork** or **Researcher**) has a native experience out-of-the-box — visible whether in draft or production, with observability data, policy templates, security guardrails, and actions available with no additional effort.
2. **Third-party partner agents**: Microsoft is building an agent ecosystem with partners to **proactively** extend the SDK and enable agent IDs and observability within their agents (one such partner, Genspark, presents later).
3. **Custom agents**: agents you build yourself (e.g., LangChain, AWS) are onboarded with the **Agent 365 SDK**, which provides identity, observability, tools, messaging, threat protection, governance, and data security — comprehensive, but with the flexibility to onboard only what you want.
4. **Connected agent platforms**: agents on platforms like **Amazon Bedrock** and **Google Vertex AI** are ingested via **Registry Sync** for visibility purposes, while preserving the governance capabilities and permissions you already have on those platforms.

---

## 3. Key concepts: Agent Blueprint and Agent Identity (11:20)

Before the demo, Kendra defined two fundamental new terms.

### Agent Blueprint

A **reusable instruction set for an agent** that defines what tools and data it can leverage and what rules and guardrails are in place. Think of it as an **agent recipe** from which other agents and agent identities can be created.

### Agent Identity

An agent identity is an agent identity **up-leveled from a service-principal identity** so that it is more in line with a **user identity** level. Agents are unique — they are essentially apps (built like apps) but they **function like users** — so they need an identity appropriate to that function. There are two authentication modes:

- **On behalf of the user**: when a user invokes the agent, the agent assumes that user's credentials, passing the credential as the auth token along with that user's permissions for information retrieval or task completion.
- **Agent user identity**: the agent maintains its own identity and its own permissions and passes that identity for authentication, functioning on its own without acting on behalf of a user.

---

## 4. Demo 1: Onboarding a custom agent with the Agent 365 SDK (13:25)

Aarthi took the stage, noting she would "wear quite a few different hats," starting as an **agent developer** in VS Code.

### Scenario

A **travel agent** built on **LangChain + Node.js (TypeScript)** that, given a source, destination, and travel dates, returns 3 hotel suggestions, 3 flight suggestions, and restaurants. She had already tested it (3 airlines from Seattle to San Francisco for Build, plus hotels). LangChain was deliberately chosen to demonstrate that Agent 365 is **not just for Microsoft-built agents**.

### Procedure (using a coding agent — GitHub Copilot, Claude Code, or your choice)

You could stitch everything together by hand using the Learn docs and samples, but instead Microsoft ships specific **Agent 365 skills** that coding agents can run:

1. **Invoke the skills**: in VS Code, run `/skills agent365`. About **6 skills** are surfaced (the set is being constantly added to, so "keep an eye out").
2. **The two "make" skills** are the interesting ones (comprehensive). The other skills are piecemeal — you can just do setup (get an identity for your agent), just instrument observability (let the agent emit telemetry), or optionally add **Work IQ servers** so the agent can interact with productivity surfaces (e.g., create a document, have its own calendar). You can also test locally. The path shown makes the agent **essentially an employee** with its own user identity.
3. **Automatic stack detection**: starting from the agent folder and saying "make this agent ready for Agent 365," the coding agent (with access to the code) determines the stack is **Node.js + LangChain (TypeScript)** and knows what the agent does. It recognizes this is the first run.
4. **Prerequisites check**: required packages/dependencies, machine setup, the latest **Agent 365 CLI** version (the coding agent picked up a recent update), Azure CLI login state, and the **target tenant** for which the agent will be enabled.
5. **Plan generation and execution (~10 minutes)**: the coding agent produced a detailed plan — install required agent packages, add a valid build, then add observability, Work IQ, register, publish, and deploy. Steps it performed:
   - Installed the Agent 365 packages.
   - **Created a Blueprint** (the Entra configuration introduced earlier).
   - **Configured observability** (wired up **OpenTelemetry** so the agent emits telemetry).
   - **Configured Work IQ MCP servers** — she chose **Word and OneDrive**, so it configured those MCP servers (letting the agent create documents and write to OneDrive).
   - Set up the agent for **notifications** so it can receive messages over Teams as well as respond to **@-mentions** in Word document comments and to emails.
   - Generated a **manifest**.

The result is a fully extended Agent 365 agent ready to go (a developer would still test locally and make tweaks). Importantly, the agent can be **hosted anywhere** — Azure, GCP, AWS, or any cloud of choice — while fully unlocking Agent 365 features. The **actual agent identity is created when the admin activates the agent** in the Microsoft Admin Center, where the admin chooses whether it is shared with a subset of users or all users.

---

## 5. Demo 2: End-user experience and treating the agent as a colleague (18:44)

### End-user view

Shifting personas to an **agent user**, Aarthi went to the list of available apps in **Teams** and **created an instance** — her own version of the agent "reporting up to" her. In a Teams chat she asked the agent to plan a trip (after Build, to Austin) and to also create a Word document. She received hotel, flight, and restaurant suggestions (she would take the Southwest flight and the Marriott) **plus an editable Word document** generated automatically.

She then switched to the Word document and **@-mentioned** the agent ("Build demo travel agent") — "the agent that I just hired" — asking it to add some coffee shops, exactly as one would @-mention a colleague in a document rather than switching to Teams. Because onboarding set up a **notification endpoint** for the agent, it can respond not just over Teams but also to @-mentions in Word comments and to emails. The agent replied as a document comment (e.g., recommending an Italian place, "Laurel," and the requested coffee places), reinforcing the experience of the agent as a "digital employee" woven into the organization.

### Observability

- **End users** can see their own interaction history with the agent — chats from today, recent chats on refresh, and the couple of failures where the agent did not carry out a task — including the prompts given and whether the task was completed.
- **Admins** can see, for a given **Blueprint**, the **multiple instances** of it (different colleagues — e.g., Pooja and Alasta — each "hire" their own instance), the activity across all instances, and exactly who the users of each instance are.

Aarthi recapped: she started with a basic LangChain agent in Node.js (to be hosted in Azure, though location does not matter), used **skills** to make it Agent 365-ready — configuring Entra (where the Blueprint was created), observability (OpenTelemetry), optional Word/OneDrive MCP servers, and notifications — leaving the agent fully configured and ready in the tenant to unlock the rest of Agent 365.

---

## 6. Demo 3: Agent governance in the Microsoft 365 Admin Center (25:12)

Kendra moved to the **Microsoft 365 Admin Center** demo, with a light moment at login ("I login tech support... Oh, there we go. Wrong button"), which drew laughs.

### Overview page

Shows tenant-wide high-level analytics: total number of agents, total number of users (**human employees only**, not agentic users), and **total runtime hours**. She noted **multi-tenant capabilities are in the works** — today you see all agents in a single tenant. The page surfaces **calls to action** for where admins need to lean in:

- **Pending requests** for agents (approvals, like the one Aarthi's instance went through).
- **Agents where risks** have been seen.
- **Agents without owners** — "a big one" — to keep **agent sprawl** under control and maintain good ecosystem hygiene.
- **Agents with exceptions** (anytime there is an error in an agent's runtime, it surfaces as an exception).

Below are more granular analytics: how many agents were built by the organization vs. third-party providers vs. across Microsoft, the **top platforms** agents are built on, **agent adoption over time** (useful for adoption campaigns or releasing highly anticipated agents like IT support or benefits agents), and **trending agents** used heavily across the organization.

### Agent registry (27:46)

Lists all agents across all platforms — **not just Microsoft agents**; the list includes **Workday** and partner agents like **Genspark** — and can be sliced and diced to manage large numbers of agents.

Drilling into an individual agent (28:22; her example was a "Zava procurement agent") shows rich metadata:

- What the agent does, publish date, last-updated date, publisher, owner, and **agent ID**.
- The **agent instructions** (system prompt) so you can see exactly what the agent is doing and its purpose.
- The full **identity history**: not only the **Bot ID**, but the **Blueprint ID** and the **Entra agent ID**. (For a Copilot Studio agent you would see environment details; for a Foundry agent you see platform details and can link out directly to the agent.)
- All **users the agent is shared with**.
- From a security perspective, all the **policies applied** during onboarding/approval, with the ability to drill into **Purview or Entra** to investigate.
- All the **permissions** the agent has.
- A **unified activity view** across all agent types (30:01): total users, total sessions, exceptions, runtime hours, **successful sessions** (so you know how the agent performs), and monitoring for spikes in errors/exceptions. Below, the **users driving traffic** to the agent, with their total sessions and last-activity date.
- A **visual / dependency view** (30:36) in addition to the list view: agents aggregated by the platforms they are built on, with hover to see which agents a multi-agent solution leverages — even across different platforms. Drilling in shows a list of connected agents and whether each is available or blocked. This is key for understanding dependencies and the **blast radius**: "If I block this agent, what else does it break?"

### Risks (31:42)

Coming back to the registry, drilling into agents that have risks takes you directly to the agent and shows the **source of the risk**. With more time, you could drill into Entra or Purview to see incidents granularly — full access to logs, down to the document or data-source layer that was accessed and triggered the blocked risk. From here, the admin can **block the agent** and work with the SecOps team for further investigation and mitigation.

### Rules (32:36 / 33:00)

Moving into **agents without owners**, an admin can easily reassign an owner (e.g., making Aarthi the owner), but doing this manually is tedious — that is where **Rules** come in. Rules provide a simple way to automate **lifecycle-management actions**, such as:

- **Reassigning an agent** to a person's manager when the individual leaves the organization (for agents built in agent builder).
- **Automatically blocking** an agent when risk is identified, so you do not have to block it manually.

Microsoft is **investing heavily** here to make risk handling as scalable as possible, with more functionality coming **over the next couple of quarters**.

### Templates (33:49) — "one of our hero features"

**Templates** aggregate all custom policies from across **Entra, Defender, Purview, and even SharePoint** into **one reusable template** that can be applied to agents consistently and comprehensively. There are **default** templates and you can easily create **custom** ones. A custom template can include access packages (multiple selectable), conditional access, and a range of default policies such as **DLP protection** and **lifecycle-management protections**.

### Agent publish flow (34:55)

Using a "staffing agent" example to be published across the organization, the IT admin team must approve it and apply the appropriate template. The flow:

1. **Select the users** with access — pre-install for all users, a subset, or just make it discoverable in the store.
2. **Review Data and tools** — what data and tools the agent can access, which is where you understand the agent's **risk level**.
3. **Apply a template** — it starts with the **default template** (a baseline of protections all agents should have), then you can apply a custom one (e.g., her "DevOps" template); all the template's policies and the appropriate permissions are applied.
4. **Review and approve** the permissions.
5. The agent becomes **available for the organization**.

### Registry Sync (36:31)

The ability to **ingest agents from common third-party platforms** like **Amazon Bedrock** and **Google Vertex AI**. After configuring access to those platforms, she clicked into Google and saw one agent. You cannot see all the observability data you would get from SDK onboarding, but you are **at least aware** of all agents deployed across that platform — and because she had **delete permissions** in Google, she also had the permission to delete that agent from within Agent 365.

She also noted plans to **identify and bring shadow agents under management**, expanding beyond Open Claw to leverage **Defender** to identify **22-plus (give or take) additional local platforms** so admins can block them or bring them under management — and the ability to govern and manage all tools from the same place.

---

## 7. Customer momentum and partner case study: Genspark integrating with Agent 365 (37:52 / 38:44)

Kendra closed her section with customer momentum (37:52). One early adopter, **EY**, found Agent 365 key for **mission-critical agents** — giving them the trust to unlock and confidently leverage these agents across the organization. The next, **Genspark**, was presented by its co-founder directly.

**Ray, Co-Founder of Genspark** (38:44), shared how Genspark integrated with Agent 365. **Genspark (Jasma)** is a "unified AI workspace for knowledge workers," already adopted by **more than 2,000 organizations** for their daily work.

### Handling diverse use cases

- **Sarah (finance)**: needs to prepare a board deck by Friday — summaries and slides — which a simple, chat-based AI tool can handle.
- **Tom (data analysis)**: has 200+ MB CSVs requiring heavy compute for calculations and summarizations — needing a **dedicated virtual machine**.

These two kinds of work need two kinds of AI back ends. Agent 365 gave developers the flexibility to **combine different back-end infrastructures** while still integrating with Agent 365.

### Agent 365 as three primitives

Ray described Agent 365 as a three-primitive platform, integrated via the **Python SDK** as a thin middle layer: at the top, the Microsoft software suite (Teams, Outlook, Word); the middle, the thin Agent 365 Python SDK layer providing identity, streaming, and MCP access; and underneath, observability/Purview and lifecycle management — with Genspark's flexible back end (lightweight chat-based AI tools and heavyweight compute like a dedicated VM) below that.

1. **Identity (federated identity credentials via Entra)**: Genspark authenticates **every request/message**, not just once at the beginning. For example, if someone in a Teams group chat @-mentions the agent asking for a private message and that user is not from the agent's Entra (AAD), the request is **detected and refused**. Genspark did **not** need to build a separate authentication layer — it uses the capabilities provided by Microsoft.

2. **MCP for M365 integration**: Agent 365 already provides powerful **MCP servers** connecting to **PowerPoint, Outlook, and Word**. For each request, Genspark can generate a PowerPoint or Word document on the fly and write it back into the user's or the agent's **OneDrive** via MCP — so Genspark did **not** need to build its own storage layer.

3. **Observability / Purview / lifecycle management**: every agent's locations, inference, and activities are **automatically logged into Microsoft Purview**, giving the tenant a single, unified place for IT managers to monitor all agent activity. Because each agent has its own unified identity, **Purview policies already implemented enterprise-wide automatically apply to agents** — e.g., sensitivity labels on a Word document also apply to the agent, so Purview can **automatically block** the agent from leaking sensitive information. Genspark did not need its own security layer. All agent logs are unified through the **same Microsoft APIs**, so IT managers can use the **same SQL queries** and existing tools to query and analyze agent activity.

The net result: end users get flexibility to choose different agent back ends (chat-based or dedicated VMs), while IT managers retain enterprise control because all activity and logs are built on Microsoft-provided APIs and existing tools — which Ray said is why Genspark's enterprise customers love the feature.

Neda closed the session, recapping how to build enterprise-ready agents with Agent 365 — integrating the SDK, and observing, securing, and governing agents — and pointing to resources for getting started, getting started with the SDK, and a recently released blog.

---

## Summary

Agent 365 is an enterprise control plane for agents that works **regardless of where the agent was built**. Developers can onboard an agent in tens of minutes using the Agent 365 SDK (or by running coding-agent skills), and IT admins can centrally observe, govern, and apply security policies to every agent from the Microsoft 365 Admin Center.

### Core messages

- By 2028 there will be ~1.3 billion agents in organizations; almost everyone is using agents, but almost no one's agents are enterprise-ready, observed, secure, and governed — Agent 365 closes that gap.
- Agent 365 covers Microsoft native agents, partner agents, custom agents (any framework/cloud), and connected-platform agents — three pillars: **Observed, Govern, Secure**.
- "Govern" is meant to **accelerate** adoption with guardrails sized to each agent's risk, not to slow innovation.
- Agents are built like apps but function like users, so they get an **Agent Identity** (up-leveled from a service principal), authenticating either on behalf of a user or with their own user identity, and are defined by reusable **Agent Blueprints**.
- Security is grounded in Entra (identity), Defender (real-time threat detection), Purview (data governance), and Intune (shadow AI detection), with full Purview logs for incident investigation and proactive mitigation of similar vulnerabilities.

### Announced features

| Feature | Status | Description |
|---|---|---|
| Agent 365 SDK (Python / Node.js confirmed) | Available (GA/Preview split not explicitly stated) | Wrapper SDK that makes third-party/custom agents discoverable in Agent 365, providing identity, observability, tools, messaging, threat protection, governance, and data security. Not an agent-building or hosting SDK. |
| Agent 365 Coding Agent Skills | Available (~6 skills; "constantly adding") | Skills runnable from coding agents (GitHub Copilot, Claude Code, etc.) in VS Code that make an agent Agent 365-ready, including the comprehensive "make" skills. |
| Agent Blueprint | Available | Reusable instruction set / "recipe" defining an agent's tools, data, rules, and guardrails, from which agents and agent identities are created. |
| Agent Identity (Entra-based) | Available | User-level identity for agents; supports on-behalf-of-user auth and standalone agent user identity. |
| Tools gateway / Work IQ MCP servers | Available | MCP servers (e.g., Word, OneDrive, PowerPoint, Outlook) letting agents use M365 productivity surfaces — create documents, write to OneDrive, have a calendar. |
| Observability (OpenTelemetry) | Available | Telemetry wiring so agents emit observability data, visible to developers, end users, and admins; unified activity view across all agent types. |
| Notification endpoint | Available | Lets agents respond to Teams messages, Word @-mention comments, and emails. |
| Registry Sync | Available | Ingests agents from connected platforms (Amazon Bedrock, Google Vertex AI) for visibility, preserving existing permissions (e.g., delete). |
| Templates | Available ("hero feature") | Aggregates policies across Entra, Defender, Purview, and SharePoint into one reusable, applicable template (default and custom). |
| Rules | Available; expanding over next couple of quarters | Automates lifecycle-management actions (owner reassignment to manager on departure, auto-block on risk). |
| Shadow AI detection expansion (22+ platforms) | Future roadmap | Defender-powered detection beyond Open Claw to identify/block/manage agents on 22-plus additional local platforms. |
| Multi-tenant management | In development | Managing agents across multiple tenants (today scoped to a single tenant). |

### Next actions

- Review the Agent 365 SDK getting-started documentation and sample code (Learn docs and a recently released blog were shared as resources at the end of the session).
- Open the Microsoft 365 Admin Center and review the agent registry, overview analytics, and calls to action (pending approvals, risks, owner-less agents, exceptions).
- Try the Agent 365 skills in VS Code (via `/skills agent365`) against an existing custom agent to onboard it.
- Set up Templates and Rules to apply consistent policies and automate lifecycle management, and configure Registry Sync to bring connected-platform and shadow agents under visibility/management.