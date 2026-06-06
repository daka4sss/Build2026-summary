# Microsoft Build 2026 OD839「AI solutions built to power industrial innovation and sovereign control」詳細まとめ

**登壇者**: Inbal Sagiv（Principal Product Manager, Microsoft — ローカルで動作する AI 担当）
**セッションURL**: https://build.microsoft.com/en-US/sessions/OD839
**取得元**: 公式WebVTTトランスクリプト（medius.microsoft.com CAPTION）

---

## 全体像

本セッションは、接続断・主権管理（ソブリン）要件が厳しい産業・公共向け環境において、Microsoft の AI をどのように展開するかを技術者向けに解説したものである。登壇者の Inbal Sagiv は「ローカルで動く AI」を専門とする PM であり、セッション全体を通じてクラウド依存のない完全ディスコネクト環境での AI 運用を中心テーマとしている。

発表の骨格は「インフラ（Azure Local）→ モデル（Foundry Local モデルカタログ）→ エージェント・ツール（Agentic RAG + MCP）→ デモ（PowerShell API / ローカルチャット / ビデオエージェント）」という順序で構成されており、Public Preview としての新機能が複数発表された。

本セッションが特に注目される点は、Foundry Local の multi-node 対応（vLLM）、Agentic RAG のローカル完結、および Microsoft 365 Local（SharePoint・Exchange Server オンプレ）との連携 POC の公開である。すべての機能は Arc-enabled Kubernetes 上で動作し、IT チームが既存の Kubernetes 知識でそのまま運用できる設計となっている。

---

## チャプター 1: 市場背景とソブリン AI の必要性（0:00頃）

### 時代背景: アプリからエージェンティック AI へのシフト

Inbal はセッション冒頭で「世代に一度のプラットフォームシフト」と表現し、次の数字を提示した。

- **2028 年までに 13 億の AI エージェント**が存在し、エンドツーエンドのビジネスプロセスを自動化する
- **82% の組織**が今後 3 年以内にエージェントを採用し、パイロットから中核ワークフォースへと移行する

この数字は「なぜ今エージェントなのか」という問いへの答えであり、組織はいまエージェント戦略を定義し、次の 10 年のソフトウェアをどう構築・運用するかを決める必要があるという主張につながる。

### 顧客ユースケースから導かれる「ハード制約」

Inbal は、AI 戦略は「すべてが正常に動いているクラウド環境」だけでなく、**実際に障害が起きた状況でも機能しなければならない**と強調した。顧客から実際に聞かれる制約として以下を挙げた。

- **地政学的リスク・規制制御**: 特定の国や地域のモデルしか使用できないケース
- **アウテージ時の継続運用**: ネットワークが落ちても AI システムが止まってはならない
- **ソブリンティ（主権）の維持**: データや推論をクラウドに送れない状況

具体例として 2 つのシナリオを示した。

**公共安全（Public Safety）**
指令センターや危機対応では、レイテンシー・依存関係・アウテージへの許容度がゼロ。AI は完全ディスコネクト状態でリアルタイムの状況把握と意思決定支援を提供しなければならない。外部呼び出しなし、データのクラウド送信なし、ネットワーク断でもシステム停止不可。

**重要インフラ（エネルギー・電力）**
変電所や鉄道システムのような分散・遠隔環境では接続が保証されない。リアルタイム監視・診断・インシデント対応に AI を使うが、接続が失われても AI がローカルで安全かつコンプライアンスに準拠して動き続ける必要がある。

### 結論: AI は「パフォーマンスとスケール」から「レジリエンスとコントロール」へ

これらの制約を今解決している組織こそが、AI を本当に重要な場所に展開できる組織となる。

---

## チャプター 2: Sovereign Cloud ポートフォリオと Azure Local（3:50頃）

### ソブリン AI のポートフォリオ

Microsoft のソブリンクラウドポートフォリオは「コントロール・ケイパビリティ・自律性」のバランスを顧客が選べる設計になっている。「ソブリン AI はロケーションだけでなくコントロールの話だ」という重要な定義が示された。

スライド中央に位置する **Sovereign Private Cloud** は以下の特性を持つ。

- クラウド機能を持ちながら、完全に顧客または国家管理下に置かれた環境
- データ・モデル・オペレーションが定義された規制・地理的境界内に留まる
- Azure Local 上で動作し、外部クラウド接続なしでも独立運用可能

### Azure Local の役割と特性

Azure Local はこのセッションの基盤インフラとして位置づけられており、以下の特性を持つ。

