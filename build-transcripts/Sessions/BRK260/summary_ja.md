# Microsoft Build 2026 BRK260「Build Apps w/ Local AI for Unmetered Intelligence on every Windows PC」詳細まとめ

**登壇者**: Anastasiya Tarnouskaya（Product Manager, Microsoft / Windows ML 担当）、Aditi Narvekar（Product Manager, Microsoft / AI APIs 担当）。ゲスト登壇者: Alfred（Microsoft ClipChamp）、Jordi Janer（Head of Research and Innovation, VoiceMod）、Flex（Content Creator / VoiceMod Ambassador）
**セッションURL**: https://build.microsoft.com/en-US/sessions/BRK260
**取得元**: 公式WebVTTトランスクリプト（medius.microsoft.com CAPTION）

---

## 全体像

本セッションは約42分のBreakout（レベル300）。テーマは「Foundry on Windows」を使って、クラウドのセットアップ・トークンコスト・ネットワーク接続なしに、10億台超のWindowsデバイス上でローカルAIアプリを構築する方法である。前日の基調講演でSatya Nadellaが語った「Unmetered Intelligence（従量課金されない知能）」——AIワークロードを常にクラウドで動かすのではなく、日常のPCのハードウェア（GPU/NPU/CPU）でローカル実行し、本当にクラウドが必要かつコストに見合う場合のみクラウドに行く——というコンセプトを開発者向けに具体化する内容となっている。

セッション全体を貫くストーリーは「Unmetered Token Café（従量課金トークン不要カフェ）」という架空のコーヒーショップで、クラウドAI費用を払う予算がなく、不安定な店舗ネットワークに依存したくない小規模事業者が、手持ちのPCだけで業務（注文受付、在庫管理、メニュー評価、マーケティング動画など）をローカルAIで回していく、という設定。各業務をFoundry on Windowsの3階層スタックで段階的に実装していく。

スタックは3つの層で構成される: (1) **Windows AI APIs**（Windows同梱モデルで動くターンキーAPI、最も簡単な入口）、(2) **Foundry Local**（一般的なオープンソースモデルをローカル実行、本セッションでGA）、(3) **Windows ML**（自前のカスタムモデルを実行する基盤レイヤーで、スタック全体のクロスシリコン能力を支える）。AMD・Intel・Nvidia・Qualcommのシリコンパートナーと連携している。

主な発表は、(1) 多くのAI APIをCPU/GPUにも拡張、(2) Phi SilicaのGPU実行、(3) Phi Silicaの後継「Aion」のプレビュー、(4) Foundry LocalのGA、(5) Qwen 3.5系など新モデルのFoundry Localカタログ追加、(6) Windows ML CLI（モデル最適化ツール）のプレビュー公開、(7) Windows ML 2.0出荷、(8) WebNNプレビューによるWebアプリでのローカルアクセラレーション、である。5台の異なるデバイスで多数のライブデモが実施された。

---

## チャプター1: イントロダクションと「Unmetered Intelligence」（0:00頃）

Anastasiya TarnouskayaとAditi Narvekarが自己紹介とセッションの主旨を説明。

- **登壇者**:
  - Anastasiya Tarnouskaya — Product Manager, Microsoft（Windows ML 担当）
  - Aditi Narvekar — Product Manager, Microsoft（AI APIs 担当）
- 本セッションのテーマ: 10億台超のWindowsデバイス向けに、クラウドセットアップ・トークンコスト・ネットワークなしで動くローカルAIアプリを構築する方法。スタックはすでにGA（一般提供）済みで本番ワークロード対応
- シリコンパートナー: **AMD、Intel、Nvidia、Qualcomm**
- 5台のデバイスにまたがる多数のライブデモと複数の発表を予告
- 前日基調講演（Satya登壇）の「Unmetered Intelligence」を引用。AIワークロードを常にクラウドで動かすのではなく、PCのハードウェアでローカル実行し、本当に必要な時だけクラウドに行く考え方
- デバイスごとのハードウェア活用方針:
  - **GPU**: 最大パフォーマンス、計算集約型ワークロード向け
  - **NPU**（Copilot+ PC）: 最大電力効率、常時稼働（always-on）体験向け
  - **CPU**: 最大リーチ（広範なデバイス）、軽量ワークロード向け

---

## チャプター2: なぜローカルAIか / Foundry on Windows のスタック（1:30頃）

