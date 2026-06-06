# Microsoft Build 2026 BRKSP91「Turn foundation models into production AI on Microsoft Foundry」詳細まとめ

**登壇者**:
- **Vivek Chauhan**（Fireworks AI、メインプレゼンター）
- **Jed**（Fireworks AI、共同プレゼンター、姓は特定できず）
- **Nico Grupin**（Harvey AI、Head of Applied Research、ゲスト登壇）
- Satya Nadella キーノートでの発表動画も挿入（0:16頃）

**セッションURL**: https://build.microsoft.com/en-US/sessions/BRKSP91
**取得元**: 公式WebVTTトランスクリプト（medius.microsoft.com CAPTION）

---

## 全体像

本セッションは、Fireworks AI と Microsoft Azure AI Foundry の統合（General Availability）を中心に、エンタープライズが open-weight モデルを使って本番品質の AI を構築・デプロイする具体的な方法を解説する技術セッションである。Satya Nadella キーノートで前日に発表済みの連携を受け、実際のデモとユースケースを通じてアーキテクチャ選択・コスト削減・モデル品質向上の戦略を示した。

セッションの前半（Vivek 担当）では Fireworks AI のプラットフォーム概要と Training Agent・Managed Training・Training API の3階層を紹介。後半（Jed 担当）では Azure AI Foundry 上での Fireworks モデルのデプロイ方法（Serverless / PTU / Bring Your Own Weights）をデモし、最後にゲストの Harvey AI（Nico Grupin）が法律特化 AI における open-weight モデル活用の実践例と新ベンチマーク「Legal Agent Benchmark (LAB)」を語った。

---

## Chapter 1: セッション開幕と Fundamental Truths（0:00頃）

Vivek が冒頭で会場の音響確認をしながらセッションを開始。Jed と Harvey AI の Nico という2名の共同登壇者を紹介する。

セッション全体の前提となる「AI ランドスケープの3つの不変の真実」を提示：

1. **オープンウェイト vs クローズドモデルのギャップ崩壊**：エンタープライズの実用ユースケースにおいては、open-weight モデルと Claude Opus 4.7 などのクローズドフロンティアモデルの品質差はほぼなくなった。メール要約のような一般的なタスクに大型クローズドモデルを使い続けることは不経済である。

2. **差別化はデータの埋め込みから生まれる**：競合他社も同じクローズドモデルを使っている限り、AI スタックで差別化はできない。fine-tuning が競争優位の核心である。

3. **継続的な改善フライホイールが鍵**：業界トップ企業は推論最適化や fine-tuning にとどまらず、「訓練 → デプロイ → モニタリング → トレース取得 → 再訓練」というフライホイールを回し続けることで持続的な優位性を構築している。

---

## Chapter 2: Fireworks AI プラットフォーム概要（2:00頃）

Fireworks AI の規模感を説明：

- **1日あたり 30 兆トークン以上**を処理（Anthropic・OpenAI に次ぐ規模）
- **10,000 超のエンタープライズ顧客**がグローバルに利用
- 主要顧客例：**Cursor**（RL ロールアウト機能を活用して Composer 2 / 2.5 モデルを構築）、**Vercel**、**Genspark**、**Uber**、**DoorDash** など

**独自推論エンジン**の価値提案：
LLM 推論は「brutal combinatorial problem」であり、quantization モード・speculative decoding・parallelization 戦略などの組み合わせで1つのモデルに対し **84,000〜85,000 通りの最適化パーミュテーション**が存在する。これを自社で管理するのはほとんどの企業にとって非現実的。Fireworks は CUDA カーネルレベルから quantization、speculative decoding、adaptive caching まで対応。SLA 例：「time to first token 500ms 以下」「P99 latency 2秒以下」などのアプリ固有要件に対応可能。

---

## Chapter 3: Training Agent デモ（7:25頃）

「evals の記述やデータの再フォーマットが好きな人はいますか？→ 誰もいない → だからこのエージェントがある」という導入から、**Training Agent** のデモ（録画）を披露。

