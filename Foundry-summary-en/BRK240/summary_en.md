# Microsoft Build 2026 BRK240 "Build context-aware agents: From data to decisions" — Detailed Summary

**Speakers**:
- Amanda Silver (Microsoft, VP of Developer Tools & Platforms; framing, narration, and explanation)
- Marco Casalaina (Microsoft, live implementation demos; the auto-captions misrecognized his surname as "Castle, Anna")

**Session URL**: https://build.microsoft.com/en-US/sessions/BRK240
**Source**: Official WebVTT transcript (medius.microsoft.com CAPTION)

---

## Overview

This session sets out to introduce Microsoft's new intelligence foundation, **Microsoft IQ**, as the answer to the single biggest obstacle in enterprise agent development: lack of context. Amanda Silver and Marco Casalaina present together for roughly 44 minutes, alternating between Amanda's framing/architecture explanations and Marco's live implementation demos.

The session's core message is that **agents fail not because the models lack capability, but because the agents lack context**. The speakers cite that more than 40% of agentic AI projects are expected to fail, attributing this to fragmented data sources, a proliferation of custom retrieval systems, and the complexity of permission models. The proposed solution is the **Microsoft IQ** platform, which unifies four sources of context.

The demo is built around a "refund-processing agent for a fictional package-delivery company." The starting point is an email Amanda sent Marco asking to automate an onerous refund process, and Marco demonstrates building the agent from that single email. From early in the session, a network outage strikes, and Marco continues narrating while repeatedly trying to restore connectivity — a running series of mishaps. Connectivity is finally restored after a member of the audience suggests disabling the GlobalProtect VPN, allowing Marco to complete the main demos.

---

## 1. Problem statement: why do agents fail? (00:00)

Amanda Silver opens by noting that "software is evolving from people-driven applications to agents that are defined by intent and measured by the outcomes." These agents can reason, retrieve context, make decisions, and take action on a user's behalf — in many ways the automated future the industry has been working toward for decades. She emphasizes she has worked at Microsoft on developer tools and platforms for more than two decades and has never seen a shift as profound as this one.

But there is a problem. **More than 40% of agentic AI projects are expected to fail** — not because the models aren't capable, but because the agents lack the context they need to succeed. Today developers have to stitch together fragmented data sources, custom retrieval systems, permission models, and orchestration logic just to make agents useful. Everyone is figuring this out together, best practices are not yet established, and the result is brittle end-user experiences. The consequences for agents are:

- They hallucinate
- They miss/violate policy boundaries
- They break when deployed into production

Amanda's central analogy: the challenge is the difference between welcoming a brand-new employee versus a seasoned employee. The question the session poses is: how do you take the context a seasoned employee already has and infuse every new agent with that knowledge as it executes?

---

## 2. Microsoft IQ design philosophy and architecture (02:43)

The answer is **Microsoft IQ** — "the context layer for the agentic web." It brings together four different sources of context:

| IQ name | Coverage |
|---------|----------|
| **Work IQ** | Organizational context (M365 email, Teams, documents, workflows) |
| **Fabric IQ** | Business knowledge (real-time operational metrics, semantic models, ontologies) |
| **Foundry IQ** | Enterprise knowledge and policies (internal documents, custom apps, security controls) |
| **Web IQ** | World knowledge (real-time web, news, images, video) |

Together these four IQs give agents "a shared understanding of the world of your business, the data, the workflows, and the policies that surround the agents as they do their work." The payoff is threefold: better accuracy, more reliable actions, and dramatically less engineering — because you no longer have to recreate the context for every single agent you build.

---

## 3. Demo overview and initial Work IQ introduction (03:32)

Marco begins the live demo. The starting point is the email Amanda sent him the previous week — no spec, no design doc, just "a crazy idea" to make an agent for the company's onerous refund process. Marco starts with **Work IQ**, opening **Copilot CLI** and using its built-in voice mode (he notes the shortcut is roughly Control-X-V) to instruct it: "Amanda Silver sent me an email about this refund agent idea. Let's start to make a plan, a little spec, so we can build this agent. Go look up that email."

Marco has **Work IQ installed into Copilot CLI**, and it uses Work IQ on his behalf (he authorized it) to go find the email in M365.

**Mishap 1 (~03:52)**: A transient network/connection error occurs and the Work IQ email lookup fails. Marco laughs it off ("it might have a transient error, but that happens, it's all good"), switches to a tab he had preloaded, and shows the spec he had already generated along with the already-built agent.

