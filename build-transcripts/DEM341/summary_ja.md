# Microsoft Build 2026 DEM341「Any agent, any cloud: Standardized tracing with Foundry+OpenTelemetry」詳細まとめ

**登壇者**:
- Hanshi（ファーストネームのみ判明）: Microsoft Foundry Observability チームのソフトウェアエンジニアリングマネージャー（自己紹介より）
- Nak Kumar: 同チームのエンジニア（推測）、GCP/AWS エージェントデモ担当

**セッションURL**: https://build.microsoft.com/en-US/sessions/DEM341
**取得元**: 公式WebVTTトランスクリプト（medius.microsoft.com CAPTION）

---

## 全体像

本セッションは「どのエージェントフレームワークを使っていても、どのクラウドで動かしていても、一箇所で統合的にエージェントのオブザーバビリティを実現する」というテーマのデモ中心のセッションである。登壇者は最初に聴衆へ「本番でエージェントを運用している人は？」「全員が同じクラウド・同じフレームワークを使っている人は？」と問いかけ、後者はほぼゼロであることを確認した上で、エンタープライズ現場の実情として複数フレームワーク・複数クラウドが混在するヘテロジニアスなエージェント環境を描写した。

解決策として提示されたのが **Foundry Observability** である。エージェントを一つのフレームワークに書き直すのではなく、**OpenTelemetry** の instrumentation を数行追加するだけで、あらゆるフレームワーク・クラウドのトレースを Microsoft Foundry に集約し、デバッグ・モニタリング・評価をワンストップで実行できる。セッション中に示したデモコードとエージェントは公式リポジトリで公開されており、全て Foundry 上で今すぐ試せる旨が強調された。

---

## チャプター1：課題提示とデモシナリオの概要（0:00頃）

セッション冒頭、Hanshi が「プロダクションでエージェントを運用している人」に挙手を求めた。さらに「全てのエージェントが同一クラウド・同一プログラミング言語・同一フレームワークで動いている人」に絞り込むと、会場でほぼ誰も残らなかった。

この反応を受けて、エンタープライズ現場の典型例が紹介された：

- **製品チーム**：ポータルで素早くイテレーションできるため **Foundry の Prompt Agent**（ノーコード）を採用
- **バックエンドチーム**：慣れ親しんでいる **LangGraph** を選んで **AWS** 上で稼働
- **第三チーム**：すでに GCP 上にあるため **Google ADK** を採用し Gemini を利用
- **追加チーム**：話題の **Copilot SDK** をキャッチオールとして採用

こうして気付けば、異なるフレームワーク・異なるホスティング・異なるメトリクス・異なるダッシュボードが乱立し、本番で不正応答が出たとき「どのエージェントが？なぜ？どう防ぐ？」という問いに答えられない状況に陥ると説明された。

---

## チャプター2：Foundry Prompt Agent と単一エージェントのトレース体験（0:03頃）

最初のデモは **Microsoft Foundry ポータル** のプレイグラウンドビューを使い、Hanshi が Xi'an（西安）旅行エージェントを構築した例を紹介。

**構成要素**：
- モデルの選択
- システムプロンプト（多言語対応も可能）
- PDFファイル（旅行ノート、画像・リンク含む）を Foundry にインデックスとしてアップロード → **RAG パターン**

「3日間、2人、歴史と食をメインにした旅程を立案して」というプロンプトに対し、エージェントは日本語を含む多言語で観光地・レストラン推薦を含む詳細な旅程を返した。

デモの本題はその後の **Traces ビュー**：

- 過去の全会話がリスト表示（トークンコスト、token in/out、推定コスト、レイテンシー）
- 特定トレースを選ぶとスパンのツリービューを展示
  - **invoke agent スパン**：システムメッセージ、ユーザー入力、エージェント出力を包含
  - **executed tool スパン**：RAG 検索クエリと取得結果が確認可能
- **Metadata タブ**：PDF からの検索クエリと取得コンテンツを確認でき、ハルシネーションや groundedness 問題のデバッグ起点となる
- **リプレイボタン**：実行速度を選んでエージェントの思考プロセスをアニメーション再生
- **ユーザービュー**：エンドユーザーが見る画面を開発者がそのまま確認可能

