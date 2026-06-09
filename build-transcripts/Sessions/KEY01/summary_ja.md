# Microsoft Build 2026 KEY01「Microsoft Build opening keynote」詳細まとめ

**登壇者**（トランスクリプトから特定。リレー形式の基調講演）:
- Satya Nadella（Microsoft CEO、全体の進行・メインスピーカー）
- Kayla Cinnamon（Windows 開発ツールのデモ）
- Jensen Huang（NVIDIA CEO／創業者。台北からリモート登壇）
- Steven Bathiche（"Stevie"。Project Solara のデモ）
- Cristiano Amon（Qualcomm CEO。事前収録ビデオ対談）
- Elijah Straight（Microsoft IQ のデモ）
- Scott Hanselman / Samantha Song（OpenClaw on Windows のデモ）
- Peter Steinberger（OpenClaw 開発者、"Clawfather"）
- Cassidy Williams（GitHub Copilot アプリ／Rayfin のデモ）
- Amanda Foster（Agent 365 / Foundry のデモ）
- Sarah Young（MDASH セキュリティのデモ）
- Alex Pall / Drew Taggart（The Chainsmokers。Mantis VC ゲストトーク）
- Mustafa Suleyman（Microsoft AI CEO。MAI モデル群を発表）
- Tanaya Yadav（Frontier Tuning のデモ）
- Dr. Gianrico Farrugia（Mayo Clinic 社長兼CEO。ゲスト対談）
- David Carmona（Microsoft Discovery のデモ）
- David Shaw / Sabrina Maniscalco（クロージング動画のナレーション、量子）

**セッションURL**: https://build.microsoft.com/en-US/sessions/KEY01
**取得元**: 公式WebVTTトランスクリプト（medius.microsoft.com CAPTION）

> 注: 本文は自動字幕ベース。固有名詞・数値・バージョン番号で聴き取りが怪しい箇所は「（自動字幕のため不確実）」と明記した。タイムスタンプは raw.vtt からの概算。

---

## 全体像

本基調講演（約2時間20分）でSatya Nadellaが提示した一貫したテーマは「**Frontier intelligence ecosystem（フロンティア知能エコシステム）に開発者がどう全面的に参加するか**」である。鍵となるメッセージは「特定の1つのモデルやプラットフォームではなく、その上に積み上げる価値（value you can compound）こそが重要」というもの。講演はAIスタックを下から上へ（エッジ／クラウド → モデル・コンテキスト・ツール → エージェントランタイム → セキュリティ・ガバナンス）順に登っていく構成で進んだ。

前半は**インフラ**。エッジ（Windows）では「unmetered intelligence（従量課金なしの知能）」を旗印に、Windows ML/Windows AI のGPU拡大、ローカルSLM「Aion Instruct」「Aion Plan」、NVIDIA RTX Spark SoC を載せた Surface（Surface RTX Spark Dev Box）を発表。Jensen Huang がリモート登壇し、RTX Spark とデータセンター側（Vera Rubin、Fairwater 超工場）の協業を語った。クラウドでは Maia 200、Cobalt 200、ネットワーク（MRC アーキテクチャ、AI WAN）を紹介。続いてエージェント時代の新ハード形態「**Project Solara**」（机上型＋ウェアラブルなバッジ型のエージェントファースト端末群）を披露した。

中盤は**インテリジェンス層とランタイム**。Foundry（11,000以上のモデル）、新しいPostgreSQLマネージドサービス「**Horizon DB**」、GPU加速の Fabric、Web向けグラウンディング「**Web IQ**」、企業文脈を束ねる「**Microsoft IQ**（Web IQ / Fabric IQ / Work IQ）」を発表。エージェント実行のためのOSレベル分離機構「**Microsoft Execution Containers（MXC）**」と、その上で動く「**OpenClaw on Windows**」をライブデモ。クラウド側ランタイムとして Foundry ホステッドエージェント、バックエンドSDK「**Rayfin**」（Replit連携）、新しい「**GitHub Copilot アプリ**」を披露。ガバナンスの「**Agent 365**」、セキュリティ harness「**MDASH**」も登場した。

後半は**企業の機会と"会社の未来（future of the firm）"**。Copilot を Chat / Cowork / Code を束ねるスーパーアプリ化し、新概念「**Autopilots**」（最初のものが "Scout"）を導入。Mustafa Suleyman が登壇し、**MAI の7つの新モデル**（Image 2.5/Flash、Transcribe 1.5、Voice 2/Flash、MAI Thinking 1、MAI Code 1 Flash）と「**Microsoft Frontier Tuning**」（RLE＝強化学習環境で自社専用モデルを"hill climb"させる仕組み）、**Mayo Clinic とのヘルスケア向けフロンティアモデル共同開発**を発表した。

クロージングではSatyaが**Microsoft Discovery のGA**（科学的発見の agentic ループ。プラスチック分解タンパク質のデモ）と、量子コンピューティングの「**Majorana 2**」を発表。「技術が権力を集中させる物語」ではなく「開発者・科学者・企業・コミュニティに機会を開く物語」を真にすることが North Star だと締めくくった。

---

## チャプター1: オープニング・AIスタック概観（0:00頃）

