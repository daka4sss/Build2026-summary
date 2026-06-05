# Microsoft Build 2026 BRK246 "Foundry IQ: Fuel agents with enterprise knowledge and agentic retrieval" — Detailed Summary

**Speakers**: Pablo (member of the Foundry IQ team; last name not identifiable from the transcript)
**Session URL**: https://build.microsoft.com/en-US/sessions/BRK246
**Source**: Official WebVTT transcript (medius.microsoft.com CAPTION)

---

## Overview

This session centers on the design philosophy, new capabilities, and live demos of "Foundry IQ," the knowledge-connection platform within Microsoft Azure AI Foundry. Foundry IQ is the platform you use to "connect agents and AI models to all the knowledge inside your enterprise." The speaker opened by laying out three fundamental design principles: (1) **it should be a piece of cake to get started**, (2) **versatility as you grow** so the same platform scales as applications get sophisticated, and (3) **top quality across ranking, relevance, and content understanding**.

Across the session the speaker covered a wide range of topics: going from a file upload to an MCP server, serverless provisioning, integration with Fabric / Microsoft 365 / the web, security (Entra / Purview integration), improvements to agentic retrieval, and a search-latency demo. All demos were performed live. A few minor hiccups occurred (the GitHub Copilot MCP configuration form disappeared once, requiring the setup to be redone), but the speaker recovered calmly each time. The recurring thesis: Foundry IQ lets you start easy and progressively use deeper layers of the stack without ever being locked out of options.

---

## 1. Session opening and Foundry IQ design principles (00:00)

Pablo introduced himself as a member of the Foundry IQ team and framed the session goal as discussing "what it takes to connect agents and your AI models with the knowledge that makes them connect to your applications, to your company, and to the data they need to get their job done." Cutting to the chase, he stated that **Foundry IQ is the thing you use to connect agents to knowledge**, and presented three fundamental principles:

- **Easy to get started**: it should be a "piece of cake" to begin
- **Versatility**: as the application gets sophisticated, needs grow, or problems get hard, you have what you need right in the same platform
- **Top quality**: like any AI-based system, you want top quality across every AI-powered component — for retrieval specifically, great ranking, great relevance, and great content understanding

He then introduced the layered architecture of Foundry IQ, designed to be "comprehensive" and "layered in a way that doesn't hide options from you" — you choose whatever layer you want to use:

1. **Foundry integration layer (top)**: high-productivity workflows on the UI for building new agents quickly
2. **Knowledge Retrieval System (middle)**: a complete knowledge retrieval system that uses agentic retrieval when needed, handling iterative query planning, multiple knowledge sources, and choosing when to query what; it connects to the entire Microsoft IQ surface and exposes APIs you can call directly
3. **Core Retrieval Engine (foundation)**: a state-of-the-art system built on Azure AI Search that does vector retrieval, lexical search, and combines the two, with state-of-the-art ranking models, in a backdrop of enterprise-grade security, quality, and scale — so you do not have to rebuild any of this from scratch

He also outlined the typical end-to-end process: you start by **provisioning** a new Foundry IQ instance, then create a **knowledge base**, add **knowledge sources**, and finally **retrieve**. The rest of the session walks through how each of these stages is being improved.

---

## 2. Live demo: building a knowledge base from files in about a minute (01:14)

The speaker opened the Azure AI Foundry UI and demonstrated the following steps in real time:

1. Went to **Build** in his already-created Foundry project, then navigated to **Knowledge** — "the part of Foundry where you manage all your knowledge bases."
2. Created a new knowledge base and chose the easy case: data that is just in files (the same experience as a chat application where you drag and drop files and ask questions). He named the knowledge source **"Movies Wiki"** (files taken from Wikipedia) and added a description ("full articles about movies") so the agents know what it is, then dragged and dropped the movie article files and hit save.
3. The knowledge base lived inside a particular Foundry IQ instance he had already created, named **"Demo 3."** He noted that you could call APIs to consume it, but **out-of-the-box, every knowledge base is an MCP server** that you do not have to do anything to stand up or run.
4. Rather than write a new agent, he used **GitHub Copilot as the agent**. In a new Copilot session he typed "MCP" to see what was configured and added a new MCP server named "Wikipedia," using an auth proxy to connect the two. The endpoint was constructed as: the Foundry IQ instance name (Demo 3) + search.windows.net + knowledge bases + the knowledge base name. He emphasized: that base URL is the API entry point, but **to get an MCP server you just append `/mcp`** — "and you are done." Like all the APIs, it carries an API version, and he used **the API version shipped that day**.

   - During the demo the configuration form disappeared once; he calmly re-entered the settings ("MCP Auth proxy... Demo 3... search.windows.net... knowledge bases... the knowledge base name... /mcp... brand-new API version") and retried.

