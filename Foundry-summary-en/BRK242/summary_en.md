# Microsoft Build 2026 BRK242 "Turn your agents into action: Connect tools, APIs, and documents" — Detailed Summary

**Speakers**:
- **Maria Nagaga** — Product Manager at Microsoft, working on Foundry Tools
- **Joe Flick** — Microsoft, working on Content Understanding
- **Linda** (full name not given) — Foundry Tools team (prepared the demo backup toolbox; mentioned only briefly)

**Session URL**: https://build.microsoft.com/en-US/sessions/BRK242
**Source**: Official WebVTT transcript (medius.microsoft.com CAPTION)

---

## Overview

This is a technical session that tackles head-on two major challenges in building enterprise agents: the "complexity of tool integration" and the "accuracy of document understanding." Held on the afternoon of Microsoft Build Day 2, the room was a full house. Maria opened by apologizing that her voice might "go in and out" because she had a bit of a cold, and noted that, because of the full house, attendees would get "two talks in one."

The first half is delivered by Maria, introducing **Toolbox**, a new capability in Microsoft Foundry. She explains a mechanism for bundling multiple MCP servers, APIs, skills, and connectors into a single reusable bundle that any agent can consume through one unified endpoint. The second half is delivered by Joe, who goes deep on **Content Understanding** (a content-understanding service) and demonstrates how agents can use diverse content formats — PDFs, video, Office documents, and more — with high fidelity.

The thread running through the entire session is "deliver the right tools and accurate context to the agent." Three points are emphasized throughout: preventing context-window bloat (token savings), governance, and multimodal document understanding.

---

## 1. Microsoft Foundry as an Agent Platform (00:01)

Maria first laid out Microsoft's overall agent platform picture.

- Build on **GitHub** -> use **Foundry** as the platform -> optimize the agent runtime and provision the tools you need -> distribute through **Microsoft 365**.
- What Foundry provides: agent services, models, IQ tools, and a control plane. It lets you govern the lifecycle "from cloud to edge."
- Foundry Tools is designed as a "single hub" that brings prebuilt tools and third-party tools together in one place while giving you enterprise-grade scalability. In short, the goal is "one place for all your tools, regardless of tool type, to exist."

---

## 2. Three Challenges Facing the Tool Ecosystem (00:02)

LLMs provide the reasoning for an agent, and tool calling is what enables an agent to take action and deliver real business value. But as agents and tools rapidly grow, customers run into a host of problems. Maria framed three.

**Tool proliferation and confusion (steering the tools)**: "Who remembers the time when all we had was MCP?" Now there are skills, plugins, APIs, connectors, and "there's going to be foobar X bar" — the ecosystem will keep growing continuously. The challenge is steering the tools in the right direction.

**The true nature of tool discovery**: When people think about tool discovery, they think it is searching a registry and finding the right tool — but that is not tool discovery. Tool discovery is **choosing the best tool to complete the task while using the limited amount of tokens available**. Maria joked that when she asked who wants to use fewer tokens, "not a lot of people" raised their hands.

**Security and governance**: Tools reach into your production code, your databases, and your APIs and generate results, so keeping them secure is critically important. You must control not only how many tools the agent has access to and securely so, but also which individuals leveraging your agents can access which tools. Her recurring example: "I don't want Maria to have the same access of tools, but Linda does, because Linda is better at her job."

Maria then walked through the "fill-up agent" example: a single agent with **6 integrations** — Entra, SharePoint, ticketing, your own custom MCP or API, Teams, Blob storage, Azure Search. This sounds simple, but it is not: every one of those tools has its own identity, is built by a different team, follows a different set of protocols, and has different credential management. Multiply that across every integration for one agent — and then add your customer support agent, billing agent, networks agent, and inventory agent — and what seemed like 6 integrations ends up being hundreds of integrations, not even counting permissions and debugging failures. The result: developers spend more time doing integrations and less time doing what makes them money and makes their business better, which is building agents.

She also framed the solution landscape: it is an ecosystem of components Foundry is investing in. The **tool catalog** (discovering, publishing, installing tools) was already shipped in 2025 — Foundry hosts a catalog of tools custom-built from the ecosystem, and for a private registry you can use Azure API Center and Azure API Management. But the catalog only solves *finding* tools; *integrating* them is a separate problem. What remains to solve in the agentic ecosystem is **tool creation, tool discovery, and tool governance**.

