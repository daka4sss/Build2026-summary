# BRK251 — Build Secure, Enterprise-Ready Agents with Microsoft Agent 365 (Build 2026)
## Theme: Agent 365 — the control plane to Observe, Govern & Secure every agent

**Session**: Microsoft Build 2026, BRK251 — *"Build secure and enterprise-ready agents with Agent 365"*
**Speakers**: Neda (host), Kendra (Agent 365 value/architecture), Aarthi (end-to-end onboarding demo), + Ray (Co-Founder, Genspark — partner integration)
**Session URL**: https://build.microsoft.com/en-US/sessions/BRK251
**Focus of this write-up**: **Microsoft Agent 365** — the enterprise control plane for *any* agent (Microsoft, third-party, and custom), centered on the **Observe / Govern / Secure** pillars and the Entra + Defender + Purview + Intune foundation.
**Sources**: official WebVTT transcript + Build 2026 primary sources (Microsoft Security blog, Microsoft 365 blog, Microsoft Learn, GitHub). Every status below was adversarially re-verified against primary docs; see Appendix.

---

## 1. Executive Summary

BRK251 answers one question: *how do you make the agents your organization is already building **enterprise-ready** — discoverable, observable, identity-bound, threat-protected, data-secure, and governed?* The answer is **Microsoft Agent 365**, positioned as the **control plane for any agent** — Microsoft-built, common third-party (Workday, Genspark, cowork, researcher…), and custom agents on LangChain, AWS Bedrock, Google Vertex AI, and more. IDC's framing motivates the scale problem: **~1.3 billion agents in organizations by 2028**.

Agent 365 organizes everything into **three pillars**:

1. **Observe** — *"you can't govern what you can't see."* A single registry/inventory across every platform, with adoption/usage analytics, per-agent metadata, identity history, activity, and connected-agent maps.
2. **Govern** — guardrails that *speed up* (not brake) adoption: reusable **Templates**, automation **Rules**, ownerless-agent management, a publish/approval flow, and **Registry Sync** for other clouds.
3. **Secure** — agents treated like employees: **Entra** identity, **Defender** real-time threat detection/blocking, **Purview** data governance, **Intune** shadow-AI detection.

Architecturally Agent 365 is a "stool": the **seat** is the end-to-end governance platform; the **legs** are **Microsoft Entra** (identity), **Microsoft Defender** (threat protection), **Microsoft Purview** (data governance), and **Microsoft Intune** (shadow-AI detection). To bring *non-Microsoft* agents under that control, the **Agent 365 SDK** (a *wrap-and-discover* SDK, **not** a build/host SDK) adds an agent ID, observability, security policy, and a tools gateway to any framework. Aarthi's demo took a **LangChain Node.js travel agent** from VS Code to a fully governed Agent 365 "employee" — agent identity, observability, Work IQ tools (Word/OneDrive), Teams + Word `@mention` interaction — using shippable **Agent 365 skills** invokable from VS Code / GitHub Copilot / Claude Code.

**The status story** (the key nuance): **Agent 365 became GA on May 1, 2026** (USD **$15/user/month** standalone, or bundled in **Microsoft 365 E7**), and so are its identity/SDK/observability core, **Templates**, **Rules**, the admin-center registry, risk-surfacing/block, ownerless management, **Network Controls**, and **Windows 365 for Agents**. Several high-value capabilities are still **Public Preview** — **Registry Sync**, **Shadow AI Discovery**, the **Graph package APIs**, **agents participating in team workflows** — and the **Defender** runtime threat-protection and most **Purview** runtime-DLP-for-agents pieces are **Preview / coming soon**, partly gated to the **Frontier** program.

---

## 2. Key Update (feature-level)

> Status legend: **GA** = generally available · **PuP** = Public Preview · **Mixed** = base GA + preview sub-feature.

### 2.1 Platform, identity & SDK