実際の開発者・企業（Adobe、WhatsApp など）がローカルAI体験を構築している事例に触れ、ローカルAIを選ぶ理由とスタック構成を説明。

### ローカルAIの4つの利点
1. **プライバシー・セキュリティ向上**: 顧客や機密の企業データがデバイスから出ない
2. **低レイテンシ**: クラウドへの往復がない。リアルタイムワークロードで特に重要
3. **オフライン動作**: ネットワーク接続なしでAI体験が可能（計算がすべてデバイス上）
4. **コスト削減**: すべてのワークロードがクラウドスケールを必要とするわけではない

- Microsoft自身の体験も同じスタックで構築（**Outlook Summarize**、**GitHub Copilot** など）

### Foundry on Windows の3階層スタック
| 層 | 内容 | 主な用途 |
|---|---|---|
| **Windows AI APIs** | Windows同梱（inbox）モデルで動くターンキーAPI | 自然言語、ビジョンなど共通タスク。最も簡単な入口 |
| **Foundry Local** | 一般的なオープンソースモデルをローカル実行。全Windowsデバイス向けに事前最適化済み | 既存OSSモデルを使いたい開発者向け |
| **Windows ML** | 自前/Hugging Face由来のカスタムモデルを実行する基盤レイヤー | カスタムモデル。スタック全体のクロスシリコン能力の土台 |

### デモシナリオ「Unmetered Token Café」
- 開業したばかりのカフェ。オーナーがあらゆる役割を兼任（注文受付〜実験的ブリュー（Experimental Brews）プログラム運営まで）
- クラウドAI費用の予算なし、不安定な店舗ネットワークに依存したくない、手持ちのPCだけで業務を回したい
- セッション全体を通じて各業務をFoundry on WindowsでローカルAI化していく

---

## チャプター3: Windows AI APIs — Speech Recognition デモ（6:30頃）

カフェの注文受付（ドライブスルー）を題材に、新しいスピーチ認識APIをデモ。

- **デバイス**: Microsoft Surface（Qualcomm Snapdragon NPU）
- **サンプルアプリ**: ドライブスルーアプリ。顧客が「Press to Talk」ボタンを押し、マイクに注文を話す
- **新しいSpeech Recognition API**: 話された注文を文字列（テキスト）に変換
  - デモでは「ソイミルク・エクストラホットのmatcha latte、サイドにクロワッサン」という注文をテキスト化して出力
  - 入力はマイクだけでなく、音声ファイル・音声ストリームも可能（通話やミーティングのシナリオに対応）
- このAPIは**Copilot+ PC（NPU）で最高に動くが、CPUでも動作**する

### 発表: AI APIs を CPU / GPU に拡張
- 当初AI APIsはNPU向けにリリースしたが、「より広いハードウェアスペクトラムに対応してほしい」という顧客フィードバックを多数受領
- **本日、多くのAI APIをCPUとGPUでも動くよう拡張**することを発表。より広いデバイス・顧客にリーチ可能に

---

## チャプター4: Phi Silica on GPU — 注文の構造化（8:30頃）

スピーチ認識で取り込んだ非構造テキストを、Phi Silicaで構造化（JSON）するデモ。

- **デモ**: 小型言語モデル **Phi Silica** を新たに **GPU** で実行
- バリスタ向けの注文管理アプリ。バリスタが注文を選ぶと、バックエンドでGPU上のPhi Silicaが関連情報を抽出し**JSONとして構造化出力**（Phi Silica出力を構造化する新API使用）
  - タスクマネージャー上でGPUに処理のスパイクが見える＝ローカルGPUで実行
  - 出力JSONにはドリンク・サイズ・モディファイア・数量などが含まれる
- **AI APIs の呼び出しパターン**（数行のコード、全API共通）:
  1. get ready state でモデルがデバイス上で準備済みか確認
  2. 未準備なら ensure ready async（インストール実行）
  3. create async でモデル初期化
  4. レスポンス生成（構造化なら generate structured JSON response、JSONスキーマ定義も可能）
- 本番事例: **Outlookの Summarize 機能**が Phi（GPU）を使用