5. From GitHub Copilot he asked **"Which pill did Neo take?"** The agent grounded on the MCP server, sent a few questions to the knowledge base, gathered grounding information, and correctly answered that **"Neo took the red pill"** (from The Matrix).

Key takeaway of the demo: "It took a minute to just go from zero to a working knowledge base that I can connect from my agent using MCP or using an API." He stressed this was a deliberately simplified scenario meant to prove the "easy to get started" principle — and that you can continue from there into deeper layers.

---

## 3. Serverless Foundry IQ — Public Preview announcement (09:00)

Provisioning historically required what is called **dedicated capacity**. Dedicated capacity is great for a steady, predictable workload: it is isolated to your environment and you control exactly what happens in terms of competing workloads. The downside is that you have to know up front how much capacity you need. To make this easier, the speaker announced the **public preview of serverless Foundry IQ**. Key characteristics:

- **No friction to start**: it takes **10-20 seconds** to create a service
- **Cost**: the service does not cost anything until you actually use it; when idle it **scales to zero**, and you only pay for the storage your index uses
- **Production ready**: usable not only for developer workloads but in production as-is
- **Ideal for dynamic workloads**: scenarios such as agents creating services on the fly, or applications that need to create and delete services dynamically; also great for unit tests that create and delete indexes on the spot
- **Same technology foundation**: built on the same state-of-the-art technology that powers the existing Foundry IQ stack — state-of-the-art ranking, an instant RAG stack ready to go, and a rock-solid foundation — but with all the dynamic characteristics of serverless

Guidance on choosing serverless vs. dedicated:

| Scenario | Recommended mode |
|---|---|
| Want a usage-based plan | Serverless |
| Lots of medium-sized or small indexes | Serverless |
| Developer workflow / unit tests (create and delete on the spot) | Serverless |
| Agents creating services and indexes on their own | Serverless |
| Highly predictable, steady workload (isolated capacity) | Dedicated |
| Confidential computing requirements (top-to-bottom) | Dedicated |

The demo showed serverless creation from multiple surfaces. **From an agent**: he pasted a prompt telling GitHub Copilot to look at an **IMDb** movie-data file and "create a new Foundry IQ service, create an index, and load the first 100 rows from that file," then let it run in the background. **From the Foundry UI**: instead of reusing Demo 3, he chose "create new resource," gave it a name and resource group, picked a region that supports serverless (West Central US), selected **serverless** as one of the SKUs (in addition to all the existing ones), and clicked create — noting it would again take 10-20 seconds. He stated the same option is available in the **Azure portal**. (The agent autonomous run is checked back on later in the session.)

---

## 4. Knowledge bases, knowledge sources, and data ingestion (12:44)

A **knowledge base** is "the scope of knowledge, not how we access it" — the domain of knowledge plus the **policy** for using that information, kept hidden from the agent to separate concerns. As policy, you can configure: **how much retrieval effort** to take (a quick pass vs. iterative retrieval), **steering instructions** to influence how the model behaves, and whether to perform **answer synthesis**. Underneath the agentic retrieval stack live the **knowledge sources**: for most of them you point Foundry IQ at where the knowledge is and it creates vector and lexical indexes; it also supports **federating out** to knowledge sources accessed online. Regardless of how a source is represented at runtime, the system can choose which sources to use for any given scenario and query them.

The speaker noted data is "all over the place" — loose files on a desktop, object stores, the Microsoft IQ platform, or other applications — and that Foundry IQ offers a spectrum of options so you do not have to reinvent the plumbing.

### Files
You can just upload content. Unlike a coding agent local file access (which works great for maybe 50-100 files and a few megs), the **file knowledge source** has the whole retrieval engine behind it, creating indexes for fast retrieval. He noted developers often have "a million PDFs in a BLOB storage account" — you cannot grab your way through a million PDFs if you want to issue 10-20 queries a second to try different angles. When files are pushed, they go through full content processing: content extraction, image handling, vectorization — everything needed so retrieval works.

### Object stores: Azure BLOB Storage, OneLake, databases
When an application manages content internally and lands it in BLOB storage, a database, or OneLake (Fabric), you point Foundry IQ at it and it **assembles a full ingestion pipeline by default** — chunking, vectorization, and indexing — yielding very high-quality results without dealing with the mechanics. You can customize every step and inject your own custom steps for exactly the output you want. The ingestion is **not a one-shot job**: it imports everything now and then **runs continuously, tracking changes** and incrementally feeding source changes into the search index, so you always have a fresh index for grounding. **Multimedia** is also handled.