- **Satya Nadella** が登壇。サンフランシスコ・Build に戻れた喜びを述べる。
- 唯一のキーテイクアウェイ:「どうすれば全員がこの **Frontier intelligence ecosystem** に全面参加できるか」。重要なのは個々の技術やプラットフォームではなく、その上に**積み上げ・複利で生み出せる価値**。
- 本会議で解きほぐすAIスタックを提示:
  1. ユビキタスな**コンピュートファブリック**（エッジ＋クラウド）
  2. **モデル／コンテキスト／ツール**の層
  3. エージェント・アプリを動かす**ランタイム**
  4. 最高の**ツーリング**
  5. **セキュリティ・コンプライアンス・ガバナンス**

---

## チャプター2: エッジ — Windows と「unmetered intelligence」（約4:00頃）

エッジの膨大な計算資源（あらゆるNPU/GPU/CPU、すべてのPC）を活用する構想。

- スローガン:「すべての机・家庭に**unmetered intelligence（従量課金なしの知能）**を届ける」
- すでにローカルAIで動く例: Outlook Summarize、PowerPoint の alt text、Teams Super Resolution。Microsoft以外でも Adobe After Effects / Premiere が Windows ML を NPU/GPU で利用。
- **発表: Windows ML / Windows AI のスコープ拡大** — GPUのフルインストールベースに到達可能に。すべての開発者がローカルAIを構築し全インストールベースで実行できる。
- **発表: Windows Inbox で動く2つの新モデル**
  - **Aion Instruct**: 効率的なSLM（推論モデル）
  - **Aion Plan**: ローカルの agentic ループを回すプランニングモデル。ツールアクセスを与え、クラウドへ往復せずに完全オンボードのエージェントアプリが構築できる
- **ハードウェアエコシステム**: AMD Ryzen、Intel Panther Lake、Qualcomm（高性能 Snapdragon X2 Elite、低価格<$500 PC向け Snapdragon C）。
- **NVIDIA RTX Spark**: 次世代PC向けSoC。CPU/GPU/AIを1チップに統合、ユニファイドメモリ、統合DRTM（自動字幕のため不確実）。

---

## チャプター3: Surface RTX Spark とデバイス発表（約8:00頃）

- **Surface（RTX Spark搭載）**: NVIDIA の力と Surface のクラフトマンシップ。128GB ユニファイドメモリ、2,000-NIT ディスプレイ、終日バッテリー。この秋登場。OEMパートナーからも多数のデザイン。
- **発表: Surface RTX Spark Dev Box（"dream machine"）** — 1 ペタフロップのAI演算、20 CPUコア、128GB ユニファイドメモリ。この秋、ウェイトリスト受付（Satya自身も登録）。
- **Windows が DGX station に対応**（Jensen 言及）:「desktop data center（机上のデータセンター）」。1兆パラメータモデルをローカル実行可能。「GPT-2.5/3 を作った最初のスパコンに近い」と表現。
- **Windows 365** にデベロッパー向けディストリビューション（クラウドで開発生産性に最適化）。

---

## チャプター4: Windows 開発ツールのデモ（Kayla Cinnamon、約11:00頃）

**Kayla Cinnamon** が Surface RTX Spark Dev Box 上で新しい開発体験をデモ。

- **distraction-free（集中）デフォルト環境**: ニュースフィード・ウィジェット・通知なし、ダークモード。
- **新 Run**（PowerToys Command Palette のアーキテクチャ）／**縦型タスクバー**（Windows Insider ビルドで提供）。
- Python・Node 等のツールがプリインストール。**公開リポジトリの設定ファイル**を `Winget Configure` で適用すれば同じ環境を再現可能。
- **PowerToys 新ユーティリティ "Grab and Move"**（Alt押下でウィンドウ移動）、"end task"。
- **Dev Drive**（ReFS、Defender 非同期、開発最適化）、**Git-aware な File Explorer**（最終変更者・メッセージ・状態、ブランチ名表示）。
- **Intelligent Terminal**（実験的）: 上が通常ペイン、下がエージェント。エラーを検知し修正提案（RegEx等）。エージェントは GitHub Copilot を選択。
- **WSL Container**: Windows ネイティブなコンテナ体験、GPU活用可。**Microsoft Edit**（構文ハイライト追加）。
- ローカルで **120 億パラメータモデル**を動かし約 **3.4M トークン**をローカル消費。
- Fleet で複数サブエージェントを起動。Copilot の **Voice 機能**（ローカルモデル）で「console.writeline/debug.writeline を標準ロガーに変換」を音声指示。
- **75以上のコマンドラインユーティリティ追加**（env, head, tail, touch 等。既に curl, tar, sudo も追加済み）。
- ログ解析に **Aion Instruct** がローカルでバックグラウンド分析（トークン消費を気にせず）。3つのローカルモデルを同時・unmetered で実行（GPUで90GB RAM使用）。

---

## チャプター5: クラウドインフラと Jensen Huang 対談（約18:51頃）

Satyaがクラウド側へ移行。「**tokens per dollar per watt**」を駆動方程式とし、電子（電力）が入って token が出るまでのエンドツーエンドのシステム最適化を説明。

