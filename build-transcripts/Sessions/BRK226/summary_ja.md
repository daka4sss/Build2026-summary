# Microsoft Build 2026 BRK226「Inside Azure innovations with Mark Russinovich」詳細まとめ

**登壇者**: Mark Russinovich（Azure CTO・Deputy CISO）
**セッションURL**: https://build.microsoft.com/en-US/sessions/BRK226
**取得元**: 公式WebVTTトランスクリプト（medius.microsoft.com CAPTION）

---

## 全体像

本セッションは Mark Russinovich が毎年 Microsoft Build で行う「Inside Azure Innovations」シリーズの 2026 年版。Azure インフラストラクチャのハードウェアレイヤーから OS・セキュリティ・AI 推論最適化に至るまで、現在開発中または直近でシップされた技術を幅広くデモ付きで紹介する。自称「まだ出荷していないかもしれないし、出荷しても同じ形とは限らない」という断りを冒頭で述べつつ、普段は公開されない Azure インフラの「内部」を見せる趣旨のセッションである。

カバー内容は大きく五分野：(1) Fairwater データセンター見学・Azure Boost カード新世代の数値、(2) MRC（Multi-Path Reliable Connection）ネットワーキングと VM-to-VM RDMA、(3) Azure Container Instances の進化（Direct Virtualization・コンテナライブマイグレーション・Memory Snapshotting・Azure Context Cache）、(4) Confidential Computing の新展開（Confidential VM ライブマイグレーション初公開・Azure Integrated HSM）、(5) Microsoft Research Cambridge が進める Project Mosaic（micro-LED を使った光インターコネクト）。

いずれのセクションも、Mark 自らライブデモを実施または映像・数値を提示して技術の実力を具体的に示す構成になっており、デモトラブルが一部あったものの全体的に盛りだくさんの内容であった。

---

## チャプター 1：オープニングと Fairwater データセンター訪問（0:00頃）

セッション冒頭でビデオが再生されず、Mark が手動で操作する小さなハプニングがあった（「なぜ再生されなかったんだろう、Play ボタンを押さないといけなかった」と笑いを取る）。

Mark は 2025 年 11 月にアトランタの **Fairwater データセンター**を直接訪問した体験を紹介した。Fairwater は AI ワークロード向けに設計されたデータセンターで、Wisconsin 拠点と Atlanta 拠点がある。映像では、建設中のデータセンター内部をヘルメット姿（「Builder Bob みたい」と自ら表現）で歩く様子が流れた。主なシーン：

- 地球を 4 周分するほどの量のネットワークケーブリングが天井のトランクを通っている
- **液冷ケーブル**がラックに先行して敷設され、後からサーバがスライド搭載される仕組み
- InfiniBand と Ethernet の両ケーブルがラック背面に接続される様子
- Mark 自身がぶら下がっていたコネクタを「なんだこれ？」と差し込んだ結果、数分後に Scott Guthrie に「誰かが予定外に Power Cell 3 を通電してしまった」とテキストが届くというエピソードが披露された（会場爆笑）。

---

## チャプター 2：Azure Boost 新世代カード（1:00頃）

Fairwater 内のサーバには **Azure Boost** オフロードカードが搭載される。Azure Boost はデータパスと管理エージェントをメイン CPU から切り離し、DPU・ARM コア・FPGA を内蔵した SoC カードに移す仕組みで、ワークロードがサーバリソースの大部分を直接使えるようにする設計。

前回 Build（2025）から今回までの新世代カードの主な数値向上：

| 指標 | 新世代 | 前世代比 |
|------|--------|---------|
| リモートストレージ帯域 | **20 GB/s** | 1.4 倍 |
| リモートストレージ IOPS | **100 万 IOPS** | 増加 |
| ローカルストレージ帯域（NVMe） | **36 GB/s** | 増加 |
| ローカルストレージ IOPS（NVMe オフロード） | **660 万 IOPS** | 増加 |
| ネットワーク帯域 | **400 Gbps**（200 Gbps ポート×2） | 2 倍 |
| ネットワーク接続数 | **40 万接続/秒** | 増加 |

2 ポート構成により Top-of-Rack スイッチ二重化が可能になり、片系障害時もサブ秒での切り替えが実現した。現在フリートの 30% 以上に Azure Boost が展開済みで、新規サーバはすべてに搭載。

### ベアメタルインスタンス（限定公開）

Azure Boost カード側で管理サービスを動かすことにより、ゲストに**ベアメタルインスタンス**を提供できるようになった。Fairwater では OpenAI 向けに限定アクセスで既に稼働中。将来的に一般提供予定とされる。

