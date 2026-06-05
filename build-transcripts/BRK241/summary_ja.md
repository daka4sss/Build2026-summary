# Microsoft Build 2026 BRK241「From prototype to production: build and run agents at scale」詳細まとめ

**登壇者**: Tina Schackman（Microsoft Foundry 担当 Corporate Vice President）、Jeff Holland（Foundry エージェントプラットフォーム担当 Partner Director）
**セッションURL**: https://build.microsoft.com/en-US/sessions/BRK241
**取得元**: 公式WebVTTトランスクリプト（medius.microsoft.com CAPTION）

---

## 全体像

このセッションは「エージェントのプロトタイプからプロダクションへ」という一連の開発ライフサイクルを、ライブデモ中心で約45分にわたって解説したものである。Build フェーズ（ローカル開発）・Deploy フェーズ（Foundry Agent Service へのホスティング）・Operate フェーズ（可観測性・評価・自律的改善）の3段階を一気通貫で実演し、Microsoft Foundry が単なるビルドプラットフォームではなく「エンタープライズAI変革のためのオペレーティングシステム」であることを強調した。

「エージェント時代における3つの変化」として Tina は冒頭で次を挙げた。①構築は最早難しくない（GitHub Copilot や Claude Code で誰でも数分でエージェントを立ち上げられる）、②エージェントの能力が爆発的に拡大し、新しいサブエージェントを生成したり新たなスキル・メモリを作り出せる汎用システムになった、③エージェントはツールではなくチームメート——人間や他のエージェントとチャットしながら重要なビジネス成果を達成する存在になった。

デモのシナリオとして「自律ファイバー障害対応エージェント（Autonomous Fiber Outage Response Agent）」を使用した。センサーがファイバーの切断を検知すると、エージェントが起動し、Foundry Toolbox・Fabric IQ（サイト信頼性データ）・Work IQ（サプライヤーとのコミュニケーション履歴）・ドキュメントインテリジェンス（発注書・サプライヤー契約書）を参照し、現場要員の派遣、Dynamics 365 へのチケット起票、Teams へのステータス通知を自動実行するというシナリオである。Azure のネットワーキングオペレーションチームが実際に類似システムを本番運用しているとのことで、このシナリオは現実ベースである。

---

## 1. デモシナリオの説明と開発者の課題（0:00頃）

Tina が冒頭でステージを設定し、エージェント時代の3つの変化を解説した後、「ファイバー障害対応エージェント」のアーキテクチャを概説した。エージェントが行う処理フロー：

- センサー → エージェント起動トリガー
- Foundry Toolbox 経由で各種ツールへアクセス
- Fabric IQ：サイト稼働率・ロケーション情報の照会
- Work IQ：サプライヤーとのやりとり履歴の照会
- Content Understanding / Document Intelligence：PDF の発注書・契約書を AI 可読形式に変換して参照
- 現場担当者（Field Rep）の派遣
- Dynamics 365（D365）へのチケット発行
- Teams へのリアルタイムステータス通知

Jeff が引き継ぎ「Build・Deploy・Operate の3フェーズ」でデモを進めると宣言。Jeff は「スライドを説明するはずが自分の画面が映っていた」というハプニングがあり、「このスライドを頭の中で思い浮かべてください。マーケティングチームが素晴らしいものを作ってくれました」と笑いで対処した。

---

## 2. Build フェーズ——ローカルでのエージェント開発（0:06〜0:18頃）

### 開発環境の選択

Jeff は **Visual Studio Code + GitHub Copilot** の組み合わせを「個人的な最愛のコンボ」と紹介しつつ、Foundry はどのツール（Claude Code、GitHub Copilot CLI、Cursor、Visual Studio 等）でも使えると強調した。

### Foundry Toolkit for VS Code（GA）

VS Code 向け **Foundry Toolkit 拡張機能**が **GA（一般提供）** であることが発表された。この拡張機能によりエディタを離れることなく以下が可能：

