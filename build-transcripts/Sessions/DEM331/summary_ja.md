# Microsoft Build 2026 DEM331「Turn APIs, tools, and data into real agent velocity」詳細まとめ

**登壇者**: 特定できず（推測：Azure AI Platform / Content Understanding チームのエンジニア）
**セッションURL**: https://build.microsoft.com/en-US/sessions/DEM331
**取得元**: 公式WebVTTトランスクリプト（medius.microsoft.com CAPTION）

---
## 全体像

本セッションは Azure AI Foundry の **Content Understanding**（コンテンツ理解）サービスを中心としたライブデモセッションである。現実のエージェント開発では、クリーンな API や構造化データだけでなく、品質の低いスキャンPDF・長文メール・複雑な表を含むOffice文書・音声ファイル・動画ファイルといった「乱雑なマルチモーダルコンテンツ」を扱う必要がある。そのままLLMに投げると、エージェントが情報の構造を失い、品質・信頼性が低下し、LLMの利用コストが増大する。

Content Understanding は、こうしたマルチモーダルな入力を「単一パイプライン」でクリーンな構造化データに変換し、エージェントが即座に活用できる形（Markdown + JSON + YAML front matter）に整える。分類・ルーティング・カスタムフィールドの抽出・推論を一括して行い、Microsoft Agent Frameworkのコンテキストプロバイダーとしてシームレスに統合できる。

デモは4つの「Act」と最後の比較スライドで構成される。通信キャリア向けの「ケーブル障害インシデント対応自動化」シナリオを一貫したストーリーラインとして使用。一部ライブデモで拡張機能が動作しないトラブルも発生したが、登壇者が別手順で対応しデモを続行した。

---
## Chapter 1: 課題提起とContent Understandingの概要󿂀:01頃）

エージェントは「推論できるが、読むことができない」という根本的な問題がある。実世界のコンテンツには以下のような非構造化データが多数含まれる:

- 品質の低いスキャンPDF
- 長文メール・添付ファイル
- 複雑なテーブルや画像を含むOfficeドキュメント
- 音声・動画ファイル

こうした生データをLLMに直接投げると、エージェントはファイルごとにカスタムコードを書き直し、テーブル構造を失い、図表やバーコードを読み飛ばし、結果として品質・信頼性の低下とLLMコストの増大を招く。

### Content Understandingの役割

単一パイプラインで以下を実現する:

1. **解析（Parse）**: マルチモーダルコンテンツを処理
2. **分類（Classify）**: ドキュメントタイプを識別
3. **抽出（Extract）**: 必要なフィールドを取り出す
4. **グラウンディング（Grounding）**: 信頼スコアとガバナンスを付与

出力はwell-formatted Markdown / JSON（キーバリューペア）で、エージェントがすぐにアクションを取れる形式。

---
## Chapter 2: デモシナリオの設定󿂀:02頃）

デモシナリオは通信キャリア（推測）の以下の状況を模している:

- **朝6:47 AM**: 「Tower Ridgeコリドーでの信号劣化」アラートが発火
- **影響範囲**: 42名の顧客がリスクにさらされている
- **従来の対応**: オンコールエンジニアが9件の文書・メディアファイル・添付ファイルを手動で検索・調査・相関分析

デモの4つのAct:

1. **Act 1**: Content Understandingがアラートに紐づく各文書を構造化データに変換（レイアウト・テーブル・図表・バーコード・カスタムフィールド・分類・ルーティング）
2. **Act 2**: Foundry PortalとCU Studioを使ったNo-Code UIデモ（音声・動画の解析）
3. **Act 3**: 構造化されたデータをGPT-4.1に送り診断・材料計画・派遣メールを生成
4. **Act 4**: Microsoft Agent Frameworkとの統合

---
## Chapter 3: Act 1 -- Content Understanding SDKデモ・プリビルトアナライザー󿂀:03頃）

### クライアントの初期化

Azure Foundryリソースのエンドポイントとクレデンシャルを使ってContentUnderstandingClientを初期化し、Python SDKから数行でプリビルトアナライザーを呼び出せる。同一エンドポイントをAzure Foundryリソースと共有可能。

デモ冬頭でVS Code拡張機能が正常に動作しないハプニングが発生（「the extension did not work」と登壇者が言及）。スライドを使って手順を説明しながらデモを続行。

### prebuilt-document-searchの特長

サイトメンテナンスログ（埋め込みテーブル2件・QRコード・チェックボックス含むPDF）を分析した比較:

| 項目 | Content Understandingの出力 | ローカルPDFパーサーの出力 |
|---|---|---|
| テーブル構造 | 行・列構造を保持 | 完全に失われる（生バイト） |
| QRコード | デコード済み | 完全に読み飛ばす |
| 選択マーク | チェック済み・未チェックを識別 | 欠落 |
| エージェントへの影響 | 直接推論できる | 多くの推測を強いられる |

**実際の出力:**

- 2テーブル（行・列構造を保持）
- 1バーコード / QRコードをデコード
- 2チェック済み + 1未チェックの選択マーク

