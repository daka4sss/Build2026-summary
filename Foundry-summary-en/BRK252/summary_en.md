# Microsoft Build 2026 BRK252 "From observability to ROI for AI agents on any framework" — Detailed Summary

**Speakers**:
- **Sebastian** (host/moderator; Microsoft Foundry Observability team. Last name not identifiable from the transcript)
- **Felicia** (demo presenter; Microsoft Foundry team. Last name not identifiable from the transcript)
- **Vivek** (demo presenter; Microsoft Foundry team. Last name not identifiable from the transcript)

**Session URL**: https://build.microsoft.com/en-US/sessions/BRK252
**Source**: Official WebVTT transcript (medius.microsoft.com CAPTION)

---

## Overview

This is a technical session centered on **Microsoft Foundry Observability** that walks through the full picture of observability for building and operating AI agents, and demonstrates practical end-to-end workflows through a series of live demos. The audience is developers and operators who are trying to take AI agents to production.

Because AI agents are non-deterministic, they create new reliability and consistency challenges, and they require a quality- and trust-management approach that differs from traditional DevOps. Under the concept of an "agent DevOps life cycle," the session shows a structure in which an **inner loop** (plan -> code -> test -> release) and an **outer loop** (monitor -> analyze -> optimize -> feed signals back into the inner loop) continuously cycle, all with observability at the developer's fingertips.

The session is positioned as a follow-on to BRK241 "Developing production agents," and reuses that session's data-center scenario. The demo scenario is a **Vendor History Analyst agent for Microsoft's data center operations**, aimed at vendor managers. The agent summarizes vendor job history, surfaces insights, and highlights key learnings so that a vendor manager can have data-driven conversations with the vendors who are fixing and addressing issues in data centers.

The session covers four threads: (1) end-to-end observability across both inner and outer loop, (2) turning traces into action for continuous improvement, (3) optimization at scale, and (4) proving the value of agentic workloads through agent ROI.

---

## 1. The four core pillars of Microsoft Foundry Observability (00:00)

Right after the session opens, Sebastian frames the whole picture of Microsoft Foundry Observability. He notes that agents are non-deterministic, which creates new reliability and consistency challenges for developers and operators — and that this is where observability comes in. Foundry Observability covers **four core pillars**:

1. **Tracing**: View the full end-to-end execution workflow of your agents.
2. **Evaluation**: All evaluations run off of the traces, so you can assess the quality and safety of your agents.
3. **Monitoring**: Run the same evaluations you ran offline in an online setting, so you can detect issues in real time.
4. **Optimization**: Continuously improve your agents.

Sebastian also positions Foundry as providing all of the building blocks needed to create reliable, high-quality production agents. **Observability is part of the control plane** that spans across all the capabilities needed to build agents — including the agent service, models, **Foundry IQ for knowledge and tools**, and machine learning capabilities such as fine tuning.

He then introduces the **agent DevOps life cycle**: traditional DevOps evolving for the age of AI agents. The session starts with getting started (out-of-the-box observability), transitions into the **inner loop** where developers plan, code, test, and release with observability directly in the IDE, and then into the **outer loop** where the same observability capabilities are used to monitor agents, analyze results and get insights, optimize, and feed those signals back into the inner loop for continuous improvement.

---

## 2. Getting started – Traces in the Foundry portal and the Rubric Evaluator (00:03)

Sebastian welcomes **Felicia** on stage for the first live demo, which covers the getting-started experience and the beginning of the inner loop (plan -> code -> test -> release).

### Demo flow

1. **Running the hosted agent**: Felicia starts with an existing **hosted agent** (referencing an earlier talk by Jeff and Tina on how hosted agents are deployed). In the **playground in the Foundry portal**, she sends a basic query that a vendor manager might type and watches the logs stream in on the right side as the agent thinks and produces a response. She notes how hard it is to assess whether an agent is trustworthy or has good "health."

2. **Creating a Rubric Evaluator**: Felicia introduces what she calls "a really interesting new feature that we've added to Foundry" — the **Rubric Evaluator**, which gives a **multi-dimensional evaluation score**. The setup steps are:
   - Give it a name and set it as a rubric type.
   - Provide the **system prompt** that the agent uses.
   - Select a model.
   - Set the **target** to the hosted agent she just showed.
   - Click **Generate Rubric**.
   She notes you can also upload additional context files from your code, and that you can do all of this in code as well.

