# Microsoft Build 2026 — セッション トランスクリプト & 日本語まとめ

Microsoft Build 2026（2026年6月・サンフランシスコ開催）の、**Microsoft Foundry を中心とした 32 セッション**について、公式トランスクリプト（WebVTT）を取得し、日本語で詳細にまとめたアーカイブです。

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

| ID | セッション | ひとことで言うと |
|----|-----------|------------------|
| [BRK230](BRK230/summary_ja.md) | Build smarter AI systems as models and costs evolve | 「選定→評価→最適化→スケール」の4フェーズ法。単一モデルを追わず eval を軸に品質・コスト・遅延を山登り改善。 |
| [BRK232](BRK232/summary_ja.md) | Post-Training & Deploying Open Source Reasoning Models | 蒸留+SFT+RFT で小型安価モデル(Qwen 14B)をフロンティア(GPT-5.2)品質へ。約1/10コストでエージェント化。 |
| [BRK231](BRK231/summary_ja.md) | Deploy. Observe. Learn. RL for production agents | Foundry ポストトレーニングの4デモ。IPを自社の重みに残しつつトークン浪費エージェントを経済的に維持。 |
| [BRKSP91](BRKSP91/summary_ja.md) | Turn foundation models into production AI (Fireworks AI) | 基盤モデルを本番 AI へ。Fireworks AI × Harvey AI の実適用事例。 |
| [BRKSP94](BRKSP94/summary_ja.md) | Orchestrate special agents with NVIDIA Nemotron | NVIDIA Nemotron モデル群で専門エージェントをオーケストレーション、Foundry Hosted Agents 実演。 |
| [DEM321](DEM321/summary_ja.md) | Post-Training & Deploying OSS Reasoning Models (デモ) | トークンコスト急増問題に対し OSS モデルのポストトレーニングで品質維持＆コスト削減。 |
| [DEM322](DEM322/summary_ja.md) | Smaller, faster, smarter: Distilling models | 本番トレースから小型モデルへ知識蒸留。AI を"贅沢品"から"ユーティリティ"へ民主化。 |
| [DEM323](DEM323/summary_ja.md) | Under the hood of Microsoft AI models | 基調講演で発表された Microsoft AI の新7モデルを哲学・アーキ・学習レシピまで深掘り。 |

### B. エージェント構築 〜 コンテキスト・ツール・スケール
モデルに「正しい知識・ツール・本番への道」を与えてエージェント化する。

| ID | セッション | ひとことで言うと |
|----|-----------|------------------|
| [BRK240](BRK240/summary_ja.md) | Build context-aware agents: From data to decisions | **Microsoft IQ**（Work/Web/Foundry/Fabric IQ）を発表。「エージェントはコンテキスト不足で失敗する」を実演。 |
| [BRK246](BRK246/summary_ja.md) | Foundry IQ: enterprise knowledge & agentic retrieval | Foundry IQ ライブツアー。ファイル→1分で自動MCPサーバ、サーバーレス、第2世代エージェント検索。 |
| [BRK242](BRK242/summary_ja.md) | Turn your agents into action: tools, APIs, documents | **Toolbox** で任意ツールを単一の統制MCPエンドポイントに集約。**Content Understanding** で乱雑な文書を整形。 |
| [BRK241](BRK241/summary_ja.md) | From prototype to production: agents at scale | 「自律ファイバー障害対応エージェント」を Build→Deploy→Operate で実演。Foundry を本番 OS と位置付け。 |
| [BRK243](BRK243/summary_ja.md) | Claw and agent harness in Microsoft Foundry | エージェントハーネスの3つの道。Microsoft Agent Framework と Autopilot Agents で Teams/M365 へ公開。 |
| [DEM331](DEM331/summary_ja.md) | Turn APIs, tools, and data into real agent velocity | **Content Understanding** で乱雑なマルチモーダル文書を単一パイプラインで構造化データへ。 |
| [DEM332](DEM332/summary_ja.md) | From zero to teammate in 25 min: Teams agent live | 25分でゼロから Teams 上で動くエージェントをライブ構築。 |
| [DEM333](DEM333/summary_ja.md) | How Foundry integrates with OSS frameworks | LangChain/LangGraph + MCP/A2A/OpenTelemetry で作ったエージェントを Foundry で本番化。 |

### C. 観測・統制・価値証明（ガバナンス & ROI）
エージェントを信頼でき、制御でき、安全で、ROI 説明可能にする。

