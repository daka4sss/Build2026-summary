# Microsoft Build 2026 BRK252「From observability to ROI for AI agents on any framework」詳細まとめ

**登壇者**:
- **Sebastian**（司会・進行。Microsoft Foundry Observability チーム。苗字はトランスクリプトから特定できず）
- **Felicia**（デモ担当。Microsoft Foundry チーム。苗字はトランスクリプトから特定できず）
- **Vivek**（デモ担当。Microsoft Foundry チーム。苗字はトランスクリプトから特定できず）

**セッションURL**: https://build.microsoft.com/en-US/sessions/BRK252
**取得元**: 公式WebVTTトランスクリプト（medius.microsoft.com CAPTION）

---

## 全体像

本セッションは「**Microsoft Foundry Observability**」を中心に、AIエージェントの開発・運用における可観測性（Observability）の全体像を解説し、複数のライブデモを通じて実践的なワークフローを示した技術セッションである。対象は AIエージェントを本番稼働させようとしている開発者・オペレーター。

AIエージェントは非決定的（non-deterministic）であるため、従来の DevOps とは異なる信頼性・品質管理の仕組みが必要になる。本セッションでは「エージェント DevOps ライフサイクル」というコンセプトのもと、**内側ループ（inner loop）**（計画→コーディング→テスト→リリース）と**外側ループ（outer loop）**（監視→分析→最適化→内側ループへのフィードバック）が循環する構造を示した。

セッションは BRK241「Developing production agents」の続編に位置づけられており、デモシナリオとして「データセンター運営のベンダー管理者向け Vendor History Analyst エージェント」が使用された。このエージェントはベンダーの作業履歴を要約・分析し、ベンダーミーティングでのデータドリブンな会話をサポートするものである。

---

## Chapter 1: Microsoft Foundry Observability の 4 本柱（0:00頃）

セッション開始直後、Sebastian が Microsoft Foundry Observability の全体像を説明した。4 つのコアピラーが紹介された。

1. **Tracing（トレーシング）**: エージェントの実行ワークフロー全体をエンドツーエンドで可視化。
2. **Evaluation（評価）**: トレースをもとにエージェントの品質と安全性を評価。オフラインおよびオンラインの両方に対応。
3. **Monitoring（モニタリング）**: オフラインで使用した評価をそのまま本番環境でも実行し、リアルタイムで問題を検出。
4. **Optimization（最適化）**: 収集したシグナルをもとにエージェントを継続的に改善。

また Foundry は「コントロールプレーン」として、エージェントサービス・モデル・Foundry IQ（ナレッジ・ツール）・ファインチューニングなどすべての AI 構築能力にまたがる横断的な Observability を提供する、と位置づけが示された。

---

## Chapter 2: ゲッティングスタート – Foundry ポータルでのトレース確認と Rubric Evaluator（0:03頃）

Felicia がステージに登壇し、最初のライブデモを担当した。

### デモの流れ

1. **Hosted Agent の実行**: Foundry ポータルのプレイグラウンドで、ベンダー管理者が使いそうな質問クエリを Vendor History Analyst エージェントに送信。エージェントが回答を生成する様子を示しつつ、応答の矛盾点（「ベンダーはうまくやっている」とも「要管理」とも取れる曖昧な回答）を観察。

2. **Rubric Evaluator の作成**: Felicia が「これが今日紹介する重要な新機能」として **Rubric Evaluator** を紹介。設定手順は以下のとおり：
   - 名前と種別（rubric type）を入力
   - エージェントが使っているシステムプロンプトを貼り付け
   - 評価用モデルを選択
   - ターゲットとして今の Hosted Agent を指定
   - 「Generate Rubric」を実行

3. **自動生成されたルーブリック**: Foundry が入力されたシステムプロンプトとエージェント情報をもとに **8 次元**の評価基準（rubric）を自動生成した。各次元には重みが設定される。これにより「データがゼロでも評価を始められる」メリットが示された。

