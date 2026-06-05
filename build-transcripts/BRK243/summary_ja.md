# Microsoft Build 2026 BRK243「Claws and Agent Harness in Microsoft Foundry」詳細まとめ

**登壇者**:
- **Sean Henry** — Microsoft Foundry チーム（司会・Agent Framework 担当）
- **Glenn**（姓不明） — Microsoft Foundry チーム（Hermes デモ担当）
- **Amanda**（姓不明） — Microsoft Foundry チーム（Autopilot Agents・Teams 連携担当）

**セッションURL**: https://build.microsoft.com/en-US/sessions/BRK243
**取得元**: 公式 WebVTT トランスクリプト（medius.microsoft.com CAPTION）

---

## 全体像

本セッションは Microsoft Build 2026 Day 2 のブレイクアウトセッションとして、Microsoft Foundry 上で高度なエージェントを構築・デプロイするための技術的手法を詳細に解説した。

セッションの中心テーマは「Agent Harness（エージェントハーネス）」の概念と、それを Microsoft Foundry 上で実現する具体的な手段。3 つのアプローチを軸に展開された。(1) オープンソースの Claude-style エージェントである **Hermes** を Foundry Hosted Agents 上で動かすデモ、(2) **Microsoft Agent Framework** を使ったカスタムハーネスのコード実装デモ、(3) ビルドしたエージェントを **Teams / M365 Copilot** に One-Click でパブリッシュし、新機能 **Autopilot Agents** を活用するデモ、の 3 本立て。

セッション全体を通じて、ネットワーク不調（「conference Internet」）によるデモのハプニングが複数回発生したが、登壇者が即興でリカバリーしながら、核心的な概念は十分に伝えることができた。

---

## Chapter 1: Foundry のレイヤー構造とセッションの位置づけ（0:00頃）

Sean が Foundry 全体のアーキテクチャをスライドで説明。Foundry は以下の 3 層から構成される。

1. **Intelligence Layer（知能層）**: 数百〜数千のモデルが利用可能な基盤
2. **Runtime Layer（ランタイム層）**: エージェントのホスティング・デプロイ・管理を担う
3. **Human & Agent Collaboration Layer（連携層）**: Teams・M365 Copilot などを通じて人間とエージェントが協働する層

これらの全層は「Trust / Security / Manageability / Observability / Evaluations」のラッパーで包まれ、本番運用を想定した信頼基盤が整備されている。

本セッションでは、プロンプトエージェント（ポータルで簡単に作れる低コード型）ではなく、**コードで書く高度なエージェント**—ライブラリを持ち込み、外部システムに接続し、ランタイム層をフル活用する—に焦点を当てる。

前日（Day 1）に Tina と Jeff が行った Foundry 概要セッションを前提とし、本セッションはその続編として Agent Runtime と Agent Collaboration に深く踏み込む。

---

## Chapter 2: Agent Harness とは何か—概念の定義（0:47頃）

Sean がセッションの中核概念を定義。

> 「エージェントハーネスとは、エージェントを囲む『シェル』—エージェントが長く複雑なタスクを実行できるようにするためのツールの集合体」

**自動車のアナロジー**: エージェントがモーター（エンジン）であり、ハーネスはそれを乗り物として機能させるための車体全体（ハンドル・タイヤ・シート等）。

### Agent Harness の構成要素

| 要素 | 説明 |
|------|------|
| **Agent Loop** | コンテキスト＋ツール → LLM 呼び出し → ツール実行 → 繰り返し → ゴール達成、という中核ループ |
| **Context Management** | プロンプト・メッセージ・ツール・スキルで膨れるコンテキストを管理。**Context Compaction**（コンテキスト圧縮）を実施してウィンドウを管理可能に保つ |
| **Skills & Tools** | スキル（テキストベースの能力定義）＋ツール（MCP / OpenAPI 経由）。特にファイルシステム・コード実行・シェル実行といった「コンピュータを与える」ツールが強力 |
| **Multi-agent Orchestration** | Web 閲覧・コード実行・文書合成など特化型エージェントの協調管理 |
| **Memory & Session Persistence** | 複数セッションをまたいだ学習・記憶の保持。ランタイムをステートレスに保てる |
| **Lifecycle Hooks** | エージェント実行前後・LLM 呼び出し前後・ツール呼び出し前後にポリシー/ロジックを注入できる拡張点 |
| **Human-in-the-Loop** | 高リスクなツール呼び出し（ファイル書き込み・コード実行等）前に人間へ確認を求めるチャネル |