- **データセンターの原則（コミュニティからの permission）**: 電気料金を上げない／水使用を replenish する／地域雇用と税基盤／地域トレーニング・NPO 投資。
- **規模**: Azure は 80リージョン・**500超のデータセンター**。過去18か月で Azure 最初の10年より多くの容量を追加。
- **3つの主要ワークロード**: training / inference / agent runtime。
- **Fairwater**（最初の "AI super-factory"）: Georgia と Wisconsin の2リージョン、AI専用設計、2階建てでGPUを高密度実装。電力供給を刷新し変換ロス最小化。冷却ループは一度充填で**水消費ほぼゼロ**（年間使用量はレストラン1軒の1日分相当）。
- **シリコン**: NVIDIA Vera Rubin を最初に検証。AMD（MI300、次世代GPU）。**Maia 200**（Iowa/Arizona で稼働、年内国際展開、リーディングGPU比 **30% 高い tokens per dollar**、GPT-5.5 で検証、M365 Copilot を駆動）。
- **発表: Cobalt 200 VM プレビュー**（次世代ARMベースCPU）。Cobalt 100 比 50%+ 高速。GitHub Copilot のエージェント traces でベンチ → エージェント呼び出しで **33% 低レイテンシ / 14% 高速 / 23% 高スループット**。
- **ネットワーク**: **MRC アーキテクチャ**でAIワークロード（同期データ並列）向けに再構築。データセンター間を結ぶ **AI WAN** で fungible なコンピュートファブリックに。

### Jensen Huang（NVIDIA CEO、台北からリモート）との対談
- 3年前のSatyaとの会話から始まったRTX Spark。PCが「personal computer から personal AI へ」進化。autonomous agent がPC上で動く時代。
- **Spark**: 1 ペタフロップの **NVFP4**（両社共同の数値フォーマット）、128GB メモリで数百億パラメータ級のSOTAモデルを搭載可能。
- データセンター世代論: Ampere（最初のAIスパコン）→ Hopper（pre-training）→ Grace Blackwell（post-training/RL、reasoning モデル、NVLink 72 でラック全体が1台に）。Microsoft が世界最大・最速の Grace Blackwell を展開。Fairwater は液冷・クローズドループ。Hopper 比で token 生成を**約30倍**コスト効率化。
- **Vera Rubin**: agent 実行向けに設計。confidential computing（保存・転送・使用中すべて暗号化）。**Vera CPU** はエージェント向けの超低レイテンシ設計。Microsoft はチップのテープアウト前から協業し既に立ち上げ済み。
- ソフト面: NVIDIA のモデル・ツールを Foundry へ、Fabric の高速化（data processing/SQL/Spark/semantic/vector/graph をGPU加速）。GitHub の commit が直近で**3倍に急増（parabolic）**、token が profitable に。

---

## チャプター6: Project Solara — エージェントファースト端末（Steven Bathiche、約40:00頃）

新しいフォームファクター／プラットフォームの発表。コンセプト動画の後、**Steven Bathiche** が解説・デモ。

- 「次のコンピュータは1台のデバイスではなく、**デバイスの星座（constellation）が1つのシステムとして協働**し、エージェントが必要な時・場所に現れる」。
- **Project Solara** = エージェントファースト端末を作るターンキーソリューション。3本柱:
  1. **エンタープライズ対応** — AOSP ベースの Microsoft device ecosystem platform
  2. **agent-driven な相互作用モデル** — フォームファクターに適応する just-in-time UI
  3. **拡張性** — 自社エージェントを持ち込める（bring your own agents）
  - これらを **Azure** が束ね、クラウドとデバイスを統合。
- **2カテゴリの端末をプレビュー**:
  - **据置型（stationary）**: 机上用、**MediaTek シリコン**。Windows Hello for Business で歩み寄るだけでサインイン → M365 Copilot（Work IQ グラウンディング）へ。デバイス間ハンドオフ、Windows 365 経由のクラウドPCアクセス。
  - **携帯型（portable）**: アクセスバッジを再構想したウェアラブル。**Qualcomm シリコン**。指紋で解錠、カメラで撮影 → 「Copilot, find some good shots, clean them up, send them to me and my team」とデモ。
- 業種展開例: ヘルスケア（チェックイン、患者記録、ハンズフリー音声ドキュメント、diarization、側面カメラでバイタル/薬剤確認）。retail / industrial / hospitality / financial service / legal など。
- 探索中の顧客: **AccuWeather, Best Buy, CBS Health（CVS Health の自動字幕誤りの可能性、不確実）, Levi's, Target** ほか。
- **Cristiano Amon（Qualcomm CEO）との事前収録対談**: アプリ向けからエージェント向けへの転換、センサー豊富で省電力なシリコン、スマホ中心の「縦型プラットフォーム」から、エージェントが中心の「オープンで水平なプラットフォーム」へ。

---

## チャプター7: インテリジェンス層 — Foundry・データ・Horizon DB（約52:10頃）

スタックを1段上げ、モデル・コンテキスト・ツールの「インテリジェンス層」へ。

- **Foundry**: **11,000超のモデル**（OpenAI、Anthropic、MAI ほか）。最大級のカタログ。先週 OpenAI のリアルタイム音声モデルと **Claude Opus 4.8** を Foundry に追加。
- **データ層の刷新**（エージェントは継続的に store/retrieve/reason/act/learn）:
  - エージェントのメモリに **Cosmos DB**（ChatGPT も利用）
  - 検索/インデックス/埋め込みに **Azure Search**
  - セマンティックモデル/オントロジーに **Fabric IQ**
  - 可観測性トレースに **Fabric real-time intelligence**
- **発表: Horizon DB** — Azure 上のフルマネージド PostgreSQL。高可用・スケールアウト、ゾーン冗長＋自動フェイルオーバー、クラスタあたり **128TB ストレージ**、**15 read replica**。社内テストで自己管理 Postgres 比 **3倍スループット**。
- **発表: Fabric への GPU 加速** — データウェアハウスで **7倍**の性能向上。

---

## チャプター8: Microsoft IQ — Web IQ / Fabric IQ / Work IQ（Elijah Straight、約56:47頃）