| # | Feature | What's new at Build 2026 | Status |
|---|---------|--------------------------|--------|
| 1 | **Microsoft Agent 365 (control plane)** | Unified plane to Observe/Govern/Secure *any* agent; admin surface = Microsoft 365 Admin Center. **$15/user/mo** or in **M365 E7**. | **GA** (May 1, 2026) |
| 2 | **Agent 365 SDK** | *Wrap-and-discover* SDK (not build/host): adds Entra identity, OTel observability, Activity-protocol notifications, governed MCP/Work IQ tools, blueprint inheritance — to any framework (Copilot Studio, Foundry, MAF, M365 Agents SDK, OpenAI Agents SDK, Claude Code SDK, LangChain). .NET / Python / Node.js. | **GA** |
| 3 | **SDK Observability (OpenTelemetry)** | Audited, traceable interactions, inference events, tool usage; feeds admin center, Defender, Purview. | **GA** |
| 4 | **Agent 365 CLI / dev tools + skills** | `a365` CLI (blueprints, Work IQ tools, deploy to Azure, publish to admin center) + ~6 shippable **Agent 365 skills** (incl. two "make" skills) usable from VS Code / GitHub Copilot / Claude Code. | **GA** (CLI ships stable; docs unbadged) |
| 5 | **Entra Agent ID + agent blueprint** | Entra-backed agent identities (uplevel from service principal); 4 object types — **blueprint**, blueprint principal, **agent identity**, **agent user**; parent-child blueprints for consistent policy; 2 auth modes (on-behalf-of user vs own user identity). | **GA** (available to all Entra customers) |

### 2.2 Observe — registry & visibility

| # | Feature | What's new at Build 2026 | Status |
|---|---------|--------------------------|--------|
| 6 | **Agent Registry (M365 Admin Center)** | Central inventory of all agents (Microsoft, partner, LOB/org-published, shared); summary cards, filtering, CSV export, upload custom agent. | **GA** (base) / **Preview** (unmanaged-local-agent surfacing) |
| 7 | **Agents-at-risk / risks & block** | Unified **Risks** column + "Agents at risk" card aggregating high-severity signals across Entra/Defender/Purview; per-agent Security flyout; one-click **block**. | **GA** |
| 8 | **Agents-without-owners management** | Detect ownerless shared agents in real time (on user deletion); one-click filter, block, delete, or **reassign**. | **GA** |
| 9 | **Connected-agents map / blast-radius** | Visual graph of agent relationships (Agent Map) + exposure/blast-radius analysis for "if I block this, what breaks?" | **Mixed**: map **GA**; blast-radius/exposure-graph **PuP** (Jun 2026) |
| 10 | **Microsoft Graph APIs (registry/details)** | Programmatic inventory/management (`GET packages`, `GET package details`); works with AI Admin role. | **PuP** |

### 2.3 Govern — policy, automation & cross-cloud

| # | Feature | What's new at Build 2026 | Status |
|---|---------|--------------------------|--------|
| 11 | **Templates** *(hero feature)* | Bundle Entra + Purview + SharePoint + Defender policies into reusable templates applied at agent activation; 2 default templates + custom. | **GA** (AI-template / AI-teammate scenarios are preview, Frontier) |
| 12 | **Agent management Rules** | Rule-based bulk governance: install Microsoft 1P agents tenant-wide; reassign ownerless Agent-Builder agents to manager via Entra hierarchy. | **GA** |
| 13 | **Publish / approval flow & agent upload** | Upload custom agent **ZIP** (manifest/config/icons/knowledge); choose publish + deploy audience; apply template; review permissions; deploy. | **GA** |
| 14 | **Registry Sync (cross-cloud)** | Connect & ingest agents from **Amazon Bedrock, Google Vertex AI, Salesforce Agentforce, Databricks Genie**; visibility + permitted platform actions; manual sync now (scheduled later). | **PuP** |

### 2.4 Secure — the Entra / Defender / Purview / Intune legs