「過去 6 か月でフロンティアモデルのコーディング能力が飛躍的に向上し、GitHub Copilot・Claude Code・Cursor のようなコーディングエージェントが台頭。さらに Open Claude（「Claw」は自動字幕の聞き間違い）が登場して『エージェントが自身のマシンを持ち、長時間稼働し続ける』アーキテクチャが普及してきた。これをエンタープライズ向けに転用するのが今日のテーマ」（Sean）

---

## Chapter 3: Demo 1 — Hermes on Foundry Hosted Agents（8:00頃）

Glenn が登壇。**Hermes** は Claude-style（「Claw-style」）のエージェントハーネス実装で、以下の特性を持つ。

- 記憶・ファイルシステム・ツール・自律実行の能力を持つ
- Telegram / Slack などお好みのコミュニケーション経路に対応
- Open Claude の直系クローンではなく、独自実装（ただし同種のアーキテクチャ思想）
- タスクを繰り返すほど自己改善するスキルの蓄積メカニズムを内蔵

### デモの構成（Foundry Hosted Agents 上）

```
ローカルマシン上の TUI（ターミナル UI: Hermes TUI）
    ↓ AGUI プロキシ経由
Foundry Hosted Agents 上の Hermes インスタンス
    ↓
Foundry 上のモデル（Azure DefaultCredential で認証）
    ↓ MCP 接続
WorkIQ SharePoint（MCP サーバー）
```

Glenn は TUI から Hermes に話しかけ、SharePoint 上の `build_demos.docx`（前日の Tina & Jeff セッションのデモスクリプト）にアクセスするデモを試みたが、**会場ネットワーク不良で MCP 接続に失敗**というハプニングが発生。「networking is bad」と実況しながらも、MCP 接続の仕組みと WorkIQ MCP の存在自体は正常にデモできた。

### セッション ID とファイルシステムの分離

Hermes の各インスタンスはセッション ID で識別される（例: `george-build-hermes`）。この ID を変えると（例: `jeff-build-hermes`）、全く別のファイルシステム・別の VM 上に新鮮なインスタンスが起動する。

- ファイルシステムはデプロイ時のスナップショットから再作成
- 非アクティブ 30 日後にファイルシステムは削除（Foundry Hosted Agents の仕様）
- セッション ID = ユーザー固有のエージェント空間の識別子

### 新機能: Routines（Preview）

Foundry Hosted Agents に追加された新機能。エージェントが外部の刺激に反応して定期実行されるスケジュール機能。

**Routines の用途例**:
- 定期メンテナンス（古くなったスキルの削除・ファイルのキュレーション）
- Hermes 自身のバックアップ（毎晩 Azure Blob Storage へ）
- エージェントが自分自身で Routine を作成・管理（自己メンテナンス）

**作成方法**: Foundry ポータル上で「エージェント・セッション・プロンプト・繰り返しスケジュール」を指定。**エージェント自身が Routine を作成できる**のが特徴（Glenn の Hermes インスタンスでは初回接続時に自動的にメンテナンス Routine が作成された）。

Glenn が強調した設計ポイント: **「状態（State）の扱い方を事前に決めること」**

- エージェントをシャットダウン可能にしたいなら、メンテナンス処理を Routines に外出しする必要がある
- 15 分アイドルでシャットダウン → Routine がトリガーされて起動し直す
- 「クラウドの Pet vs. Cattle 論で言えば、Hermes は究極のペット—名前までついている」

---

## Chapter 4: Microsoft Agent Framework の概要（21:30頃）

Sean が登壇し直し、Microsoft Agent Framework を紹介。

- **GA 済み**: バージョン 1.0 は 2026 年初頭にリリース済み
- **プレビュー開始**: 2025 年 10 月
- **言語**: Python & C#（完全フィーチャーパリティ）

### 3 層構造

#### ① Agent Loop

Framework の核心。Foundry モデルとの接続・LLM 呼び出し・ツール実行のループを抽象化。

- **マルチモデル対応**: Foundry / OpenAI / Anthropic (Claude) / Gemini / Bedrock / Ollama
- **ツール接続**: OpenAPI・MCP・コード直接実装
- **デプロイ先**: Foundry Hosted Agents / Azure Functions / Azure Container Apps / AWS も可（一応）
- **エージェントコネクタ**: Foundry Prompt Agents・Copilot Studio・Claude Code・GitHub Copilot CLI・A2A プロトコル

#### ② Workflows

Multi-agent システム構築用のビルトイン構造:

| パターン | 説明 |
|---------|------|
| Sequential | エージェント間の順次ハンドオフ（コンテキストも移動） |
| Author-Critic | 出力を継続改善するエージェントペア |
| **Magentic** | Microsoft Research と共同開発。スーパーバイザーが計画し、サブエージェントが実行 |
| Custom | コードまたは YAML で自由定義。エージェントと通常コードの混在も可 |

#### ③ Agent Harnesses（最新追加）

ビルトインで提供される機能群:
- ファイルシステム・コード実行・シェル実行ツール
- Context Compaction、ツール選択アルゴリズム
- 計画フェーズ（Planning）とサブエージェント専門化
- ミドルウェア拡張（パーミッション・ケイパビリティ定義）
- OpenTelemetry Gen AI 仕様準拠のフルテレメトリ出力

---

## Chapter 5: Demo 2 — Microsoft Agent Framework でカスタムハーネスを構築（25:50頃）

Sean がコードデモを実施（C# で示し Python でも同一機能）。

### 最小ハーネスの作成

```csharp
// chatClient = Agent Loop の中核（Foundry モデル接続済み）
var harness = chatClient.AsAgentHarness();
// ↑ この一行でファイルシステム・コード実行・Context Compaction が自動付与
// （Preview 中は数行の追加設定が必要だが GA 時に省略可能予定）
```

### カスタム化例（Research Agent）

```csharp
var agent = new ResearchAgent {
    Name        = "ResearchAgent",
    Tools       = [ new WebPageToMarkdownTool() ],
    ModelOptions = { ReasoningEffort = "high" },
    FileAccess  = { StorePath = "..." },
    Memory      = { MemoryStore = "..." },
    Telemetry   = { Endpoint = foundryEndpoint },          // Gen AI OTEL 準拠
    BackgroundAgents = [ new WebSearchBackgroundAgent() ]  // バックグラウンドウェブ検索
};
```

### Harness Console（TUI）でのデモ実行

プロンプト: `"Write a blog about Microsoft's Agent Framework announces at Build 2026"`

実行中の挙動:
1. **Plan Mode** で計画を立案（To-do リスト生成）
2. 事前に保存されたスキルファイル（ブログアウトライン用スキル）を自動読み込み
3. **Human-in-the-loop**: 「読者層は誰にしますか？」と途中で質問（ハーネスイベントとして発火）
4. 回答（「AI エージェントを作る開発者向け」）を受けて実行フェーズへ移行
5. バックグラウンドウェブ検索・ページ取得しながらブログ執筆

### AGUI 対応（Web UI を数行で追加）

```csharp
app.UseAgui(agent);  // AGUI エンドポイントを即時追加
```

**AG-UI（AGUI）** はエージェントと UI が通信するためのオープン標準プロトコル。**CopilotKit** がこの AG-UI の React 実装を提供。グラフ・チャート等のリッチコントロールを**追加コード不要**で埋め込める（セールス CSV を分析するデモエージェントでグラフを自動生成するデモを実施）。

### 3 つの実行オプション

| オプション | 用途 |
|-----------|------|
| Workflow 内直接組み込み | UI なし・バックグラウンドで自動実行 |
| Harness Console（TUI） | 開発・デバッグ・プロトタイピング |
| AGUI + CopilotKit | エンドユーザー向け Web UI |

### Foundry Agent Inspector との連携

`agent.UseAgentHostBuilder().CreateResponsesEndpoint()` で Foundry Responses エンドポイントに公開。**Foundry Toolkit Agent Inspector** でエージェントに直接接続してリアルタイムデバッグ・トレース確認が可能。

ワンクリックで Foundry Hosted Agents にデプロイ後は、Foundry のトレース・評価・監視の全機能が利用可能になる。

---

## Chapter 6: Demo 3 — Teams & M365 Copilot へのワンクリックパブリッシュ（35:10頃）

Amanda が登壇。Foundry にデプロイしたエージェントをエンドユーザーが実際に使う場所に公開するフローを解説。

### パブリッシュフロー

1. Foundry ポータルの **「Publish」ドロップダウン** をクリック
2. **「Publish to Teams and M365 Copilot」** を選択
3. ダイアログで名前・説明・エンドユーザー向けアクション説明を入力
4. スコープを選択:
   - **自分だけに公開**: 即時利用可能（テスト目的）
   - **組織全体に公開**: Microsoft Admin Center に承認申請 → 承認後に全社展開
5. オプション: **「Download & Customize」**（Copilot Studio 等でカスタマイズ）

パブリッシュ後は **Teams と M365 Copilot の両 UI** が自動生成される（追加コード不要）。

デモエージェント: SaaS 系顧客・製品サポートエージェント。M365 Copilot で「どんな製品を売っているか」に即答するデモを実施。