デモでは ND144V6 の IP を取得して SSH ログインし、仮想化サービスが起動していないことを確認後、lspci で 8 本の Mellanox RDMA 対応 Ethernet コントローラが直接見えることを実証した。

---

## チャプター 3：MRC（Multi-Path Reliable Connection）と VM-RDMA（7:00頃）

### MRC の概要

100,000 GPU を結ぶ巨大なトレーニングジョブでは、ネットワーク輻輳や単一リンク障害が同期トレーニング全体を停止させ、チェックポイントから再開せざるを得なくなる。従来 InfiniBand + RoCE（RDMA over Converged Ethernet）の組み合わせが多かったが、Azure の Fairwater では**Ethernet に切り替え**、Azure・OpenAI 共同開発の **MRC（Multi-Path Reliable Connection）** を採用した。

MRC の核心は「パケット スプレーイング」—パケットを独立したネットワークドメイン（plane）に分散して送出することで、特定リンク/スイッチ障害時に残存 plane に自動的に再バランスする仕組み。MRC は今や大規模ネットワークトポロジーの業界標準になりつつあるとの説明。

**デモ（MRC フェイルオーバー）**：2 台のサーバが 4 スイッチ越しに 4 GB ペイロードを 8 plane に分散送信し、**95 GB/s** を達成。途中 1 スイッチを強制ダウンさせた後も帯域が落ちず、残る 3 スイッチのうち 1 台が自動的に 36 Gbps 増加して補完したことをリアルタイム可視化で示した。

### VM-to-VM RDMA over Azure Boost

OpenAI の学習クラスターではベアメタル間 RDMA が使われているが、汎用の仮想マシン間でも RDMA を提供するのが目標。通常の TCP/IP パスは memory copy と同期オーバーヘッドが大きいのに対し、RDMA では Azure Boost が両端のメモリを直接マッピングしてデータを転送するため CPU が介在しない。

**デモ（prefill-decode 分離推論）**：LLM 推論を prefill サーバ（プロンプトトークンの KV キャッシュ生成）と decode サーバ（トークン生成）に分離する構成で比較実験：

| 指標 | TCP/IP | RDMA |
|------|--------|------|
| トークンスループット | 3,400 tokens/s | **7,637 tokens/s**（2.2 倍） |
| Time to First Token（中央値） | 123,000 ms | **47,000 ms**（2.6 倍短縮） |

この RDMA は Azure Boost の MANA（Microsoft Accelerated Network Adapter）ドライバ経由で有効になり、すでに Foundry の推論クラスターに展開中であると説明された。

---

## チャプター 4：Azure Container Instances の進化とサーバレス（13:30頃）

### サーバレスの未来宣言

Mark は「10 年前から言い続けているが、サーバレスはいよいよ本当に到来している」と宣言。Azure Container Instances（ACI）が GitHub Actions、Python in Excel、HorizonDB など多数の Microsoft サービスの基盤に採用されていることをスライドで示した。

### Direct Virtualization

従来の ACI は VM（Hyper-V）の中にネストされたコンテナとして動いていた。これを **Direct Virtualization**（L1 直接仮想化）に移行する計画が進行中。L1 ホスト（parent partition）に管理 VM を置き、コンテナは L2 VM として直接サーバに配置することで：

- ネストハイパーバイザーのオーバーヘッド除去
- VM と同等のネットワーク・ストレージデバイスアタッチ能力
- 敵対的マルチテナント分離（Hyper-V による強固な境界）を維持

フリート全体の移行には 1〜2 年かかる見込みとのこと。

### コンテナライブマイグレーション（世界初公開デモ）

VM にはライブマイグレーション（稼働中のサーバ間移動）があるが、コンテナには今まで存在しなかった。Mark は**コンテナライブマイグレーションの世界初デモ**と銘打ち、以下を実演：

1. Server dev-6 上で tick カウンターを毎秒出力するコンテナが動作（tick 695 付近まで確認）
2. ライブマイグレーション実行 → dev-6 側で出力停止
3. Server dev-1 側で同コンテナが起動、tick 7055 まで進行
4. ファイルの内容を確認すると tick 695 が欠落なく連続していることを cat で証明

「まだ開発中なのでコマンドラインから実行している」とコメント。ACI 上での agent サンドボックスに活用される予定。

### Manifold（GPU リソースマネージャー）

Microsoft 内部の全 GPU リソースを一つのプールとして扱い、AI ワークロードのトポロジーを理解してリソースを効率配置するシステム **Manifold** を紹介。ASICs・GPU・FPGA・CPU を統合管理し、複雑なモデル（内部に embedding モデルや vision LLM を包含するマルチモーダルモデル等）のトポロジーにも対応。