4. **継続的評価（Continuous Evaluation）の確認**: トレース一覧画面に切り替え、App Insights から取り込んだ本番トレースに対してルーブリックが自動採点されている様子を確認。スコアが低いトレースを選んで詳細ビューを開くと、「task completion」と「vendor history rubric score」の両方が低いことが判明。

5. **根本原因の特定**: ユーザーが「特定の日付のデータ」を要求したところ、エージェントにはそのデータがなかったにもかかわらず、あたかもデータがあるかのような回答をしていた（ハルシネーション）。Felicia と Sebastian がその場で原因を確認した。

---

## Chapter 3: コードファースト Observability – Foundry Toolkit と Foundry Skill（0:12頃）

引き続き Felicia がデモを進め、今度はポータルから IDE（VS Code）に場所を移した。

### Foundry Toolkit（VS Code 拡張）

- **Foundry MCP サーバー**と**Foundry Skill**の両方が「Foundry Toolkit」という VS Code 拡張にパッケージされている。
- 将来的には他のコーディングエージェント・エディタにも対応予定（現時点では VS Code のみ）。
- Foundry MCP を使うことで、GitHub Copilot Chat（VS Code 内）からポータルと同様の操作（評価結果の取得・分析・アクションなど）が可能になる。

### Foundry Skill の役割

Foundry Skill は「Foundry チームが提供するオピニオン付きフロー」と説明された。開発者が観察→分析→最適化を行う際のベストプラクティスが組み込まれており、リポジトリコンテキストと Foundry のコンテキスト両方を踏まえた信頼性の高い提案を行う。

### デモの流れ

1. GitHub Copilot Chat に「先ほどのルーブリック評価結果を取得し、スコアが低い理由と改善点を教えて」と指示。
2. Foundry MCP が呼び出され、評価定義と直近 8 時間の評価実行結果を自動取得。
3. Copilot Chat が次元別スコアの内訳・最も弱い次元・失敗パターン・改善推奨事項を一覧表示した。（「数百件のトレースや評価結果を手動で確認する必要がなくなった」と Sebastian がコメント）
4. 「システムプロンプトを改善して」と指示すると、Skill がトレースの失敗パターンを踏まえた新しいシステムプロンプトを自動生成。（デモ中、Felicia が「あ、ファイルを消してしまった」と言うハプニングがあったが、概念説明を続行）
5. 改善後のコードをローカルでテストし、本番へプッシュできる流れを示した。

### トレース→データセット変換

本番のトレースをデータセットに取り込む「**Traces to Data Sets**」機能（スマートフィルタリング付き）が紹介された。これにより内側ループでの回帰テスト範囲を継続的に拡充できる。

---

## Chapter 4: Public Preview 発表まとめ – 内側ループ関連の新機能（0:17頃）

Sebastian がデモを受け、新機能の発表を行った。

### Rubric Evaluator（Public Preview）
- システムプロンプトとエージェントの情報から多次元評価基準を**自動生成**する機能。
- データがゼロの新規エージェントでも利用可能。
- オフライン評価・オンライン評価の両方に対応。
- **Public Preview として発表。**

### Multi-Turn Evaluation（Public Preview）
- 従来はシングルターン（1 問 1 答）のみだったが、セッション全体（複数ターン）を対象とした評価が可能になった。
- 例：エージェントが最終的に正解したとしても、20 分かかった場合は「5 分で終わるべきセッション」として失敗と評価できる。
- Groundedness・Coherence・Task Completion・Customer Satisfaction・Rubric Evaluator などが**マルチターン対応**になった。
- **Public Preview として発表。**

### User Simulation（Public Preview）
- マルチターンのテストデータがない場合に、**リアルな会話を自動生成**してくれる機能。
- Multi-Turn Evaluation と組み合わせて使用することが想定されている。
- **Public Preview として発表。**