### 提供中の AI APIs 一覧（スライド）
| カテゴリ | API例 |
|---|---|
| **Task-specific APIs**（多くがGA） | image description、conversation summary、text summary、text to table |
| **Customization APIs** | LoRAアダプタによる言語モデルのファインチューニング、アプリコンテンツ検索（RAG）、言語モデル出力の構造化 |
| **Media APIs** | video super resolution、speech recognition |
| **Imaging APIs** | 拡大中のイメージング系API群（アクセシビリティ、生産性、企業ワークフロー等に適用可能） |

- これらの多くを**今回GPU/CPUに拡張**

---

## チャプター5: ゲストデモ ClipChamp — Video Super Resolution（11:56頃）

ISV事例として、Microsoft ClipChampのAlfredがVideo Super Resolution（VSR）をデモ。

- **登壇者**: Alfred（Microsoft ClipChamp / Windows内蔵の無料動画エディタ）
- **デバイス**: Asus（AMD NPU）
- **課題**: 携帯・古い動画・画面録画など解像度の異なるクリップを使うと、最終書き出し解像度に合わずソフト／ぼやけて見える
- **VSR（Video Super Resolution）**: AIで動画をアップスケールし、単純なリサイズでは出せないディテールを付加。ローカルモデルとしてClipChampに組み込み、エディタを離れずに実行可能
- **フロー**: 動画選択 → 「Upscale」パネルを開く → 解像度選択 → 「Upscale」クリック
- **コード統合**: モデル準備確認 → video scaler インスタンス生成 → 各フレームをデコーダフレーム＋出力サーフェスとともに scale に渡してアップスケール → エンコーダで動画に戻す
- 比較動画では顔が右側でより鮮明に
- **VSRはCPUとNPUの両方で動作**（NPUでさらに体験向上）。より多くのWindowsデバイスで利用可能
- カフェはVSRをマーケティング動画作成に活用予定

---

## チャプター6: Aion（Phi Silica の後継）プレビュー（14:31頃）

基調講演でSatyaが触れた「Aion」を紹介。

- **Aion**: **Phi Silica の後継**となるモデル。**AI APIs 経由で提供予定**（自動字幕のためモデル名表記は不確実だが、トランスクリプト上は "Aion"）
- 提供までの間、指定リンクから試用可能。本セッションでもスニークプレビュー
- **Edge ブラウザの Prompt API** が今は Aion で動いている。Edge Canary でいくつかのフラグをオンにすると Prompt API を試せる
  - デモ: システムプロンプト＋プロンプトを入力し「Run」でその場でレスポンス生成
- Aionでの改善点: **モデル品質の向上、コンテキストウィンドウの拡大、トークン毎秒（速度）の高速化**。AI APIsの言語モデル体験をレベルアップ
- AionもinboxモデルなのでディストリビューションはWindowsが全部やってくれる（アプリ側の配布不要）

---

## チャプター7: Foundry Local（GA）— 在庫管理デモ（16:05頃）

一般的なオープンソースモデルをローカル実行する Foundry Local を紹介し、在庫管理アプリをデモ。

- **Foundry Local**: Azure上のMicrosoft Foundryに対応するローカル版。OSSモデルをCPU/GPU/NPUで実行可能
- **発表: Foundry Local が GA（一般提供）に**
- **デモ（在庫管理アプリ）**: ドロップオフされた商品の画像をアップロード → 「Identify Items」 → バックエンドで **Qwen 3.5 vision language model**（Foundry Localカタログに新登場）が画像内のすべてを分類・記述し、在庫ログ化を容易に
- **Foundry Local のコード手順**:
  1. get model（Qwen 3.5 の 9B パラメータ版を指定）
  2. model.download（デバイスへダウンロード）
  3. model.load（メモリへロード）
  4. create responses client
  5. レスポンス生成（create streaming に入力画像とプロンプト「You are a helpful coffee shop inventory assistant」を渡す）
- GitHubリポジトリに多数のサンプルあり（おすすめの入口）

### Foundry Local の構成（スライド）
- **左**: 豊富なモデルカタログ — オープンソースGPTモデル、DeepSeek、Mistral、Qwen、Phi、音声用のWhisper など。**新規追加**: Qwenの新バリアント（前述のVLMなど）、新しい音声モデル
- **中央**: Foundry Local SDK — モデル管理とデバイス別ハードウェアアクセラレーション（CPU/GPU/NPU）の複雑さを抽象化。デバイス固有コード不要
- **右**: Foundry Local CLI — モデルを試してシナリオに最適なものを選べる

---