### Azure Content Understanding integration (high-quality extraction) (16:50)
To understand what is inside files (e.g., PDFs) before presenting them to agents, Foundry IQ is integrated with **Azure Content Understanding**, providing high-end components for **optical character recognition**, **document layout**, **reading-order preservation**, handling tables that **span pages** and **sparse tables**, etc. In the demo he added a **BLOB storage** knowledge source named "notes" / "annotations for movies," pointed at a storage account called "Build 26," picked a container, used a **system identity**, and chose **"standard"** content extraction (i.e., full Content Understanding). An embedding model was already set for vectorization, and optionally a **chat-completion model** can be supplied to enable **image verbalization** to handle media. He showed extraction examples: a scanned, handwritten table where the markdown output captured not just the tables but even the **checkboxes**; a business document where layout, two-column reading order, and embedded pictures were all understood. For more structured content, you can supply a **schema** of the elements to extract, isolating specific fields to feed to the agent or use as filters.

### Work IQ (Microsoft 365 tenant data) (20:30)
Most enterprise data — Word documents, calendar, email — sits in your **M365 tenant**. **Work IQ** enables direct access. The interesting thing is there is essentially **nothing to configure**: you just tell Foundry IQ you want to integrate with Work IQ. Your **tenant admin must give consent** (because it is your Office data), and once granted, "it will just work."

### Fabric IQ (Microsoft Fabric analytics data)
**Fabric** holds all your analytics state — data lakes, data warehouses, semantic models, Power BI reports, data agents, and even ontologies on top of OneLake. The **Fabric IQ** layer lets agents communicate with all that information, handling **natural language to SQL** and navigating multiple data sources. Integration is with the **entire OneLake catalog**, so you see all sorts of objects (lakehouses, data agents, ontologies). In the demo he added a Fabric data agent as a knowledge source named **"movie stats"** ("use for ratings and other stats"). He showed a Fabric lakehouse holding a few **Parquet files** of movie statistics (ratings, etc.) and a simple **data agent** built on that structured data; natural-language questions are turned into SQL as needed. When adding it, choosing a **data agent** requires no indexing (questions are integrated at retrieval time, agent-to-agent), whereas choosing a lakehouse would surface indexing options.

### Web IQ (web grounding)
**Web IQ**, announced the day before Build, provides web access. He added it as an MCP-server knowledge source named "YQ2," supplying the **Web IQ endpoint** (obtained when you sign up for the Web IQ preview), authenticating, and selecting the **web search** tool. The result: a single knowledge base that transparently uses Wikipedia articles, the web, and Fabric data agents — and "the agent that consumes it does not need to know" all this was added; the agentic orchestration chooses what to use when.

### MCP servers (custom extensibility)
For data or applications the built-in options do not cover, you connect via **MCP**. The speaker noted there is no "ODBC for agents," but MCP is universal and easy to create one if you do not have one — so it became a great integration point. Foundry IQ turns MCP output, via heuristics, into an **item-oriented list**, and then runs **its own ranking system** on top to improve relevance. Example mentioned: using the **GitHub MCP server** to turn issues into one of the tables fed into the system — "it kind of just works."

---

## 5. Security: document-level access control and Purview integration (27:42)

Access control over enterprise data is not improvised on top — it is built in at the bottom of the stack, because in the real world "not everybody can see every document." The retrieval system must support the **same security model** as the underlying data.

- **Document-level security via Entra**: Foundry IQ **propagates access-control information** from sources that support it — e.g., **SharePoint** or **BLOB storage with hierarchical namespaces** (where ACLs can be set) — into the indexes it builds under the covers. This is integrated with **Entra**, so **group membership** works as expected. At query time you simply present the **delegated token of the calling user**, and the search appears to contain only the subset of items that user can see. **Security is enforced at the bottom of the stack — you do not layer your own on top.**
- **Microsoft Purview integration**: documents with **sensitivity labels** are encrypted and cannot be indexed by a random tool, but Foundry IQ Purview integration lets you **index and then secure them** with the additional access-control information. You can also **propagate sensitivity labels into the UI you are building**, so your application "will look like Office" from the perspective of label propagation.
- A **complete example** was shipped for putting all these moving parts together.

### Checking back on the autonomous agent
Returning to the agent kicked off at the start of the serverless section: it had provisioned a new Foundry IQ service (picking a name and endpoint), created an index, and added files. In the **Azure portal** he found the resource group, located the service (named "FIQ-IMDB-..."), confirmed it was a **serverless** service with an **index containing 100 documents**, and inspected the content to see the movie information had loaded. "This was a one-liner I told the agent, and I have a working index as a result" — reinforcing that serverless instances are ideal for agents that create and delete their own resources on the fly.