### コードファースト Observability（Foundry Toolkit）
- Foundry MCP・Foundry Skill を VS Code / GitHub Copilot Chat / CLI から利用可能。
- 評価実行・結果分析・比較・トレース参照・最適化への遷移がシームレスに行える。

### Evaluator カタログ
- 品質・リスク・安全・エージェント評価にまたがる豊富な組み込み評価器を提供。
- コードベース評価器（正規表現チェック、DB ルックアップなど）は非決定的シナリオに特に有効で、LLM ジャッジ不要。

---

## Chapter 5: Agent Optimizer – 自動最適化デモ（0:20頃）

Vivek がステージに登壇し、**Agent Optimizer**（新機能）のデモを行った。

### 概要

Agent Optimizer は、エージェントに対して**自動的に複数バージョンを生成・評価・反復**することで最適なプロンプト・ツール定義・モデルの組み合わせを探索する機能。ユーザーが手動でプロンプトを読んだり、トレースを確認したりする手間を大幅に削減する。

### 最適化対象

以下の組み合わせを同時に最適化できる：
- システムプロンプト
- スキル（設定している場合）
- ツール定義（tool descriptions / parameter descriptions）
- モデル選択（複数モデルを指定した場合、最もパフォーマンスが良いモデルを推薦）

### 設定手順（eval.yaml ベース）

1. 最適化したい Hosted Agent を指定
2. 40 クエリのデータセットを指定
3. ルーブリック評価器を指定
4. 最適化するコンポーネント（プロンプト・ツール・モデル等）を選択
5. **最適化用モデル（reflection model）**を選択。このモデルは Agent の実行モデルとは別で、トレースを自己反省し、評価ルーブリックを読んで何を変えるべきか判断するために使われる。「より賢いモデルほど最適化の質が上がる」

### ライブデモ結果

- 最適化ジョブは「数分から数十分」かかる（「犬の散歩やコーヒーに行けるくらい」と Vivek がコメント）。
- 以前に実行済みの結果を表示：
  - **14% ベースラインスコア向上**（コンテキストエンジニアリングのみで実現）
  - 4 つの候補バージョンが生成された：
    - Candidate 1: システムプロンプト改善 → 40 タスク中 38 が成功
    - Candidate 2: システムプロンプト + ツール定義改善
    - Candidate 3: ツール定義のみ改善
    - Candidate 4: 全対象改善 → **40/40 タスク成功、スコア 0.577→0.700 に向上**
  - **25 分で完了。**
- 各候補の差分ビューで、「どのシステムプロンプトの文言が変わったか」「どのツール説明が変わったか」を確認できる。以前のデモで判明したハルシネーションの箇所も修正されていた。
- Agent Optimizer はワンタイムで終わりではなく、**継続的なヒルクライミング**（トレースを見て→データセットに追加して→再最適化）として使うことが推奨された。

### リリース状況

**Agent Optimizer は Private Preview。Public Preview も近日予定。**

---

## Chapter 6: Agent ROI – ビジネス価値の証明（0:27頃）

Sebastian が最後のデモセクションを担当し、**Agent ROI 機能**を紹介した。

### 背景

エージェントの内側/外側ループを整備した後、次の問いは「そのエージェントはビジネス価値を生み出しているか？コストに見合っているか？」である。従来これはデータがなく経営層への説明が難しかった。

### 機能の仕組み

1. **設定画面で評価器を選択し、そこに「1 回あたりのビジネス価値」を割り当てる。**
   - 例：「Vendor Analyst エージェントがタスクを完了するたびに、手動で照会する手間が省けるので $5 の価値がある」として設定。
2. Foundry が**エージェントのトークンコスト**を自動で取得し、ユーザーは**ツールコスト**を手入力で追加。
3. バージョン別の「価値 / コスト / 純価値（net value）」をチャートで時系列比較できる。

### デモで確認できたこと