**Training Agent の機能と動作フロー**：

1. ユーザーがプレーンな英語でデータセットとビジネスゴールを伝える
2. エージェントが **データ再フォーマット・eval 生成・モデル選択・ハイパーパラメータ探索**を自動実行
3. 事前に「計画（プラン）」と**推定コスト**を提示し、ユーザーの承認を求める
4. データセットの小さなカットで**ハイパーパラメータグリッドサーチ**を実施し、有望な候補（例：10試行中の上位2）を絞り込む
5. ユーザーが OK すると**全データセットで本番訓練ジョブ**を実行
6. ステップバイステップの詳細ビューと**最終レポート**を出力

エージェントは **Supervised Fine-Tuning (SFT)**・**Preference Optimization (DPO)**・**分類タスク特化モデル**に対応。UI・API の両方で利用可能で、GitHub Copilot / Cursor / Claude 等の既存コーディングエージェントから呼び出せる **Skill ファイル**（ヘッドレス）も提供。

**対象ユーザー**：ML の専門知識なしに fine-tuning を実施したいプロダクトマネージャー・アプリ開発者。

---

## Chapter 4: Managed Training と Training API（10:00頃）

**Managed Training Platform**（ML エンジニア向け）：

- UI から SFT・Reinforcement Fine-Tuning・Preference Optimization を選択可能
- モデルを選択しデータセットをアップロード（直接 or BYOB：自社クラウドから安全ストリーミング）
- epoch・学習率・バッチサイズなどのパラメータをスマートデフォルト付きで設定
- **Reinforcement Fine-Tuning 対応**：grader を GitHub リポジトリで接続し reward 付与
- **Weights & Biases** 連携によるリアルタイム監視
- 訓練中に loss 関数・reward 関数のライブモニタリング（異常時に一時停止可能）
- 一クリックデプロイ：訓練済みモデルをそのまま本番投入、ダウンロード・フォーマット変換不要
- **Compound Training**：SFT → DPO → RL のパイプライン連鎖が可能（フライホイールの実体）

**Training API**（上級 ML チーム・研究者向け）：

- インフラは完全管理しつつ、カスタム loss 関数・reward 関数・最新アルゴリズム（GRPO、on-policy training 等）を raw プリミティブとして提供
- フルパラメータ fine-tuning・最大コンテキストウィンドウ対応
- ラップトップから 1兆パラメータモデルの訓練ジョブを発行可能（インフラはクラウド側）
- **数値的整合性の保証**：訓練時と本番サーブ時で数値が一致（MoE モデルの floating point drift 問題を回避）
- 公開 GitHub Cookbook（レシピ集）で素早くスタートできる
- 既存 AI エージェントハーネス内からモデルを訓練する使い方が重要：「AI はそれが持つツールを知った状態で、自分の環境の中で改善すべき」

---

## Chapter 5: Fireworks on Azure AI Foundry — GA 発表（15:42頃）

Satya Nadella キーノート（前日）での発表映像を上映。発表ポイント：

> 「Fireworks の Microsoft Foundry での General Availability を発表。1つのエンドポイント、1つの契約、1つのジャーニー、1つのプラットフォームで、Fireworks と Foundry 双方の強みを活用できる」

**スコープの整理**：
- 推論・デプロイ機能：Foundry 上で GA
- 訓練機能（Training Agent / Managed Training）：**現時点では Foundry 上では未提供**（Fireworks.ai 側で訓練し、モデルを Foundry に持ち込む形）

**Foundry で Fireworks を選ぶ4つの理由**（Jed が解説）：

1. **Performance**：CUDA カーネルレベルからの推論最適化。ユースケース特性に合わせた GPU 最大化
2. **Model Advantage**：新しい open-source モデル（DeepSeek V4、Kimi 2.6 等）の **Day-0 リリース**。エージェントへの即時組み込みが可能
3. **Control & Extensibility**：Foundry カタログとの統合により、カスタムモデルのデプロイが容易
4. **Economics**：クローズドモデルのスケール時コスト爆発を回避。Azure クレジットをそのまま利用可能