| ID | セッション | ひとことで言うと |
|----|-----------|------------------|
| [BRK250](BRK250/summary_ja.md) | Observe and control agents across any framework (OSS) | 責任あるAIの「識別→評価→制御→監視」サイクル。プロンプトではなく決定論的ガードレールで信頼を担保。 |
| [BRK252](BRK252/summary_ja.md) | From observability to ROI for AI agents | Foundry Observability。任意フレームワークのトレーシング、トレース根拠の評価、自動最適化、ROI 追跡。 |
| [BRK251](BRK251/summary_ja.md) | Build secure & enterprise-ready agents with Agent 365 | **Agent 365** を発表。あらゆるエージェント（自社/パートナー/外部Bedrock・Vertex）を SDK と M365管理センターで統制。 |
| [DEM340](DEM340/summary_ja.md) | Build work-ready agents + Work IQ, govern with Agent 365 | Foundry（構築）と Agent 365（統制）を開発者/IT管理者の両視点で一気通貫デモ。 |
| [DEM341](DEM341/summary_ja.md) | Any agent, any cloud: tracing with Foundry+OpenTelemetry | GCP/AWS 上のエージェントも OpenTelemetry で標準化トレーシング。 |
| [OD831](OD831/summary_ja.md) | Govern AI models, tools, agents with Azure API Management | APIM を AI ゲートウェイ化し、モデル・ツール・エージェントをエンタープライズ統制。 |
| [OD840](OD840/summary_ja.md) | Enable agents for enterprises using Agent 365 SDK | Agent 365 SDK / CLI でエージェントをエンタープライズ対応に。セキュリティ視点も。 |

### D. プラットフォーム・OSS・Claude・キーノート裏側
Azure インフラの内側、OSS ランタイム、Claude 統合、業界横断トピック。

| ID | セッション | ひとことで言うと |
|----|-----------|------------------|
| [BRK226](BRK226/summary_ja.md) | Inside Azure innovations with Mark Russinovich | Azure CTO による恒例セッション。HW〜OS〜セキュリティ〜AI推論最適化までデモ付きで公開。 |
| [BRK225](BRK225/summary_ja.md) | Data, apps, and agents: future of app dev with Rayfin | Fabric/Power BI/Replit を交えたデータ×アプリ×エージェントの次世代アプリ開発。 |
| [BRK233](BRK233/summary_ja.md) | Software Defensibility in the era of AI coding | Chip Huyen が AI コーディング時代の競合優位（モート）の変質と残る問題空間を論じる。 |
| [BRK235](BRK235/summary_ja.md) | Local models, developer control, future of AI runtimes | Ollama 共同創業者によるローカル/クラウド・ハイブリッド実行とオープンモデル。 |
| [BRK245](BRK245/summary_ja.md) | Build the thing that builds the thing | OpenClaw メンテナーがコーディングエージェントの自律ループを閉じる自作ツール群を紹介。 |
| [LIVE144](LIVE144/summary_ja.md) | Behind the Keynote: OpenClaw on Windows | キーノートデモ「OpenClaw の Windows 動作」の舞台裏を Scott Hanselman が語る対談。 |
| [DEMSP388](DEMSP388/summary_ja.md) | Ship faster with Claude Code and Cowork in Foundry | Anthropic が Foundry 上の Claude Code でエージェンティック・コーディングを実演。 |
| [ODSP934](ODSP934/summary_ja.md) | Unlock Claude in Microsoft Foundry | Microsoft × Anthropic。Foundry で Claude を本番導入する方法。 |
| [OD839](OD839/summary_ja.md) | AI for industrial innovation and sovereign control | 接続断・主権要件の厳しい産業/公共環境で完全ディスコネクト AI を運用。 |

---

## 📂 フォルダ構成

```
build-transcripts/
├── README.md                  # 本ファイル（テーマ別ガイド）
├── _index.md                  # 取得結果の生インデックス（バイト数・ステータス等）
├── manifest.json              # 取得メタデータ（ID, title, description, asset_id, route, bytes）
├── manifest_more.json         # 追加取得分のメタデータ
└── {SESSION_ID}/
    ├── transcript_raw.vtt     # 取得した生 WebVTT（タイムスタンプ付き）
    ├── transcript_clean.txt   # クリーニング済みプレーンテキスト
    └── summary_ja.md          # 日本語の詳細まとめ
```

## ℹ️ 取得方法について

- セッションページの `og:image` から ASSET_ID を抽出 → `https://medius.microsoft.com/video/asset/CAPTION/{ASSET_ID}` で公式 WebVTT を取得。
- **32 / 32 セッションすべて**で公式トランスクリプトの取得に成功（フォールバックなし）。
- 各 `summary_ja.md` は、登壇者 → 全体像 → タイムスタンプ付きセクション → まとめ（コアメッセージ・発表機能一覧・次アクション）の統一フォーマット。
- 登壇者名はトランスクリプトの自己紹介から特定できた範囲で記載しています。

> 英語版の Foundry コアセッションまとめは [`../Foundry-summary-en/`](../Foundry-summary-en/) にあります。
