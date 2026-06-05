# Microsoft Build 2026 DEM323「Under the hood of Microsoft AI models」詳細まとめ

**登壇者**: Dave Citron（CVP of Products, Microsoft AI）
**セッションURL**: https://build.microsoft.com/en-US/sessions/DEM323
**取得元**: 公式WebVTTトランスクリプト（medius.microsoft.com CAPTION）

---

## 全体像

本セッションは约25分のDEMセッション。当日の基調講演（Mustafa Suleiman登壇）でMicrosoft AIが発表した7つの新モデルについて、技術的な内側を掘り下げる「Under the Hood」形式の解説セッションである。登壇者のDave Citronは、モデルの哲学・アーキテクチャ・学習レシピ・強化学習システム・Frontier Tuningの順に解説した。

セッションは（1）開発哲学、（2）7モデルの概要、（3）MAI Thinking 1の詳細（アーキテクチャ・データ・RLクライム・安全性）、（4）Microsoft Frontier Tuningの活用方法、という構成で進んだ。Voice 2のデモでは音声が会場に届かないハプニングが発生したが、登壇者は冷静に対処してデモを乗り越えた。

発表の核心は「蒸留（distillation）を一切使わず、すべての能力をスクラッチから習得させる」という哲学と、それを実現するための独自強化学習システム（GRPO + 5つの改善技術）、そして企業が自社のデータで同様のhill climbingを行える「Microsoft Frontier Tuning」の提供開始である。

---

## チャプター1: セッション概要・構成説明（0:00頃）

Dave Citronが自己紹介とセッション構成を説明。

- **登壇者**: Dave Citron、CVP of Products at Microsoft AI
- セッションは25分間の「Under the Hood」深掘りセッション。基調講演でMustafaが発表した内容の技術的背景を解説するのが目的
- 構成は以下の4パート:
  1. モデル開発の哲学
  2. 発表した全7モデルの概要
  3. **MAI Thinking 1**（初のフロンティア推論モデル）の詳細 — アーキテクチャ、学習レシピ、強化学習システム
  4. **Microsoft Frontier Tuning** — ユーザー自身がhill climbing loopを走らせる方法

---

## チャプター2: 発表7モデルの概要（1:04頃）

Microsoft AIとして発表した7モデルを画像・文字起こし・音声・コーディング・思考の分野にわたって紹介。

| モデル | 分野 | 主なハイライト |
|---|---|---|
| **Image 2.5** | 画像生成・編集 | ELO Arenaの画像編集リーダーボードで2位（競合モデルを上回ると発言。具体的なモデル名は自動字幕が聴き取り不明確、推測） |
| **Image 2.5 Flash** | 画像生成（高速版） | Image 2.5と同アーキテクチャ、コスト3分の1で本番スケールに対応 |
| **Transcribe 1.5** | 音声認識・文字起こし | 43言語でSOTA精度、競合モデル比5倍高速 |
| **Voice 2** | 音声合成 | ブラインドリスニングテストで72%が支持、感情制御機能付き |
| **Voice 2 Flash** | 音声合成（低遅延版） | 150ms以下のレイテンシ、音声エージェント向け |
| **Code 1 Flash** | コーディング | 5BパラメータのアクティブパラメータながらSWE-bench Pro 51.2、VS Code/GitHub Copilotにデフォルト搭載中 |
| **MAI Thinking 1** | 推論（フロンティア） | AIME 2025で97%、SWE-bench Pro 52.8、35Bアクティブパラメータ |

---

## チャプター3: 開発哲学「Humanist Superintelligence」（2:29頃）

モデル群を貫く設計思想の解説。「Humanist Superintelligence」という概念を中心に3つの具体的な意味を説明。

- **Human First**: モデルは常に人間のウェルビーイングを最優先する
- **Serve, not replace**: AIは人間の能力を拡張するものであり、代替するものではない
- **Platform commitment**: 開発者を常にフロンティアに維持する

この哲学から3つの技術的判断が導かれる:

1. **蒸留（Distillation）を使わない**
   蒸留はよく使われる手法（強いモデルの挙動を小さなモデルに転移）だが、教師モデルの能力が実質的な上限になる。また、「自前の学習パイプラインが本当にゼロから強くなれるか」「良い教師が存在しない領域でも前進できるか」のテストにならない。そのためMicrosoft AIはスクラッチからhill climbを行う。