3. **Auto-generated rubric**: Foundry generates a rubric **across 8 different dimensions**, each with its own weights, based on the supplied system prompt and agent. This "really simplifies evaluation" because you can see everything across a whole set of dimensions within a single evaluator — and crucially, you can get started even when **you have no data** ("So I have no data. How can I get started?").

4. **Reviewing the agent reply**: Going back to the agent, the reply has come in but it's **contradictory** — the evidence is unclear about whether the vendor actually needs management from her side or not, even though there's a recommendation. This is something she'd want to investigate.

5. **Continuous Evaluation on production traces**: Felicia switches to the **traces** view. Because **continuous evaluations and jobs** have been set up, Foundry is pulling **production traces from App Insights** and the previously created evaluator runs against those traces, producing scores as the traces populate in. Scores vary based on the kind of question the user asks. She picks a **low-scoring trace**, clicks its **trace ID**, and gets a "really rich view" where she can see the evaluations against the agent invocation. The detailed view shows that **both task completion and the vendor history rubric score are low**.

6. **Root cause**: Switching to the user view, the user had asked a very specific question, and the agent **lacked the exact data** it was supposed to provide that the user referenced. Sebastian summarizes that the agent is **effectively hallucinating** — pretending to say the vendor is performing well, but not actually giving the correct response with the context the user requested.

---

## 3. Open ecosystem support and the Rubric Evaluator announcement (00:09)

Sebastian recaps the first demo and makes the first announcement.

### Open ecosystem / any-framework support

What was shown in the tracing experience — with evals running off the traces — is a core part of Foundry's value proposition. Not only can you evaluate **Foundry agents**, you can also evaluate **Foundry and non-Foundry agents built with any framework**, including the most popular agent frameworks:
- **LangChain**
- **LangGraph**
- **OpenAI SDK**
- **Microsoft Agent Framework**

You get complete visibility into the full agent execution workflow and the eval signals produced directly from the traces.

### Full-stack observability with Azure Monitor

Through Foundry's partnership with **Azure Monitor**, you get full-stack observability. Within Foundry you get observability for your apps, agents, and all of the AI platform components; all of that data then flows to **Azure Monitor**, where you get a full-stack view across all of your Azure resources, data, and infrastructure. That data is then **read back into Foundry** so you have centralized observability for all of your AI workloads.

### Rubric Evaluator (Public Preview)

Sebastian announces that the **Rubric Evaluator is now available in public preview**. It gives out-of-the-box and context-specific observability for agents. Whether you're creating a **new agent with no data** or you have an **existing agent that already has traces**, you can use the Rubric Evaluator to **auto-generate a multi-dimensional evaluator** and use it for both your **offline testing** and your **online evaluation**.

---

## 4. Code-first observability – Foundry Toolkit and Foundry Skill (00:12)

Felicia returns for the next demo, this time moving from the portal into her editor (VS Code) to show **code-first observability**, taking the full agent DevOps loop across both inner and outer loop.

### Foundry Toolkit (VS Code extension)

- The **Foundry MCP server** and the **Foundry Skill** are both packaged under the **Foundry Toolkit**, which is an extension in VS Code.
- Support for other coding agents and editors is planned eventually; today it is available in VS Code.
- The Foundry MCP lets you do, from **GitHub Copilot Chat inside VS Code**, the same kinds of operations available in the portal — retrieving, analyzing, and even taking actions on behalf of Foundry from the developer environment.

### Role of the Foundry Skill

The Foundry Skill is described as **an opinionated flow that the Foundry creators provide** — "this is how you should observe and analyze and perhaps optimize your agent." Because it knows what part of the observability loop you're in, it can suggest improvements that may be from Foundry or may be coding issues; it can help connect **client-side and server-side** layers. Felicia stresses that this can be trusted more than just dropping a result into a general LLM because it is **grounded both in your repo context and in the Foundry skill context**, which makes the analysis more actionable and trustworthy.

### Demo flow

1. Felicia prompts **Copilot Chat in VS Code** to fetch the eval result she had hooked up earlier on the portal and to explain why a **~0.4 score** pulled from the traces was showing up low and what the opportunities for improvement are.
2. The **Foundry MCP** is invoked. On a previous run she shows the exact same query from a couple of hours earlier, run against her **project endpoint**: it ran **eval get**, retrieved the **evaluator definition and last run**, and produced the **last 8 hours of evaluation analysis** as an entire summary — including evaluation runs from everyone on the team who had been trying out the agent.
3. The output gives a **per-dimension breakdown** and tells her **which dimension is the weakest**, so she can drill into the low-scoring dimension. Sebastian comments on no longer having "to go through hundreds of traces and eval results anymore."
4. The skill provides a detailed explanation of what could have gone wrong, the patterns, and the recommended improvements. It recommends a **system prompt change** (with reasons) and how to change the harness and evaluator. Felicia asks it to **draft the system prompt**, and it generates a new system prompt whose first metric-definition block addresses exactly the trace issue seen earlier. (As a live hiccup, she notes "oops, I actually deleted that file earlier," but continues conceptually.) She can set a new baseline and see whether it improves the rubric score.