Through this demo Marco explains Work IQ's capabilities:
- **Installable into Copilot CLI** (acting as an MCP server / authorized agent)
- It logs in on your behalf as the M365 user to search and operate over email, Teams, SharePoint
- M365 Copilot does the same thing — users will notice a little "Work IQ" indicator at the top when Copilot looks up their email
- Regardless of connectivity, the agent is already wired in Foundry to all four IQs, including Work IQ. He shows the agent's polished front end and then what the same agent looks like in **Foundry**, where all four IQs are connected.

---

## 4. Web IQ in detail (06:27)

Amanda hands off to explaining **Web IQ**. Agents don't just need to understand your business — often they need to understand the real world in which your business operates. She gives the example of someone who delivers consumer goods and needs to understand micro-events (local events) so he can micro-target which consumer goods to deliver to which markets.

**Web IQ** connects AI to authoritative real-world information: a structured, multimodal index across the web, news, images, and video, so agents can be grounded in fresh, verifiable context. It is explicitly **not a traditional search API wrapped in AI** — it is a grounding platform built specifically for the needs of modern agentic systems.

**Three things that matter when building agents at scale**:

1. **Quality**: Structured, citation-ready results across web, news, images, and video, so agents generate answers users can verify and trust.
2. **Speed**: **Sub-200-millisecond P95 grounding**, keeping multi-step agent workflows (retrieval, reasoning, planning, action — all of which add latency) responsive even when agents chain together many operations.
3. **Efficiency**: Context windows are valuable real estate, so Web IQ uses **passage-level ranking** to surface the highest-signal information and filter out noise, reducing token consumption and lowering overall cost at scale.

Web IQ is already in use by frontier model providers and many enterprises, and is **available today for a few Azure customers**.

**Customer example: NASDAQ Board Vantage** — A solution that helps boards and executives make decisions in real time, where accuracy, timeliness, and trust are critical. It brings together enterprise information and external web signals without compromising security or data boundaries. With Web IQ, NASDAQ grounds AI in fresh, authoritative information, resulting in faster access to external context, higher-quality responses, and a simpler architecture for building AI applications.

Later in the session Marco attempts a Web IQ demo asking about the **Sandy Fire** — a wildfire actually burning 400 miles south of the San Francisco venue, in Simi Valley — to ground the agent in real-time data, but the ongoing network outage prevents it at that point. (It succeeds later once connectivity is restored — see Section 8.)

---

## 5. Foundry IQ in detail (09:38)

Amanda explains **Foundry IQ**: "If Web IQ connects agents to the world's knowledge, Foundry IQ connects them to your knowledge" — the enterprise knowledge scattered across data platforms, content repositories, business systems, and custom applications. Today developers spend too much time stitching these sources together before an agent can deliver value; Foundry IQ provides a unified knowledge layer that automatically ingests, enriches, and connects enterprise information, eliminating much of the retrieval logic and infrastructure you'd otherwise build. At runtime it intelligently retrieves the right information from the right sources.

**Foundry IQ mental model (layered)**:

- **Foundation (knowledge sources)**: enterprise data, documents, applications, and the live web
- **Context layer**: memory, embeddings, and semantic models that turn information into understanding
- **Top layer (agents/apps)**: the agents and applications users interact with

The key idea is **delegation**: every layer does one thing well. As a developer you don't want to rebuild that machinery inside every single agent — you define a knowledge base once and make it available to multiple agents across the organization, so you reach your solution faster. And great grounding isn't just retrieval, it's trust, which is why **security, governance, and policy enforcement are built directly into the platform, not bolted on afterward**.

**New announcement**: Microsoft is **introducing a new serverless developer tier** for Foundry IQ that gives every developer an easy on-ramp to start building, and lets them scale to production when ready. (GA/Preview status not explicitly stated.)

**Customer example: Sitecore** — a leader in digital experience and content management. Foundry IQ gives them reusable knowledge bases, agentic retrieval, and enterprise-grade security out of the box. Sitecore applied these directly to a real business problem, ensuring their marketing and brand knowledge is accessible to every agent across the organization, every time, with all the right permissions.

When Marco shows Foundry IQ (covered in errors due to the dead network), he highlights **reuse** as a core value: he reports **35 agents, of which 31 are currently running**, many connected to the same data sources and grounded in the same context. Rather than redefine this for every agent, he uses a Foundry IQ knowledge base — which he clarifies is "a bit of a misnomer," because **it is really a separate sub-agent doing agentic retrieval**, able to try again and re-rank results before handing them to the downstream agent.