2. **完全な透明性と制御**
   - 商用ライセンス済みデータのみ使用
   - サードパーティのweightは一切なし
   - ブラックボックスの継承なし
   - すべてのコンポーネントをデバッグ・監査・改善可能

---

## チャプター4: Image 2.5 / Voice 2 / Transcribe 1.5 / Code 1 Flash の詳細（4:15頃）

各モデルの特徴と現在の展開状況を概説。

### Image 2.5
- 画像編集リーダーボード2位（画像to画像カテゴリ）
- **精度と一貫性**が他モデルが苦手とするレベルで実現
  - 複雑な合成編集（照明変更、環境に合ったオブジェクト追加、指定領域のみ変更）を高精度で処理
- Flagship版（最高品質）: PowerPointに既に展開、OneDriveにもロールアウト中、Azure AI Foundryで即時利用可能
- Flash版: 高スループット・低コスト向け、品質トレードオフ最小限
- MAI Playground（スマートフォンからも利用可能）で体験可

### Voice 2
- 自然さを最重視、プロソディ（リズム・強弱・イントネーション）を深く学習
- **感情の細粒度制御**が目玉: warm（暖かさ）、urgent（緊迫感）、conversational（会話的）、joyful（喜び）など
- 15言語で提供中（さらに追加予定）
- **デモハプニング**: 「joyful」感情のサンプル音声を再生しようとしたところ、会場の音響システムに問題が発生し最初は音が出なかった。登壇者が状況を認め再試行して音声デモを実施。会場からは拍手。サンプルは "I just got the best news ever. I cannot stop smiling..." という台詞で喜びの感情を表現
- **ボイスクローニング**: 数秒分の音声サンプルから話者の声を高忠実度で複製
- Flash版: 150ms以下のレイテンシ、音声エージェント向け

### Transcribe 1.5
- 43言語でWord Error Rateの精度がGemini・OpenAI競合モデルを上回る「世界最高精度」と主張
- ノイズ環境・アクセント・ドメイン固有用語・複数話者への対応
- Artificial Analysisのスピードベンチマークで競合比最大5倍高速
- Microsoft製品への統合: Copilot、Teams、GitHub、Dynamics 365
- Azure AI Foundryで即時利用可能

### Code 1 Flash
- アジェンティックコーディングタスクに特化して構築
- **SWE-bench Verified**: 71.6
- **SWE-bench Pro**: 51.2
- アクティブパラメータ5Bでこの性能を「驚異的（amazing）」と強調
- VS Code / GitHub Copilotにデフォルトモデルとして搭載中

---

## チャプター5: MAI Thinking 1 の詳細 アーキテクチャとデータ（9:13頃）

Microsoft初のフロンティア推論モデル「MAI Thinking 1」を深掘り。まず技術レポート（100ページ超）がwebサイトに公開されたことを告知。

### アーキテクチャ
- **手法**: Mixture of Experts (MoE)
- **アクティブパラメータ**: 35B
- **総パラメータ**: 約1兆（~1T）
- **コンテキストウィンドウ**: 256K トークン
- クラス比較で「体重以上のパフォーマンス（punches well above its weight class）」
- スクラッチからのhill climb、蒸留なし、教師モデルなし

### 3つの設計原則
1. 能力は学習するもの、継承するものではない (Capabilities should be learned, not inherited)
2. シンプルさは持続可能 (Simplicity is sustainable)
3. ショートカットよりも科学的厳密さ (Scientific rigor over shortcuts)

### データ戦略
**使用しなかったもの:**
- オープンソースの学習データセット
- 合成データ
- Web上のAI生成コンテンツ（積極的にハンティングして除外。「毎月難しくなっている」と表現）
- ベンチマークはデコンタミネーション済み（数値の信頼性を強調）

**実際に使用したもの:**
- **事前学習（Pre-training）**: 30兆トークン — ウェブ、コード、書籍、論文、多言語テキスト、ドメイン固有素材をすべて社内でソーシング・処理
- **中間学習（Mid-training）**: 3.55兆トークンのキュレーション済みSTEM・数学・コーディングデータ。「答えが検証可能なもの、動くか動かないかが明確なコード」に絞り込み
  - この段階でコンテキストを256Kに拡張し、RLクライムの準備を整える

---

## チャプター6: MAI Thinking 1 の詳細 強化学習システム（11:22頃）

