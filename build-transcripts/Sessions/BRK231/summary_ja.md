# Microsoft Build 2026 BRK231「Deploy. Observe. Learn. Reinforcement learning for production agents」詳細まとめ

**登壇者**: Alicia Frame（Product Lead, Model Customization, Microsoft Foundry）/ Omkar More（Engineering, Microsoft Foundry）
**セッションURL**: https://build.microsoft.com/en-US/sessions/BRK231
**取得元**: 公式WebVTTトランスクリプト（medius.microsoft.com CAPTION）

---

## 全体像

本セッションでは、本番環境で稼働中のエージェントをより良く、より安く、より速くするために Microsoft Foundry 上で活用できる post-training 技術を、3 段階のデモを通じて紹介した。取り上げた技術は（1）教師モデルのトレース蒸留（distillation）による supervised fine-tuning（SFT）、（2）実ツール呼び出しを伴う reinforcement fine-tuning（RFT）、（3）低レベルトレーニング API（"PyTorch as a service"）を使った完全カスタムレシピの 3 段階で構成される。

エージェントはチャット比 20〜30 倍のトークンを消費するため、frontier モデルをそのまま使い続けるとコストが爆発的に増大する。fine-tuning で 10〜30 倍安価な小型モデルを同等性能まで引き上げることが、経済的に持続可能なエージェント運用の鍵だと強調された。デモ全体を通じた主題は「あなたの IP・ドメイン知識をモデルの重みに焼き込み、frontier ラボではなく自社のものとして保持する」という価値提案である。

セッション末尾では、fine-tuning を自然言語だけで実行できる **fine-tuning skill**（GitHub Copilot for Azure のスキル、または単体でも利用可能）を披露し、誰でも fine-tuning を試せる民主化の方向性を示して締めくくった。

---

## Chapter 1: なぜ今 fine-tuning なのか（0:00頃）

セッション開幕直後、Alicia が「ノイズが多いので後ろにヘッドセットがあります」とハプニング気味に案内してから本題へ入った。

エージェント普及の背景として以下の数値が共有された。
- 企業向けソフトウェアアプリの **3 分の 1 が 2 年以内にエージェンティック AI を組み込む**と回答（実際にはそれより早く、割合も高いと Alicia は予測）
- 既に **半数のチームが何らかの本番エージェントを持つ**
- エージェントは旧来のチャット対話比 **20〜30 倍のトークンを 1 ターンで消費**

この「エージェントによるトークン爆増」こそが fine-tuning の必要性を生む。fine-tuning の主要な価値は次の 3 軸。

1. **品質向上**: プロンプトのインストラクションをモデルの重みに焼き込むことで、正しいタイミングに正しいツールを正しい入力で呼び出せるエージェントを実現。
2. **コスト削減**: fine-tuning のターゲットは frontier モデルの **10〜30 倍安価** な小型モデル（例: GPT-4.1 nano、Qwen など）。30 倍安ければ 30 倍のトークンを消費しても予算が合う。
3. **レイテンシ削減**: 小型モデルはトークン生成速度が速い。エージェンティックワークフローの応答速度が上がりユーザー体験が改善される。

---

## Chapter 2: fine-tuning の仕組みと Foundry における位置付け（2:06頃）

Microsoft Foundry のプラットフォーム全体像が提示された。11,000 以上のモデルを持つ基盤の上に、エージェントランタイム・デプロイ・ホスティング・ツール付与・Evaluate・Optimize が積み重なる。本セッションは **Evaluate と Optimize** のレイヤーを扱う。

fine-tuning の技術的背景。
- **Pre-training**: 大規模な無ラベルデータで次トークン予測を学習（最もコストが高い）
- **Instruction tuning (SFT)**: プロンプト＆レスポンスのペアデータでタスク固有の応答を学習
- **Alignment tuning**: 人間の好みデータ・報酬モデルで出力の方向性を調整

fine-tuning はこの最も高価な pre-training をスキップし、汎用ベースモデルに対して SFT または alignment（あるいはその両方）だけを追加するショートカット。

最適化の旅程は「プロンプトエンジニアリング → コンテキスト管理（RAG・メモリ）→ ツール付与 → Evaluate → fine-tuning」という順序で進む、と説明された。

---