---

## 6. Fabric IQ in detail and the ontology demo (16:21)

Amanda hands to Marco, then continues the explanation of **Fabric IQ** while Marco fixes the network. "Foundry IQ helps unlock all of the information your organization knows; Fabric IQ helps them understand what's happening in real time." It lets agents connect to organizational data — the metrics, semantic models, and reports describing the current state of the business — so they can reason with the same context people use to make decisions every day.

Three outcomes: a shared understanding of how the business operates, insights that turn into actions, and agents that can reason over business context (not just raw data).

**Architecture (three layers)**:

| Layer | Description |
|-------|-------------|
| **1 Lake (OneLake)** | A single unified data layer bringing together analytical and operational data across systems and clouds — even non-Microsoft databases — without constantly moving or duplicating it. Every team, application, and agent works from the same source of truth, eliminating silos and re-authentication/authentication errors |
| **Semantic models** | Bridge data and business meaning, defining the metrics and concepts teams use to run the business. Crucially, Fabric IQ can pick up what you have **already defined in Power BI** and let agents reason over it, so an agent answering "what happened" gets the same answer your Power BI dashboards, your analysts, and your executive reports deliver |
| **Ontologies** | The live model of the business — entities, relationships, rules, and processes — so agents reason about customers and orders, not just tables, schemas, and rows. You can bootstrap an ontology from existing semantic models or create one from scratch |

All three layers live in Fabric, co-located with the data they describe, rather than stitched together.

**Demo: ontology generation (22:20)**

Due to the network outage, pressing the **"Generate ontology"** button does nothing — Marco presses it anyway "just for the feeling" and narrates that, as expected, nothing happens (not even a loading screen). He falls back to a pre-generated ontology (a graph of packages, customers, and drivers).

Marco explains the difference between an ontology and a semantic model: the semantic model defines relationships between tables (e.g., packages and drivers, the one-to-manys), but **an ontology's nodes are business entities, not tables, and its edges are verbs, not table relationships** — a customer can *send* or *receive* a package; a package can be *sent to* a customer. You can also add metadata/semantics — for example defining what "a package" means to your business and its synonyms ("box," "case," "shipment") — so the ontology helps the agent convert whichever word a user uses into the underlying query.

**Key concept: context delegation (25:39)**

Every agent sits on top of a model, and every model has a finite context window — "there's only so much you can put in your agent's head." Querying a structured data source like a lakehouse directly requires tons of context: what each data source is, the data dictionary, example queries, and ancillary instructions. The solution is the **Fabric Data Agent**:

- A separate sub-agent connected to the ontology, the lakehouse, and other data sources
- It holds all the business-specific context, including internal/tribal terminology — Marco's example is the acronym **SRC = Shipping Refund Concession**, which is specific to this business, isn't in the data or the data dictionary, and the model would never know unless you define it
- Downstream agents don't have to keep all that context in their own heads — they "**phone a friend**" by calling the Fabric Data Agent to get the structured data
- **An ontology can be exposed directly as an MCP server**, so you can connect agents to it
- You can also connect **Foundry IQ to a Fabric ontology** — under the hood it connects to that same MCP server, using the ontology as a data source. In this demo Marco intentionally connected to the Fabric Data Agent (rather than directly to the ontology) so all that delegated context lives in one place.

**Customer example: Qcells (Quanta / "Quanwa Q Cells" in captions)** — manages energy for AI data centers, facing problems too dynamic and complex for humans to reason about alone. They used Fabric IQ to build an operational model of the data center understood by people, applications, and AI agents. That common understanding lets agents reason about the business, recommend actions, and continuously optimize operations — all while **keeping human operators in control** and not replacing human judgment.

---

## 7. Work IQ in detail and the agent-identity demo (27:46)

While Marco continues trying to restore the network, Amanda explains **Work IQ** in depth. It is "the **people layer** of Microsoft IQ." It takes all the context of what your organization knows — what you discuss over email and Teams, and all the data living in M365 — and imbues agents with it, so an agent understands your business processes, who is involved in a project, what's important, what decisions have already been made, and what needs attention next. The most valuable context in an organization isn't just data; it's the people collaborating to get work over the finish line.