「ここが一番面白い（the part I find the most interesting mechanically）」と登壇者が強調するRLクライムの仕組みを解説。

### 基本アルゴリズム: GRPO
- **GRPO（Group Relative Policy Optimization）**: 1つの問題に対して複数のロールアウト（解答候補）を生成し、検証可能なグラウンドトゥルースに対してスコアリングし、より良い解を強化する
- 数学・コードの報酬は**バイナリ**: 正解か不正解か

### 問題: 大規模モデルで数千ステップのRLはそのままでは機能しない
- このサイズのモデルでRLを数千ステップ安定して走らせるために、**5つの独自技術**を開発・組み合わせた（詳細は技術レポートに記載）
- これらの技術の組み合わせにより、**AIME（米国数学招待試験）スコアがほぼ0%から97%まで、安定した対数線形のラインで上昇**するという結果を達成

### 3つのスペシャリストモデルのマージ
RLクライムを3領域それぞれで実施し、最終的に1つのモデルにマージ:
1. STEM・コーディング特化モデル
2. エージェンティック特化モデル
3. ヘルプフルネス＆セーフティ特化モデル

1つのモデルで3分野の専門性を獲得。

---

## チャプター7: MAI Thinking 1 の安全性設計（12:28頃）

安全性を「後付けのフィルター」ではなく訓練プロセスの中核に組み込んだ設計を説明。

- **専用のRLクライム**: セーフティも独立したRL最適化を持つ。人間のプリファレンスデータで訓練した報酬モデルを使用
- **設計の保証**: 安全性とヘルプフルネスをトレードオフ関係にできない設計（You cannot trade safety for helpfulness. It is baked into the math with this design.）
- **レッドチーミング**: 15ラウンド（学習の初期・中期・後期にまたがる）
  - 実施主体: Microsoft AI Red Teaming チーム + 独立した外部ベンダー
  - 2100以上の敵対的シナリオ

### セーフティ vs. ヘルプフルネスの評価
スキャタープロットで**Claude Sonnet 4.6と比較し、8カテゴリ中5カテゴリでMAI Thinking 1が右上（より安全かつより役立つ）に位置**することを示した（スライドは会場からは少し見えにくいと登壇者自身が認めた）。

---

## チャプター8: MAI Thinking 1 のベンチマーク結果（13:16頃）

各種ベンチマークでの結果まとめ。

| ベンチマーク | スコア | 備考 |
|---|---|---|
| **AIME 2025** | **97%** | 数学オリンピックレベルの問題、学習カットオフ後にリリースされた新問題 |
| **AIME 2026** | **94.5%** | 同上（ブランドニューの問題） |
| **LiveCodeBench** | **87.7** | 継続的に新問題追加でコンタミネーション防止 |
| **SWE-bench Pro** | **52.8** | 実際のGitHub issueと実コードベース。Claude Opus 4（推測）と競合 |
| **GPQA Diamond** | **84.2** | 大学院レベルの生物・化学・物理（検索ツール不使用） |

- 35Bアクティブパラメータという規模ながら、より大型のモデルと完全に競合
- 「能力は学習によって習得したからこそ、モデルサイズに依存しない」と強調

---

## チャプター9: Microsoft Frontier Tuning（14:19頃）

朝の基調講演でも紹介された「Microsoft Frontier Tuning」の詳細を解説。ユーザー・組織が自社のhill climbing machineを構築する仕組み。

### コンセプト
「多くのAI製品は汎用モデルを貸し出し、それがうまく動くことを祈るだけ。それでは不十分」というメッセージのもと、各開発者・組織が自社のモデルを作れる仕組みを提供。

### 4つの特長
1. **Private（プライベート）**: データは一切移動しない。テナント内で完結
2. **Cost-efficient（コスト効率）**: 不要なトークンにコストをかけない
3. **Smarter on your context（コンテキスト特化）**: 自社の実際のコンテキストで賢くなる
4. **You control the model（モデルコントロール）**: 特定の大型モデルへのロックインなし、他社のロードマップに依存しない

### Frontier Tuningのプロセス
1. **タスク定義**: 何をするモデルを作るか、自社ビジネスにとっての「良い結果」を定義
2. **データ投入**: M365コンテキスト、Azure Fabricコンテキスト、ワークフロー、ドメイン知識
3. **学習実行**: セキュアなテナント内でトレーニングを実施
4. **デプロイ**: Azure AI Foundry または Copilot 経由でデプロイ
5. **継続改善**: 実際の利用データが次のトレーニングサイクルにフィードバック。モデルが使うほど賢くなる