データとモデル能力を混ぜて「正しいコンテキスト」を届ける IQ 層。

- **発表: Web IQ** — 10億超ユーザーを支える Microsoft のグローバル基盤を LLM/agentic 向けに再アーキテクチャ。model-agnostic、MCP-native、任意のエージェントランタイムに接続。Web/news/images/video。品質・速度・コストの3基準で best-in-class を主張。
- **Microsoft IQ** = Foundry + Fabric + Microsoft 365 を束ねる統合 IQ 層。

### Elijah Straight のデモ（電力会社の制御センター想定）
- Foundry でエージェント構築 → Foundry IQ ナレッジベース（文書・運用データ・人）に接続 → M365 へ公開。
- **Web IQ**: 「SFの現在の電気料金」を最新の公式ソースでグラウンディング回答。
- **Fabric IQ**: Brightline（架空のグリッド）を **Fabric オントロジー**として表現。Power BI セマンティックモデルを拡張し、ライブテレメトリと結合（分単位で現状反映）。リスクのある変電所をテーブルで提示。
- **Work IQ**: 対応手順を SharePoint から取得（コピーやアップロードではなく、チームが日々保守する同一ソースから回答。手順変更が即反映）。
- **Foundry routines** でスケジュール実行。長時間エージェントが完了し、Teams にインシデントブリーフを送付。

---

## チャプター9: エージェントランタイムとセキュリティ — MXC / OpenClaw on Windows（Scott & Samantha & Peter、約1:05頃）

- エージェント = 新しい実行環境（継続的推論、動的にコード生成・実行、ファイル/デバイス/ネットワークで行動）。力もあるがリスクも生む。
- **発表: Microsoft Execution Containers（MXC）** — Windows がOSネイティブのプリミティブで分離・封じ込めをポリシー適用する新レイヤー。
  - process-level isolation（軽量アクション）
  - session-level isolation（ユーザー分離）
  - Windows/Linux VM（WSL含む）でより強い境界
  - 最大分離は **Windows 365 for agents**
- パートナー: NVIDIA が **OpenShell** を Windows に。
- **発表: OpenClaw が Windows で動作（MXC を活用）**。

### Scott Hanselman / Samantha Song のデモ
- 各自の OpenClaw（"claw"）活用例（血糖管理、メールトリアージ、GitHub issue、映画チケット購入、トライアスロンのコーチ等）。
- **OpenClaw Windows Companion アプリ**（GitHub でオープン共同開発、**WinUI 3** ネイティブ、alpha リリース）。MXC（process isolation）でツール呼び出しをサンドボックス。
- 権限設定: clipboard アクセス、インターネット通信、カスタムフォルダのアクセス制御。
- **デモのハイライト**: 「デスクトップの全ファイルを削除」と OpenClaw に指示 → OpenClaw 自身の安全層を全部切っても、IT（=Samantha）が read-only に設定したため MXC が削除を阻止。94 個のJPEGが残存。
- **Peter Steinberger（"Clawfather"、OpenClaw 開発者）** 登壇: 半年前なら削除は成功していた。企業利用に向けた追加（observability、permission の auto モード、フォルダ単位の read-only/write/hidden 制御）。harness 自体をプラグイン化（Copilot/Codex 等を持ち込み可）。Slack/Teams 内の "claw"、persistent memory、heartbeats。**OpenClaw Foundation（非営利）**を設立。

---

## チャプター10: クラウドランタイム — Foundry・Rayfin・GitHub Copilot アプリ（Cassidy Williams、約1:17頃）

- **Foundry** をエージェント時代のフルアプリケーションプラットフォームへ。**Foundry ホステッドエージェント**（IQ層・ツール・durability/memory/state・高速 sandbox・rubric/eval・safety/guardrails、自己改善ループ内蔵）。
- **発表: Fireworks AI との提携** — open-weight モデルと推論スタックを Foundry へ。
- GitHub が「すべてのエージェントの control plane」に。CLI 形態の成長。
- **発表: 新しい GitHub Copilot アプリ**（CLIの速さ＋IDEの能力＋無限のエージェントセッション）。
- **発表: Rayfin** — agent-first SDK。エージェントをバックエンド（BaaS）に接続。**Replit との提携**で、Replit でアプリを作りつつ enterprise-managed Fabric テナントにデプロイ。

### Cassidy Williams のデモ
- GitHub Copilot アプリのホーム（agentic コーディングセッション起動、Mona のミニゲーム）。
- リリースブロッカーを全件、issue ごとに**別セッション**で起動。**git worktrees** で並列・分離。"Agent merge" で CI/コードレビュー/コンフリクトを継続監視。
- "My work"、automations（再利用セッション、"Issue Poetry"）、Sessions（ローカル/GitHub リポジトリ。clone/pull 不要で読み込み）。
- 統合ブラウザ・ターミナル・チャット・light/dark。"Pick and Polish"。
- モデルピッカー: OpenAI/Anthropic/Google を単一の Copilot サブスクで。大型機能では **Rubber Duck review**（GPT-5.5 使用中に Claude Opus 4.8 にレビュー依頼）でブラインドスポット検出。
- **Canvas**: エージェントがカスタムUIを構築。カメラで PR を thumbs up/down 承認するデモ。
- **Rayfin デモ**: 100% エージェント構築・コンテナ化・DBバックエンドのアプリを `rayfin up` で Microsoft Fabric にデプロイ。

---

## チャプター11: ガバナンス — Agent 365（Amanda Foster、約1:26頃）