## Chapter 3: デモ① — Distillation による SFT（安く・速く）（9:16頃）

### シナリオ設定

全デモ共通のシナリオとして、小売業の**カスタマーサービスエージェント（返金処理）**が使われた。エージェントは以下のツールを使って判断する。
- `get_order_details` — 注文詳細取得
- `get_fulfillment_status` — フルフィルメント状態確認
- `check_resolution_policy` — 返金ポリシー確認
- `process_payment` — 支払い処理

誤判断は小売業者に多大な損失をもたらす（米国の返品ビジネス規模は年間 **9,000 億ドル**）。

### デモの流れ

1. **Foundry でホスト型エージェントを作成**: GPT-5.4 をベースモデルに使用。Foundry のエージェントホスティングは Semantic Kernel、LangGraph など任意のフレームワークに対応。
2. **トレースの確認**: エージェントの会話トレース（ツール呼び出しの軌跡、入出力）が Foundry UI に自動保存される。千件以上のトレースが既に蓄積されていた。
3. **ベースライン評価**: Foundry の evaluation 機能で GPT-5.4、o4-mini、GPT-4.1-mini、GPT-4.1-nano を比較。Python ベースのカスタムグレーダーで以下 3 指標を評価。
   - 返金判断の正誤（重みづけ 50%）
   - 金額の正確性（重みづけ 30%）
   - 出力フォーマット（重みづけ 20%）
   - 結果: o4-mini・GPT-5.4 は 65% 前後、4.1-mini/nano は大幅に下回り、小型モデルの直接置換は不可と確認。
4. **Distillation（SFT）**: トレースから「Create Dataset」ボタンでデータセットを生成（重複除去・PII 除去を自動実行）。1,000〜1,400 サンプルを用いて GPT-4.1-mini に対して SFT 実施。
   - **Training type（SKU）**: Standard、Developer Preview（**コスト 50%オフ**、低優先度 VM 使用）、**Data Zone SKU**（米国内データレジデンシー保証、**Build で新規発表**）
   - ハイパーパラメータ調整、自動デプロイ設定などが UI から数クリックで完結。
   - 継続 fine-tuning（continuous fine-tuning）にも対応。
5. **SFT 後の評価結果**: **GPT-4.1-mini fine-tuned が 74% でトップ**に。o4-mini・GPT-5.4 を上回りつつ、fraction of the cost（GPT-5.4 比で大幅安価）を実現。
   - 意図解決（intent resolution）・タスク完了（task completion）のデフォルトグレーダーも確認し、fine-tuning により基本能力が劣化していないことを担保。

---

## Chapter 4: 間奏 — 「先生が十分に賢くない」問題と RFT の必要性（21:14頃）

74% はビジネス的に十分ではない（9,000 億ドルの 26% = 2,000 億ドル以上が誤処理リスク）。Distillation（SFT）の本質的限界として、「学習データの源である教師モデルを超えることができない」という天井が存在する。これを打破するのが **Reinforcement Learning（RL）/ Reinforcement Fine-Tuning（RFT）**。

RFT の仕組み（ホワイトボード解説）。
- モデルに同じプロンプトを複数回与え、複数の **rollout**（サンプル応答）を生成させる
- 定義済みグレーダーが各サンプルをスコアリング
- グレーダーの質がそのまま学習シグナルの質を決定（グレーダーが全正解・全不正解では学習不可）
- スコアをトレーナーにフィードバックし、高スコアの挙動を強化
- モデルはツール呼び出しを含む多段推論を自律的に学習していく

**重要な前提**: RFT はタスクの正解が「検証可能（verifiable）」な場合に機能する。返金可否や金額は検証可能なため、このシナリオに最適。

---

## Chapter 5: デモ② — Reinforcement Fine-Tuning（RFT）（23:19頃）

### SFT との違い

SFT では教師モデルの完全なツール呼び出し軌跡（どのツールをどの順序で呼ぶか）をコピーするが、RFT ではその軌跡を与えない。代わりに学習プロセス自体にリアルタイムでツールを呼び出す権限を与え、結果をグレーダーで評価し、自力で最良の推論経路を発見させる。

### SDK ベースのデモ手順