| # | Feature | What's new at Build 2026 | Status |
|---|---------|--------------------------|--------|
| 15 | **Entra Network Controls extension** | Extends Entra network controls (incl. network-level prompt-attack blocking) to Copilot Studio agents and local endpoint agents (e.g. OpenClaw). | **GA** |
| 16 | **Defender threat protection for agents** | Real-time detection + runtime protection + advanced hunting; inspects the 3 points of the agentic loop (prompt / pre-tool / post-tool) to block prompt injection, leakage, unsafe tool use; endpoint runtime protection for Claude Code & GitHub Copilot CLI via agent hooks. | **Preview** (coming soon) |
| 17 | **Shadow AI Discovery (Defender + Intune)** | Discover unmanaged local/cloud agents (OpenClaw + 20+ types incl. MCP servers); policy-based block; asset-context mapping & runtime blocking phased in Jun 2026. | **PuP** (Frontier) |
| 18 | **Purview data security for agents** | DSPM for AI, runtime DLP for agent prompts, sensitivity labels, audit, IRM, eDiscovery; agentic risk detection for coding agents (Claude Code, Copilot, Codex, OpenClaw). | **Preview** (Foundry Control Plane data-risk signals **GA**) |
| 19 | **Agents participating in team workflows** | Agents operate with their own access/identity inside team environments (AI-teammate). | **PuP** (delegated & behind-the-scenes own-access modes **GA**) |
| 20 | **Windows 365 for Agents** | Cloud PCs purpose-built to run any agent in fully isolated, policy-governed environments with native Windows integration. | **GA** (was US-only preview on May 1) |

---

## 3. Update detail

### 3.1 Why Agent 365 — the problem and the pillars

Neda set the stakes: nearly everyone is *building/using* agents, but almost no one calls them *enterprise-ready, observed, secure, and governed*. Three agent shapes coexist in the enterprise: **SaaS agents** (pre-built into apps), **endpoint agents** (OpenClaw, CLI-built, etc.), and **cloud agents** (built on various clouds/frameworks). The unanswered questions — *Can we discover them all? Are they behaving to intent? Misusing tools? Over-sharing/leaking data? Auditable?* — are precisely what Agent 365 exists to answer.

The product is structured around **Observe → Govern → Secure**:

- **Observe** — *"you cannot govern what you cannot see, and you cannot trust you're protected if you don't know what agents are out there."* Full visibility across platforms plus adoption/usage/platform trends and the actions to keep the ecosystem safe.
- **Govern** — explicitly framed *not* as a brake on innovation but as **guardrails that speed adoption**: the right protections apply every time, for every agent, based on its risk — regardless of who built it.
- **Secure** — secure agents like any employee/asset: with **Defender, Purview, and Entra** you block threats in real time *and* go further — deep hunting/investigation, full **Purview** step-by-step logs per incident, and finding *other* agents with similar vulnerabilities before they're exploited.

### 3.2 Architecture — the "stool", and how third-party agents are covered

Foundationally Agent 365 is the **end-to-end governance platform** (the seat). The **legs** are the enterprise security solutions that hold it up:

| Leg | Role |
|---|---|
| **Microsoft Entra** | Identity management (agent identities) |
| **Microsoft Defender** | Risk assessment + real-time threat detection & blocking |
| **Microsoft Purview** | Data governance |
| **Microsoft Intune** | Shadow-AI detection |

Coverage works in four ways:
1. **Microsoft-built agents** — native experience, every agent (draft → production) visible out-of-the-box with policy templates, observability, and actions, **no extra effort**.
2. **Partner agents** — an ecosystem program proactively extends the SDK (agent ID + observability) into partner agents (Workday, Genspark, etc.).
3. **Custom agents** — onboard via the **Agent 365 SDK** (identity, observability, tools, messaging, threat protection, governance, data security — adopt only what you want).
4. **Connected platforms** — **Registry Sync** ingests agents from other clouds (Bedrock, Vertex AI, …) for visibility plus whatever actions those platforms' APIs permit.