- **Agent 365** = エージェントの control plane。Entra（ID）、Defender（リアルタイム防御）、Purview（データ保護・コンプライアンス）を拡張。AWS/GCP やどのフレームワーク上のエージェントもホスト可。
- **発表: Agent 365 SDK の GA**。ローカル（Windows）エージェントや "claws" にも拡大。

### Amanda Foster のデモ
- LangGraph エージェントを Foundry の価値で強化。**Foundry Toolbox**: ツールを一度登録すれば単一の MCP エンドポイントで全エージェントが利用。ガードレールを一度適用すれば PII 漏洩をブロック。
- 1ブロックのコード追加＋push → GitHub Actions でデプロイ。セッションごとに専用 micro VM＋永続ファイルシステムを起動。
- サーバーサイド traces、組み込み eval。**rubric evaluators**: 1つの AZD コマンドで本番 traces から評価基準（rubric）を自動生成。
- **agent optimizer**: model / instructions / tool descriptions / skills の4つをチューニングし候補を生成・スコアリング、最良候補を新バージョンとしてデプロイ。利用するほど改善。
- **autopilot エージェント**: 独自の ID と生産性ライセンスを持ち M365 を自走。Teams のグループチャットに参加。**admin 承認が必須**で、承認後も監視・ブロック可能。

---

## チャプター12: AIによるセキュリティ防御 — MDASH（Sarah Young、約1:34頃）

- 「AIを使った攻撃をAIで防御する」。先月発表のマルチモデル agentic セキュリティシステム **MDASH**（セキュリティ用エージェント harness）。フロンティア＋カスタムモデルの **100 エージェント**で exploitable bug を発見。**CyberGym ベンチマークでトップ**だった（自動字幕のため一部不確実）。

### Sarah Young のデモ
- スタンドアロンCLIだが GitHub Copilot アプリ内で実行。脆弱性ドメイン・深刻度別の結果（コーディングエラー、ハードコードされた秘密に加え **AI固有の脆弱性**も検出）。
- 100超の専門エージェントが discover/debate/prove を end-to-end で実施。完了時に **SARIF ログ**と **HTMLレポート**を生成。
- `defender details` で詳細確認、`defender fix` でローカル環境に修正適用（diff で透明性、human-in-the-loop）。PR 作成や **GitHub Advanced Security** へのアップロードも可。
- 実例: **WASM time** の out-of-bounds バグ（3つの異なる箇所にまたがり単一ファイルでは正常に見える。開発者の「問題ない」というコメントが通常のスキャナーを欺く）。MDASH は1チームが疑わしいギャップを発見、別チームが反論、第3チームがクラッシュを再現する working example を構築。オープンソースコードベースで実証。
- 「coming soon to your CLI and the Microsoft Defender portal」。

---

## チャプター13: ゲストトーク — The Chainsmokers / Mantis VC（約1:38頃）

- **Alex Pall** と **Drew Taggart**（The Chainsmokers、VCファーム Mantis VC のゼネラルパートナー）が Satya と対談。
- 14年のアーティスト活動、2020年に自社ファンドを institutionalize、B2B SaaS から開始。
- AI論:「**outputs を生産する世界から actions を生産する世界へ**」。機械が outputs を生み、ソフトウェア・エンタープライズのアーキテクチャ全体を再構想する機会。
- 創業者へのアドバイス: 真正性（authenticity）、自分の「sound」を見つけ、一貫して反復し続けること。
- この日の夕方6時にライブ演奏予定。

---

## チャプター14: 企業の機会と Copilot・Autopilots（約1:42頃）

- 自社のプラグイン/エージェント/AIアプリが Microsoft エコシステム（Windows、M365 Copilot、Teams、GitHub）で**発見される（discovered）**ことが job number one。Copilot Studio の line-of-business エージェントも Copilot 体験から発見可能に。Teams は human-to-agent の multiplayer の destination。
- **Copilot の進化**: Chat → Cowork（artifacts 生成、多段タスク）→ そして夏には **coding を含む全 knowledge work を1つの Copilot スーパーアプリに**統合（Chat / Cowork / Code）。
- **発表: Autopilots** — 「エンタープライズグレードの "claws"」。テナント内で動く自律・長時間エージェント（フルコンプライアンス）。名前・パーソナリティ・カスタムコネクタ・コンテキスト・メモリを持てる。
- **最初の Autopilot = "Scout"**。Teams のグループチャットや Outlook のスレッドで働く。**Copilot Frontier** 利用者は本日から試用可。今後 autopilots の "digital team" を構築。

---

## チャプター15: MAI 7モデルと Frontier Tuning（Mustafa Suleyman、約1:48〜2:02頃）

「会社の未来（future of the firm）」と暗黙知の複利の話から、**Frontier Tuning** へ。各組織が自社の目標に対して継続改善する「hill climbing machine」を持つべき、というメッセージで **Mustafa Suleyman** を招く。

- 過去15年で **Frontier モデル訓練の計算量は1兆倍（12桁）**に増加。今後数年でさらに3桁。「Intelligence is now a function of compute」、log linear hill climbing が標準に。
- **humanist superintelligence**: 人間と組織に**仕えるが置き換えない**SOTA AI。人間性を最優先。
- **発表: 7つの新MAIモデル**（Image / Voice / Transcription / Coding）:

| モデル | 分野 | ハイライト（トランスクリプト記載） |
|---|---|---|
| **MAI Image 2.5** | 画像生成・編集 | 画像編集でリーダーボード **2位**、Nano Banana 2 のスコアを上回る。最大忠実度・プロ品質。PowerPoint で稼働中、OneDrive へ展開中、Foundry で利用可（market-leading quality per dollar） |
| **MAI Image 2.5 Flash** | 画像（高速版） | 超効率な本番ワークロード向け |
| **MAI Transcribe 1.5** | 文字起こし | **43言語で SOTA**、Gemini・OpenAI のフラッグシップを上回る。競合比 **5倍高速**。GitHub/Teams/Copilot/Dynamics 365 Contact Center に統合。Foundry で最速・最高効率・最安 |
| **MAI Voice 2** | 音声合成 | 美しい prosody、自然な delivery、**細粒度の感情制御**、15言語（追加予定） |
| **MAI Voice 2 Flash** | 音声合成（低遅延） | 超低遅延の音声エージェント向け（2026年の big thing） |
| **MAI Thinking 1** | 推論（初） | **35B アクティブパラメータ MoE / 256K コンテキスト**。Surge の人間評価で **Sonnet 4.6** に対し選好。**AIME 2025 で97%**、**SWE Bench Pro で53%**（Opus 4.6 と並ぶ）。蒸留ゼロ・ボトムから climb・ベンチをターゲットにしていない・商用ライセンス済みのクリーンなデータ系譜 |
| **MAI Code 1 Flash** | コーディング | **わずか5Bパラメータで SWE Bench Pro 51%**。Haiku 級のサイズだが安価。VS Code / GitHub Copilot CLI 向けにチューン、本日 VS Code に展開 |

- 配布: Foundry、1P製品に加え **Open Router / Fireworks / BaseTen** でも提供。「初めて weight を自分で直接チューン可能」。
- **安全性**: 音声の無許可クローン対策、すべて watermark、over-refusal 削減、障害者を含む representation 改善。**詳細な技術レポートを本日公開**。
- **シリコン協調設計**: MAI Thinking 1 を自社 **Maia 200** に最適化、GB200 と head-to-head。Satya の言う 30% 性能向上に加え、Maia 200 で **1.4倍の performance per watt** ゲイン。MAI モデルは **N1X**（Windows）にも数か月内に。

### Microsoft Frontier Tuning と RLE
- **RLE（Reinforcement Learning Environments）** = AI用のトレーニングジム。会社・タスク固有のエージェントを MAI モデル上に構築。
- 例: Microsoft 内で RLE＋MAI モデルにより **Excel** の agentic ユースケースを climb。MAI チューンモデルは公開/非公開ベンチで **GPT-5.4 と同等、コスト効率10倍**。
- **McKinsey** のタスクでチューン → MAI が最高 win rate、**GPT-5.5 を上回りコスト効率10倍**。
- 差別化:「共有モデルから知能を借りない」。自社のワークフロー・ノウハウ・データの便益は自社のみ、結果モデルも自社のみが制御。RLE とモデルが「**あなたの moat（堀）**」になる。

### Mayo Clinic 提携（約1:59頃）
- **発表: Mayo Clinic とヘルスケア向け Frontier モデルを共同開発**し、世界中の病院へ展開。
- **Dr. Gianrico Farrugia（Mayo Clinic 社長兼CEO）** 登壇。7年前に立ち上げた Mayo Clinic platform は4大陸・約1億人にリーチ、世界最大級の縦断的マルチモーダル（ゲノム含む）医療データセット。
- モデルは教科書知識は既に優秀だが、**臨床実践の専門性**が欠けている。それを本番で改善する。患者には臨床・ロジスティクスの回答、医療者にはリアルタイムのチームメンバーとして次に起こることを示し、害を防ぎ患者安全を高める。

---

## チャプター16: Frontier Tuning デモ（Tanaya Yadav、約2:03頃）

**Tanaya Yadav** が Frontier Tuning を実演。

- **MAI Thinking 1 が Foundry モデルカタログで private preview**。そのままデプロイ or "Fine Tune" ボタンで hill-climbing 開始。
- Fine tuning UI: データセット追加 → grader 追加 → ジョブ submit。数時間でロールアウト生成・スコアリング・hill-climb の様子を確認。
- **low-level training API**（sneak peek）: ロールアウト戦略・ハイパーパラメータ設定、独自の **RL gym**（ツール定義）を組み込み可能。
- M365 顧客はゼロから始めない。**Land O'Lakes**（米最大級の農業ビジネス）の環境を例示。
  - 環境 = skills + knowledge + tools、バックエンドでフルの RL gym。
  - "Butter Report Generation" skill: 多数の手動ステップと高精度が必要で 80% では不十分。skill に **rubric**（何が "good" か）を拡張。
  - M365（Teams/Outlook/Word/Excel/PowerPoint）のシグナルから skill と rubric を提案。OneDrive/SharePoint の組織知識でグラウンディング。
  - ツールは仮想化して実行をシミュレート（ライブ状態に影響を与えず学習）。
  - "main" モデルと embedding モデルに学びを汎化し、Land O'Lakes タスクで **90%超の精度**、ベースライン比 **10倍の効率**。
  - 実行時に **Test-Time Tree Search**（fine-tuned モデルを含む複数モデル）を活用。生成サマリは「紛れもなく Land O'Lakes らしい」。自己 retrospect・自己評価で継続改善。