- エージェントの作成
- トレース・可観測性
- 評価（Evals）
- モデル管理

拡張機能は Foundry のベストプラクティスを自動的にビルトインする形で GitHub Copilot と統合される。Copilot の「Generate with Copilot」オプションを使い、フィールドオペレーション向けエージェントを自然言語プロンプトから生成するデモを実施。生成中に拡張機能のダウンロードポップアップが表示されるハプニングがあり、Jeff が「これがいかにライブであるかの証拠」とコメントしつつ続行した。

### Microsoft Agent Framework 1.0（GA）

生成されたコードは **Microsoft Agent Framework**（Python）を使用。主な特徴：

- マルチステップ・マルチエージェントワークフローに最適化
- **新機能：Agent Harness**——エージェントがシェルコマンド実行・コードの読み書き・実行を行えるセキュアな環境を提供
- **GitHub Copilot SDK** および **Claude Agent SDK** をアドオンハーネスとしてプラグイン可能
- エージェントは事前定義ツールの実行にとどまらず、動的な調査・コード記述・コード作成が可能

### Foundry Toolbox（GA 予定）

ツール管理の中核 **Foundry Toolbox** を VS Code 内から操作するデモ：

- エージェント群に対して一元化されたツールセットを管理
- 単一の **MCP 互換エンドポイント**でアクセス
- 統合対象：Foundry IQ（RAG ベースドキュメント検索）、Web IQ（ウェブ検索）、Fabric IQ（Microsoft Fabric のサイト信頼性データ）、Work IQ（Microsoft Graph 経由で Teams・Outlook 履歴）
- **Tool Search 機能**：コンテキストウィンドウ最適化のため、当該タスクに関連するツールのみを動的に返す。全ツール定義を常にコンテキストに含める必要がなくなる
- PII 漏洩防止ガードレールを設定可能
- **Content Understanding ツール**：PDF の表・図・Markdown・生 JSON を AI 可読形式に変換する専用モデルを統合

### ローカルデバッグ（F5デバッグ）

F5キーでエージェントをローカルホストで起動し、ブレークポイントでリクエスト・レスポンスを検査するデモを実施。「現地作業員がファイバー終端仕様書の照会」シナリオで、エージェントが Toolbox を通じてリアルタイムで情報を取得する様子を確認した。

### ボイスモードの有効化（1クリック）

「現地作業員が革手袋をつけたままチャット UI を操作するのは無理」という実用的な動機で、エージェントをボイス対応にするデモを実施。Foundry へのデプロイ後、**「Voice Mode」ボタンを1クリックするだけ**でボイス対応化が完了。Jeff がマイクで「Quincy N サイトのファイバー終端仕様書を引っ張って、B サイドパネルで使うべきコネクタを教えて」と話しかけると、エージェントが仕様書を取得し「LC/UPC デュプレックス、B サイドパネル必須」とリアルタイムで音声回答した。WebSocket による双方向ストリーミングでレスポンスがリアルタイムに流れることも確認された。

---

## 3. Deploy フェーズ——Hosted Agents と長期実行（0:18〜0:27頃）

Tina が Build フェーズの機能ステータスを整理した後、Jeff が Deploy フェーズのデモに移行。

### Hosted Agents in Foundry Agent Service（GA 予定）

**Hosted Agents** の特徴：
- プロセスレベルのサンドボックス分離
- サブ秒レベルのコールドスタート
- アイドル時コスト：ゼロ
- フレームワーク非依存
- **長期実行型エージェント**（OpenClaw / Hermes エージェント等）のサポート：耐久ステート実行とファイルシステムアクセスを提供

セキュリティ上の動機として Jeff は「サブコントラクターAとBが同じホストで動作すると、互いのファイルやコード実行コンテキストが漏れる可能性がある」という問題提起をし、Hosted Agents がセッション単位の完全分離でこれを解決すると説明した。