1. **訓練データの構成**: トレースから「ユーザーの質問」+「正解（返金額など）」のみ抽出。ツール呼び出し軌跡は含めない。
2. **RFT グレーダーのカスタマイズ**: 評価フローで使ったグレーダーに加えて、ツールカバレッジ（`get_orders` が呼ばれているか等）を追加。**reward hacking 対策**（モデルが「ツールを呼ばない」戦略で報酬を水増しするのを防ぐ）として重要。
3. **ツール環境の設定**: Azure Function App にツールをホストし、RFT ジョブに接続。MCP サーバーも利用可能。これが RL の「環境（environment）/ ハーネス（harness）」に相当する。
4. **RFT ジョブ実行**: Foundry UI から対象モデル（o4-mini）、reasoning effort（low/medium/high）、epoch 数、evaluation interval などを設定。reasoning effort はトークンコストに直結。
5. **Monitor タブによる監視**:
   - **rewards（train/validation）**: 両方が増加傾向であることを確認 → 正常な学習の証拠
   - **reasoning token mean per step**: 学習初期は大量の推論トークンを使うが、後半は減少傾向。ファインチューン済みモデルがベースより少ない推論トークンで正解できるようになった証拠
   - **tool calls per rollout**: これが急落している場合は reward hacking の兆候 → グレーダーを再調整
6. **RFT 後の評価結果**: **o4-mini fine-tuned が 84% でトップ**。SFT の 74% から +10pp。o4-mini は GPT-5.4 より安価なモデル。

### 実世界の採用事例（Alicia による紹介）

| 企業 | 使用技術 | 成果 |
|---|---|---|
| **Decagon AI** | Distillation + fine-tuning on Foundry | カスタマーサポートエージェントをより安価な小型モデルで実現 |
| **Discovery Bank** | Distillation + fine-tuning | 銀行アプリのレスポンスを **6 秒→1.5 秒**に短縮 |
| **Docusign** | Distillation | AI ドキュメント処理コストを **50% 削減** |

---

## Chapter 6: デモ③ — Interactive Training API（低レベル API / "PyTorch as a service"）（32:37頃）

### managed fine-tuning vs. training API

| 項目 | Managed Fine-tuning（デモ①②） | Training API（デモ③） |
|---|---|---|
| ユーザーの操作 | モデル・手法選択、データ提供、ジョブ送信 | config→rollout→loss→重みアップデート→グレーダー更新（全制御） |
| サービス境界 | 閉じたループ内で全処理 | ユーザーコードがループの外にある（アルゴリズム全体を制御可能） |
| GPU インフラ | サービスが管理 | サービスが管理（ユーザーは不要） |
| 向き不向き | ほとんどのケース | AI/データサイエンティスト、研究者 |

### API の構成要素（プリミティブ）

- `sample` API: GPU 上に事前ロードされたベース LLM でサンプリングを実行（forward pass）
- `forward-backward pass` API: 勾配計算（training node で実行）
- `sync` API: training node から sampling node への LoRA 同期
- `sync_checkpoint` API: チェックポイントの保存

バックグラウンドでは **training node と sampling node の 2 ノード構成**が動く。LoRA を使った分散トレーニングが透過的に管理される。

### 柔軟性のポイント

- **カスタムグレーダー**: C# でも任意の言語でも記述可能
- **カスタムツール統合**: MCP サーバーに縛られず、任意のフォーマットのツールを sampling プロセスで直接呼び出せる
- **アルゴリズム選択**: GRPO（デフォルト）以外に PPO、DPO なども利用可能
- **Curriculum learning**: 簡単なタスクから段階的に難易度を上げる学習が可能
- **mid-flight 変更**: 実行中にサンプリング戦略やアルゴリズムを変更可能

### ローカルダッシュボード

training API は orchestration コードがユーザーのローカルマシン（または Azure VM）で動く。付属のローカルダッシュボードで以下の詳細指標をリアルタイム確認可能。
- rewards（train/validation）
- entropy（下降傾向が正常）
- gradient norm
- **KL divergence**（reward hacking の主要検出指標 — managed ではこれまで見えなかった）
- GRPO の group composition

### デモ結果

Qwen3 32B（OSS モデル）に対し低レベル API で RFT を実施した結果、**leaderboard で o4-mini fine-tuned（84%）を上回る最高スコアを記録**。Qwen3 32B は o4-mini よりさらに安価なモデルであり、「より安く・より速く・よりスマート」の三拍子を満たした。