### Satya のまとめ（Frontier 参加）
- 「Frontier モデルを**消費する**側から、Frontier エコシステムに**全面参加する**側へ」の転換。自社の private eval/RLE/traces/enterprise knowledge で scaffolding を作り、モデルを hill-climb させ、所有・制御する差別化IPを生む。
- 新しい operating point:「効率的な reasoning モデル＋coding モデルでも、環境（RLE）を作り込めば **Frontier 級の性能**に到達できる」。

---

## チャプター17: Microsoft Discovery GA（David Carmona、約2:11頃）

- **発表: Microsoft Discovery を GA**。モデル・HPCコンピュート・科学知識のナレッジグラフ・自動ラボ／シミュレーションを1つの agentic discovery ループに統合。科学的手法を「より連続的・並列・programmable」に。

### David Carmona のデモ（PET プラスチックのリサイクル）
- 現状の PET リサイクルは shred & melt で品質劣化（downcycling）。**Cambridge Consultants（Capgemini の一部）** が Microsoft Discovery で研究。
- Discovery アプリは **VS Code ベース**（agentic discovery は agentic SWE と並行点が多い）。3ステップ = 論文執筆（=planning）／実際の発見＝新タンパク質探索（=coding & testing）／ラボプロトコル作成（=deploy to production）。
- **discovery engine** = 科学的手法に従い常時稼働する専門エージェント群。OSS/サードパーティ/自作のエージェント・モデル・ツールのコミュニティ。数時間〜数日かかる長時間ジョブ、仮説探索と長時間シミュレーションを動的に実行。
- 出力: **知識グラフ**（公開文献＋内部知識、推論の完全な可視性）に基づく研究論文。
- 発見プロセス: タンパク質の良し悪しを予測するAIモデルを複数訓練し最良を選択（専用エージェントがなければ**その場でエージェントを生成**、YAML とPython を作成）→ HPC で seed タンパク質から小セグメント置換による変異を数百万回・並列生成し木探索 → **80個のタンパク質候補**。
- 各タンパク質のDNA配列ファイルを生成。**自動ラボ**（Cambridge Consultants 実在のラボ）と統合し、Copilot インターフェースから実験投入（バクテリアにDNAを挿入してタンパク質生成）。人間監督下で多くのステップを自動化。

---

## チャプター18: 量子コンピューティング — Majorana 2 とクロージング（約2:18頃）

- 昨年、最初のQPUと「100年前に理論化されただけの新しい物質の状態」を実証。reliability/speed/size の根本的障壁に対する radical なアプローチ。
- **QuNorth** で自然原子コンピュータ（atom computers）＋Microsoft スタックの量子コンピュータ。Algorithmic（自動字幕のため不確実）、Columbia、ETH Zurich と協業。Discovery の agentic ループで量子研究を加速。
- **発表: Majorana 2**:
  - 次世代の material stack（Discovery で発見・製造を支援）。
  - **qubit 平均寿命が 20秒〜最大1分**（他方式は microsecond〜millisecond）。Majorana 1 比 **約1000倍**。
  - 操作時間は **1 microsecond**、複雑な量子計算が可能に。
  - Majorana 1 と同じ qubit フォームファクター（1/100ミリメートル）、全デジタル制御。**クレジットカードより小さいチップに100万 qubit** を収める構想。
  - Majorana 1 で基礎物理を実証 → Majorana 2 で engineering scale を開始。
- **クロージング（Satya）**: 技術は権力を集中させ人間の主体性を減らすという物語と、開発者・科学者・企業・あらゆるコミュニティに機会を開くという物語の2つがある。「**第2の物語を真にすること**が Frontier ecosystem の North Star」。「Let's all go build together」。
- 末尾の動画: **David Shaw / Sabrina Maniscalco** が量子の意義（現実世界の low-level OS、信頼性とスケーラビリティ、化学・材料・創薬への直接的アプローチ）を語る。

---

## まとめ

KEY01 のコアメッセージは「**Frontier intelligence ecosystem に開発者・組織が全面参加する**」こと。単一モデルへの依存ではなく、自社の private eval・RLE・traces・enterprise knowledge を scaffolding として、効率的な reasoning/coding モデルを **hill-climb** させ、**所有・制御できる差別化IP（＝moat）**を作る——これが「会社の未来（future of the firm）」の中心思想として繰り返された。技術スタックはエッジ（unmetered intelligence）→ クラウド（tokens per dollar per watt）→ モデル/コンテキスト（Microsoft IQ）→ エージェントランタイム（MXC, Foundry）→ ガバナンス/セキュリティ（Agent 365, MDASH）→ 企業適用（Copilot/Autopilots, Frontier Tuning）→ フロンティア先端（Discovery, 量子）と一貫して語られた。

### 主要発表一覧