---

## 3. The Toolbox Concept and Its Four Pillars (00:09)

Maria announced **Toolbox** as the solution — a new category of capability that was also referenced in Satya Nadella's keynote earlier (the day before).

**Definition of Toolbox**: "Toolboxes are a reusable bundle of tools managed in Foundry that agents can consume through a single consistent interface regardless of tool type."

Three keywords to pay attention to:
- **Reusable**: Build a set of toolboxes once and use them across any single agent. Build it once, use it everywhere.
- **Managed**: Foundry handles the lifecycle for you, so you don't have to.
- **Consistent interface**: Your agent shouldn't have to care what the underlying tool type is — whether MCP, an OpenAPI spec, a skill, or a connector. You get one unified endpoint with one OAuth and one experience that integrates into any single agent.

The four pillars:

| Pillar | Content |
|---|---|
| **Build** | Create tools as a named, reusable bundle; configure and publish them (e.g., put your Entra, SharePoint, and other configs into a single "fill-up toolbox") |
| **Discover** | When the agent makes a request through a prompt to the toolbox, it only retrieves the tool it requires to complete the task |
| **Consume** | A single MCP-compatible endpoint exposes every tool to any agent runtime |
| **Govern** | Centralized authentication and observability to monitor all your tool calls |

Key features built to deliver this:
- **Toolbox**: how you build them.
- **Tool Search**: the protocol that searches and discovers tools at runtime, so you only load the tool required to complete the task into the context window rather than everything.
- **Unified endpoint**: an MCP-compatible endpoint.
- **Control and visibility**: add your own policies and guardrails.
- **Governed dashboard** (future): a more detailed view, coming in the future.

**The promise of Toolbox** is that you can consume it across any agent — hosted agents, the GitHub Copilot CLI, the GitHub Copilot SDK, "cloud code" (Claude Code — "we want to get working in cloud code as well"), and soon Microsoft Copilot Studio applications. The lifecycle: you build a toolbox, you consume a unified endpoint, and you know it's all going to be governed.

---

## 4. Demo (1) — Building a Toolbox and Tool Search in Action (00:12)

Maria ran a live demo. (A permission issue forced her to switch screens mid-demo, which she joked through — "Who says CEOs are the only people who get demo ghosts in the background? I have one too" — and ultimately got everything working.)

**Without Toolbox (Before)**: You configure every single MCP endpoint separately. Maria pointed out that lines 33 through 104 of the sample were all configuration (OAuth, credentials, protocol setup) — and this was only **three** MCP servers. With more servers, or different protocols, it grows quickly. She added with humor that "this code doesn't run, it's 100% generated by AI," but promised working demo content would be shared.

**With Toolbox (After)**: "That's it." You configure authentication once, put all your servers into a specific toolbox, and it generates a URL you can drop into any application of your choice. The summary diagram: you go from manually wiring every single tool to a specific agent, to just attaching it to a toolbox exposed through a unified endpoint — and Tool Search makes the decision (e.g., "I need GitHub," so it directly picks the GitHub toolbox and loads only that into the context window).

**Tour of Foundry**: In Foundry, click **Build -> Tools**, and you see **Toolbox tools** and **Skills**. A toolbox can be built in code, in the Foundry portal, or through the Foundry toolkit.

**Skills upload demo**: From the Skills area, Maria uploaded a custom skill (an "art skill" that makes better architectural diagrams) from her desktop and gave it a name ("Must have Laura's face"). Once uploaded successfully, the skill became available to any single agent in her project. She noted she would also make it available in the repo.

**Browser Automation announcement**: Maria announced that **Browser Automation is "available today"** — a new tool built on Playwright that lets you scrape information and fill in forms. In the live demo (copy-pasting the prompt), it automatically filled in a Microsoft Form. (She noted the browser automation team was in the room and that she had a GIF as backup.)

**Creating a Toolbox**: Go into Foundry -> Toolbox -> Create -> give it a name -> add tools (showing every tool in the catalog) plus an option to add skills (including the skill she just created). Because of permission issues she switched to a backup toolbox that **Linda** had created. She noted the option to **turn Tool Search on/off**, turned it off for a moment, set the toolbox as **default**, which set the endpoint in her hosted agent to that specific toolbox version. She then asked her agent to "find me three" work orders — the agent went into a work order, found it, and checked whether the work order was complete and whether parts were available. After a pause (attributed to too many people on the network), the live demo worked.