### 3.3 The Agent 365 SDK — wrap any agent (GA)

The single most-misunderstood point Kendra stressed: **the SDK is not an agent-building or hosting SDK.** It **wraps** an agent you already built and makes it discoverable and governable within Agent 365. It went **GA** (Build 2026 Security blog: *"With the general availability of the Agent 365 SDK, developers can integrate controls directly…"*). It layers on:

- **Entra-backed agent identity** (give your agent an agent ID),
- **OpenTelemetry observability** (audited interactions/inference/tool usage feeding admin center, Defender, Purview),
- **notifications via the Activity protocol** (Teams, Outlook, Word comments, email — an endpoint so the agent can be `@mentioned`),
- **governed MCP / Work IQ tools** (Word, OneDrive, PowerPoint, Outlook),
- **blueprint inheritance.**

Available in **.NET, Python, and Node.js/TypeScript**, with extensions for LangChain, OpenAI Agents, Semantic Kernel, Foundry, and Claude. (Note: docs now recommend the **Microsoft OpenTelemetry Distro** over the original Observability SDK, which still works without breaking changes.)

**Onboarding via skills (the demo).** Rather than stitch concepts together by hand, Microsoft ships **~6 Agent 365 skills** (including two "make" skills) invokable from **VS Code, GitHub Copilot, or Claude Code** (`/skills` → `agent365`). The other skills are piecemeal: get an identity, instrument observability, add Work IQ MCP servers, test locally. Aarthi ran *"make this agent ready for Agent 365"* on a **LangChain Node.js travel agent**; the coding agent detected the stack (Node.js/LangChain/TypeScript), checked prerequisites, installed the latest **Agent 365 CLI**, targeted the tenant, and produced a plan: install packages → add a valid build → add **observability**, **Work IQ**, **register**, **publish**, **deploy**. End result (~10 min): a **blueprint**, an agent identity (created at admin activation), configured observability (OpenTelemetry), chosen **Word + OneDrive** MCP servers, a manifest, and a notifications endpoint.

### 3.4 The fundamental terms — blueprint & agent identity

Two terms Kendra called "fundamental for success":

- **Agent blueprint** — a *reusable instruction/recipe* defining the tools, data, rules, and guardrails an agent may use. Other agent identities are created from it; parent-child relationships let one blueprint enforce consistent policy across many instances.
- **Agent identity** — an identity **upleveled from a service principal toward a user-level identity**, because *agents are built like apps but function like users.* Two authentication modes:
  - **On behalf of the user** — when invoked, the agent assumes the user's credentials/permissions and passes that as the auth token.
  - **Own (agent user) identity** — the agent maintains its own identity and permissions and acts independently.

This sits on **Microsoft Entra Agent ID** (GA, *"available for all Microsoft Entra customers"*), which formalizes four object types — **agent identity blueprint, blueprint principal, agent identity, agent user**. Security sub-features (Conditional Access, ID Protection, ID Governance, network controls) require their respective Entra/E5 tiers.

### 3.5 The end-user experience — agents as colleagues