| 製品・機能 | カテゴリ | ステータス | ポイント |
|---|---|---|---|
| **Windows ML / Windows AI 拡大** | エッジ/Windows | 発表 | GPUフルインストールベースへ。ローカルAI開発を全機種で実行 |
| **Aion Instruct / Aion Plan** | ローカルモデル | 発表（Windows Inbox） | 効率SLM＋ローカル agentic ループのプランニングモデル |
| **Surface RTX Spark Dev Box** | ハードウェア | この秋、ウェイトリスト | 1ペタフロップ、20コア、128GBユニファイドメモリ |
| **Windows on DGX station** | ハードウェア | 発表 | 机上データセンター、1兆パラメータをローカル実行 |
| **Intelligent Terminal / WSL Container / 75+ CLIユーティリティ / 縦型タスクバー** | Windows開発 | 一部 Insider/実験的 | calm な開発環境、GPU活用コンテナ、env/head/tail/touch 等 |
| **Maia 200** | AIアクセラレータ | 稼働中（Iowa/Arizona）、年内国際展開 | tokens per dollar 30%向上、GPT-5.5 検証、M365 Copilot を駆動 |
| **Cobalt 200 VM** | CPU | プレビュー | ARMベース、エージェント呼び出しで33%低レイテンシ等 |
| **Fairwater / Vera Rubin（NVIDIA協業）** | DC/シリコン | 検証・稼働 | AI super-factory、水消費ほぼゼロ、Vera Rubin はエージェント向け |
| **Project Solara** | エージェント端末 | プレビュー（2形態） | 据置型(MediaTek)＋バッジ型(Qualcomm)、AOSPベース、bring your own agents |
| **Foundry（11,000+モデル、Claude Opus 4.8 / OpenAI 音声 追加）** | プラットフォーム | 提供中 | 最大級カタログ |
| **Horizon DB** | データ | 発表 | フルマネージドPostgreSQL、128TB、15レプリカ、3倍スループット |
| **Fabric GPU加速** | データ | 発表 | 7倍性能 |
| **Web IQ** | グラウンディング | 発表 | LLM/agentic向け再アーキテクチャ、MCP-native、品質/速度/コスト best-in-class |
| **Microsoft IQ（Web/Fabric/Work IQ）** | コンテキスト | 発表 | Foundry+Fabric+M365 を統合 |
| **Microsoft Execution Containers (MXC)** | セキュリティ/OS | 発表 | OSネイティブのエージェント分離（process/session/VM/W365） |
| **OpenClaw on Windows（Companion アプリ）** | エージェント | alpha リリース | WinUI 3、MXC サンドボックス、OpenClaw Foundation 設立 |
| **GitHub Copilot アプリ** | ツール | 発表 | git worktrees 並列、Agent merge、Canvas、Rubber Duck review |
| **Rayfin（＋Replit提携）** | バックエンドSDK | 提供開始 | agent-first BaaS、Fabric テナントへデプロイ |
| **Fireworks AI 提携** | モデル | 発表 | open-weight モデルを Foundry へ |
| **Agent 365（SDK GA）** | ガバナンス | GA（SDK） | Entra/Defender/Purview 拡張、optimizer、rubric evaluators、autopilot ID |
| **MDASH** | セキュリティ | coming soon（CLI/Defender portal） | 100エージェント harness、SARIF/HTML、CyberGym 首位 |
| **Copilot スーパーアプリ（Chat/Cowork/Code）** | Copilot | 夏に統合 | knowledge work に coding を統合 |
| **Autopilots（"Scout"）** | Copilot | 本日試用可（Copilot Frontier） | テナント内の自律長時間エージェント |
| **MAI Image 2.5 / 2.5 Flash** | MAIモデル | PowerPoint稼働中、OneDrive展開中、Foundry | 画像編集2位、Nano Banana 2 超え |
| **MAI Transcribe 1.5** | MAIモデル | GitHub/Teams/Copilot/Dynamics統合、Foundry | 43言語SOTA、5倍高速 |
| **MAI Voice 2 / Voice 2 Flash** | MAIモデル | 提供 | 15言語、感情制御、超低遅延版 |
| **MAI Thinking 1** | MAIモデル | private preview（Foundry） | 35B/256K MoE、AIME 97%、SWE Bench Pro 53%、蒸留ゼロ |
| **MAI Code 1 Flash** | MAIモデル | 本日 VS Code 展開 | 5BでSWE Bench Pro 51% |
| **Microsoft Frontier Tuning（RLE）** | カスタマイズ | private preview（MAI Thinking 1） | 自社データで hill-climb、Land O'Lakes で90%超・10倍効率 |
| **Mayo Clinic ヘルスケアモデル** | パートナー | 発表（共同開発） | 臨床実践知でフロンティア医療モデルを構築 |
| **Microsoft Discovery** | 科学発見 | **GA** | agentic discovery ループ、自動ラボ統合 |
| **Majorana 2** | 量子 | 発表 | qubit寿命20秒〜1分（Majorana 1 比1000倍）、operation 1μs |

### エンジニア向け次のアクション
1. **Windows ローカルAI**: Aion Instruct/Plan、Intelligent Terminal、WSL Container を試す。公開リポジトリの設定ファイルを `Winget Configure` で適用し dev 環境を再現。
2. **GitHub Copilot アプリ**を導入し、git worktrees による並列セッション・Agent merge・Canvas・マルチモデル（Rubber Duck review）を活用。
3. **Foundry**: 11,000+モデル（Claude Opus 4.8 含む）を試し、Foundry Toolbox／rubric evaluators／agent optimizer でエージェントを enterprise-ready 化。**Rayfin** で Fabric テナントへデプロイ。
4. **Microsoft IQ**（Web IQ / Fabric IQ / Work IQ）でエージェントを Web・自社データ・社内手順にグラウンディング。
5. **MAI モデル**を Foundry / Open Router / Fireworks / BaseTen で利用。Code 1 Flash は VS Code で本日試用可。技術レポートを参照。
6. **Microsoft Frontier Tuning**: MAI Thinking 1 の private preview にサインアップし、自社の RLE・rubric でモデルを hill-climb（Land O'Lakes 事例: 90%超精度・10倍効率）。
7. **MXC / Agent 365 / MDASH** でエージェントの分離・ガバナンス・セキュリティを設計に組み込む。
8. **Microsoft Discovery（GA）**で科学計算ワークフローを agentic 化。