**FIBI agent demo**: The unified endpoint was connected to the **FIBI agent**, hosted in an **Azure Container App**, using the exact same MCP endpoint. Maria directed attention to the **Activity (live) view**, where you can see which tools are called via Tool Search and how they were loaded.

She then handed over to Joe (noting they were short on time).

---

## 5. Content Understanding — Overview and Positioning (00:22)

Joe Flick took the baton to discuss how agents handle "content inside documents."

So far the talk had shown how Toolbox solves problems with agents accessing tools and saves tokens on tool calls. But in the real world, not all the content you want comes from an API — often the content you need is in a document, in a video, or in a PowerPoint deck, and the agent needs to go access it. When agents try, they often break, costs scramble and grow, they use more tokens. The agent tries to write custom code to "crack" the PowerPoint, it might miss content, or it might find a table but fail to access the data in it. These are the problems Content Understanding was built to solve.

**Definition of Content Understanding**: "Content Understanding takes messy multimodal content and turns it into clean, structured, agent-ready output." Any kind of file comes in; it gets parsed, classified, and extracted, and turns into structured JSON with key-value pairs and markdown that represents the details of the file with high fidelity.

This is not a brand-new service: it has been **GA since about six months ago** and **in production for a year and a half**. **Foundry IQ** uses it as its content-extraction layer to get the highest-fidelity version of the input as grounding for agents, and **Microsoft 365 Copilot** uses it when you ask a question about a document or PDF.

Customer examples:
- **Wolters Kluwer** (trusted professional tools for tax automation, legal, and healthcare): uses Content Understanding in their **CCH Axcess Tax** product to ingest tax forms, supporting documents for taxes, and other financial documents in structured format, automating tax-prep processing end to end.
- **Data Sniper** (an agentic platform for audit and finance): uses Content Understanding to power their AI extraction capability, taking any kind of document directly into Excel — where financial professionals want to live — in structured format. They describe it as enabling "faster reviews, more reliable evidence, and trustworthy AI."

---

## 6. The Content Understanding Pipeline in Detail, and Upcoming Improvements (00:25)

Content Understanding is a single pipeline that does **Parse -> Classify -> Extract**, available for any modality (video, image, document, PDF, and even older formats like ZIP files or email files), with a custom-tailored solution per file type.

Joe noted the service is being improved with broad coverage and quality integrations: new file types supported, better quality with the **GPT-5 family of models** added as an engine for running extraction and classification, and easier integration with support for **Logic Apps, Agent Framework, LangChain, and Markitdown** (a set of open-source tools to use this extraction as part of an agent runtime).

**Parse**: Applies Microsoft's OCR and layout technology refined over 20 years, still state-of-the-art and continually improved. Gives detailed extraction of tables and multilingual documents — and can even pull some details off a "crumpled page." It is the foundation of search ingestion for Foundry IQ. Two key advancements shown for parse: extracting tables well from a document into structured markdown to ground the agent, and extracting **detailed representations of figures, like charts and diagrams**, so you don't lose that content when ingesting into your system.

**Classify**: Identifies the type of document or breaks a long document into logical parts. Many enterprise documents aren't a single document but a set of documents in a package (a case file, an application bundle, a tax submission). Content Understanding lets you find the classes you want to identify, throw away parts you don't need, identify the key parts you care about, and extract the right information from each piece. **Coming in July**: split documents not just on **page boundaries** but also on **section boundaries** — a frequent customer ask, since document boundaries often don't fall neatly on page boundaries.

**Extract**: Parses content into structured fields and structured output, giving you key-value pairs, confidence scores, and **grounded results**. Each extracted field isn't just a completion from an LLM — it is grounded back to a bounding box, a word, or a sentence in the document, so you can go directly back into the file to find where the content came from. The confidence score lets you **auto-approve when confidence is high and route to human review when it isn't** — which is what allows customers to build real automation workloads on top of Content Understanding.