**GA 済みの機能**
- Connected（接続）モードと Disconnected（完全非接続）モードの両方で GA
- 主権・エンタープライズ AI をオンプレミスで実現する基盤

**ハードウェア層**
- CPU / NPU / GPU にわたる AI 最適化ハードウェア構成を提供
- Foundry ワークロードに対して検証・認定済み
- シングルノード推論（軽量モデル向け）からマルチノード GPU クラスター（高性能生成 AI 向け）まで対応
- 事前検証済みのため、顧客は長い認定サイクルなしに自信を持って展開可能

**Kubernetes ネイティブ運用**
- Arc-enabled Kubernetes で動作
- AI ワークロードは既存のコンテナ化アプリと同じ宣言的オペレーター手法でデプロイ・スケール・管理
- Foundry Local は Arc Extension としてインストール
- カスタムオーケストレーションや独自ツールは不要。Kubernetes を知っていれば操作できる

**Connected / Disconnected の両対応**
- Connected モード: Azure Arc を通じてモデルカタログ・管理ポリシーをクラウドと同期
- Fully Disconnected / Air-gapped モード: 同一インフラが自律動作し、モデルはローカルにキャッシュ、推論はクラウド依存なしで実行

**セキュリティ・ガバナンス**
- ID 管理: Microsoft Entra ID + JWT 検証
- 推論エンドポイント: TLS + API キー / トークンベース認証
- クラウドで使うのと同じ ID・ガバナンス層をオンプレミス AI にも拡張、妥協なし

**まとめ**: Azure Local は単なるサーバーや単なるインフラではなく、事前検証ハードウェア・Kubernetes ネイティブ運用・セキュリティを備えた「AI レディプラットフォーム」であり、Foundry のクラウド機能をエンタープライズエッジへと持ち込む。

---

## チャプター 3: Foundry Local の発表内容と 3 つのアナウンスメント（8:18頃）

### Microsoft の AI 展開ポートフォリオ全体像

| 展開先 | 製品 |
|--------|------|
| パブリッククラウド | Microsoft Foundry（エージェント構築用クラウド提供）|
| デバイス（Windows / macOS / Android） | オンデバイス推論 SDK |
| エンタープライズ / オンプレ / ディスコネクト | Foundry Local（今回の発表対象）|

### 本日の発表（Public Preview）

Foundry Local を Azure Local 上で動作させる形で 3 つの機能を発表した。

**発表 1: Foundry Local モデルカタログのマルチノード対応（新規 Public Preview）**
- 2026 年 2 月に既に Foundry Local モデルカタログのシングルノード展開は発表済み（ONNX 推論対応）
- 今回新たにマルチノード展開（vLLM ベース）への対応を追加。スケールが必要な顧客向け
- Connected / Disconnected の両シナリオで動作

**発表 2: ローカル Agentic RAG（知識管理）の刷新（新規 Public Preview）**
- Local RAG オファリングを刷新し、組織内の知識をローカルで管理できる機能を提供
- 従来の RAG に加え、アクションを起こせる（Agentic）能力を持つ（初のプレビュー発表）
- カスタム MCP またはカタログ内のビルトイン MCP に接続可能

**発表 3: カスタム MCP によるローカルツール連携（新規 Public Preview）**
- カスタム MCP をローカルソースに接続可能
- モデル選択 + RAG + カスタム MCP + その他ローカルツールの組み合わせが実現
- Arc-enabled Kubernetes 環境上で、Azure Local の様々なフォームファクターで動作

### モデルカタログの詳細

現時点でカタログには **71 種類のモデル**が収録されており、2 つの管理オプションがある。

**モデル as a Platform（顧客管理）**
- Foundry Local のコミュニティモデル・オープンソースモデルを完全顧客管理で運用
- 推論エンジン: シングルノード → ONNX Runtime、マルチノード → vLLM（今回の新発表）
- Connected / Fully Disconnected 両対応
- Hugging Face 等からの BYOM（Bring Your Own Model）を OCI レジストリ経由で持ち込み可能
- OpenAI 互換 REST エンドポイントで一貫したアクセス

**モデル as a Service（Microsoft 管理 / 限定プレビュー）**
- フロンティアモデル（Mistral、OpenAI 等のプロプライエタリ IP モデル）への接続
- クラウドにアクセスできない最高機密ワークロード向け
- 特定の資格基準（Eligibility Criteria）あり、全顧客が利用できるわけではない
- 主なユースケース: EU 限定 LLM 要求、地政学的制約、規制圧力、外国司法権への懸念、長期的自律性確保