**What makes Work IQ different from the Graph or traditional APIs (3 things)**:
1. **Built for agents, not users**: Traditional API/Graph access was designed at human scale; Work IQ is designed for the speed an agentic process needs.
2. **Organizational context, not raw data**: Built around organizational context so agents can reason, rather than handing back raw data.
3. **Built on top of your existing security model — not a copy of it**: All Work IQ data stays in your M365 context and tenant. Developers don't have to index the information, extract data from M365, or build their own retrieval pipelines or governance layer.

**Four capabilities brought into a single intelligence layer**:
- **Chat**: Agents interact with people and other agents, supporting conversational experiences (e.g., agent-to-agent collaboration in Microsoft Copilot).
- **Text**: Grounded understanding of what's happening across the organization, drawing from emails, meetings, Teams chats, documents, and conversations — without developers building their own retrieval orchestration or index.
- **Tools**: A simplified, governed way for agents to retrieve information and **take action just as any user would** in M365 (send an email, send a message), via agent-friendly services.
- **Workspaces**: A persistent place for agents to store intermediate work product. As agents run longer tasks, they need to maintain state and share progress across phases of a plan with other agents or with humans they collaborate with.

**Miro partnership**: Miro integrates with Work IQ, bringing M365 context (documents, conversations, the relevant people, decisions) directly into the Miro canvas. Instead of copy-pasting between tools or working from stale snapshots, teams access the same live M365 context directly — shared context flows seamlessly from M365 into Miro and back.

**Network restored (33:06 / 33:31)**: A gentleman from the audience came up and suggested "try turning off GlobalProtect." Marco disabled the GlobalProtect VPN and the connection returned — "it turns out it was globally protecting you all from seeing my demos." Marco thanks him profusely, calling it "the most catastrophic failure I've ever had on any stage anywhere," and jokes the man came "from heaven, somewhere from Valhalla."

Post-recovery demo:

1. **From Foundry to M365**: The agent defined in Foundry (the refund agent) became a **blueprint in M365**, which in turn became an **agent template** (34:10).
2. **Instantiation and org-chart registration**: Any user can go into **Teams and create an instance** of that template. The template by itself is not an agent — instantiating it creates the agent. Marco didn't just create an agent, he created *his* agent: in the **org chart**, the agent has **its own identity and reports to Marco** (35:24), who in turn reports to Amanda Silver.
3. **Its own Teams box and inbox**: The agent instance has its own Teams box and its own email inbox.
4. **Real email handling**: Marco had earlier forwarded the agent an email from **Maria Garcia** about a package that hadn't arrived, delegating that work. The refund-processor agent checked its own inbox via Work IQ and **emailed Maria back, copying Marco** — apologizing (in this demo it couldn't find the package, "full of challenges here today") but completing the send-reply-with-CC flow on its own.

**Work IQ security model**:
- Via Copilot CLI, Work IQ logs in **as the user** and inherits all of the user's rights and permissions — it can do anything the user can do.
- An **agent instance** ("autopilot agent") lives in **its own security space with its own rights and permissions** — e.g., "you can send and receive emails but can't write Word documents," or "you can only draft emails, not send them" — enabling least-privilege control distinct from the human's permissions.

Marco summarizes Work IQ as "the **agent-facing headless version** of all the Microsoft apps — Outlook, Teams, SharePoint, and Word" (36:29), which is how the agent interacts with these Microsoft services using its own identity.

---

## 8. Closing and the importance of governance (39:49)

Amanda wraps up with a synopsis and the session close. Marco quickly revisits all four IQs now that the network is back:
- **Web IQ**: the earlier **Sandy Fire** query now returns results in just a couple of seconds, grounding the agent in real-time data about how the fire is affecting the business.
- **Foundry IQ**: shown working.
- **Fabric Data Agent**: Marco shows the context he had loaded — data sources with descriptions, data dictionaries, example queries, and ancillary instructions, including the **SRC** acronym — context you put in Fabric so you don't have to give it to every downstream agent.
- **Work IQ**: the agent literally reading and sending email. As a final flourish, Marco retries the Copilot CLI flow ("Work IQ as me") and it now successfully asks Work IQ and finds Amanda's email.

Amanda stresses they "always want to do live demos" rather than canned screenshots, and thanks the audience for bearing with them. She frames the whole demo as **agentic delegation grounded in real context**: one refund agent grounded in the web (real-world data via Web IQ), the people interaction and historical team collaboration (Work IQ), the business ontologies/semantic context (Fabric IQ), and the enterprise knowledge the agent works over (Foundry IQ). Critically, Marco "embodied" the agent by giving it an **addressable name in the org chart**, so it can be emailed and interacted with in Teams — a vital capability because you're building for people who work in M365 and Teams and don't want to learn a different technical UI.