---

## Chapter 7: デモ④ — Fine-tuning Skill（自然言語での fine-tuning）（41:54頃）

### 背景・課題

- 「データがない」
- 「以前 fine-tuning したらモデルが悪化した。もうやらない」
- 「API や SDK を覚えたくない」

こうした声を受けて、Alicia（PM）自身が行った最終デモ。

### fine-tuning skill の概要

**GitHub Copilot for Azure** のスキルとして組み込まれているか、単体の fine-tuning skill としてもダウンロード可能。コーディングエージェント（Claude、GitHub Copilot CLI など）を通じた自然言語で fine-tuning ワークフロー全体を実行できる。Alicia は「Claude と Copilot CLI をライブデモで使う自信がない」と正直に打ち明けた上で事前収録版を提示した。

### デモの流れ（事前収録ベース）

1. **グレーダー自動生成**: ホスト済みエージェントの URL と要件（ツール確認・部分クレジット付与）を自然言語で指示。スキルが自動でグレーダーコードを生成・評価ジョブを実行し、GPT-5.4 ベースラインスコア（mean 8.37、pass@8 = 78%）を出力。
2. **Distillation ジョブの自動実行**: 「目標は安く・速くすること。エージェントのトレースを取得・フィルタ・重複除去して、fine-tuning autopilot ジョブを実行して」と指示。スキルがターゲットモデル（GPT-4.1-mini/nano）とハイパーパラメータを自律的に決定。fine-tuned GPT-4.1-mini がほぼ同等スコアを達成。
3. **フォールバック動作**: 全実験でモデルが悪化した場合、ログを分析して「データ追加生成」「別の実験を試みる」を自律的に繰り返す。

---

## Chapter 8: まとめ・新機能・リソース（45:37頃）

### よくある誤解の解消

**誤解①「frontier モデルがどんどん賢くなるので fine-tuning は不要」**
→ frontier モデルは賢くなると同時に大きく・遅く・高価にもなる。小型 fine-tuned モデルが frontier を超えることはデモで実証済み。また自社 IP がモデルの重みに残り、frontier ラボに渡らない。

**誤解②「fine-tuning は高い」**
→ Developer tier training（50%オフ）、SFT 中央値コスト約 1 ドル、Developer tier hosting（ホスティング費用なし）。

### 発表された新機能・ステータス

| 機能 | ステータス |
|---|---|
| **Data Zone SKU**（米国内データレジデンシー保証） | Build 2026 で新規発表（推測: Public Preview） |
| **Interactive Training API**（低レベル API / PyTorch as a service） | プレビュー申し込み受付中（推測: Private Preview） |
| **Fine-tuning skill**（GitHub Copilot for Azure / 単体） | 利用可能（GA または Public Preview — ステータス明記なし） |
| Developer tier training（50%オフ） | 既存機能 |
| Developer tier hosting（ホスティング費用なし） | 既存機能 |
| Traces to Dataset 変換（PII 除去・重複排除自動） | 既存機能 |

### 次のアクション

1. サンプルノートブック: デモで使ったコードは公開リポジトリで参照可能
2. Training API プレビュー申し込み: セッション内で案内
3. ハンズオンラボ: 翌日 3 セッション開催予定
4. fine-tuning skill のインストール: GitHub Copilot for Azure のスキルまたは単体ダウンロード

---

## 全体まとめ

本セッションは「本番エージェントを運用してトレースが溜まったら、そのデータを使って安く・速く・賢くする」という一貫したストーリーで構成されていた。SFT（簡単・高速）→ RFT（より高精度・やや複雑）→ 低レベル Training API（完全制御・研究者向け）という段階的なオプションを提供し、最後の fine-tuning skill で「誰でも自然言語で実行可能」という出口を用意した。

特に注目すべきは、RFT の学習ループに実際のツール（Function App / MCP サーバー）をリアルタイム接続するアーキテクチャと、KL divergence などの詳細メトリクスで reward hacking を検知・防止できる低レベル API の存在である。これらは、大規模生産ユースで RL を使う際のエンジニアリング上の最大の課題を Foundry が吸収してくれることを意味する。