この構造化情報をLLMに渡すことで、エビデンスとして推論させる。

### to_llm_input()ヘルパー関数

Content Understandingの出力をLLMに渡すためのフォーマット関数。YAML front matterを付与したMarkdown形式に変換。最大 **85%のトークン削減**が可能（フルドキュメント送付かフィールドのみ送付かを選択可能）。

---
## Chapter 4: Act 2 -- Foundry PortalとCU StudioのノーコードUIデモ󿂀:06頃）

### Foundry Portalでのアクセス方法

1. Azure Foundryポータル -> **Deployments & AI Services**
2. 一番下に **Content Understanding Playground** が表示される
3. プリビルトアナライザーの一覧から選択（ドキュメント・インボイス等）

### インボイス解析の例

- 重要なフィールド・値を自動抽出
- JSON出力にoffset/length（テキストの位置情報）とbounding box（ページ上の座標）を含む
- 引用（citation）のトレースが可能

### 音声ファイルの解析デモ

フィールドクルーが光ファイバー切断現場を検査する際の会話を録音した音声ファイルを、**audioプリビルトアナライザー**に投入:

- タイムスタンプ付きのトランスクリプトを生成
- 例: 「Vault TV 3付辺のコンジット入口に接近中」「クラックと曲がったファイバー、保護スリーブが完全に外れている」
- LLMへの送付向けにサマリーを生成

Note: デモ中に無関係な音声（「checking accountに1000ドル送金したい」という銀行取引の会話）が混入するハプニングが発生。登壇者はれっきりすることなくデモを続行。

### CU Studioの紹介

- Content Understanding Playgroundから **CU Studio**ボタンでアクセス
- **Discoverタブ**: 税務・法律・ID確認・支払・住宅ローン等の業界別プリビルトモデル一覧
- **動画解析デモ**: 短い現場検査動画を解析 -> 「光ファイバー打ち込みが発生しており、修理クルーが作業する前に周辺の状況を整理する必要がある」というサマリーを生成

### 画像付きドキュメントの解析結果

6枚の埋め込み画像を含むドキュメントをdocument-searchアナライザーで解析:

- ドキュメント内のすべてのテキストをOCRし位置情報を保持
- ドキュメント画像内のテキストもOCR
- **各画像に対する説明文（description）を自動生成**し、エージェントの推論に活用
- LLMが「3cmの変位」を特定し、Vault TV 3付辺が根本原因であると結論付け

---
## Chapter 5: カスタムアナライザーとClassifier󿂀:10頃）

### カスタムアナライザーの定義

プリビルトアナライザーで対応できないビジネス固有のフィールドを抽出したい場合、カスタムアナライザーを定義できる。スキーマ定義でフィールド名・型・メソッド・自然言語の説明を指定する。

重要な点は、単純な抽出だけでなく、ドキュメントに直接記載がないフィールドも **推論・計算によって生成**可能なことである（例: 緊急度・予算判定・行動推奨）。Python SDKからカスタムアナライザーをデプロイ。

デモでは6種類のドキュメントタイプに対し、それぞれカスタムアナライザーを定義・デプロイ。処理に1分程度かかるため、プリプロセス済みの結果を表示しながらデモを進行。

### Classifier（分類器）

ドキュメントタイプが事前に不明な場合に対応:

- **分類カテゴリを定義**するだけで、未知のドキュメントを自動判定
- 判定結果に基づき、プリビルトまたはカスタムアナライザーへ**自動ルーティング**
- 単一呼び出しで「分類 -> ルーティング -> 抽出」を完結
- アプリケーションコードの分岐ロジックを最小化

**デモ結果:** 6種類のドキュメントがすべて正しく識別・ルーティングされ、それぞれのカスタムアナライザーで適切なフィールドが抽出された。

---
## Chapter 6: Act 3 -- エージェントによる根本原因分析・材料計画・ディスパッチ󿂀:14頃）

Content Understandingから得た構造化データを`to_llm_input()`u{3067}フォーマットし、GPT-4.1に送付。以下の4ステップで処理:

1. **情報集約**: 全てのContent Understanding出力を集約しLLMに送付
2. **根本原因診断（Root Cause Analysis）**: 障害の原因を特定
3. **材料計画（Material Plan）**: 修理に必要な資材・予算を計算
4. **ディスパッチ（Dispatch）**: 関係者へのアクションメールを生成

### 実際の出力結果

- **根本原因分析**: Vault TV 3の地下コンジットのメカニカル故障、マイクロベンドによる機械的破損と特定。場所・種類・度合いの詳細情報も実覇
- **エビデンスチェーン**: 収集した全ドキュメントのエビデンスを紐づけて最終判定
- **材料計画**: 予算上限を確認（承認済み）し、修理に必要な資材テーブルを生成
- **ディスパッチメール**: 生データから関係者情報を自動特定し、担当者が次のアクションを取るために必要な情報のみを送付

---
## Chapter 7: Act 4 -- Microsoft Agent Frameworkとの統合󿂀:15頃）

### Content Understanding Context Provider