### Routines（Public Preview）

**Routines** はエージェントを「リアクティブ」から「プロアクティブ」にする新機能：

- 定期イベント（毎時起動等）や特定トリガーでエージェントを自動起床させる
- Foundry がキューイング・実行・トラッキングをすべて管理
- 実演：Fibe エージェントに「毎時起動 → 調査ログ確認 → 異常があれば担当者にアラート → サブコントラクターを発行」というハートビートルーティンを設定

### Durable Task Scheduler との統合

Jeff が「11時からアイドル中のセッション」を開き、調査ファイル（異常分析・ベンダー連絡情報・調査記録）がファイルシステムに保存されていることを実演。**Durable Task Scheduler** との統合により：

- セッションがアイドル中でも状態を監視可能
- 人間の承認待ちインスタンスを追跡
- 「Approve」クリック → Durable Task がセッション再開 → 全ステートが復元されてエージェントが作業継続

「アイドル中は費用がかからない、承認を受けた瞬間にセッションが復活する」という点が強調された。

### Teams / Microsoft 365 Copilot への公開

- Foundry エージェントを Teams と Microsoft 365 Copilot に直接パブリッシュ可能（**GA 予定**）
- アイデンティティ・ポリシー・パーミッションは自動的に継承
- **Autopilot エージェント（Public Preview）**：エージェント自身がメールアドレス・Teams プレゼンス・チームIDを持ち、自律的に会話を開始したりアクションアイテムをフォローアップできる。ガバナンスは **Agent 365** によりエンドツーエンドで管理
- Jeff が Fibe に `fibe@notareal.co` というメールアドレスを持つ Teams エージェントとしてデプロイし、「今対応中のアクティブなインシデントを教えて」と質問したところ、Fibe が Foundry セッションを再開してリアルタイムで回答するデモを実施した

---

## 4. Operate フェーズ——可観測性と自律改善ループ（0:28〜0:38頃）

Jeff が「本当の仕事はここから始まる」と述べた。Jeff は体調不良を明かしながらも「皆さんのエネルギーで残り10分乗り切る」とコメントし、Operate フェーズへ。

### Trace Replay View（GA 予定）

- 全会話のリストから任意の会話を選択し、エージェントが取った推論・ツール呼び出しの軌跡を可視化
- 時間軸でもトークン消費量軸でも可視化可能
- **8倍速でのリプレイ**機能で一連のプロセスとユーザーが見た内容を再現
- OpenTelemetry パイプラインで全LLM呼び出し・ツール呼び出し・サブ秒ホップ・エージェント間ハンドオフをすべてログ記録

改善の動機として、ボイス対応エージェントが「箇条書きリストを読み上げる機械的な回答」を返していたことを挙げ、これを「音声に最適化した自然な応答」に改善するプロセスを実演した。

### Rubric——カスタム評価基準の自動生成（Public Preview）

**Azure Developer CLI（AZD）** コマンドを使った評価フロー：

1. **`azd ai agent eval init`** でエージェントプロジェクトの評価を初期化
   - eval データセットを持っていない場合でも、過去のトレースとインタラクションシグナルから LLM が初期データセットを自動生成
2. 生成された **Rubric（評価基準）** には複数の重み付き評価ディメンションが含まれる：
   - 正しいツール選択（例：稼働率を聞いたら Fabric IQ を使うべき）
   - 安全性警告
   - 音声最適化簡潔性（Voice Optimized Conciseness）
3. Jeff は「音声最適化簡潔性」の重みを 3 から **10 に引き上げて**カスタマイズ
4. 開発者はこの rubric を自由に修正可能

### Agent Optimizer（Private Preview）

**`azd ai agent optimize`** コマンドで起動する自動最適化ループ：

