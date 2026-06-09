# Microsoft Build 2026 — セッション トランスクリプト & 日本語まとめ

Microsoft Build 2026（2026年6月・サンフランシスコ開催）の、**Microsoft Foundry を中心とした 32 セッション＋ Foundry コア外の追加 8 セッション（計 40 セッション）**について、公式トランスクリプト（WebVTT）を取得し、日本語で詳細にまとめたアーカイブです。

> 🆕 追加 8 セッション（オープニング基調講演 KEY01／Windows BRK260-262／モデル・エージェント文化 BRK234・244・247・209）は、公式カタログ実API（`api-v2.build.microsoft.com/api/session/all`、全460件）の全件クロールで洗い出したものです。詳細な全カタログ調査結果は [`catalog_build2026_full.md`](./catalog_build2026_full.md) を参照。

> 📄 取得状況・ファイル一覧・バイト数などの**生インデックス**は [`_index.md`](./_index.md) を参照してください。
> このページは「**どのセッションが何を話しているか**」をテーマ別にパッと把握するための技術ガイドです。

---

## 🎯 Build 2026 の技術的な全体像

Build 2026 の Foundry のストーリーは、エージェント型 AI が「モデルを選んで動かす」段階から、**エンタープライズ規模でエージェントを構築・運用・統制・ROI 実証するための"本番 OS"** へと成熟したことを示しています。全セッションを貫くライフサイクルは次の一本の流れに集約されます。

```
モデルを選ぶ → コンテキストで根拠付ける → エージェントを構築・デプロイ
   → ツール/データを接続 → 観測・統制・ROI を証明 → 継続学習(ポストトレーニング)で改善
```

### 繰り返し登場する 4 つのテーマ

1. **Eval ファースト（評価駆動）** — 評価を最終QAではなく*プロダクト仕様そのもの*として扱う。先に成功基準を定義し、継続的に計測してシステム全体を改善する。
2. **タスク分解 > 万能モデル** — "マイクロサービス"的発想で各タスクを適切なサイズのモデルにルーティング。小型モデルを蒸留/ファインチューニングしてフロンティア品質に引き上げ、コストを約 1/10 に。
3. **ボトルネックはモデル性能ではなくコンテキスト** — エージェントは「企業内知識の欠如」で失敗する。Microsoft IQ / Foundry IQ が Work・Web・Fabric・Foundry のコンテキストを安全に供給する。
4. **任意フレームワークへの開放性 + エンタープライズ統制** — OSS 仕様と OpenTelemetry ベースのトレーシングでフレームワークに依存せず観測・制御し、Agent 365 が ID・セキュリティ・管理を担う。

---

## 🗺️ テーマ別アジェンダ（セッションが何を話しているか）

### A. モデル・コスト・ポストトレーニング 〜 経済性と品質のエンジンルーム
モデルの選定・ルーティング・蒸留・強化学習チューニングを扱う。

| ID | セッション | Speaker | ひとことで言うと |
|----|-----------|---------|------------------|
| [BRK230](Sessions/BRK230/summary_ja.md)<br><sub>📑 [pptx あり](Sessions/BRK230/BRK230_slides.pptx)</sub> | Build smarter AI systems as models and costs evolve | Yina Arenas, Naomi Moneypenny | 「選定→評価→最適化→スケール」の4フェーズ法。単一モデルを追わず eval を軸に品質・コスト・遅延を山登り改善。 |
| [BRK232](Sessions/BRK232/summary_ja.md)<br><sub>📑 [pptx あり](Sessions/BRK232/BRK232_slides.pptx)</sub> | Post-Training & Deploying Open Source Reasoning Models | Chris, Vijay, Manoj | 蒸留+SFT+RFT で小型安価モデル(Qwen 14B)をフロンティア(GPT-5.2)品質へ。約1/10コストでエージェント化。 |
| [BRK231](Sessions/BRK231/summary_ja.md)<br><sub>📑 [pptx あり](Sessions/BRK231/BRK231_slides.pptx)</sub> | Deploy. Observe. Learn. RL for production agents | Alicia Frame, Omkar More | Foundry ポストトレーニングの4デモ。IPを自社の重みに残しつつトークン浪費エージェントを経済的に維持。 |
| [BRKSP91](Sessions/BRKSP91/summary_ja.md)<br><sub>📑 [pptx あり](Sessions/BRKSP91/BRKSP91_slides.pptx)</sub> | Turn foundation models into production AI (Fireworks AI) | Vivek Chauhan, Jed (Fireworks AI), Nico Grupin (Harvey AI) | 基盤モデルを本番 AI へ。Fireworks AI × Harvey AI の実適用事例。 |
| [BRKSP94](Sessions/BRKSP94/summary_ja.md) | Orchestrate special agents with NVIDIA Nemotron | Joey, Steven McCullough (NVIDIA) | NVIDIA Nemotron モデル群で専門エージェントをオーケストレーション、Foundry Hosted Agents 実演。 |
| [DEM321](Sessions/DEM321/summary_ja.md)<br><sub>📑 [pptx あり](Sessions/DEM321/DEM321_slides.pptx)</sub> | Post-Training & Deploying OSS Reasoning Models (デモ) | Chris, Vijay | トークンコスト急増問題に対し OSS モデルのポストトレーニングで品質維持＆コスト削減。 |
| [DEM322](Sessions/DEM322/summary_ja.md)<br><sub>📑 [pptx あり](Sessions/DEM322/DEM322_slides.pptx)</sub> | Smaller, faster, smarter: Distilling models | William (Foundry Fine Tuning) | 本番トレースから小型モデルへ知識蒸留。AI を"贅沢品"から"ユーティリティ"へ民主化。 |
| [DEM323](Sessions/DEM323/summary_ja.md) | Under the hood of Microsoft AI models | Dave Citron (CVP, Microsoft AI) | 基調講演で発表された Microsoft AI の新7モデルを哲学・アーキ・学習レシピまで深掘り。 |