---

## 6. Agentic Retrieval, second generation: quality and token efficiency (31:00)

Retrieval is "the moment where all the work you do actually delivers value" — a search engine is useful the moment your top 3 or 4 results are what the agent needed to ground its answer. Foundry IQ has an agentic retrieval pipeline built in that you can choose to use (or, per the layered design, you can use raw indexes directly).

### Pipeline flow

1. Take the question / data requirements from the calling agent
2. **Query planning**: decide which data sources to look at and how to decompose the query into parts
3. Run a few searches
4. Look at the results and decide whether it got what it was hoping for; if not, depending on the configured **retrieval effort**, **iterate** and search again on the new information
5. Produce a final result for the agent (optionally with answer synthesis)

### Second-generation improvements (32:15)

The team is now on the **second generation** of agentic retrieval. A key observation: from about **October of last year to now, the language models have changed significantly**, including how good they are at tool-calling loops. The improvements come from a mix of factors:

- **Significantly revamped the agentic retrieval workflow / prompts** to fit the style of today best-performing models
- **Trained a new semantic ranker** — they have been training rankers for a while and keep pushing the boundary on quality
- **Significant improvements to answer synthesis**
- **Model-specific prompts** for tasks like **MCP parameter binding**, tuned per model because there is enough variability between models to get it exactly right

### Quality metrics

The charts compose multiple metrics: **recall**, how often the answer is **correct**, how often the answer is **complete**, and how often the model **says it does not know** even though the answer was present in the data. Comparisons were against **BM25 lexical indexes**, **hybrid search** (vector + lexical), and a knowledge base with **agentic retrieval off** ("minimal mode"). The result was **material improvements across the entire set of metrics**. The trade-off is **latency**: a raw search index is effectively instantaneous (no need to budget for it), whereas agentic retrieval can take a few seconds, or sometimes about 10 seconds if it must iterate multiple times.

### Token efficiency (35:19)

The team also looked at **what it takes to get a right answer**, not just to run a search ("anybody can do a search with a few tokens; did you get it right?"). A **Pareto line** showed the best achievable with the fewest tokens, again comparing plain hybrid search vs. full agentic retrieval. Two findings: (1) **fewer tokens are needed to produce better answers**, and (2) prompt construction is designed to be **aware of token caching** (hitting the **prefix cache** on the language model) — making it both **faster** (prefix-cache hits) and **cheaper** (cached tokens cost less than full tokens). The science team publishes detailed write-ups at a referenced URL for those interested in information retrieval and how these systems are evaluated.

---

## 7. Composite demo: multi-source agentic retrieval and index deep-dive (36:16)

The speaker built a quick test client that calls the **retrieve API** for the combined knowledge base (Wikipedia file source, Fabric "movie stats" data agent, and Web IQ via MCP) and exposes some internals. Before running, he noted he had to specify an **orchestration model** for the knowledge base (required once you have online data sources): he chose **GPT-4.1 mini** (rendered in the captions as "GPT 454 mini"), set a default reasoning effort (overridable later), chose whether to do answer synthesis, and could optionally give steering instructions for both. He ran the retrieve in **medium** effort.

Showing the output of a prior run for a query about top sci-fi movies ratings and box office:

- **Ratings** came from the **Fabric data agent**, which ran SQL over the Parquet files
- **Box office** was not in his datasets, so the system used **web grounding** (Web IQ via MCP) to fetch the top-ten movies and pull results
- The **activity log** made the steps explicit: the **planner ran, then went to the data agent** (to find the top sci-fi movies), then **hit the MCP server for web**, discarding some content, then the **synthesis step** constructed the answer, then **finished the reasoning process**
- The response included **all the references** — which knowledge source each piece came from, and links to underlying files where available. You usually will not surface this in the UX, but it is great for feeding back to an agent to understand the interaction, or for **debugging**

He emphasized: "all the technology and all the science for improving ranking, relevance, and agentic retrieval is behind that one API" — one MCP-server call or one retrieve call — with everything else happening under the covers. He also reiterated the **versatility** point: the stack is cleanly layered so you can pick a layer (Foundry integration, knowledge bases, or the core retrieval engine on Azure AI Search) and still move **up and down the stack** as needed, or change your mind after building.

### Index deep-dive in the Azure portal (40:42)