## チャプター8: Windows ML — カスタムモデルと Windows ML CLI（19:30頃）

自前のカスタムモデルを実行する Windows ML を紹介し、実験的ブリューのレビュー感情分析（センチメント分析）を題材にモデル最適化をデモ。

- **Windows ML**: 自前で学習した／Hugging Faceで見つけたカスタムモデルを直接実行する層
- **対応範囲（広範）**: Windows 10 1809 以降、Windows Server 2019 以降、さらに **Windows 365**（クラウドベースWindows環境。別PC・Mac・モバイル・ブラウザからWindows ML開発環境にアクセス可能）
- **シナリオ**: Experimental Brews プログラムの新メニューに対する顧客レビューの感情分類。カスタムOSSモデルを使うため Windows ML が最適

### 発表: Windows ML CLI（プレビュー）
- **Windows ML CLI** を GitHub でプレビュー公開（**aka.ms/winmlcli**）。モデル最適化のあらゆるニーズに対応
- 提供価値:
  1. **ワンストップのツールチェーン＋エージェントスキル**: 変換（conversion）・最適化（optimization）・ベンチマーク（benchmarking）を1つのフローで
  2. **最大の柔軟性**: プリミティブコマンドで各ステージを手動制御することも、プリビルトconfigで一括エンドツーエンド実行することも可能
  3. **AIワークフロー／エージェント統合**: エージェントスキルを備え、GitHub Copilot等のツールに組み込み可能
- UIで始めたい開発者向けには **VS Code の Foundry Toolkit 拡張**

### Windows ML CLI デモ（感情分析モデルの最適化）
- **デバイス**: Surface Laptop for Business（第7世代、Intel プロセッサ）。出力はポータブルモデルで全デバイスで実行可能
- 使用モデル: リストから「Cardiff NLP for Sentiment」を選択
- 実行コマンドの流れ:
  | コマンド | 役割 |
  |---|---|
  | WinML（引数なし） | 利用可能なコマンド一覧表示 |
  | WinML Catalog | 最適化可能なモデル一覧（Hugging Faceの他モデルや自前ONNXモデルも可） |
  | Inspect | モデルが最適化に適さない一般的な理由を事前に除外 |
  | Export | モデルを ONNX 形式に変換 |
  | Analyze | モデルグラフをオペレータ単位で読み、ターゲットHWでの対応状況を表示（緑=完全対応、黄=部分対応でCPUフォールバックの可能性、赤=非対応） |
  | Optimize | configを取り込みグラフ書き換え・オペレータ融合・未対応オペレータの解消 |
  | Analyze（再実行） | 全オペレータが緑になったことを確認 |
  | Perf | スループット等の指標でベンチマーク。NPU使用率のライブグラフ表示 |
- 各コマンドを個別実行したが、プリビルトconfigで一括実行、または GitHub Copilot＋エージェントに最適化フローを任せることも可能

---

## チャプター9: Windows ML の価値（運用面）（28:00頃）

最適化後のモデルをどう動かすか、Windows ML が運用面でもたらす利点を整理。

1. **スケール（Scale）**: 抽象化レイヤーとして、ハードウェアの詳細や複数SDKに深入りせずにチップセット・ベンダー横断でモデルをスケール。ONNX Runtime統合により、何をどこで動かすかの柔軟性が高い
2. **パフォーマンス（Performance）**: シリコンパートナーと連携し、最新の性能改善・新モデル／新デバイス対応を、ハードウェアベンダー所有の Execution Provider 経由でスタックに反映。1つの統一スタックで「ネイティブ同等」の恩恵
3. **デプロイメント（Deployment）**: ランタイム依存関係をシステム全体のコピーとして提供し、デバイスに応じて正しいビットを取得するAPIを用意。依存関係をアプリに同梱不要 → アプリサイズ削減、更新ごとの再コンパイル不要。ベンダー認証プログラムにより、提供ビットは更新ごとにWindows固有の厳格テストを通過（安定性最適化・Windowsメンテナンス・スムーズな更新）
4. **統一ツールチェーン＋エージェントスキル**: Windows ML CLI、VS Code の Foundry Toolkit 拡張など

---

## チャプター10: WebNN — Webアプリでのローカルアクセラレーション（29:50頃）

ダウンロード不要・クラウド不要でWebサイトからAIを使えるよう、WebNN を紹介・デモ。