### B. エージェント構築 〜 コンテキスト・ツール・スケール
モデルに「正しい知識・ツール・本番への道」を与えてエージェント化する。

| ID | セッション | Speaker | ひとことで言うと |
|----|-----------|---------|------------------|
| [BRK240](Sessions/BRK240/summary_ja.md)<br><sub>📑 [pptx あり](Sessions/BRK240/BRK240_slides.pptx)</sub> | Build context-aware agents: From data to decisions | Amanda Silver, Marco Casalaina | **Microsoft IQ**（Work/Web/Foundry/Fabric IQ）を発表。「エージェントはコンテキスト不足で失敗する」を実演。 |
| [BRK246](Sessions/BRK246/summary_ja.md)<br><sub>📑 [pptx あり](Sessions/BRK246/BRK246_slides.pptx)</sub> | Foundry IQ: enterprise knowledge & agentic retrieval | Pablo | Foundry IQ ライブツアー。ファイル→1分で自動MCPサーバ、サーバーレス、第2世代エージェント検索。 |
| [BRK242](Sessions/BRK242/summary_ja.md) | Turn your agents into action: tools, APIs, documents | Maria Nagaga, Joe Flick | **Toolbox** で任意ツールを単一の統制MCPエンドポイントに集約。**Content Understanding** で乱雑な文書を整形。 |
| [BRK241](Sessions/BRK241/summary_ja.md)<br><sub>📑 [pptx あり](Sessions/BRK241/BRK241_slides.pptx)</sub> | From prototype to production: agents at scale | Tina Schackman, Jeff Holland | 「自律ファイバー障害対応エージェント」を Build→Deploy→Operate で実演。Foundry を本番 OS と位置付け。 |
| [BRK243](Sessions/BRK243/summary_ja.md)<br><sub>📑 [pptx あり](Sessions/BRK243/BRK243_slides.pptx)</sub> | Claw and agent harness in Microsoft Foundry | Sean Henry, Glenn, Amanda | エージェントハーネスの3つの道。Microsoft Agent Framework と Autopilot Agents で Teams/M365 へ公開。 |
| [DEM331](Sessions/DEM331/summary_ja.md)<br><sub>📑 [pptx あり](Sessions/DEM331/DEM331_slides.pptx)</sub> | Turn APIs, tools, and data into real agent velocity | （特定できず） | **Content Understanding** で乱雑なマルチモーダル文書を単一パイプラインで構造化データへ。 |
| [DEM332](Sessions/DEM332/summary_ja.md)<br><sub>📑 [pptx あり](Sessions/DEM332/DEM332_slides.pptx)</sub> | From zero to teammate in 25 min: Teams agent live | Umang, Aamir | 25分でゼロから Teams 上で動くエージェントをライブ構築。 |
| [DEM333](Sessions/DEM333/summary_ja.md) | How Foundry integrates with OSS frameworks | Facundo, Nakul Kumar | LangChain/LangGraph + MCP/A2A/OpenTelemetry で作ったエージェントを Foundry で本番化。 |

### C. 観測・統制・価値証明（ガバナンス & ROI）
エージェントを信頼でき、制御でき、安全で、ROI 説明可能にする。