### Traces -> Data sets

Asked how to do this **at scale**, Felicia highlights that because Foundry is "all in one," you can **pull production traces back into your data set** to **regression-prove** changes later. A developer working in the inner loop can run locally staged agent changes against that data set and then push the code to production.

---

## 5. Inner-loop announcements summary – Code-first observability and new evaluation capabilities (00:17)

Sebastian recaps the code-first capabilities and announces several additional Public Preview features.

### Code-first observability (Foundry Toolkit)
- Code-first observability for Foundry agents with a **skill-based, guided user experience**: not only run evaluations, but **analyze results, do comparisons, look at traces, and seamlessly transition to optimization** and making improvements.
- Available in **VS Code, GitHub Copilot Chat, CLI, and so forth**.

### Multi-Turn Evaluation (Public Preview)
- A new capability in Foundry. Previously everything was **single-turn**; now you can evaluate **across an entire session**.
- Example: an agent might succeed at the end of a session, but if the session took 20 minutes when it should have taken 5 minutes, that is not a successful session — multi-turn evaluation captures this.

### User Simulation (Public Preview)
- Goes along with multi-turn evaluation. **Automatically generates realistic conversations**, so if you don't have multi-turn data available to run your first evaluation, **user simulation helps you get started**.

### Traces to Data Sets + smart filtering
- Feed traces back into the inner loop to improve **test coverage**. Initial test coverage (e.g., 20 test cases) won't cover everything seen in production; with **traces to data sets** and **smart filtering**, you can select traces and feed them back into your data sets.

### Evaluator catalog
- A comprehensive **evaluator catalog** with built-in evaluators spanning **quality, risk, safety, and agent evaluation**.
- Several evaluators are now **multi-turn**: **groundedness, coherence, task completion, customer satisfaction, and the rubric evaluator** — and you can make **custom LLM-as-a-judge and code-based evaluators** multi-turn as well.
- Sebastian recommends a variety of evaluators. **Code-based evaluators** are especially recommended for **non-deterministic scenarios** — e.g., a regex check or a database lookup — without needing an LLM-as-a-judge.

---

## 6. Agent Optimizer – Optimization at scale demo (00:20)

Sebastian invites **Vivek** on stage for the optimization-at-scale demo, introducing the new **Agent Optimizer** feature ("AI Agent Optimize").

### Overview

Vivek recaps the state so far: an agent that's working well and hosted in Foundry, a **data set of representative tasks** the agent should be doing well, and **rubrics** that tell how good it is on those tasks. The next question is how to **improve** it — fix specific gaps and have the agent do well across all tasks. This is where Agent Optimizer comes in.

Importantly, Agent Optimizer doesn't just **recommend** what the next system prompt should be. It **deploys new versions** of the agent, runs them across the tasks, **assesses them on the rubrics, and then iterates** — doubling down on prompts/context that work and trying another strategy for what doesn't. ("It's real. It's live... and it is iterative.")

### What it optimizes