- **WebNN**: Windows ML はネイティブWindowsアプリだけでなく、**Webアプリでもサポート**。WebNN はネイティブML API（Windows上のWindows MLなど）の上に乗る層で、フレームワークAPI経由でGPU/NPU/CPUへの「ネイティブ近似」アクセスを提供
  - 任意の **Chromium ベースブラウザ（Edge、Chrome）** で、いくつかの実験的フラグによりプレビュー利用可能
  - Webサイトでもネイティブなハードウェアアクセラレーションの恩恵を受けつつ、トークンコストや機密データのクラウド送信を回避

### WebNN デモ（感情分析をブラウザで）
- **デバイス**: Surface Laptop for Business（第7世代、Intel）。今回はモデルの推論（inference）を実行
- VS Codeの sentimentanalyzer.js:
  - **ONNX Runtime Web API**（ブラウザでONNXモデルを動かすフレームワークAPI）を使用 → 内部でWebNN → Windows MLでネイティブHWアクセラレーション
  - 先にWindows ML CLIで最適化したモデルを渡す
  - **WebNN の create context API** でセッション構築。デバイスタイプを指定（初期はNPU、デモでは全デバイス対応のため CPU に変更）
  - 残りはトークン化・テンソル化・推論実行・出力を positive/neutral/negative に分類
- **実行結果（CPU）**: "Decaf Eclipse"（ノンカフェインエスプレッソ）のレビューを分類。レイテンシ約 **300ミリ秒**、毎秒約 **3.5件**。結果はニュートラル多め＋賛否ほぼ拮抗で芳しくない
- **実行結果（NPU）**: "Aurora Latte"（ラベンダーハニーのグラデーション飲料）を分類。レイテンシ **30ミリ秒**、毎秒 **11件超**（CPUの3倍超のレート）。ポジティブ多数・ネガティブ僅少で好評

---

## チャプター11: ゲストデモ VoiceMod — 超低遅延のローカル音声変換（34:28頃）

本番事例として、VoiceModがWindows MLによる超低遅延のローカルAI音声変換をデモ。

- **本番実績**: Windows ML は昨秋（last fall）にGA。すでに数十のパートナーが本番体験を出荷（**Adobe、Canva、Affinity、Speechify** など）
- **登壇者**: Jordi Janer（Head of Research and Innovation, VoiceMod）、Flex（Content Creator / VoiceMod Ambassador）
- **デバイス**: Asus Zenbook A16（Qualcomm Snapdragon NPU）
- **VoiceMod**: Windowsファーストのプラットフォーム。ボイスフィルター・サウンドボード・作成ツールで声をリアルタイム変換。ゲーマー／ストリーマーが声をカスタマイズ
- **技術**: デジタル信号処理（DSP）エフェクト＋最先端の生成AIスピーチ・トゥ・スピーチモデルを組み合わせた音声生成パイプライン。**45ミリ秒未満の超低遅延**で動作し、音声インタラクションが即時かつ自然
- **Windows ML がもたらした3つの価値**:
  1. 高品質モデルをローカル実行（クラウド依存なし）
  2. Execution Providerの抽象化でアプリサイズ削減
  3. 「一度作れば各シリコンパートナー（Qualcomm、Nvidia、AMD、Intel）へ展開」でき、**4倍高速**に提供
- **ライブデモ**: Fortnite スキン（Ice King など）に対し、リアルタイムで複数の声色を切り替えて適用

---

## チャプター12: Windows ML 2026 の新機能まとめ（38:30頃）

2026年のWindows MLアップデートを総括。

- **Windows ML CLI**: GitHubでプレビュー公開（モデルの最適化・準備）
- **Gen AI ワークロードの高速化**: モデルにより最大 **2.6倍**のスループット向上
- **デフォルトCPU Execution Provider**: 最新プレビュー版で性能向上
- **Windows ML 2.0 出荷**: ONNX Runtime改善、新しいハードウェアベンダー製プラグイン Execution Provider 対応 → 新モデル対応・基盤改善・リリース間の互換性向上
- **WebNN**: プレビュー公開。Chromiumベースブラウザで実験的フラグによりWebアプリにHWアクセラレーションを導入
- **新デバイス対応**（シリコンエコシステムからの革新を全Windows MLアプリが享受）:
  - AMD **Ryzen AI 400 シリーズ**
  - Intel **Core Ultra Series 3**
  - Nvidia **RTX Spark** および **DGX Station**（upcoming）
  - Qualcomm **Snapdragon X2 Elite**