**デモ（Manifold + Direct Virtualization）**：同一サーバ上に GPU ポッド（Llama 4 Maverick モデル搭載、GPU・大量 RAM・多数 CPU コア割り当て）と CPU ポッド（GPU なし、最小メモリ・2 CPU コアのみ）が独立して共存。GPU ポッドに猫の動画を送り込み、Llama 4 Maverick による推論成功を実演。「Direct Virtualization によって CPU ポッドと GPU ポッドが物理サーバの異なる分離された空間に存在する」ことを証明。

### Azure Context Cache（Preview）

LLM 推論でのコスト削減を目的とした **Azure Context Cache** を紹介。KV キャッシュ（LLM の「状態」）をバックエンドの Azure Storage に保持することで、リクエストが異なる GPU/サーバに届いても同一プロンプトの prefill 再計算を回避できる。

**デモ結果**：
- 同一 system prompt、並列度 1：cache hit rate 81%
- 並列度 10（リクエストが複数サーバに分散）：hit rate 低下
- Azure Context Cache 有効時：hit rate **96.2%**（サーバをまたいだプールキャッシュにより大幅改善）

コスト削減・レイテンシ改善の両面で効果があるとして、現在 Preview 公開中と説明。

### コンテナ 10,000 個のバースト起動（Memory Snapshotting デモ）

コンテナを起動後にメモリスナップショットを取得し、次回以降は初期化をスキップして直接メモリマップするという **Memory Snapshotting** 技術を説明。「エージェントが Python スクリプトを書いて実行したい、HTML サイトを作りたいといったユースケースでは、サンドボックスの起動時間が瞬時でないといけない」という動機。

**デモ**：10 ワーカーそれぞれが 1,000 コンテナサンドボックスを起動し、**計 10,000 個を平均 2 秒で起動完了**というスペクタクルな実演。Mark は「これが一番好きなデモのひとつ」とコメント。エージェントサンドボックス用途（Foundry Agent Service 等）に活用予定。

---

## チャプター 5：セキュリティ—Confidential Computing の新展開（28:58頃）

### Confidential Computing の基礎

Mark は Confidential Computing の概念を改めて説明：

- データは「転送中（TLS）」「保存中（暗号化）」の保護はほぼ普及
- 「使用中（in-use）」の保護が従来欠けていた
- Confidential Computing では、ハードウェアエンクレーブ内に閉じ込めたデータを hypervisor・管理者・不正アクセス者から保護
- **Attestation**（アテステーション）：エンクレーブのコード構成をハードウェアが測定し、鍵管理サービスがポリシーに基づいてのみ鍵を解放する仕組み

Azure は Intel SGX 対応サーバ導入（10 年前）を皮切りに、現在は AMD・Intel の CVM（Confidential VM）まで最大のハイパースケーラー CC ポートフォリオを持つ。

### Confidential VM ライブマイグレーション（世界初デモ）

Confidential Computing の大きな課題のひとつが「ライブマイグレーション非対応」であった。Mark は Intel と共同開発した **Confidential VM ライブマイグレーション**を**世界初公開デモ**として披露：

- **MIG TD（Migration TD）**：送信側・受信側それぞれのサーバに設置されるコンフィデンシャルパーティション。VM のアテステーション測定値に含まれ、「承認された MIG TD を持つサーバにのみ移行する」というポリシーを VM 自身が持つ
- デモ：Hyper-V Manager 2 台を並べ、Server 1 上の CVM（1 秒ごとに ping）を Server 2 に移行。RDP 接続が一瞬切断された後、Server 2 に CVM が現れることを確認
- 「数週間前に初めて動いた。まだ本番環境には入っていない」と説明

これにより Confidential VM が通常 VM と同等の可用性・フリート効率を持てるようになる見通し。

### Azure Integrated HSM（Manacor）

すべての Azure サーバに搭載される FIPS 140-3 Level 3 認定のハードウェア HSM、**Azure Integrated HSM**（内部コード名 Manacor）を紹介。Calyptra（Root of Trust チップ、Open Compute Project に寄贈済み）に続く取り組みとして、鍵のライフサイクル全体をハードウェア境界内に収める設計。

Azure Key Vault や Azure Managed HSM からポリシーベースで鍵を Azure Integrated HSM に転送し、仮想マシンにマッピングして直接暗号操作が可能。

**デモ（署名スループット比較）**：

| 方式 | 署名スループット |
|------|----------------|
| Azure Key Vault（HSM にリモート送信） | **640 ops/sec** |
| Azure Integrated HSM（ローカルで直接操作） | **18,800 ops/sec**（約 29 倍） |

「セキュリティを失わずにスループットが 29 倍になる。これが鍵管理インフラの未来形」とまとめた。エージェントが使うサービスの鍵もすべてこの仕組みで保護されることを展望として述べた。