「これが本当の意味のhill climbing マシン。汎用ベンチマークではなく、自社の目標に対して時間とともに改善していく（It compounds over time against your objectives, not some generic benchmark）」

### 実世界事例: Land O Lakes（乳製品メーカー）
- **課題**: テイスティングパネル（試食評価会）の議論から製品品質レポートを生成したい
- **アプローチ**: MAI Thinking 1 Flash を Frontier Tuning でタスク特化
- **結果**:
  - **品質スコア 89.3%** — すべてのフロンティアモデル（汎用モデル）を上回る
  - **10倍のコスト効率** — フロンティアモデルと比較して10分の1のコスト
- 「これは小さなモデルがおもちゃのタスクで大きなモデルを負かしたのではない。チューニングされたモデルが実際のビジネスワークフローで最高の汎用モデルをはるかに低コストで上回った事例」

---

## チャプター10: 提供状況・クロージング（16:48頃）

各モデルの現在の提供状況と次のアクションを案内。

### 今すぐ利用可能（GA / Public Preview）
| モデル | アクセス先 |
|---|---|
| **Image 2.5** | Azure AI Foundry、MAI Playground |
| **Image 2.5 Flash** | Azure AI Foundry、MAI Playground |
| **Voice 2** | Azure AI Foundry、MAI Playground |
| **Transcribe 1.5** | Azure AI Foundry、MAI Playground |
| **Code 1 Flash** | VS Code（GitHub Copilot）、Azure AI Foundry |

### 近日展開（Private Preview）
| モデル | 提供状況 | アクセス先 |
|---|---|---|
| **MAI Thinking 1** | Private Preview（一部顧客のみ） | Azure AI Foundryウェブサイトでサインアップ待機 |

### サードパーティプラットフォーム対応
- Baseten、OpenRouter、Fireworks でもすべてのモデルが利用予定

### 情報リソース
- Azure AI Foundry ウェブサイト
- microsoft.ai — モデルカード、APIドキュメント、価格情報
- MAI Playground はスマートフォンからも利用可能

---

## まとめ

Dave Citronは「We are just getting started as a lab and we have much more to come」と締めくくり、Microsoft AIラボが本格稼働フェーズに入ったことを強調した。

### 発表新機能・モデル一覧（GA/Public Preview/Private Preview）

| 機能・モデル | ステータス | ポイント |
|---|---|---|
| **MAI Image 2.5** | GA（Foundry）、PowerPoint/OneDrive展開中 | 画像編集リーダーボード2位、プロ品質 |
| **MAI Image 2.5 Flash** | GA（Foundry） | 同品質を3分の1のコストで提供 |
| **MAI Voice 2** | GA（Foundry/Playground） | 15言語、感情制御、ボイスクローニング |
| **MAI Voice 2 Flash** | GA（Foundry） | 150ms以下、音声エージェント向け |
| **MAI Transcribe 1.5** | GA（Foundry）、Teams/Copilot/Dynamics 365統合 | 43言語SOTA、競合比5倍高速 |
| **MAI Code 1 Flash** | GA（VS Code/GitHub Copilot） | 5Bアクティブパラメータ、SWE-bench Pro 51.2 |
| **MAI Thinking 1** | Private Preview（Foundry） | MoE 35B/1T、AIME 2025 97%、RL from scratch |
| **Microsoft Frontier Tuning** | 発表（展開時期詳細は別途） | 自社データでのhill climbing、プライベートテナント内学習 |

### エンジニア向け次のアクション
1. MAI Playground（microsoft.ai）で Image 2.5 / Voice 2 / Transcribe 1.5 を今すぐ体験
2. VS Code / GitHub Copilot で Code 1 Flash を試す（既にデフォルト設定済み）
3. MAI Thinking 1 Private Preview への参加: Azure AI Foundryウェブサイトでサインアップ
4. 技術レポート（100ページ超）を参照: MAI Thinking 1のアーキテクチャ、学習レシピ、5つのRL改善技術の詳細が公開
5. Microsoft Frontier Tuning を活用した自社特化モデル構築の検討（Land O Lakes事例: 89.3%品質・10倍コスト効率）
6. Baseten / OpenRouter / Fireworks 経由でのアクセスも近日対応予定