- その他、基盤・性能・ツーリング面の多数の改善

---

## チャプター13: まとめとリソース（40:46頃）

Aditiがセッション全体を総括。

- 「Unmetered Token Café」のストーリーを通じて示したこと:
  - **AI APIs** で簡単にAI体験を構築でき、その多くを**CPU/GPUに拡張**した
  - **Foundry Local**（**今回GA**）で一般的なOSSモデルをローカル実行できる
  - **Windows ML** で自前モデルを持ち込み、**1つのCLIツール**で複雑な最適化ができる
- 行動喚起: スマホでリソースリンクとQRコード（フィードバック用）を撮影。関連セッションも案内。登壇者2名はロビーで質問対応

---

## まとめ

本セッションのコアメッセージは、**「Foundry on Windows」を使えば、10億台超のWindows PCのGPU/NPU/CPU上で、クラウドのトークンコスト・ネットワーク・データ流出なしに本番品質のローカルAIアプリを構築できる**という点である。3階層（AI APIs / Foundry Local / Windows ML）を、難易度とカスタマイズ性に応じて選べることが要点。

### 発表機能・API・SDK 一覧

| 機能・API・SDK | ステータス | ポイント |
|---|---|---|
| **AI APIs の CPU / GPU 拡張** | 発表（多くがGAまたは拡張展開） | NPU専用だった多くのAPIをCPU/GPUにも拡張、対応デバイス拡大 |
| **Speech Recognition API** | 新規 | マイク／音声ファイル／音声ストリームをテキスト化。NPU最適だがCPUでも動作 |
| **Phi Silica on GPU** | 提供中（本番でOutlook Summarizeが使用） | 小型言語モデルをGPU実行、JSON構造化出力の新API |
| **Aion** | プレビュー（リンクから試用、Edge Prompt API） | Phi Silica の後継。品質・コンテキスト・速度向上。AI APIs経由で提供予定（モデル名は自動字幕のため不確実） |
| **Foundry Local** | **GA** | OSSモデルをCPU/GPU/NPUでローカル実行。SDK＋CLI |
| **Qwen 3.5 VLM / 新音声モデル** | Foundry Localカタログに新規追加 | 9Bパラメータ版VLMなど。Whisper等も提供 |
| **Windows ML CLI** | プレビュー（aka.ms/winmlcli, GitHub） | 変換・最適化・ベンチマークを1フロー。エージェントスキル対応 |
| **Windows ML 2.0** | 出荷 | ONNX Runtime改善、新Execution Provider対応 |
| **WebNN（ONNX Runtime Web）** | プレビュー（Chromiumブラウザ＋実験フラグ） | Webアプリにネイティブ近似のHWアクセラレーション |
| **Foundry Toolkit 拡張（VS Code）** | 提供 | UIでモデル準備・最適化を開始 |

### 発表された性能・指標（トランスクリプト記載）
- 感情分析（WebNN）: CPU 約300ms・3.5件/秒 → NPU 30ms・11件超/秒（NPUで3倍超）
- VoiceMod: 45ミリ秒未満の超低遅延、Windows MLで4倍高速に展開
- Gen AI ワークロード: Windows MLで最大2.6倍スループット向上

### エンジニア向け次のアクション
1. **Windows AI APIs** で着手（共通の呼び出しパターン: get ready state → ensure ready async → create async → 生成）。多くがGA、今はCPU/GPUでも動作
2. **Foundry Local（GA）** をGitHubサンプルから試す。Qwen 3.5 VLMなど新モデルをCPU/GPU/NPUで実行
3. **Windows ML CLI** をプレビュー取得（**aka.ms/winmlcli**）し、自前/Hugging Faceモデルを Inspect → Export(ONNX) → Analyze → Optimize → Perf で最適化。GitHub Copilotのエージェントに任せることも可能
4. **WebNN** を Edge/Chrome の実験フラグで試し、ONNX Runtime Web 経由でWebアプリにローカルアクセラレーションを導入（device typeでNPU/CPU切替）
5. **Aion** をリンク先・Edge Canary（Prompt API）で先行体験。提供後はAI APIs経由で利用
6. Video Super Resolution（VSR）など Media/Imaging API を自社ドメイン（生産性・アクセシビリティ・企業ワークフロー）に適用