---

## チャプター 6：Project Mosaic—micro-LED 光インターコネクト（38:39頃）

最後は「非常に実験的だが、できれば大きなインパクトになる Microsoft Research の研究」として **Project Mosaic** を紹介。

### 背景

データセンター内部の接続は銅線（最大約 2m）か光ファイバー（レーザー）が主流。レーザーは帯域幅に優れるが高発熱・高コスト。特に GPU の**分散配置（Disaggregated Computing）**——GPU ラックとサーバラックを離して置く構成——が進む中で、低コスト・高帯域の長距離接続が求められる。

### Project Mosaic の仕組み

- **micro-LED** を多数配列し、それぞれ数 Gbps で変調
- 数千コアの多芯マルチコアファイバーに結合し、シリコンカメラセンサーアレイで受信
- 使用する micro-LED・センサーはスマートグラス（VR ゴーグル）やカメラ向けに量産が始まっており、民生技術のコスト曲線に乗れる
- 個々の micro-LED を個別制御でき、ビット単位の変調が可能

**ライブデモ（Cambridge 研究所と中継）**：研究員（推測、Kathar と聞こえた）が Microsoft Research Cambridge のラボから生中継。評価ボード上の tiny 配列に数百個の micro-LED が実装されており、マルチコアファイバー経由で数十メートル先のカメラセンサーに信号を送信。会場からの掛け声で「Z」の文字を micro-LED で表示してライブデモを実証した。

「これが実用化できれば分散 GPU 配置のコストを劇的に下げられる可能性がある」として、実験成果に期待を示して締めくくった。

---

## まとめ

### 結論

セッション全体を通じて Mark は「AI インフラ共設計」というコンセプトを一貫して示した——データセンターの物理設計（Fairwater）から、ネットワーク（MRC）、オフロードカード（Azure Boost）、コンテナランタイム（ACI）、セキュリティ（Confidential Computing）に至るまで、すべてが AI ワークロードを最高効率で動かすために再設計されている。

「サーバレスの未来はいよいよ到来した」という 10 年来の主張が、Direct Virtualization と Memory Snapshotting で現実になりつつあることを示した。セキュリティ面では鍵管理のハードウェアネイティブ化という大きな方向転換が進んでいる。

最後に「今日の午後は Scott（Guthrie）とソフトウェアエンジニアリングの未来について話す予定なので、ぜひ来てください」と案内してセッションを締めた。

---

### 発表された新機能・技術（GA/Preview/研究段階）

| 機能・技術 | 状態 | 概要 |
|------------|------|------|
| Azure Boost 新世代カード | **GA（展開中）** | 20 GB/s リモートストレージ、400 Gbps ネットワーク |
| ベアメタルインスタンス | **Limited Access→近日一般提供予定** | Azure Boost で管理を完全オフロード |
| MRC（Multi-Path Reliable Connection） | **展開中（Fairwater）** | Ethernet ベースの耐障害 RDMA プロトコル |
| VM-to-VM RDMA over Azure Boost | **Foundry 推論クラスターで展開中** | prefill/decode 分離推論を 2 倍以上高速化 |
| Direct Virtualization | **移行中（1〜2 年かけてフリート全体）** | コンテナを L1 直接仮想化で動かす |
| コンテナライブマイグレーション | **開発中（未リリース）** | 世界初デモ公開 |
| Manifold + Direct Virtualization | **内部展開中** | CPU/GPU コンテナを同一サーバで分離共存 |
| Azure Context Cache | **Public Preview** | クロスサーバ KV キャッシュで hit rate 96.2% |
| Memory Snapshotting（10,000 サンドボックス） | **開発中** | 平均 2 秒で 10,000 コンテナ起動 |
| Confidential VM ライブマイグレーション | **研究段階（未リリース）** | Intel 共同開発、世界初デモ公開 |
| Azure Integrated HSM（Manacor） | **展開中（全サーバに搭載開始）** | FIPS 140-3 L3 認定、18,800 ops/sec の署名スループット |
| Project Mosaic（micro-LED 光インターコネクト） | **Microsoft Research 段階** | 量産 micro-LED＋多芯ファイバー＋カメラセンサーで低コスト光通信 |

### 次アクション

- **Azure Context Cache** は現在 Public Preview 中。Azure OpenAI Service 経由で試験可能。
- **ベアメタルインスタンス**はパブリックプレビューの公開を待つ。
- **Confidential Computing** の本番採用を検討している場合、Azure Integrated HSM の展開状況を追う価値あり。
- **MRC** の仕様はオープンコンソーシアムが進めており、パートナー参加も可能（推測）。
- Project Mosaic は製品化未確定のため、Microsoft Research ブログを継続ウォッチ。