From an **eval.yaml**-style configuration, Agent Optimizer can iterate on a combination of:
- **System prompt** (read from the instructions file)
- **Skills** (if configured — not configured for this agent in the demo)
- **Tool descriptions and parameter descriptions** (since these go into the agent's context and affect how the agent uses tools)
- **Model selection**: you can specify a **list of models**, and it recommends the best-performing model for your agent on those tasks. Vivek notes there are constant new models with trade-offs across cost and latency, and this avoids the "very non-streamlined" manual process of trying a new model and re-running on many tasks. The goal: figure out the best possible combination of **model + prompt + tool definition + skills** all together.

### Configuration steps (in the demo)

1. Specify the **hosted agent** to optimize.
2. Specify the **data set** — a **40-query data set** of representative tasks.
3. Specify the **evaluator** — the rubrics that assess how good the agent is on those tasks.
4. Select which components to optimize — in the demo, **model, system prompt, and tool definitions**.
5. Select an **optimization model** — this is **different from the agent's model**. It is the model the optimization job uses to **self-reflect, re-read traces, read evaluation rubrics, and then decide what needs to change**. "The better model, the better it is" — even if your agent runs with a smaller model, using a **better reflection model** here really helps.

### Live demo results

- Vivek notes the job can take "minutes to tens of minutes" ("So I can walk my dog and get coffee"). He starts a job, then jumps into a previously completed run he had been **hill-climbing** on.
- The prior run achieved roughly a **14% boost** over the base system prompt — with just **context engineering** (system prompt + tool definitions), without having to sit and read prompts and traces.
- It completed in **25 minutes** and **created 4 candidates**:
  - **Candidate 1**: a new system prompt -> **38 of 40 tasks** working.
  - **Candidate 2**: system prompt + tools.
  - **Candidate 3**: tools only.
  - **Candidate 4**: works all the time -> **40 of 40 tasks**, increasing the baseline score from **0.577 to 0.7**.
- A diff view shows what changed: the system prompt was changed and **grounded more on the traces, data, and rubrics**, and **tool definitions/descriptions were changed**. Notably, the earlier **hallucination on a vendor detail that wasn't there** is exactly the kind of issue that was addressed.
- A score-details view shows the **real evaluation results** for the agent iteration, with per-task detail of why a task was scored a certain way plus an analysis.
- Agent Optimizer is **not a once-and-done thing**: you keep looking at traces (smart filtering helps select the right traces), keep optimizing, and keep **hill-climbing** as users, domains, models, and tool definitions/implementations change.

### Release status

**Agent Optimizer is now in Private Preview and will be in Public Preview soon.** Sebastian also notes that, in addition to Agent Optimizer, Foundry provides **single-shot optimization** as another option.

---

## 7. Agent ROI – Proving business value (00:27)

Sebastian leads the final demo section, introducing the **agent ROI** feature ("return on investment for agents in Foundry").

### Background

Once you've set up your inner and outer loop, the final step is to **prove the business value** of your agents: you have to do the math to figure out whether your agents are generating sufficient value to be worth the cost you're spending on the agent workloads.

### How the feature works

The feature looks at **all of the agent invocations** and applies settings you specify:
1. Go to **settings**, enable the feature, **select an evaluator**, and **assign a business value** to that evaluator.
   - Example: every time the **Vendor Analyst agent** successfully completes its task and gives an analysis, that saves **$5 worth of time** the user would otherwise have spent running a query or looking up the information elsewhere — that's the business value generated. (You have to do the math; Foundry doesn't have that information.)
2. In **optional settings**, the feature **automatically pulls in the token cost** of your agents, and you **specify the tool cost** of your agent (which has to be averaged across agent invocations).
3. Once enabled, you can **track net value over time**.

### What the demo showed

- The demo showed **3 different versions**, comparing **value, cost, and net value** over time, and how the **ROI is changing across versions**.
- It revealed that **tool calls were actually costing more than the LLM** — a clear candidate for optimization.
- The feature lets you **drill into low-ROI traces**. As an example, an **agent call that just doesn't succeed is all negative cost** — exactly the kind of trace you want to drill into and root-cause using the code-first capabilities.

### Release status

**Agent ROI is now available in Private Preview within Foundry, and will be in Public Preview soon** as feedback is collected. Interested customers can engage through their sales team to try the feature and give feedback.

---

## 8. OpenTelemetry investment, additional capabilities, and closing (00:31)

In the wrap-up, Sebastian re-emphasizes that Foundry Observability broadly covers everything needed to ship agents with confidence — **tracing, evaluation, monitoring, and optimization** — and highlights a few key capabilities.

### Tracing / OpenTelemetry

- Foundry continues to **invest heavily in OpenTelemetry** as the standard that underpins **both tracing and evaluation**.
- Microsoft's engineers are **heavily involved in the open-source community** and are contributing **new semantics** — for example, **new semantics for memory** that were just contributed and are **coming soon into Foundry**.

### Evaluation

- Beyond the Rubric Evaluator and the built-in evaluators in the catalog, Foundry provides **red-teaming agents**, **CI/CD integration**, and more.

### Monitoring

- In addition to running evaluation in production, Foundry gives access to all of the **operational metrics** needed to understand how AI applications and agents are performing.

### Optimization

- In addition to the **Agent Optimizer**, Foundry provides **single-shot optimization** as another option.

### Customer example