After onboarding, the persona shifts. As an **agent user** in **Teams**, Aarthi created her own **instance** of the travel agent (reporting to her), asked it to plan a post-Build trip *and* produce a **Word document** — then collaborated inside that document by **`@mentioning` the agent** ("can I get some coffee places as well?"). Because onboarding created a **notifications endpoint**, the agent responds not just over Teams but to **Word comment `@mentions` and emails** — exactly like an employee. The agent can be **hosted anywhere** (the demo used Azure, but GCP/AWS/any cloud works). **Observability** serves three audiences: developers (what's my agent doing?), end users (how did my interactions go, including failures?), and IT admins (the **blueprint** and all its **instances** — e.g. colleagues with their own copies — with cross-instance activity and per-user usage).

### 3.6 Observe — the admin registry (M365 Admin Center)

The admin surface is the **Microsoft 365 Admin Center**:

- **Overview** — total agents, total (human) users, total runtime hours; **calls to action** (pending approval requests, **agents at risk**, **agents without owners**, agents with exceptions); granular analytics (built-by-org vs third-party vs Microsoft, top platforms, adoption over time, trending agents). *(Multi-tenant is in progress; today it's single-tenant.)*
- **Agent Registry** — every agent across platforms (Workday, Genspark partner agents, etc.), sliceable. **GA** for the base experience (four agent types, summary cards, publisher/channel/platform/data-source filters, CSV export, upload custom agent); the surfacing of **unmanaged local agents** (20+ types incl. MCP servers, via Defender/Entra/Intune) is **Preview**.
- **Per-agent view** — metadata (what it does, published/updated, publisher, owner, agent ID), **full identity history** (bot ID, blueprint ID, Entra agent ID; environment details for Copilot Studio / platform link-out for Foundry), users it's shared with, **Data & tools**, applied **policies** (drill into Purview/Entra), permissions, and a **unified activity view** across all agent types (users, sessions, exceptions, runtime hours, successful sessions, error/exception spikes, top traffic-driving users).
- **Connected-agents map** — a visual graph aggregating agents by platform, showing multi-agent dependencies and, critically, **blast radius**: *"if I block this agent, what else breaks?"* (The relationship **map is GA**; the **exposure-graph/blast-radius** assessment arrives via Defender/Intune in **Public Preview**, June 2026.)
- **Graph APIs (Preview)** — programmatic registry/details (`GET packages`, `GET package details`) for the AI Admin role.

### 3.7 Govern — Templates, Rules, publish flow, Registry Sync

- **Templates (GA, "hero feature").** Aggregate custom policies from across **Entra + Defender + Purview + SharePoint** into one reusable template, applied consistently at agent activation. Two default templates ship (one for all agents except AI teammates; one for AI teammates in Frontier) plus custom templates (which add Entra **Conditional Access**, access packages, custom security attributes). Default policies span Purview audit/DSPM/compliance, Entra identity protection/lifecycle/network visibility, SharePoint access/sharing, and Defender real-time protection + advanced hunting. (*AI-template* scenarios and AI-teammate templates are **preview**, Frontier-only.)
- **Rules (GA).** Bulk governance automation: **install Microsoft (1P) agents** tenant-wide, and **reassign ownerless Agent-Builder agents to the manager** via the Entra org hierarchy. Admins identify matches, review impacted agents, and apply in bulk — staying in the control loop. (Action set is currently narrow; Microsoft signaled heavy investment in risk-driven rules over coming quarters.)
- **Publish / approval flow (GA).** Upload a custom agent as a **ZIP** (manifest, config, icons, embedded knowledge) via *Agents → All agents → Add agent*; choose **publish audience** and **deploy audience**; apply a **security template** (default baseline → custom); review permissions; finish deployment. This is the IT-approval gate Aarthi referenced before an agent goes org-wide.
- **Registry Sync (Public Preview).** Connect external platforms — **Amazon Bedrock, Google Vertex AI, Salesforce Agentforce, Databricks Genie** — authenticate once per environment, and **ingest those agents into the registry** for visibility. Any management actions the platform's API permits (e.g. deleting a Vertex AI agent) are surfaced too. Manual sync now; scheduled sync "in a future release."

### 3.8 Secure — the four legs in detail

- **Entra Network Controls extension (GA).** Extends Microsoft Entra network controls to **Copilot Studio agents** and **local endpoint agents** (including OpenClaw), inspecting agent traffic at the network layer to **block malicious prompt-based attacks** and add visibility.
- **Defender threat protection for agents (Preview).** Real-time detection, runtime protection, and advanced hunting for AI agents. Defender inspects the **three points of the agentic loop** — user prompt, pre-tool call, post-tool response — to block **prompt injection, data leakage, and unsafe tool use** across Work IQ MCP / Copilot Studio / Foundry, plus **endpoint-level runtime protection** for local coding agents (**Claude Code, GitHub Copilot CLI**) via agent hooks. (Both Defender Learn pages are titled *(Preview)*; the Build blog says *"Preview of these capabilities coming soon."*)
- **Shadow AI Discovery (Public Preview, via Defender + Intune).** Discover **unmanaged local/cloud agents** — OpenClaw detection/blocking for Frontier-program customers, expanding to **20+ local agent types** (incl. MCP servers). Phased **June 2026** additions: asset-context mapping (devices, MCP servers, identities, cloud resources), policy-based guardrails, runtime blocking + malicious-behavior alerts. (BRK251 cited "22+" local platforms; published docs say "more than 20.")
- **Purview data security for agents (Preview, mixed).** Runtime **DLP for agent prompts** is *"in preview with Agent 365"*; **agentic risk detection** for coding agents (Claude Code, GitHub Copilot, OpenAI Codex, OpenClaw) is *"Preview… coming soon"*; whereas Purview data-risk signals in the **Foundry Control Plane** are **generally available**. Default Agent 365 templates also enable Purview audit, DSPM detection in AI interactions, and AI compliance assessment as built-in policies. Sensitivity labels on a Word document automatically apply to agents, and Purview policies auto-block sensitive over-share/leakage (the property Genspark relied on — no second security layer needed).
- **Windows 365 for Agents (GA).** Cloud PCs purpose-built to run *any* agent in a fully isolated, policy-governed environment with native Windows integration. (Status moved from *"public preview, US-only"* on May 1 to **GA** at Build on June 2.)
- **Agents participating in team workflows (Public Preview).** Agents operating with their own access/identity in team environments (the AI-teammate concept). The delegated-access and behind-the-scenes own-access modes are **GA**; *participating in team workflows* specifically is the preview-stage piece.

### 3.9 Customer momentum & the Genspark partner integration

- **EY** — for mission-critical agents, Agent 365 provides the **trust** to unlock and confidently operate agents across the org.
- **Genspark** (Ray, Co-Founder) — *Genspark* is a unified AI workspace used by **2,000+ organizations**. Their Agent 365 integration is a **thin Python SDK layer** between the Microsoft software suite (Teams/Outlook/Word) and Genspark's **flexible back end** (lightweight chat-based AI tools *and* heavyweight dedicated VMs for big-compute jobs). The three primitives they consume:
  1. **Identity** — federated identity credentials; they **authenticate every message** (not just at session start), so a Teams group-chat `@mention` from a user outside the agent's tenant is refused — **no custom auth layer needed**.
  2. **Unified UI/UX** — MCP access to PowerPoint/Outlook/Word lets Genspark generate a deck or doc on the fly and write it back to the user's OneDrive — **no custom storage layer needed**.
  3. **Observability + Purview + lifecycle** — every agent action is logged to **Purview**; the agent's unified identity means enterprise Purview policies (sensitivity labels, DLP) auto-apply; IT admins query all agent logs with the **same Microsoft APIs/SQL** — **no custom security layer needed**.

---

## 4. Appendix — all sources

### 4.1 Provided / primary blogs (Build 2026)
- **Microsoft Agent 365, now generally available, expands capabilities and integrations** (Microsoft Security Blog, May 1 2026) — https://www.microsoft.com/en-us/security/blog/2026/05/01/microsoft-agent-365-now-generally-available-expands-capabilities-and-integrations/
- **Microsoft Build 2026: Securing code, agents, and models across the development lifecycle** (Microsoft Security Blog, Jun 2 2026) — https://www.microsoft.com/en-us/security/blog/2026/06/02/microsoft-build-2026-securing-code-agents-and-models-across-the-development-lifecycle/
- **Announcing the new Work IQ APIs** (Microsoft 365 Blog, Jun 2 2026) — https://www.microsoft.com/en-us/microsoft-365/blog/2026/06/02/announcing-the-new-work-iq-apis/
- **Microsoft Agent 365: The control plane for AI agents** (Microsoft 365 Blog, Nov 18 2025) — https://www.microsoft.com/en-us/microsoft-365/blog/2025/11/18/microsoft-agent-365-the-control-plane-for-ai-agents/
- (Index pages searched per request) **Microsoft 365 Blog** — https://www.microsoft.com/en-us/microsoft-365/blog/ · **Microsoft Security Blog** — https://www.microsoft.com/en-us/security/blog/

### 4.2 Microsoft Learn (primary docs)
- **Overview of Microsoft Agent 365** — https://learn.microsoft.com/microsoft-agent-365/overview
- **Microsoft Agent 365 SDK Overview** — https://learn.microsoft.com/microsoft-agent-365/developer/agent-365-sdk
- **Agent 365 SDK & CLI — developer hub** — https://learn.microsoft.com/microsoft-agent-365/developer/
- **Observability SDK** — https://learn.microsoft.com/microsoft-agent-365/developer/observability
- **Manage agent registry in Microsoft 365 admin center** — https://learn.microsoft.com/microsoft-365/admin/manage/agent-registry?view=o365-worldwide
- **Agent settings — Rules, Templates, Allowed agent types** — https://learn.microsoft.com/en-us/microsoft-365/admin/manage/agent-settings
- **Agent templates** — https://learn.microsoft.com/en-us/microsoft-agent-365/admin/agent-template
- **Registry sync in the Microsoft 365 agent registry (preview)** — https://learn.microsoft.com/en-us/microsoft-agent-365/admin/agent-registry
- **What is Microsoft Entra Agent ID?** — https://learn.microsoft.com/en-us/entra/agent-id/what-is-microsoft-entra-agent-id
- **Agent identities vs service principals** — https://learn.microsoft.com/en-us/entra/agent-id/agent-service-principals
- **Identity governance for agents — object types & lifecycle** — https://learn.microsoft.com/en-us/entra/id-governance/agent-id-governance-overview
- **Detect, block, and investigate threats to AI agents using Microsoft Defender (Preview)** — https://learn.microsoft.com/en-us/defender-xdr/security-for-ai/ai-agent-detection-protection
- **AI agent runtime protection with Microsoft Defender for Endpoint (Preview)** — https://learn.microsoft.com/en-us/defender-endpoint/ai-agent-runtime-protection-overview
- **Secure AI agents at scale using Microsoft Agent 365** — https://learn.microsoft.com/en-us/security/security-for-ai/agent-365-security
- **Establish governance & security across the organization for AI agents (Cloud Adoption Framework)** — https://learn.microsoft.com/azure/cloud-adoption-framework/ai-agents/governance-security-across-organization

### 4.3 GitHub
- **Agent 365 Samples** — https://github.com/microsoft/Agent365-Samples
- **Agent 365 dev tools (CLI)** — https://github.com/microsoft/Agent365-devTools
- (Agent resources hub, per request) **agent365** — https://microsoft.github.io/agent-resources/agent365/

### 4.4 Session
- **BRK251 — Build secure and enterprise-ready agents with Agent 365** — https://build.microsoft.com/en-US/sessions/BRK251 (transcript: `build-transcripts/Sessions/BRK251/transcript_clean.txt`)

### 4.5 Verification note
This summary was produced by fanning out web/Learn/GitHub research and **adversarially verifying** every feature claim (3 independent refutation attempts per claim; dropped only if ≥2 of 3 refute). 20 of 22 candidate features survived. Key status corrections applied vs. first-pass extraction: **Agent 365 GA = May 1, 2026** ($15/user/mo or M365 E7); **CLI** resolved toward **GA** (stable NuGet package, no preview badge); **Windows 365 for Agents** corrected to **GA** (was US-only preview); and the **base-GA vs. preview-sub-feature** split is called out per row (Registry base GA vs. unmanaged-local-agent surfacing preview; Templates GA vs. AI-teammate scenarios preview; Defender/Purview runtime pieces preview). The "22+ local platforms" figure is from the talk; published docs say "more than 20."