---

## Chapter 7: 新機能発表 — Autopilot Agents（39:50頃）

Amanda がエージェントの 3 類型を整理し、新機能を発表。

### エージェント 3 類型

| 種類 | 動作 | 権限 |
|------|------|------|
| **Assisted Agents** | ユーザーセッション中に稼働。WorkIQ ツールでメール送信・Teams メッセージ下書き等を代行 | ユーザー代理 |
| **Autonomous Agents** | 非ユーザートリガー（イベント等）で独立起動。Azure リソースグループや Storage Account へ直接権限付与可能 | サービスプリンシパル。WorkIQ 系アクション不可 |
| **Autopilot Agents** ★新機能 | 常時独立動作。**Microsoft 365 ユーザーアカウント** を保有 | ユーザーアカウントと同等（最高権限） |

### Autopilot Agents の詳細

Autopilot Agent は組織内の「一人の M365 ユーザー」として扱われる:

- 独自のメールアドレスエイリアス
- 自分の名義で Teams メッセージを送信
- 自分の名義で Word ドキュメントを作成
- ユーザーアカウントを必要とするあらゆる M365 アクションを実行可能

**Scout**（Microsoft Foundry の既製 Autopilot Agent）は本機能の実装例として前日キーノートで紹介済み。本セッションでは、開発者が独自 Autopilot Agent を作れる**プラットフォームとしての機能**が公開された。

### Group Chat デモ（Workstream Manager Agent）

Foundry チームが GitHub で公開した Hero シナリオのサンプル: **Workstream Manager Agent**

機能:
- グループチャット全メッセージを監視して未対処事項をトラッキング
- グループ内の質問に自律回答
- オンボーディングフロー内蔵（「誰と話してよいか」を作成者に確認し許可リストを設定）
- **スマートな Group Chat 動作**: 全メッセージに反応せず、必要な場合のみ発話（@メンション対応）

デモの流れ:
1. Admin Center → Requests タブでエージェントを承認
2. Teams でエージェントを「ハイヤー（雇用）」
3. エージェントが作成者にオンボーディングメッセージを送信 → 許可ユーザーを設定
4. グループチャットで動作確認（許可されていないユーザーへは応答しない）

**ハプニング**: Teams に @メンションしたが応答が遅れる場面があった（「Hopefully the agent woke up this morning」と Amanda がコメント）。最終的にエージェントは正常に応答した。

---

## Chapter 8: クロージング（44:00頃）

Sean がセッション全体を総括し、以下のリソースを案内:

- **GitHub**: デモコード全公開（セッション資料に URL）
- **Agent League Hackathon**: 6 月 14 日締切、豪華賞品あり（QR コードで参加登録）
- **Foundry & Agents ブース**: 会場内で Q&A 対応、スティッカー配布あり
- 関連セッション（Day 1 の Foundry 概要セッション等）はオンラインで視聴可能

---

## まとめ

### 発表された新機能一覧

| 機能名 | 状態 | 説明 |
|--------|------|------|
| **Microsoft Agent Framework v1.0** | **GA** | Python & C# でエージェントとハーネスを構築する公式 SDK |
| **AsAgentHarness() API** | **GA** | 既存エージェントに一行でハーネス機能を追加 |
| **Routines（Foundry Hosted Agents）** | **Public Preview** | エージェントが定期タスクをスケジュール実行。エージェント自身が Routine を作成可能 |
| **AG-UI / AGUI サポート** | **Preview**（推測） | `UseAgui()` 一行で Web UI エンドポイントを追加。CopilotKit 連携でリッチ UI |
| **Autopilot Agents** | **Public Preview**（推測） | M365 ユーザーアカウントを持つ自律エージェント。メール・Teams 送信等が可能 |
| **Publish to Teams & M365 Copilot** | **GA**（推測） | Foundry ポータルからワンクリックでパブリッシュ。Teams と M365 Copilot の両 UI を自動生成 |
| **Workstream Manager Agent サンプル** | **Public Preview**（推測） | Autopilot Agent の Group Chat Hero シナリオ。GitHub で公開 |

### 次のアクション

- GitHub の公開リポジトリ（セッション資料参照）でサンプルコードを試す
- Foundry ポータルで **Routines** を作成・実験する
- Microsoft Agent Framework の `AsAgentHarness()` API を C# または Python でコード体験する
- **AG-UI + CopilotKit** で Web UI 付きエージェントをプロトタイピングする
- **Autopilot Agents** でチーム向け Workstream Manager を構築してみる
- **Agent League Hackathon** に参加する（6 月 14 日締切）