### スタック全体像（アーキテクチャ）

```
[アプリケーション / エージェント]
         ↑
[コミュニティモデル（71種）/ パートナープロプライエタリモデル / BYOM]
         ↑
[ONNX Runtime（シングルノード）/ vLLM（マルチノード）]
         ↑
[Kubernetes クラスター（Arc-enabled）]
         ↑
[Azure Local（CPU / NPU / GPU ハードウェア）]
```

---

## チャプター 4: デモ — モデル展開（PowerShell / REST API）（17:15頃）

登壇者は「開発者がインターフェースだけで作業するとは限らない。SDK・CLI・API でも利用可能にしている」と前置きし、PowerShell を使ったデモを紹介した。

### デモ手順（スクリーンショットベースのウォークスルー）

**ステップ 1: IT による Azure Local への Foundry Local 拡張機能のインストール**
- Azure ポータルの Azure Local リソースで「Settings」→「Extension」→「+」をクリック
- 新オプション「Foundry Local on Azure Local」を選択
- 構成パラメーターを入力して「レビュー・作成」
- IT 担当者はこれだけで Foundry Local を利用可能状態にできる

**ステップ 2: アクセストークン取得と利用可能モデル一覧確認**
```powershell
# アクセストークン取得後、利用可能なモデル一覧を REST API で取得
Invoke-RestMethod -Uri "https://<foundry-local-endpoint>/models" -Headers @{Authorization = "Bearer $token"}
# → 利用可能なモデルのリストが返ってくる
```

**ステップ 3: モデルのデプロイ（2 モデル）**
```powershell
# gpt-opensource-20b を vLLM で展開（名前: gpt-oss-vllm）
Invoke-RestMethod -Method POST -Uri ".../deployments" -Body '{"name":"gpt-oss-vllm","model":"gpt-opensource-20b","inferencing":"vllm"}'
# → デプロイ完了レスポンス

# Mistral 3b を展開
Invoke-RestMethod -Method POST -Uri ".../deployments" -Body '{"model":"mistral-3b"}'
# → デプロイ完了レスポンス
```

デモでは `gpt-opensource-20b`（推測: Microsoft 社内 OSS モデルの表示名）と `Mistral 3b` の 2 つをコマンドラインでデプロイし、この 2 モデルが後続のデモで使われると予告した。

---

## チャプター 5: エージェントとツール — Foundry Local Agentic RAG（19:48頃）

### ソリューションテンプレートの提供

開発者が AI アプリを構築できるよう、Microsoft Foundry ソリューションテンプレートとして 2 種類のコードサンプルを提供。

1. **Chat UI テンプレート**: デプロイ済みモデルに接続されたエージェントを持つローカルチャット体験（エンドツーエンド）
2. **ビデオエージェントテンプレート**: CCTV カメラ等のコンテンツを Video Indexer（Azure Local 上で動作）で分析するユースケース

### Agentic RAG のアーキテクチャ

知識パイプラインは以下の反復フローで動作する。

1. ユーザーが質問を投げる
2. エージェントがクエリを計画（何を検索するか決定）
3. 知識ソースを選択（SharePoint / Exchange Server / ローカルインデックス）
4. 結果をマージしてグラウンデッドな回答を生成
5. 信頼度が不足なら: クエリ書き直し → 再検索（反復ループ）
6. 高信頼度エビデンスが得られるか、設定済み effort limit に達したら終了

**重要な特性**:
- 全処理がローカルで完結。クラウド呼び出しなし
- すべてのレスポンスはソースドキュメントまで追跡可能（引用付き回答）
- イテレーティブな検索: 結果が不十分であればエージェントが自律的にクエリを書き直して再検索（これが単純な RAG との違い）

### 接続可能なデータソース（ツール）

**インデックス型ソース**: ローカルに保存・インデックス化されたドキュメント

**リモート型ソース**:
- SharePoint（オンプレミス / Microsoft 365 Local）
- Exchange Server（オンプレミス / Microsoft 365 Local）

特筆すべきは、SharePoint と Exchange Server が **Microsoft 365 Local** として Azure Local 上で動作する形で統合される点であり、このシナリオに関心のある顧客向けに **POC への登録**を受け付けている（現時点ではパートナリングとテスト段階）。

### Agentic RAG のデモ（ローカルチャット体験）