---

## Chapter 6: Foundry 上での3つの統合デプロイモード デモ（19:00頃）

Jed が Azure AI Foundry でのデプロイフローをビデオデモで解説。

**① Serverless（ペイパーゴー）モード**：
- Azure AI Foundry の Discover ページ → Models → Catalog で Fireworks モデルを検索（プレフィックス **"FW"** が目印）
- 利用可能モデル例（現在）：**GLM 5.1**、**Kimi 2.6**、**Qwen 120B**（字幕では "GPT 120B" と誤記、Qwen2.5 系と推測）
- クリック → Deploy → レート制限設定 → デプロイ完了
- Playground でチャット or API を取得してエージェントに組み込み
- 共有インフラのため rate limit あり；token 単位の従量課金

**② PTU（Provisioned Throughput Unit）モード**：
- GPU を予約して本番ワークロードに専用デプロイ
- 高トラフィックの本番環境に適し、rate limit なし
- PTU ゲーテッド（プロビジョニング申請）

**③ Bring Your Own Weights (BYOW) モード**：
- Fireworks 上で訓練・ダウンロードしたカスタムウェイトを Azure にアップロード
- Foundry の Build → Models → Custom Models セクションでモデルを登録
- ベースアーキテクチャ選択（未対応アーキの場合は Azure+Fireworks へ連絡）
- CLI コマンドでウェイトをアップロード → クリックで PTU デプロイ
- Playground or API でそのまま利用

---

## Chapter 7: Azure AI Foundry エージェントへの組み込みデモ（25:40頃）

既存モデル or カスタムモデルを **Azure AI Foundry の Agents** に紐付けるフローをデモ：

1. Foundry の Build ページ → Agents
2. エージェントに名前を付けて Deploy
3. エージェントが使用するモデルを変更（FW モデル or カスタムモデルを指定可能）
4. Web 検索ツール、ユーザー定義ツール（関数）などを統合
5. デプロイ完了後は UI チャット or API でエージェントを呼び出し

---

## Chapter 8: 顧客ユースケース事例（21:00頃）

Jed が3社の実例を紹介：

- **UiPath**：クローズドモデル（Claude Sonnet 4.6）と同等品質を open-weight モデルで達成。コスト削減と速度向上を両立
- **Bolt**（字幕では "Bolt new"）：本番環境でのスループット・レイテンシのスケーラビリティが要件。Fireworks エンジン最適化 + Foundry で解決
- **Motif**（字幕通りの表記）：繰り返しタスクの高ボリュームワークロード。Foundry 上の Fireworks 最適化モデルで対応

---

## Chapter 9: Harvey AI ゲストセッション — Legal Agent Benchmark & オープンモデル戦略（27:13頃）

マイクトラブル（Nico のマイクが一時オフ）のハプニングを経て、Nico Grupin（Harvey AI、Head of Applied Research）が登壇。

### Legal Agent Benchmark (LAB) の詳細

Harvey AI が約3週間前（セッション当時）にリリースした、**法律エージェントのための業界特化型ベンチマーク**。

構成要素：
- **エージェント環境**：クライアントマター（弁護士が案件で使う文書・中間作業物の全体）を環境として設定
- **タスク形式**：詳細手順リストではなく「パートナーレベルの指示」（例：「このデータルームを元にイシューリストを作れ」）
- **成果物要件**：チャット応答ではなく、Word 文書・Excel・PowerPoint など実際の法律作業物（1タスクあたり5〜10ドキュメント）
- **採点**：各タスクに **50以上のルーブリック基準**、All-Pass スコアリング
- **規模**：**24の法律実務領域**、**1,200以上のタスク**、**75,000のルーブリック基準**（合計）

### Harvey × Fireworks の協業成果