He peeked under the covers in the Azure portal for the "Demo 3" service. In the **Azure Search blade** he found the knowledge base, all its knowledge sources, and — for the two with indexed content — the **indexer** (the data pipeline / job that transforms and pulls data into the index), where you can view runs and configure internals. Opening the **index** for the article files, he showed the **schema** and the controls available: reasonable defaults are chosen if you do not care, but you can control details such as **vector-search compression** (**8-bit quantization by default**, with the option of a different quantization or re-ranking policy). He also pulled the actual indexed **content** — the chunk snippet produced by chunking — and the raw **vector** used for vector-search computations.

### Ultra-fast search demo (full English Wikipedia index) (43:17)

To show the speed difference, he used another service holding **all of English Wikipedia**, chunked into roughly **22 million chunks** — a sizable index. With a simple client, searching for terms (e.g., "Neo," "pill," "Microsoft build") returned results **on every keystroke** — "this thing searches at the speed that I can type... I still cannot keep up." He explained that if an agent issues 10 searches, or multiple rounds of 10-20 searches each, **all of them finish well within a second in parallel** — even at tens or hundreds of millions of documents. This means you can change how you think about retrieval: let Foundry IQ run the **agentic retrieval loop** for you (a few seconds, up to about 10), or give the agent direct **index entry points** and let it "hit the search index as hard as you want," and it will be just fine.

---

## Summary

### Core messages

- **Foundry IQ connects agents and AI models to all enterprise knowledge**, built on three principles: easy to get started, versatility as you grow, and top quality in ranking / relevance / content understanding.
- The platform is **cleanly layered** (Foundry integration to knowledge retrieval system to core retrieval engine on Azure AI Search) and lets you move up and down the stack without being locked in.
- **Every knowledge base is automatically an MCP server** — append `/mcp` to the API endpoint and you are done.
- Knowledge sources span **files, object stores (BLOB / OneLake / databases), Work IQ (M365), Fabric IQ (analytics), Web IQ (web), and arbitrary MCP servers**, with automatic, continuously-syncing ingestion pipelines.
- **Security is enforced at the bottom of the stack** via Entra document-level access control (delegated tokens, group membership) and Purview sensitivity-label integration — not bolted on by the application.
- **Second-generation agentic retrieval** improves recall, correctness, completeness, and "do not know" honesty across the board versus BM25, hybrid, and minimal modes, while being **more token-efficient** (token-caching-aware prompt construction).

### Announced features

| Feature | Status | Description |
|---|---|---|
| **Serverless Foundry IQ** | **Public Preview (announced this session)** | No-friction provisioning in 10-20s, scale-to-zero, pay only for index storage when idle; production-ready; ideal for dynamic/agent-created and developer/unit-test workloads |
| **Web IQ** (web grounding via MCP) | Public Preview (announced the prior day) | Connect via MCP, select the web search tool, and gain web grounding inside a knowledge base |
| **Fabric IQ integration** (OneLake catalog + Fabric data agents) | Available | Integrates the entire OneLake catalog (lakehouses, data agents, ontologies); natural-language-to-SQL via Fabric data agents, integrated at retrieval time |
| **Work IQ integration** (M365 tenant data) | Available | Direct access to M365 tenant content (SharePoint, mail, calendar) with admin consent and near-zero configuration |
| **Agentic Retrieval, 2nd generation** (quality + token efficiency) | Available (presented this session) | Revamped workflow for newer models, new semantic ranker, improved answer synthesis, model-specific MCP parameter-binding prompts |
| **Automatic MCP server per knowledge base** | Available (presented this session) | Every knowledge base is exposed as an MCP server by appending `/mcp` |
| **Azure Content Understanding integration** (OCR, layout, image verbalization) | Available (presented this session) | High-quality extraction: OCR, document layout, reading order, spanning/sparse tables, checkbox capture, schema-based field extraction, image verbalization |
| **Purview integration** (sensitivity-label propagation) | Complete example shipped | Index and secure label-encrypted documents; propagate sensitivity labels into your own UI |
| **New API version** (released on Build 2026 day) | Shipped | The API version shipped that day, used in the MCP-server demo |

### Next actions

The speaker stated plainly that **"everything I showed you today, you can use today."** Three entry points were offered:

1. **Azure AI Foundry portal** — create knowledge bases and serverless services through the UI
2. **Azure portal** — manage as Azure AI Search resources (indexers, indexes, schema, compression policies)
3. **SDKs** — "get our SDKs and get going" (e.g., Python / .NET)

He closed by pointing to several other related Build 2026 sessions (session numbers not identifiable from the captions). Foundry IQ is positioned as a comprehensive platform — "start easy, then use the stack as deeply as you need" — for connecting all enterprise data to AI agents.