- **Entity Data** is cited as a customer already using Foundry's observability capabilities **together with Azure Monitor** to transform AI into an enterprise-grade, production-ready system.

### Platform recap and next sessions

Sebastian closes by restating the end-to-end story: build reliable agents in the playground, create a context-specific Rubric Evaluator, look at traces and evaluation scores, then go into the IDE for code-first capabilities with the Foundry Toolkit and Foundry Skills to debug, optimize, and get the broader view with agent ROI. Microsoft provides all the building blocks — start building in **GitHub**, then within **Foundry** get evaluation, optimization, governance, and the building blocks to run agents, and finally distribute agents to users via **Microsoft 365 Copilot, Teams, apps, and APIs**.

---

## Summary

### Core messages

- **Works with any framework**: Foundry can centrally trace and evaluate agents built with **LangChain, LangGraph, OpenAI SDK, and Microsoft Agent Framework** — not just Foundry agents.
- **Evaluation comes from traces**: Evaluation and tracing are tightly coupled in Foundry; production traces can be used directly as evaluation data, and continuous evaluation runs against production traces pulled from App Insights.
- **Consistent tooling from inner to outer loop**: The same evaluation, analysis, and optimization workflow is available regardless of where you work — **portal, VS Code (Foundry Toolkit), GitHub Copilot Chat, and CLI**.
- **Automate with Agent Optimizer**: Free yourself from manual prompt engineering by automatically searching for the best combination of **model, system prompt, tool definitions, and skills**, with iterative hill-climbing assessed against rubrics.
- **Make ROI visible**: Continuously track **business value minus cost (net value)** per agent version so you can be accountable to leadership about whether an agent is worth its cost.
- **Open standards**: Microsoft continues to invest heavily in **OpenTelemetry**, contributing new semantics (e.g., for memory) back to the community.

### Announced features

| Feature | Status | Description |
|---------|--------|-------------|
| **Rubric Evaluator** | Public Preview | Auto-generates a multi-dimensional evaluator from a system prompt and agent info; works even with zero data; for both offline and online evaluation. |
| **Multi-Turn Evaluation** | Public Preview | Evaluates across an entire session (multiple turns) instead of single-turn only; e.g., flags a session that succeeded but took too long. |
| **User Simulation** | Public Preview | Automatically generates realistic conversations to bootstrap multi-turn evaluation when no multi-turn data exists. |
| **Multi-turn built-in evaluators** | Public Preview | Groundedness, coherence, task completion, customer satisfaction, and the rubric evaluator are now multi-turn; custom LLM-judge and code-based evaluators can be made multi-turn. |
| **Open ecosystem / any-framework observability** | Public Preview | Trace and evaluate agents built with LangChain, LangGraph, OpenAI SDK, and Microsoft Agent Framework. |
| **Code-first observability — Foundry Toolkit / Foundry MCP / Foundry Skill** | Available | VS Code extension (MCP server + opinionated skill) usable from VS Code, GitHub Copilot Chat, and CLI for running, analyzing, comparing, tracing, and transitioning to optimization. |
| **Traces to Data Sets + smart filtering** | Available | Select production traces and feed them back into data sets to expand inner-loop regression test coverage. |
| **Agent Optimizer** | Private Preview (Public Preview soon) | Automatic hill-climbing optimization that generates/deploys/evaluates new agent versions across prompt, tool definitions, skills, and model selection. |
| **Single-shot optimization** | Available | An additional, non-iterative optimization option. |
| **Agent ROI** | Private Preview (Public Preview soon) | Tracks business value, token + tool cost, and net value per agent version over time; drill into low-ROI traces. |
| **OpenTelemetry memory semantics** | Contributed (coming soon to Foundry) | New OpenTelemetry semantics for memory contributed to the OSS community, coming soon into Foundry. |

### Next actions

- Try the capabilities hands-on at the **Microsoft Build lab**; the lab is also available to **take with you / online** if you can't attend in person.
- Engage your **sales team** to participate in the **Agent Optimizer** and **Agent ROI** Private Previews and provide feedback.
- Related sessions the next day: a **Microsoft 365 (Agent 365) breakout** covering how Foundry observability aligns with Microsoft 365; a **demo session** going deeper on the interoperability story; and a **lightning talk** on how **Azure Monitor** fits into the picture.
- Start building in **GitHub**, then use **Foundry** for evaluation, optimization, governance, and running agents, and distribute via **Microsoft 365 Copilot, Teams, apps, and APIs**.