- Mistral（Ministral として表示）モデルを使ったローカルチャット UI のデモ
- UI 上で SharePoint と Exchange のトグルを ON にすることでローカルデータに接続
- 質問に対してソース（どのドキュメントから取得したか）を明示して回答
- モデル切り替えはドロップダウンメニューで可能。他のローカルチャット体験と同様の操作性
- 登壇者は「このシナリオでは強力なモデルは不要だが、切り替えは自由にできる」と補足

### MCP カタログの拡充方針

現在はビルトイン MCP としてカタログが提供されているが、登壇者は顧客からのフィードバック（必要な MCP・接続したいローカルソース）を収集してカタログを拡充していく方針を明言した。

---

## チャプター 6: ビデオエージェントと次のアクション（25:29頃）

### ビデオエージェントのユースケース

Foundry ソリューションテンプレートからビデオ分析コードサンプルをダウンロードして試用可能。

- **Video Indexer**: Azure Local 上で動作するビデオ分析プロダクト
- CCTV カメラ等からのライブビデオ分析を主なユースケースとして想定
- ローカルチャット体験と同じ仕組みで、ビデオエージェントとして動作
- 産業用途・公共安全用途に特に適している（リアルタイム状況把握・意思決定支援）

### 参加方法・次のアクション

1. **プレビュー登録**: セッション内のリンクからモデルオファリングのみ、または RAG + ローカルチャット体験も含む形でプレビュー登録可能（対象: Azure Local の Kubernetes 上で動作させている顧客）
2. **ブログポスト**: 技術詳細とコードサンプルを含むブログポストを参照
3. **コードサンプル**: Foundry ソリューションテンプレートから直接ダウンロード
4. **ドキュメント**: モデルカタログの詳細とユースケースに応じた使い分けを説明するドキュメントが公開済み
5. **フォーム登録**: Model as a Platform または Model as a Service への参加希望は専用フォームから申し込み

---

## まとめ

### セッション全体の結論

Microsoft Build 2026 の本セッションでは、接続断・主権管理が求められる産業・公共向け環境での AI 展開を実現する **Foundry Local** の大幅な機能強化が発表された。Azure Local というオンプレミス・エッジインフラ上に Foundry のクラウド機能を持ち込み、完全ディスコネクト環境でも AI が止まらない世界を実現することが中心メッセージであった。

### 発表された新機能一覧

| 機能 | ステータス | 概要 |
|------|-----------|------|
| Foundry Local マルチノード展開（vLLM） | Public Preview | Azure Local のマルチノードクラスターで vLLM を使った高性能 LLM 推論が可能に |
| Foundry Local モデルカタログ拡張（71 モデル） | Public Preview | Community モデル + Proprietary（要資格）をオンプレで利用可能 |
| Model as a Service オプション | 限定プレビュー（Eligibility Criteria あり） | フロンティアモデル（Mistral, OpenAI 等）をクラウド不要でオンプレ利用 |
| Foundry Local Agentic RAG | Public Preview | ローカル完結の反復型 RAG エンジン。クラウド呼び出しなし、ソース追跡付き |
| カスタム MCP 連携 | Public Preview | ローカルソースへのカスタム MCP 接続。Arc-enabled Kubernetes 上で統合動作 |
| SharePoint / Exchange Server ローカル統合 | POC 登録受付中 | Microsoft 365 Local（Azure Local 上）との Agentic RAG 統合 POC |
| Foundry ソリューションテンプレート: Chat UI | 利用可能 | ローカルチャット体験のエンドツーエンドコードサンプル（エージェント接続済み） |
| Foundry ソリューションテンプレート: Video Agent | 利用可能 | Video Indexer（Azure Local）を使ったライブビデオ分析コードサンプル |

### 技術者向け重要ポイント

1. **インフラ**: Azure Local（Arc-enabled Kubernetes）が必須。IT は Arc Extension のインストールのみで Foundry Local を有効化できる
2. **モデル管理**: REST API / PowerShell / CLI / SDK すべてから操作可能。OpenAI 互換エンドポイントで既存コードとの親和性が高い
3. **推論エンジン**: シングルノード → ONNX Runtime、マルチノード → vLLM（今回の新発表）
4. **Agentic RAG**: 反復クエリ型。effort limit 設定でコスト制御可能。すべてローカル完結
5. **MCP**: カスタム MCP またはカタログビルトイン MCP でローカルソースと接続。フィードバックによりカタログ拡充予定
6. **セキュリティ**: Entra ID + JWT + TLS + API キー / トークン認証。クラウドと同一ガバナンス層をオンプレへ拡張