- 3 バージョンの ROI チャートを比較し、バージョンごとに純価値がどう変化するかを可視化。
- ツール呼び出しのコストが LLM コストを上回っている事例を発見 → ツール使用の最適化余地を示唆。
- **ROI が低いトレースにドリルダウン**し、なぜ失敗したか・どこでコストが発生したかを追跡できる。失敗して価値ゼロのエージェント呼び出しはすべて「ネガティブコスト」として計上される。

### リリース状況

**Agent ROI は現在 Private Preview。フィードバックを収集しながら近日 Public Preview 化予定。**

---

## Chapter 7: オープンエコシステムサポートと OpenTelemetry への取り組み（0:09頃 / 0:31頃）

セッション中盤・終盤で、Sebastian がクロスフレームワーク対応と OSS コミュニティへの関与について言及した。

### 任意フレームワーク対応

Foundry Observability は Foundry エージェントだけでなく、以下の外部フレームワークで構築されたエージェントも評価・トレース可能：
- **LangChain**
- **LangGraph**
- **OpenAI SDK**
- **Microsoft Agent Framework**

エージェントの実行ワークフロー全体と、トレースから生成される評価シグナルを完全に可視化できる。

### Azure Monitor との統合

- Foundry 内のデータは Azure Monitor に送られ、Azure リソース・データ・インフラのフルスタックビューと統合される。
- Azure Monitor のデータを Foundry に読み戻すことで、AI ワークロードの集中管理ビューが実現する。
- 顧客事例として **Entity Data** が Foundry と Azure Monitor を組み合わせてエンタープライズグレードの本番システムを構築していることが紹介された。

### OpenTelemetry へのコントリビューション

- Microsoft の Foundry エンジニアが OpenTelemetry の OSS コミュニティに積極的に参加。
- 直近では**メモリ（memory）に関する新しいセマンティクス**を OpenTelemetry に提案・コントリビュート済み。近日中に Foundry にも取り込まれる予定。
- CI/CD インテグレーション・レッドチーミングエージェントなど追加の評価機能も提供中。

---

## まとめ

### 発表された新機能と提供状況

| 機能名 | 提供状況 |
|--------|----------|
| **Rubric Evaluator**（多次元評価基準の自動生成） | Public Preview |
| **Multi-Turn Evaluation**（セッション全体の評価） | Public Preview |
| **User Simulation**（リアルな会話データの自動生成） | Public Preview |
| **クロスフレームワーク対応 Observability**（LangChain、LangGraph、OpenAI SDK、Microsoft Agent Framework） | Public Preview |
| **Foundry Toolkit / Foundry MCP / Foundry Skill**（VS Code 統合） | 提供中 |
| **Agent Optimizer**（自動ヒルクライミング最適化） | Private Preview（近日 Public Preview） |
| **Agent ROI**（ビジネス価値とコストのトラッキング） | Private Preview（近日 Public Preview） |

### 技術者向けの要点整理

- **どんなフレームワークでも使える**: LangChain・LangGraph・OpenAI SDK・Microsoft Agent Framework など主要フレームワークのトレースを Foundry で一元管理できる。
- **評価はトレースから**: Foundry では評価とトレースが密結合しており、本番のトレースをそのまま評価データとして活用できる。
- **内側ループ～外側ループの一貫したツール**: ポータル・VS Code（Foundry Toolkit）・CLI と開発場所を問わず同一の評価・分析・最適化ワークフローを利用できる。
- **Agent Optimizer で自動化**: 手作業でのプロンプトエンジニアリングから解放され、モデル・プロンプト・ツール定義の最適な組み合わせを自動探索できる。
- **ROI の見える化**: エージェントの「ビジネス価値 − コスト」を継続的に追跡することで、経営層への説明責任を果たせる。

### 次アクション

- Microsoft Build 会場のハンズオンラボで体験可能（後日オンラインでも公開）
- セールスチームへの問い合わせで Agent Optimizer・Agent ROI の Private Preview 参加が可能
- 翌日の関連セッション：Agent 365 ブレイクアウトセッション・Foundry Observability インテロペラビリティデモセッション・Azure Monitor ライトニングトーク