**Improvements coming in July (for Extract)**:
- A new **training process using knowledge sources** so you can improve extraction on the documents that matter to you (provide examples of a specific document, e.g., a tax form or industry-specific financial document; Content Understanding trains on that file and improves its results).
- New **prebuilt analyzers** with significant cost reductions in terms of tokens, to be much more efficient.
- **Agentic Extraction.**

---

## 7. The Agentic Extraction Announcement (Coming July) (00:30)

Joe drilled into a new Content Understanding mode, **Agentic Extraction** (demonstrated via a recorded demo), coming in July.

Standard Content Understanding extraction does a good job at **finding** answers and summarizing data in a document. But there is a broader class of use cases it doesn't do well today: cases where an answer needs to be **built, not found** — built step by step by reasoning across content in the file. Examples: "for this contract and this set of amendments, which clause applies across this entire chain of changes?" or "how could I root-cause this issue?" Just finding a specific value isn't good enough; you need to reason across the files.

With Agentic mode, you set a **set of questions in the schema**. Content Understanding then uses a set of tools to reason across a big corpus of evidence and loops over it to build a good answer — it is not a one-shot, it searches across the evidence. In the **trace**, you can see it find specific evidence in the documents, ask follow-up questions about images, and run calculations and code, capturing a set of evidence to support a final answer that is well grounded in the input data.

The recorded demo used a complicated **fiber-optic cable failure** scenario (the same grounding documents shown that morning in **Demo 331**; a QR code points to the repo). With questions such as "What's the root cause? How much will it cost to fix? Is it on budget?" set in the schema, Agentic Extraction produced a root cause, a cost analysis, and the right answer for a question that would otherwise have required a bunch of custom coding to build.

---

## 8. Demo (2) — The FIBI Agent Using Content Understanding (00:33)

Joe ran a live demo comparing several scenarios on the same FIBI (fiber-optic) agent Maria showed earlier. On the left of the UI were options for which **Foundry IQ knowledge source** is used and which **context provider** the agent uses to process input files. He showed both Foundry IQ ingestion and use as a context provider.

**Scenario 1 (no Content Understanding)**: Starting with a minimal Foundry IQ knowledge source that does not use Content Understanding to process documents, Joe asked a specific question about an **F3 fiber** measurement (the "3O 1313 10" measurement). There was actually **no evidence** of a measurement for that fiber, yet the agent answered "**46**" — an **ungrounded (hallucinated) result**, because a simple PDF parser lumps the missing value into a long list and misses it.

**Scenario 2 (Content Understanding, standard mode)**: Turning on Content Understanding for the file generated a **structured markdown representation** of the maintenance log, surfacing the **missing value** explicitly — so the agent correctly answered that there is **no recorded value**. Charts in the file were also given a **JSON representation** of the chart data, so the chart's content could be queried too.

**Scenario 3 (DOCX file + Context Provider)**: A DOCX work order emailed to Joe normally can't be handled because agent harnesses typically have very limited file support. By turning on Content Understanding as a **context provider** (in Agent Framework, context providers preprocess files and generate a text version to give the agent — and there is also a **LangChain primitive** for this), any file format can be supported. He also tested passing a PDF directly: by default the agent uses a low-quality parser and gave the wrong answer (it said work order 89 was "scheduled" when it was actually "completed"). After turning on Content Understanding, the structured output (including a JSON representation of the charts) let the agent correctly report that work order 89 was complete — exactly what the PDF says.

**Scenario 4 (encoding business rules with an analyzer)**: On a work order, Joe asked "Who is the field technician?" The correct answer is **Jay Martinez**, but other people are mentioned (e.g., site contact **John Smith**). Without guidance, the agent answered "John Smith" — the wrong answer. By creating a **classify-and-extract analyzer** in **Content Understanding Studio**, Joe encoded a predefined way to process the file: classify whether it is a work order (with a description of what a work order is — he noted you could classify against hundreds of classes, page by page or section by section), and when it is a work order, extract the technician with guidance ("this 'route' thing is how you know who the technician is"). With those business rules encoded via the analyzer, the agent reliably returned the correct answer — **Jay Martinez**.

Joe closed by summarizing the three valuable patterns for Content Understanding (see Summary below).

---

## 9. Wrap-up and Closing (00:41)