---

## チャプター3：マルチエージェント・マルチクラウドデモ（0:08頃）

ここで Nak Kumar が登壇し、自身が実装した **Bangalore 旅行エージェント**（Google ADK / GCP 上で稼働）を紹介。curl コマンドで `run.app`（Google Cloud Run）エンドポイントへリクエストを送信し、リアルタイムでレスポンスが返ってくる様子を実演した（ネットワーク遅延でわずかな待ち時間が発生するハプニングあり）。

さらに、2人が共同で **Seattle 旅行エージェント**（LangGraph / AWS 上で稼働）も構築。デモのアーキテクチャ全体は以下の構成となった：

| エージェント | フレームワーク | 実行環境 |
|---|---|---|
| オーケストレーター（都市ルーター） | Microsoft Agent Framework | Foundry Hosted Agent |
| Xi'an 専門エージェント | Foundry Prompt Agent（ノーコード） | Microsoft Foundry |
| Bangalore 専門エージェント | Google ADK | GCP（Cloud Run） |
| Seattle 専門エージェント | LangGraph | AWS |
| フォールバック（未対応都市） | Copilot SDK | （推測） |

オーケストレーターに「Seattle、Bangalore、Lisbon について教えて」と問い合わせると、都市ごとに適切なサブエージェントへルーティングされる。Lisbon は専用エージェントが存在しないため Copilot SDK がフォールバックとして処理した。

これら全エージェントが OpenTelemetry トレースを emit することで、**Foundry Observability がエンドツーエンドの実行を一本のトレースとして結合して表示**した。スパンツリーには「invoke Seattle specialist → 結果取得 → Copilot fallback for Berlin（過去の別テスト）」といった流れが一目でわかる形で描画された。

---

## チャプター4：OpenTelemetry Instrumentation の技術詳細（0:13頃）

マルチクラウドトレース統合を可能にした「Key Ingredients」として2点が解説された。

**1. Microsoft Agent Platform の2種類のエージェント形式**

- **Foundry Prompt Agent（ノーコード）**：ポータルで素早くイテレーション可能
- **Foundry Hosted Agent（プロコード）**：コードまたはコンテナを Foundry に提出し管理・実行を委任。エンタープライズ向け特徴として：
  - エンタープライズグレードのVM分離
  - **Entra agent identity** によるセキュリティ保証（自動字幕では「Ontree」と誤記）
  - 長時間実行操作（Long Running Operations）やルーティン機能

**2. OpenTelemetry GenAI Semantic Conventions**

共通のテレメトリースキーマとして機能し、異なるフレームワークが**エージェント名・モデル呼び出し・主要イベントに対して一貫した属性でスパンを emit** できる。Microsoft は本標準に積極的にコントリビュートしており、サポートシナリオを随時拡充中。

**インストルメンテーションのコード変更（VS Code デモ）**

Foundry ネイティブエージェントは **Microsoft OpenTelemetry Distro** が組み込み済みのためコード変更不要。外部エージェントに対しては数行の初期化コードのみ追加：

```python
# 擬似コード（デモで示された内容の要約）
use_open_telemetry(
    enable=True,
    azure_monitor_connection_string="<接続文字列>",
    framework="adk",          # 使用しているフレームワークを指定
    agent_id="<Foundry登録済みのエージェントID>"
)
```

`agent_id` は Foundry にエージェントを外部エージェントとして登録した際に発行されるIDで、これによりトレースの相関が実現される。

バックエンドとして **Foundry Observability は Azure Monitor と Azure Application Insights によって駆動**されており、既存の Azure Monitor ユーザーは非エージェントワークフローのメトリクスと同一のインフラで管理できる。

---

## チャプター5：Monitor/Operate タブと評価機能（0:17頃）

**Monitor タブ**