**Governance foundation**: Every layer of Microsoft IQ is built on the same foundation of **identity, governance, and security**.
- Agents are **permission-aware by default**
- **Every action is traceable and explainable**
- **Policies are applied consistently across the entire agent ecosystem**

Amanda also reframes the goal: filling agents with *more* information makes them expensive to operate; the point is giving them the *right* context so they make the best decision with the minimum information needed at the highest confidence. "It's the intelligence that makes agents useful, and the trust that makes them deployable."

**Scaling challenge**: The real challenge isn't building a single agent in an intelligent environment — it's building thousands of them, governing them across the whole organization, trusting and deploying them without bespoke per-agent monitoring, in a unified way.

**Next actions (as presented by the speakers)**:
- Try the **hands-on lab** that goes deep on all four IQs
- Visit the **booth** at Microsoft Build
- Join the **discussion on GitHub**
- Join the **Agents League hackathon** (43:18) — build with everything shown today, from creative applications to autonomous agents to enterprise-grade systems

Marco signs off thanking the audience for bearing with them and wishing everyone a great Build (and to "enjoy the cold, cold San Francisco summer").

---

## Summary: core messages and announced features

**Core messages**:
- Agents fail because of **missing context, not weak models** — 40%+ of agentic AI projects are expected to fail for this reason.
- **Microsoft IQ** is the unified context layer for the agentic web, combining **Work IQ, Fabric IQ, Foundry IQ, and Web IQ** so agents share an understanding of an organization's people, data, workflows, and policies.
- The recurring architectural principle is **delegation** (define context/knowledge once, reuse it across many agents) and **context delegation** (sub-agents like the Fabric Data Agent hold heavy context so downstream agents "phone a friend").
- Every IQ is built on a common foundation of **identity, governance, and security**: permission-aware by default, traceable, consistently policed — designed for governing thousands of agents at scale.
- Agents can take on their **own identity** in the M365 org chart, with their own inbox/Teams presence and their own least-privilege permission space.

**Announced features**:

| Feature | Status | Description |
|---------|--------|-------------|
| **Microsoft IQ (overall)** | Announced / available (coverage varies per IQ) | Unified context layer combining Work/Fabric/Foundry/Web IQ for agents |
| **Work IQ** | Available (integrated into M365 Copilot; installable in Copilot CLI) | Agent-facing "headless" access to M365 (email, Teams, SharePoint, Word); agent identity, org-chart integration, dedicated inbox/Teams box; 4 capabilities (Chat, Text, Tools, Workspaces) |
| **Web IQ** | Available today for a few Azure customers | Sub-200ms P95 multimodal web/news/image/video grounding platform with passage-level ranking and citations |
| **Foundry IQ** | Available | Unified enterprise knowledge layer with agentic retrieval (sub-agent) and built-in security/governance/policy |
| **Foundry IQ serverless developer tier** | Newly announced in this session | An easy on-ramp for every developer to start building with Foundry IQ and scale to production |
| **Fabric IQ** | Available | Agent access to business data via OneLake (1 Lake), Power BI semantic models, and ontologies; can expose an ontology as an MCP server |
| **Fabric IQ ontology auto-generation ("Generate ontology")** | Demoed (GA/Preview status not stated) | AI-generates an ontology from an existing Power BI semantic model |
| **Agent templates / agent identity (Foundry to M365 blueprint)** | Demoed live (GA/Preview status not stated) | Foundry-defined agent becomes an M365 blueprint then an agent template; instantiated from Teams with its own org-chart identity, inbox, Teams box, and permission space |
| **Fabric Data Agent** | Available (used in demo) | A dedicated sub-agent connecting ontology + lakehouse + other sources, holding delegated context (data dictionary, example queries, business acronyms like SRC) so downstream agents "phone a friend" |

## Next actions
- Join the **hands-on lab** that goes deep on all four IQs (Work / Fabric / Foundry / Web IQ).
- Visit the Microsoft Build **booth** to talk with the team.
- Join the **discussion on GitHub** and share what you're building.
- Enter the **Agents League hackathon** to build with today's technology — from creative applications to autonomous agents to enterprise-grade systems.
- Try **Foundry IQ's new serverless developer tier** to start building immediately and scale to production when ready.