- **最適化の対象変数**：システムプロンプト、ツール説明文、スキル設定、使用モデル（GPT 5.5 vs Anthropic Opus 4.8 等を変数として比較可能）
- 最先端のデータサイエンス手法でカスタム rubric に対してスコアが高い候補を複数生成
- **実際のデモ結果**：4つの候補が生成され、最良候補はスコアが **11% 向上**
- 候補間でシステムプロンプトの差分（Before / After）が表示され、どの変更が効いたかを確認できる
- 候補は**品質・コスト・レイテンシ**の3軸で横並び比較
- ロールバック・系譜追跡機能あり。開発者が最終的にどの候補を採用するかをコントロールする

デモ中に最適化結果を表示しようとしたところ、Chrome を誤って閉じてしまうハプニングがあり、Jeff が URL を手打ちして復旧する場面が見られた（「ライブデモの神様、お願い！」と発言）。

### Procedural Memory（手続き記憶、Public Preview）

- エージェントが全セッションにわたって「プレイブック（手続き知識）」を学習し、毎回ゼロから学び直さなくて済む仕組み
- プロンプトやスキルの手動書き換えなしに、実行を重ねるほどエージェントがスマートで安全かつ低コストになる
- 開発者はすべての変更を管理・承認できる

---

## 5. 顧客事例と締めくくり（0:38〜0:43頃）

Tina が Operate フェーズの機能を整理した後、実際の顧客事例を紹介：

- **Ecolab**：14カ国にわたるミッションクリティカルなエネルギーオペレーションを Foundry Agent Service のアイデンティティ・メモリ・ガバナンス・可観測性機能で支える。規制対応オペレーションをフルコントロールで運用
- **Twilio**：Twilio Agent Connect（AI エージェントと Twilio プラットフォームを接続するオープンソースフレームワーク）を Foundry のホストエージェント上で稼働
- **KPMG**：グローバルな KPMG Workbench プラットフォームをホストエージェント上に構築。Foundry Toolbox のツール・スキルを活用してクライアント対応を強化

「**80,000以上の顧客が既に Foundry を運用中**」と強調。

最後に Tina は「Microsoft Foundry：シンプルにビルド、パワフルにデプロイ、信頼性をもって運用（Build simply, Deploy powerfully, Operate with trust）」と締めくくった。

---

## まとめ——発表された新機能・ステータス一覧

| 機能・製品 | ステータス |
|---|---|
| Microsoft Agent Framework 1.0（含 Agent Harness） | **GA（本番対応）** |
| Foundry Toolkit for VS Code | **GA** |
| Voice Live integration（プロンプトエージェント向け） | **GA** |
| Hosted Agents in Foundry Agent Service | **GA 予定（GA soon）** |
| Tracing & Evaluation for Hosted Agents | **GA 予定（GA soon）** |
| Foundry Toolbox | **GA 予定（GA soon）** |
| Publish to Teams / Microsoft 365 Copilot | **GA 予定（GA soon）** |
| Routines（プロアクティブ長期実行） | **Public Preview** |
| Autopilot Agents（Teams への公開） | **Public Preview** |
| Voice Live integration（ホストエージェント向け） | **Public Preview** |
| Rubric（カスタム評価基準の自動生成） | **Public Preview** |
| Procedural Memory | **Public Preview** |
| Agent Optimizer | **Private Preview** |

### 開発者向け次のアクション

- **Foundry Toolkit for VS Code** をインストールしてエージェント開発を開始する
- **`azd ai agent eval init` / `azd ai agent optimize`** コマンドで評価と最適化を自動化する
- **Foundry Toolbox** の単一 MCP 互換エンドポイントで Foundry IQ・Fabric IQ・Work IQ・Content Understanding を統合する
- **Hosted Agents** と **Routines** を組み合わせて長期実行・プロアクティブなエージェントを構築し Teams や Microsoft 365 Copilot に公開する
- Agent Optimizer の **Private Preview** に参加し、本番トレースからの自動改善ループを試す