| ID | セッション | Speaker | ひとことで言うと |
|----|-----------|---------|------------------|
| [BRK250](Sessions/BRK250/summary_ja.md)<br><sub>📑 [pptx あり](Sessions/BRK250/BRK250_slides.pptx)</sub> | Observe and control agents across any framework (OSS) | Sarah Bird, Sandeep Atluri | 責任あるAIの「識別→評価→制御→監視」サイクル。プロンプトではなく決定論的ガードレールで信頼を担保。 |
| [BRK252](Sessions/BRK252/summary_ja.md)<br><sub>📑 [pptx あり](Sessions/BRK252/BRK252_slides.pptx)</sub> | From observability to ROI for AI agents | Sebastian, Felicia, Vivek | Foundry Observability。任意フレームワークのトレーシング、トレース根拠の評価、自動最適化、ROI 追跡。 |
| [BRK251](Sessions/BRK251/summary_ja.md)<br><sub>📑 [pptx あり](Sessions/BRK251/BRK251_slides.pptx)</sub> | Build secure & enterprise-ready agents with Agent 365 | Neda, Kendra, Aarthi, Ray (Genspark) | **Agent 365** を発表。あらゆるエージェント（自社/パートナー/外部Bedrock・Vertex）を SDK と M365管理センターで統制。 |
| [DEM340](Sessions/DEM340/summary_ja.md) | Build work-ready agents + Work IQ, govern with Agent 365 | Sri | Foundry（構築）と Agent 365（統制）を開発者/IT管理者の両視点で一気通貫デモ。 |
| [DEM341](Sessions/DEM341/summary_ja.md)<br><sub>📑 [pptx あり](Sessions/DEM341/DEM341_slides.pptx)</sub> | Any agent, any cloud: tracing with Foundry+OpenTelemetry | Hanshi, Nak Kumar | GCP/AWS 上のエージェントも OpenTelemetry で標準化トレーシング。 |
| [OD831](Sessions/OD831/summary_ja.md) | Govern AI models, tools, agents with Azure API Management | Anish Tallapureddy, Mike Budzynski, Sreekanth Thirthala | APIM を AI ゲートウェイ化し、モデル・ツール・エージェントをエンタープライズ統制。 |
| [OD840](Sessions/OD840/summary_ja.md) | Enable agents for enterprises using Agent 365 SDK | Jeremiah Follis, Sunil Garg | Agent 365 SDK / CLI でエージェントをエンタープライズ対応に。セキュリティ視点も。 |

### D. プラットフォーム・OSS・Claude・キーノート裏側
Azure インフラの内側、OSS ランタイム、Claude 統合、業界横断トピック。

| ID | セッション | Speaker | ひとことで言うと |
|----|-----------|---------|------------------|
| [BRK226](Sessions/BRK226/summary_ja.md)<br><sub>📑 [pptx あり](Sessions/BRK226/BRK226_slides.pptx)</sub> | Inside Azure innovations with Mark Russinovich | Mark Russinovich (Azure CTO) | Azure CTO による恒例セッション。HW〜OS〜セキュリティ〜AI推論最適化までデモ付きで公開。 |
| [BRK225](Sessions/BRK225/summary_ja.md)<br><sub>📑 [pptx あり](Sessions/BRK225/BRK225_slides.pptx)</sub> | Data, apps, and agents: future of app dev with Rayfin | Ben, Sachin, Sujata, Carl (Replit) | Fabric/Power BI/Replit を交えたデータ×アプリ×エージェントの次世代アプリ開発。 |
| [BRK233](Sessions/BRK233/summary_ja.md) | Software Defensibility in the era of AI coding | Chip Huyen | Chip Huyen が AI コーディング時代の競合優位（モート）の変質と残る問題空間を論じる。 |
| [BRK235](Sessions/BRK235/summary_ja.md) | Local models, developer control, future of AI runtimes | Michael, Parth (Ollama) | Ollama 共同創業者によるローカル/クラウド・ハイブリッド実行とオープンモデル。 |
| [BRK245](Sessions/BRK245/summary_ja.md) | Build the thing that builds the thing | Peter (OpenClaw) | OpenClaw メンテナーがコーディングエージェントの自律ループを閉じる自作ツール群を紹介。 |
| [LIVE144](Sessions/LIVE144/summary_ja.md) | Behind the Keynote: OpenClaw on Windows | Monica Cisneros, Scott Hanselman | キーノートデモ「OpenClaw の Windows 動作」の舞台裏を Scott Hanselman が語る対談。 |
| [DEMSP388](Sessions/DEMSP388/summary_ja.md) | Ship faster with Claude Code and Cowork in Foundry | Caroline Matthews (Anthropic) | Anthropic が Foundry 上の Claude Code でエージェンティック・コーディングを実演。 |
| [ODSP934](Sessions/ODSP934/summary_ja.md) | Unlock Claude in Microsoft Foundry | Keiji Kanazawa, Caroline Matthews (Anthropic) | Microsoft × Anthropic。Foundry で Claude を本番導入する方法。 |
| [OD839](Sessions/OD839/summary_ja.md) | AI for industrial innovation and sovereign control | Inbal Sagiv | 接続断・主権要件の厳しい産業/公共環境で完全ディスコネクト AI を運用。 |