Maria returned with about three minutes left and showed one final demo: an agent leveraging the **unified endpoint in an Agent Framework / LangGraph application** (similar to what was shown in the keynote). She directed attention to the **activity line**: the agent goes into the toolbox, loads a skill, **finds 10 tools but selects only one**, pulls that tool, checks the order, and generates the results back — proving that, rather than loading every single tool into the context window, Tool Search selects just one.

She pointed attendees to resources (see Next actions below). After the talk, in response to a question from the audience (asked by "Ralph," likely about the Toolbox roadmap), Maria replied "**Two to three months**... don't hold me to it."

---

## Summary

### Core messages
- **Toolbox** brings tools of any type (MCP, OpenAPI, skills, connectors, and more) into a reusable, managed bundle exposed through a single MCP-compatible **unified endpoint** — so developers stop wiring hundreds of integrations by hand and can focus on building agents.
- **Tool Search** keeps the context window lean by loading only the tool required to complete the task (in the closing demo: "found 10 tools, selected 1"), saving tokens and cost.
- Governance is built in: centralized authentication, observability, policies, and guardrails, with a governed dashboard coming.
- **Content Understanding** turns messy multimodal content (PDFs, video, Office docs, ZIP, email) into clean, structured, agent-ready output via a single **Parse -> Classify -> Extract** pipeline, with grounded results and confidence scores enabling real automation.
- **Agentic Extraction** (coming July) handles the harder class of problems where an answer must be **built by reasoning across evidence**, not merely found.

### Announced features

| Feature | Status | Description |
|---|---|---|
| **Toolbox** (Foundry) | Public Preview / available in Foundry | Reusable, managed bundle of tools of any type, consumed via a single consistent interface |
| **Tool Search** (within Toolbox) | Available | Runtime protocol that searches toolbox metadata and loads only the required tool into the context window |
| **Unified endpoint (MCP-compatible)** | Available | Single endpoint that exposes every tool to any agent runtime (hosted agents, GitHub Copilot CLI/SDK, Copilot Studio soon; Claude/"cloud code" in progress) |
| **Browser Automation** (Playwright-based) | Available today (GA) | New tool to scrape information and fill in forms |
| **Governed dashboard** | Future | Detailed visibility into tool calls |
| **Content Understanding** | GA (since ~6 months ago; in production ~1.5 years) | Parse -> Classify -> Extract pipeline turning multimodal content into structured, grounded output |
| **GPT-5 family as extraction/classification engine** | Available / being added | Better-quality extraction and classification |
| **Integrations: Logic Apps, Agent Framework, LangChain, Markitdown** | Available / being added | Easier integration into agent runtimes |
| **Agentic Extraction** | Coming July | Builds answers by reasoning across an evidence corpus (search, follow-up questions on images, calculations/code) |
| **Section-boundary classification splitting** | Coming July | Split documents on section boundaries, not just page boundaries |
| **Knowledge-sources extraction training** | Coming July | Train extraction on your specific documents from examples |
| **New cost-reduced prebuilt analyzers** | Coming July | Significant token-cost reductions for greater efficiency |

### Content Understanding's three usage patterns (Joe's summary)
1. **At Foundry IQ indexing time**: turn on Content Understanding to extract document structure — figure descriptions, tables, and more — with as little loss as possible into the index, so you get the right answers from indexes.
2. **As a real-time Context Provider**: preprocess any incoming file format when uploaded to the agent (also available as a LangChain primitive), so you can handle any file, not just PDFs, and get the right answers for tricky files.
3. **Encode business rules with analyzers**: write domain-specific rules (e.g., how to process a work order or a tax file) so information is extracted accurately and consistently.

## Next actions
- **Try Foundry / Toolbox**: go to https://ai.azure.com and navigate to Foundry to try Toolbox, Tool Search, Browser Automation, and the unified endpoint.
- **Get the demo content**: at `aka.ms/build` (the build account referenced in the session).
- **Try the live FIBI demo**: `aka.ms/fibi` — live for the rest of the week, with the demo code included.
- **Grab the Agentic Extraction / Demo 331 repo**: via the QR code shown in the session.
- **Join the Foundry Discord** and review the documentation and demos.
- **Watch for July**: Agentic Extraction, section-boundary classification, knowledge-sources extraction training, and new cost-reduced prebuilt analyzers in Content Understanding.