Microsoft Agent Frameworkにおける **Context Provider** は、エージェントのラウンドループにフックするプリミティブ:

- LLMに届く前にメッセージを検知・処理
- 添付ファイルを自動検出・処理し、構造化出力を会話ループに返す
- **マルチターンキャッシュ**: 一度処理したContent Understandingの結果を同一セッション内でキャッシュし、重複呼び出しを回避

### 実装フロー

セットアップ時にContent Understanding Context Providerをエンドポイント・クレデンシャル・アナライザーIDで初期化し、Agent FrameworkのFoundry Chat Clientと組み合わせる。エージェント構築時にinstructionsとcontext_providerを指定するだけ。メッセージ送信時に9件のPDF添付を渡すと自動的にContent Understandingで処理される。

フォローアップ質問も同一セッション・同一Context Providerを使って追加のContent Understanding呼び出しなしに回答可能（キャッシュを活用）。

### SDKパイプライン vs Microsoft Agent Frameworkの比較

| 項目 | SDKパイプライン（Act 1-3） | Microsoft Agent Framework（Act 4） |
|---|---|---|
| 基盤サービス | Content Understanding | 同じContent Understanding |
| 添付処理 | 手動 | 自動分析 |
| フォーマットコード | 手動でto_llm_input()を呼び出し | 自動インクルード |
| マルチターン | 手動でキャッシュ管理 | 自動キャッシュ |
| 対応FW | 任意（LangChain等） | Agent Framework前提 |

**結果:** Agent Frameworkを使うと、Act 1-3で手動で組んだSDKパイプラインとほぼ同一の出力を、ほぼ1ステップで取得できる。

---
## Chapter 8: まとめ・ベストプラクティス・次のステップ󿂀:18頃）

### ライブデモからの主なテイクアウト

1. **プリビルトアナライザーから始める**: ドキュメントタイプが不明な場合、またはRAG / AI Search向けにリッチな情報をLLMに送りたい場合は`prebuilt-document-search`等のプリビルトを使う

2. **カスタムアナライザーを使うべきケース**: dispatch urgency・予算判定・緊急度レベルなど、ビジネス固有のフィールドを抽出・推論したい場合

3. **本番環境ではClassification + Routingを使う**: ドキュメントタイプが事前不明なペイロードが来る場合、単一呼び出しで「分類 -> ルーティング -> 抽出」を完結させる

4. **to_llm_input()ヘルパーの活用**: 最大 **85%のトークン削減**が可能

### 外部フレームワークとの統合

- **LangChain**: ダイレクト統合を提供
- **Markdown (ダイレクト)**: フレームワーク統合を提供
- Microsoft Agent Framework以外でもSDK + to_llm_input()で対応可能

### リソース・次のステップ

- **デモコード・チュートリアルノートブック**: GitHubで公開中（セッション中にQRコードを提示）
- **ブレイクアウトセッションBRK242**: 同日午後4:00 PMに開催
  - Content Understandingの今後のロードマップ
  - **Generative Mode**（推測：VTT上の「Genentech mode」を補正）: より複雑なドキュメントシナリオに対応
  - Azure AI FoundryのToolboxesとの連携

---

## まとめ

DEM331はAzure AI Foundryの **Content Understanding** サービスが、乱雑なマルチモーダルデータをエージェントが即座に活用できる構造化データに変換する能力を、実際の通信キャリア障害対応シナリオを通じて実演したデモセッションである。

### 発表された新機能・サービス

| 機能名 | ステータス | 概要 |
|---|---|---|
| **Content Understandingプリビルトアナライザー** (document-search, invoice, audio, video等) | GAまたはPublic Preview（推測・明示なし） | マルチモーダルコンテンツの構造化抽出 |
| **Content Understandingカスタムアナライザー** | GAまたはPublic Preview（推測・明示なし） | ビジネス固有フィールドの抽出・推論 |
| **Content Understanding Classifier** | GAまたはPublic Preview（推測・明示なし） | ドキュメント自動分類・ルーティング |
| **Content Understanding Context Provider** (Microsoft Agent Framework) | Public Preview（推測・明示なし） | Agent Frameworkへのシームレス統合・マルチターンキャッシュ |
| **to_llm_input()ヘルパー関数** | GAまたはPublic Preview（推測・明示なし） | 最大85%トークン削減フォーマッター |
| **CU Studio** | GAまたはPublic Preview（推測・明示なし） | Content UnderstandingのノーコードUI |
| **Generative Mode** (Content Understanding) | Private Previewまたは近日発表（推測） | より複雑なドキュメント処理（BRK242で詳細発表予定） |

Note: トランスクリプトからはGA/Previewの正確なステータスが特定できなかったため「推測」と明記。

### 次のアクション

1. GitHubのデモリポジトリを確認し、チュートリアルノートブックを実行
2. Azure FoundryポータルのContent Understanding Playgroundで試す
3. `prebuilt-document-search` -> カスタムアナライザー -> Classifierの順に段階的に導入
4. Microsoft Agent FrameworkのContent Understanding Context Providerを評価
5. BRK242の録画でGenerative Modeの詳細を確認