- ライブトラフィックパターン・レイテンシー分布
- 推定コスト・総トークン使用量
- スケジュールされた評価（scheduled evals）の結果一覧
- **スケジュールされた red team** の結果（自動脅威テスト）
- エラーレート推移（デモ中に「最近エラーレートが上がっている、確認しないと」とコメント）
- Tool Call Success Rate の推移（「最近下がっている」と言及）
- 人間評価者（Human Evaluator）のレビュー結果も統合表示

**Operate タブ（フリートビュー）**

- **Active Alerts**：Foundry エージェントにはデフォルトでセキュリティワークフローが稼働し、悪意あるURL検出やジェイルブレイク試行などを自動アラート
- 評価結果に基づくカスタムアラート設定が可能
- エージェント成功率・ボリューム推移などのメトリクス

**評価機能のデモ（Evaluation）**

```python
# 擬似コード（デモより）
project = FoundryProject(...)
project.add_evaluator(IntentResolutionEvaluator())
project.run_eval(agent_id="<エージェントID>")
```

評価結果の画面では複数メトリクスが表示され、失敗したトレースをクリックすると直接スパンツリービューへ遷移してデバッグできる。デモ例では：
- ユーザーの意図：「Bengaluru と Barcelona を簡潔に比較して」
- 失敗したメトリクス：**Task Adherence**
- 失敗理由：レスポンスが両都市の説明を別々に記述するのみで、比較表などの「比較形式」になっていなかった

登壇者はこれを見て「評価器は表形式の比較を期待していたようだ」とコメントした。

---

## チャプター6：追加機能の紹介とまとめ（0:22頃）

時間の都合でデモできなかった追加機能として以下が紹介された：

- **Rubric Evaluators**：エージェント固有にカスタマイズされた評価プランを自動生成し、評価設計のコールドスタート問題を解決（ステータス明言なし）
- **Agent Optimization**：システムプロンプトのチューニング、異なるモデルの試行、ツール追加などによりエージェントを自動改善。M365（自動字幕では「865」「M-65」と誤記）へのオプトイン利用も可能
- **OpenInference および OpenLLMetry サポート**：OpenTelemetry GenAI Semantic Conventions への移行が難しい既存顧客向けに、これら2つの人気トレースフォーマットでも Foundry のトレース表示と評価をサポートすると発表

セッションは「Build what you want, run it where you need, observe it all in one place — Any agent, any cloud, one observability plane.」というキャッチフレーズで締めくくられた。

---

## まとめ

### 結論

- マルチフレームワーク・マルチクラウドのエージェント環境において、OpenTelemetry instrumentation の数行追加だけで Foundry Observability に全トレースを統合できることをライブデモで実証した
- デバッグ→モニタリング→評価→最適化のループを Foundry の単一オブザーバビリティプレーンで完結させるアーキテクチャが示された

### 本セッションで言及・デモされた機能のステータス

| 機能 | ステータス（セッション発言に基づく） |
|---|---|
| Foundry Observability（トレース統合・Monitor/Operate タブ） | **GA（live and available on Foundry）** — 冒頭で「全てライブで利用可能」と明言 |
| OpenTelemetry GenAI Semantic Conventions サポート | **GA** |
| Microsoft OpenTelemetry Distro（外部エージェント向け） | **GA** |
| OpenInference / OpenLLMetry サポート | **発表済み**（ステータス明言なし、要確認） |
| Foundry Hosted Agent（Entra agent identity・VM分離） | **GA**（機能説明あり） |
| Rubric Evaluators | **言及のみ**（ステータス明言なし） |
| Agent Optimization | **言及のみ**（ステータス明言なし） |

### 次アクション

1. QRコード経由でデモリポジトリを確認し、Xi'an / Bangalore / Seattle 各エージェントのコードを参照
2. Microsoft Foundry ポータルで外部エージェント（LangGraph、ADK 等）の登録手順を確認
3. `azure-monitor-opentelemetry` ディストロを既存エージェントに数行追加して Foundry トレースを試す
4. Monitor タブおよび Operate タブで既存エージェントの KPI・アラート設定を確認
5. Rubric Evaluators と Agent Optimization の Public Preview 参加を Foundry ドキュメントで確認