---

## 🆕 E. Foundry コア外の追加収録（キーノート・Windows・モデル/エージェント文化）

当初の Foundry 中心 32 セッションに加え、公式カタログ全件クロールで選定した「Foundry 以外で特に注目すべき」セッション群。

### 🎤 キーノート

| ID | セッション | Speaker | ひとことで言うと |
|----|-----------|---------|------------------|
| [KEY01](Sessions/KEY01/summary_ja.md) | Microsoft Build opening keynote | Satya Nadella ほか多数 | Build 2026 開幕基調講演。MAI 7モデル・Surface RTX Spark Dev Box・Project Solara・Foundry IQ・Agent 365・OpenClaw on Windows・Maia/Cobalt 200・Horizon DB 等、当日の主要発表を一望できる本丸。 |

### 🪟 Windows / クライアント

| ID | セッション | Speaker | ひとことで言うと |
|----|-----------|---------|------------------|
| [BRK260](Sessions/BRK260/summary_ja.md) | Build Apps w/ Local AI for Unmetered Intelligence on every Windows PC | Anastasiya Tarnouskaya, Aditi Narvekar ほか | すべての Windows PC でローカル推論（従量課金なし）アプリを作る。Windows ML / ローカルモデルとゲスト事例（ClipChamp・VoiceMod）。 |
| [BRK261](Sessions/BRK261/summary_ja.md) | Build and ship faster with a developer-optimized experience on Windows | Kayla Cinnamon, Craig Loewen ほか | winget 構成ファイル・新 Run・Intelligent Terminal・WSL containers・Coreutils など、開発者最適化の Windows 開発体験。 |
| [BRK262](Sessions/BRK262/summary_ja.md) | Building Agents You Can Trust on Windows | Kirupa Chinnathambi, Stuart Schaefer, Patrick Nikoletich | Windows 上で信頼できるエージェントを作る。Agent Identity・権限制御・セキュリティ機構。 |

### 🧠 モデル & エージェント開発文化

| ID | セッション | Speaker | ひとことで言うと |
|----|-----------|---------|------------------|
| [BRK234](Sessions/BRK234/summary_ja.md) | Shipping custom models at scale from fine-tuning to inference | Rob Ferguson (Fireworks AI), Daniel Han (Unsloth), Mark Saroufim | ファインチューニング〜推論デプロイまで、カスタムモデルを本番スケールで出荷する実践知。 |
| [BRK244](Sessions/BRK244/summary_ja.md) | Agent supervision is the new senior engineering skill | swyx (Shawn Wang) | 「エージェント監督（supervision）」こそが新しいシニアエンジニアのスキルだと説く。複数エージェントを束ねて成果を出す方法論。 |
| [BRK247](Sessions/BRK247/summary_ja.md) | Scott and Mark learn...how agents reshape software engineering | Scott Hanselman, Mark Russinovich | 人気ポッドキャストのライブ版。エージェントがソフトウェアエンジニアリングをどう作り変えるかを掛け合いで深掘り。 |
| [BRK209](Sessions/BRK209/summary_ja.md) | Japan Wrap-up Session | 岡崎 ほか日本チーム | 日本語セッション。Build 2026 の主要発表を日本市場視点で総括するラップアップ。 |

---

## 📂 フォルダ構成

```
build-transcripts/
├── README.md                  # 本ファイル（テーマ別ガイド）
├── _index.md                  # 取得結果の生インデックス（バイト数・ステータス等）
├── manifest.json              # 取得メタデータ（ID, title, description, asset_id, route, bytes）
├── manifest_more.json         # 追加取得分のメタデータ
└── Sessions/                  # 全セッションフォルダを格納
    └── {SESSION_ID}/
        ├── transcript_raw.vtt     # 取得した生 WebVTT（タイムスタンプ付き）
        ├── transcript_clean.txt   # クリーニング済みプレーンテキスト
        └── summary_ja.md          # 日本語の詳細まとめ
```

## ℹ️ 取得方法について

- セッションページの `og:image` から ASSET_ID を抽出 → `https://medius.microsoft.com/video/asset/CAPTION/{ASSET_ID}` で公式 WebVTT を取得。
- **40 / 40 セッションすべて**で公式トランスクリプトの取得に成功（フォールバックなし）。
- 各 `summary_ja.md` は、登壇者 → 全体像 → タイムスタンプ付きセクション → まとめ（コアメッセージ・発表機能一覧・次アクション）の統一フォーマット。
- 登壇者名はトランスクリプトの自己紹介から特定できた範囲で記載しています。

> 英語版の Foundry コアセッションまとめは [`../Foundry-summary-en/`](../Foundry-summary-en/) にあります。