セッション当日に記事をリリース（「go check it out」と言及）。

**Advisor Agent システム**（最も注目の成果）：
- Worker エージェント：**Kimi 2.6**（open-weight）などを使用
- Advisor モデル：**Claude Opus 4.7** などのクローズドフロンティアモデルを重いタスクのみに使用
- 推論時ルーティング（inference-time routing）により、quality-cost の Pareto フロンティアを最適化
- 結果：**2.4倍のコスト削減**、かつ LAB All-Pass スコアで**30%向上**（closed-only システムを上回る）

**SFT with Kimi モデル**：Fireworks の Managed Training を使って Kimi 2.6 などに SFT を実施し、LAB ベースモデルスコアからリフトを確認。

### Harvey のオープンモデル戦略（4つの軸）

1. **ドメイン専門性**：モデルの「ジャギーインテリジェンス」（Andrej Karpathy の用語）問題 — M&A・財務デューデリジェンスは強いが、訴訟・ケースロー調査は弱い、などの偏りを post-training で均す
2. **コスト・レイテンシ**：高度なタスクにはフロンティアモデル、単純タスクには open-weight モデルと使い分けるバイモーダル分布が出現。ルーティングの重要性が増す
3. **セキュリティ・ガバナンス**：法律顧客は VPC 内でのセキュアデプロイを要求。オープンウェイトモデルは完全な推論トレースへのアクセスを可能にし、interpretability・auditability の向上に寄与
4. **イテレーション速度**：「all timelines are compressed」（Harvey 社内の合言葉）。Fireworks のマネージドインフラで post-training 実験のループが大幅に短縮

---

## まとめ

### 新機能・発表ステータス一覧

| 機能/発表 | ステータス | 詳細 |
|---|---|---|
| **Fireworks on Azure AI Foundry** | **General Availability (GA)** | Satya Nadella キーノートで発表。1エンドポイント・1契約・1プラットフォームで利用可能 |
| **Serverless（ペイパーゴー）モデル** | **GA** | GLM 5.1、Kimi 2.6、Qwen 120B 等、FWプレフィックスのモデルが Foundry カタログに掲載 |
| **PTU（Provisioned Throughput）モード** | **GA（PTUゲーテッド）** | 本番ワークロード向けに GPU 予約デプロイ |
| **Bring Your Own Weights (BYOW)** | **GA** | Fireworks 訓練済みカスタムモデルを Foundry にアップロード・デプロイ |
| **Training Agent** | Fireworks プラットフォーム上で利用可能（Foundry 統合は将来） | プレーンな英語でfine-tuningを自動化。SFT・DPO・分類タスクに対応 |
| **Managed Training Platform** | Fireworks プラットフォーム上で利用可能 | SFT・RFT・DPO、Weights & Biases 連携、Compound Training 対応 |
| **Training API** | Fireworks プラットフォーム上で利用可能 | カスタム loss/reward 関数、フルパラメータ fine-tuning |
| **Harvey Legal Agent Benchmark (LAB)** | 発表済み（セッション約3週間前） | 24法律領域・1,200タスク・75,000ルーブリック基準の法律特化ベンチマーク |
| **Harvey Advisor Agent System** | セッション当日に記事リリース | Worker (open-weight) + Advisor (frontier) の hybrid routing、2.4倍コスト削減・30%品質向上 |

### 次アクション

- **Foundry カタログ**で "FW" プレフィックスのモデルを試す（Serverless、即時利用可能）
- **Bring Your Own Weights** を使って Fireworks で fine-tune したカスタムモデルを Foundry にデプロイする
- **Training Agent** の Skill ファイルを既存コーディングエージェント（Cursor / Copilot / Claude）に組み込む
- Harvey AI の LAB ベンチマーク記事（当日公開）を参照して、業界特化 AI エージェントの評価手法を学ぶ
- Fireworks Cookbook（GitHub 公開）で Training API のレシピを参照する
