# Microsoft Build 2026 BRK261「Build and ship faster with a developer-optimized experience on Windows」詳細まとめ

**登壇者**: Kayla Cinnamon、Craig Loewen（Product Manager, Windows Subsystem for Linux ほかWindows AIツール担当）、Jianye Lu（Windows Performance）、Clint Rutkas（カタログ記載。本編ではマイク保持役として「4人目のスピーカー」と紹介されたが、自己紹介としての発言は文字起こしに無し）
**セッションURL**: https://build.microsoft.com/en-US/sessions/BRK261
**取得元**: 公式WebVTTトランスクリプト（medius.microsoft.com CAPTION）

---

## 全体像

本セッションは约40分のBreakout（Level 300）。Windowsプラットフォームチーム（Windows本体、PowerToys、Windows Terminal、winget、WSL を担当）が、当日の基調講演で発表された開発者向けアップデート群を「スライド最小・デモ中心」で深掘りする内容である。テーマは大きく2部構成: 前半「**Building on Windows**（Windows上で開発する体験そのものの改善）」と、後半「**Building for Windows**（Windowsアプリを作るためのツール群）」。

前半では、開発環境を一括セットアップする winget 構成ファイル、タスクバーの可動化や新RunダイアログといったWindows本体のUI改善、エージェントが端末内で伴走する実験的機能「Intelligent Terminal」、そしてその場で発表されたばかりの「WSL containers」（wsl c / container コマンドによるネイティブLinuxコンテナCLI）と Coreutils、Comfort shell が紹介された。

後半では、Windowsアプリ開発を簡易化する winapp CLI、エージェント向けプラグイン「win-dev-skills」によるWinUI 3アプリのライブ生成デモ、PowerToysの新ユーティリティ「grab and move」、Adobe Photoshopで最大20%の性能向上を出した Sample-based PGO（SPGO）の実演、WSL containers をC#（NuGet）からアプリに組み込むAPI、そして MOONRAY レンダリングエンジンとの協業事例が示された。

本セッション最大のメッセージは「**ほぼすべてがオープンソースである**」という点で、Terminal/WSL/WinUI/PowerToys全体で16,000名超のコントリビューターがいることを締めくくりで強調した。なお紹介されたリポジトリ・ツールの多くは「今朝公開したばかり（fresh this morning）」と何度も言及されている。

---

## チャプター1: イントロとチーム紹介（0:00頃）

- **登壇者の自己紹介**:
  - Kayla Cinnamon（司会・進行役）
  - Craig Loewen — Product Manager。Windows Subsystem for Linux（WSL）およびWindows上のAIツールを担当
  - Jianye Lu — Windows Performance担当（後半のSPGOデモを担当）
- チームが扱う領域: Windows本体、**PowerToys**、**Windows Terminal**、**winget**（Windowsパッケージマネージャー）、**WSL**（Windows Subsystem for Linux）。
- セッションの方針: 「slidesは最小限。それが我々のスタイル（that is our jam）」。
- 2部構成の予告:
  1. **Building on Windows** — アプリを作る際の、Windows自体に施した改善
  2. **Building for Windows** — Windowsアプリ構築をよりシームレスにするために作ったすべて

---

## チャプター2: 開発環境セットアップ（winget構成ファイル）（1:21頃）

- 課題: Windowsで開発を始めるとき、Python、Node、各種パッケージ、好みのツールを集めるのに時間がかかる。
- 解決策: チームが用意した **winget configuration file** が一括でセットアップを行う。
  - インストール内容: Ubuntu + WSL、Git、GitHub CLI、Copilot CLI、VS Code など
- **idempotent（冪等）** であるのが利点。既にGitがある場合は再インストールせず、存在を確認して次へ進む。
- 公開リポジトリ: **Windows Developer Config**（今朝publicにした）。
  - ダウンロードして何がインストールされるか確認してから実行可能。
  - 本セッションで紹介する他の要素もこのリポジトリに含まれる。
  - リンク一覧は最後のスライドにまとめて掲示。

---

## チャプター3: Windows本体のUI改善 — Vertical Taskbar と 新Run（2:37頃）

### Movable taskbar（可動タスクバー）
- 非常に要望の多かった機能で「復活」させた。
- タスクバーを **左 / 上 / 下** に配置可能。
- Insider Programで提供中（shipping）。
- Kayla自身は「左に置くとアイコンを見失う」ため習慣で下のままにしておくとコメント。

### 新Runダイアログ（3:00頃）
- 従来のRunに似ているが、UIがより洗練された（streamlined）。
- 注目点: **PowerToys Command Palette のアーキテクチャを流用**して構築されている。
- 進化の系譜:
  - **PowerToys Run**（最初に登場）
  - → **Command Palette**（拡張性向上、インストール可能な拡張、フィードバックを反映した新UI）
  - → このアーキテクチャが今や **Windows本体のRun** に組み込まれた
- ツールを検索でき、見た目はCommand Paletteに酷似（配色が反転している程度）。
- オープンソースの意義: 冒頭スライドに載っていたものはWindows本体を除きほぼすべてオープンソース。Command Paletteへ貢献したコードがWindowsに入っている可能性が高い。

---

## チャプター4: Intelligent Terminal（実験的機能）（4:20頃）

- 背景: エージェント（例: Copilot CLI）を使うとターミナル全体が占有されてしまう。プロンプトに留まりつつ、エージェントに伴走してもらえたら良い、という発想。
- **デモ**: 「動かないように」と頼んで書かせたregexコマンド（パスワード検証用regexの想定）を、エージェントが「動作しない」と検知し、修正案を考える様子を実演。
  - エージェントは具体的なコマンドを即提示せず、「大文字を含めるか」「ユニーク文字を要求するか」といった意図を確認しながら、ターミナルを離れずにより良いregexを共同で組み立てられる。
- **エージェントの選択**: 初回起動時に使用するエージェントを尋ねられる。デモ環境にはGitHub Copilotのみ導入していたが、**Claude、Codex、Open Code** など、マシンにインストールすればIntelligent Terminalが自動で認識する。優先モデルも選択可能。
- 提供状況: **本日（今朝）GitHubで公開**。オープンソース。フィードバック募集中（このagenticペインの使い心地、追加してほしい点など）。

---

## チャプター5: WSL containers — CLI（wsl c / container）（6:06頃）

Craig Loewen担当。今朝発表されたばかりの **WSL containers**。「コンテナを使ったことがない人に、なぜ使い始めると良いかを納得してもらうのが目標」。

- 新バイナリ **wsl c** をWSLに追加。多様なLinuxコンテナコマンドを実行可能。
  - 例: ubuntu の最新版を起動。Debian派なら最新版Debianも、未ダウンロードでも自動でpullして実行。
- コンテナの強み: 共有可能（クラウド/ローカル）で強力なLinux環境を構築できる。これがWSLの一部として直接動く。
- **container** というエイリアスも内蔵（wsl c と container のどちらでも可）。
- **イメージのビルド**: Containerfile からサービスをターミナル内で直接ビルド（デモではキャッシュ済み）。
  - edit という新しいCLIエディタを紹介。マウス対応で「お気に入り」。
  - 中身は Python 3.13 を取得し各種Linuxコマンドで環境構築。

### Coreutils（8:11頃／8:19頃）
- wsl c image ls の結果を **Grep** にパイプして MarkItDown を絞り込み。
- このGrepが動くのは、新たにリリースされた **Coreutils**（多数のLinuxコアユーティリティをWindows上で直接実行する仕組み）のおかげ。
- wc にパイプして数えると **165個**のツールが含まれることが判明（※後述のリキャップでは「75個」と言及しており、自動字幕/口頭での数値に揺れあり）。
- 例: test.exe、tail.exe、env.exe（環境変数表示。「Bashでしかやり方を知らなかった」とCraig）。WindowsとLinuxの世界が共存できる点を強調。

### MarkItDown サービスのデモ
- ビルドした **MarkItDown** サービスを起動。-p で **コンテナのポート8000をWindows側へフォワード**。
- Edgeで localhost:8000 を開くと、コンテナが定義する小さなWebアプリが表示。
- 任意のフォルダのPDFや .docx をドラッグ＆ドロップ → Markdownへ変換し、左右に元ファイルと変換結果を表示。
- お遊びとして、コンテナでターミナルを「炎上」させるデモ（誰かが作ったものを1行で実行可能）。

### なぜ独自CLIを作ったか（10:xx頃）
- Podman Desktop / Docker Desktop / Rancher Desktop など優れたCLIが既にある。
- しかし **APIも併せて構築**しており（Part 2で紹介）、APIとCLIが協調動作するよう「opinionated（意見を持った設計）」にしたかった。
  - 例: system session コマンドはDocker/Podmanには存在しないが、API/CLI連携のために追加。
- **すべてオープンソース**。基盤の仮想マシン技術への改善は Docker / Podman / Rancher すべてに無償で還元される。
  - 例: **Linuxから Windows ファイルへアクセスする際のクロスOSファイル性能を2倍に改善**。

---

## チャプター6: Comfort shell とリキャップ（building on Windows）（12:07頃）

### Comfort shell（12:24頃）
- Windows Developer Config に含まれる、Ubuntuのカスタマイズ実装（セットアップスクリプト）。
- 馴染みのツールをプリインストール: **Homebrew、ZSH、Starship** など。Ubuntuディストロにそのまま接続。
- Kayla一押し: **btop**（基調講演でも紹介）も同梱。

### Building on Windows のリキャップ（13:26頃）
- 構成ファイル（GitHubリポジトリ、人気ツールを多数含む）でセットアップ最適化
- **Intelligent Terminal**（エージェント伴走の実験的体験）
- Windows改善: 新Run（PowerToys Command Paletteアーキテクチャ流用）+ Vertical Taskbar
- **Coreutils**
- **WSL container** のネイティブコンテナ実装（既存のContainerfileで動作）
- **Comfort shell**（btopデモ）

---

## チャプター7: Building for Windows — winapp CLI と win-dev-skills（14:01頃〜15:20頃）

ここから後半「Building for Windows」。WinUIアプリ等を直接Windows上で作る話。

### winapp CLI（14:21頃）
- Windowsアプリ構築を容易にするための単一CLI（オープンソース、GitHub）。
- 管理対象: Windows SDK、パッケージング、app identity生成、manifest、証明書、ビルドツール。
- 公開（publishing）など難しい部分もカバー。
- **package identity** が解除する機能: インタラクティブなネイティブ通知、Explorer・タスクバー・share sheet との統合 など。
- winget で1行インストール可能。

### win-dev-skills（agentプラグイン）（15:20頃）
- エージェント向け **プラグイン**（= skills、MCPサーバー、カスタムエージェントを1つのインストーラーにまとめたもの）。
- 用途: エージェントで **WinUI 3 / Windows App SDK アプリ**を構築。
- 含まれるスキル例: build/runワークフロー、WinUI design、WinUI code review、testing、packaging、**WPFからの移行**、session report、WinUI setup。
- Craigの補足: **最新情報をエージェントに直接提供**するため、Web検索でトークンを浪費せずに済む（古い情報も避けられる）。「WinUI 3を調べさせる代わりに、このプラグインで最初から知っている状態にできる」＝トークン効率が良い。
- インストールは長いプロンプトをCopilotに貼り付ける方法、または手動でも可能。

---

## チャプター8: WinUI 3アプリのライブ生成デモ（16:xx頃）

- Craigの MarkItDown アプリを、今度はネイティブWinUIで作り直すライブデモ。
- 手順:
  1. Copilot CLIを起動し、カスタムエージェントを **WinUI-dev プラグイン** に設定（インストール後に得られるカスタムエージェント。WinUI/Windows App SDKのスキルへルーティングされる）。
  2. Copilot CLIの **音声入力（voice feature）** で指示: 「任意のファイルをMarkdownに変換するネイティブWinUI 3アプリを作って。左右並列ビューで両ファイルの内容を表示。CraigのMarkItDownより綺麗にして、完成後にUIテストして実行して」。
  3. **Shift+Tab** でモード切替（Plan / Autopilot / Regular）。Autopilotモードで全権限許可して実行。
- プラグイン同梱の **UI testing** が自動実行（アプリのビルド→デプロイ→マウスが自動でボタン・テキストボックスを操作・検証）。
- 事前に（「綺麗にして」抜きの）別プロンプトで同様のアプリを作った際は **一発で成功**。モダンなボタン等のWinUI 3コンポーネント、テキストボックス、Browse fileボタンが使われている。
- 結果: セッション後半でアプリは実際にビルド完了し、UIテストも実行・完了したと報告。

---

## チャプター9: PowerToys「grab and move」（19:29頃）

- PowerToysの新ユーティリティ。Kayla曰く「PowerToys愛ゆえにねじ込んだ」。
- 課題: Edgeでタブを大量に開く（デモ環境では约50タブ）と、タブが邪魔でタスクバー/タイトルバーを掴めない。
- **grab and move**: **Alt を押しながら**ウィンドウのどこからでもクリックしてウィンドウ全体をドラッグ移動できる。

---

## チャプター10: Sample-based PGO（SPGO）デモ（20:57頃）

Jianye Lu担当（マイクトラブルがあり、Kaylaがマイクを貸す/ Clintがマイク保持で対応）。

### 背景: PGOとその課題
- **PGO（Profile-Guided Optimization）**: 実行中の実行ファイルからデータをサンプリングし、どの部分が実行されるかをコンパイラに渡して最適化させる手法。性能向上は5〜10%と実績あり。
- ISV採用を妨げる課題:
  1. **instrumentation**（アプリへの追加コード）が必要
  2. ビルドパイプラインに **余分なfork** が生じる
  3. instrumented buildは非常に **遅く**、エンドユーザーの実挙動を模倣できず、プロファイル品質が疑わしい

### 解決策: SPGO（Sample-based PGO）
- アプリコードのinstrumentationの代わりに **ハードウェアカウンター** を使用（非常に軽量）。**release build** をそのまま走らせてプロファイル収集できる。
- 同じ性能メリットを、上記のfrictionなしで享受可能。
- 実績: **Adobe Photoshop チームと協業し、実ワークフロー（CPU負荷の高い処理）で最大20%の改善**。

### end-to-endデモ（22:43頃〜）
- サンプルコード: スタックベース仮想マシンでフィボナッチ数列を計算。switch op（演算子ごとに分岐）に注目 — スタック処理では分岐の偏り（予測しやすい分岐 vs めったに使われない分岐）が大きく、PGO/SPGOが得意とする最適化対象。
- **手順**:
  1. **ベースラインビルド**（SPGOなし、通常のコンパイラ最適化のみ）→ 実行時間 **約3秒**
  2. SPGOフラグ付きでコンパイル（まだ最適化はしないが、PDB等を準備しSPDファイルを後で消費できるようにする）→ 実行すると「SPDが見つからない」と表示（正常。まだ未投入のため）
  3. **xperf** でETLトレースを取得し、ハードウェアカウンターを収集（release buildを、instrumentationなしでエンドユーザー同様に実行）
  4. ETL → **SPT**（情報抽出）→ **SPD**（コンパイラに直接渡すプロファイルデータ）へ変換。2ステップに分けてあるのは、大規模ソフトでは複数の重要ワークフロー（ベンチマーク、ユーザー操作等）があり、1ワークフロー=1 ETL=1 SPTを並列で複数取得し、最後に全SPTを1つのSPDに統合できるようにするため
  5. SPDを与えて **再ビルド**（最後のステップ以外はベースラインと同一）
- **結果**: 最適化ビルドの実行時間 **約2秒**（ベースライン約3秒）→ **約33%の改善**。
  - 「mileageは環境次第」だが、ISVからは **5〜15%** の性能改善の報告。

### Adobeからの追加知見
- Adobeは20%改善を「ベンチマーク数値だけでなく、Photoshop利用時のレスポンスが向上し邪魔にならなくなった」と評価。低レベルチューニングからの **発想の転換**（スケーラブルで持続可能な最適化）として歓迎し、製品ビルドパイプラインに自然に統合。近日中にSPD最適化版を一般公開予定。
- **反復的なプロセスである点**が重要: コードや顧客の使い方が変われば、ステップ3に戻ってシナリオを再実行し、プロファイルをリフレッシュして再投入する。ビルドパイプラインの一部として継続的に回せる。

---

## チャプター11: WSL containers — API（C# / NuGet）と MOONRAY協業（32:26頃〜）

Craig Loewenに再びバトンタッチ。前半でteaseしたAPIの話。

### WSL Containers API（C#組み込み）（33:09頃）
- 狙い: 前半のLinuxコンテナコードを書き直さず、そのままWindowsアプリ（WinUI）に組み込みたい。
- **WSL Containers NuGet パッケージ** を .csproj に追加し、同一のContainerを定義（名前・取得元・出力先を指定）。
- **dotnet build / dotnet run の一部としてコンテナが自動ビルド**される。Containerfileを編集すれば自動でビルドプロセスに反映＝真にソースコードの一部。
- dotnet run で同じ **MarkItDown アプリをフルWinUIで構築**。見た目は完全にモダンなWindowsアプリで、裏でLinuxが動いていると言われなければ気づかない。
  - 「Linuxの力が必要だと知らなくてよい顧客もいる（例: 自分の両親）。強力なアプリを使えればよい」。
- **起動性能**: コールドスタートで約 **2.5秒**（セッション初期化→コンテナ起動→Linuxコード/Pythonサービス実行）。
- **アーキテクチャ**: タスクマネージャーで MarkItDown service が独自プロセスとして確認できる。**各Windowsアプリが専用のWSL VMを持ち**（WSLディストロと同じVM技術）、その中で任意個数のコンテナを実行可能。
- コード例（C#）: 新規セッション開始（CPU/メモリ数指定でVM起動）、特定イメージのpull、オプション設定。
  - 例のオプション: **port 8000のみマップ**、**volume mounting**（特定Windowsフォルダのみアクセス許可）、**GPUアクセス付与**。
  - 終了時にはVM含む全リソースが自動クリーンアップ。

### エコシステム改善（37:07頃）
- **lazywslc** プロジェクト: 全コンテナ向けの優れたTUIダッシュボード。
- **Dev containers** 対応: 「attach to running container」「reopen in container」など、VS CodeでWSL containerがサポートされる。

### MOONRAY 協業（37:18頃）
- **MOONRAY** チーム: 強力なLinuxベースのレンダリングエンジンを開発。映画レンダリングに使用（例: The Bad Guys 2、The Wild Robot）。
- 全コードがLinux・完全オープンソース（WSL同様）で、これをWindowsユーザーに使いやすく届けたい → WSL containers で本番対応のギャップを橋渡し。
- **デモ**: WSLC-Moonray フォルダにビルド済みの **moonray.exe**（明確にWindows実行ファイル）。Windowsファイル（バックスラッシュパス、.rdla レンダリング入力）を渡し、jpegをレンダリング。
  - デバッグ情報で「マシン起動 → レンダリング（全CPU使用）→ 完了時にVMをクリーンアップ」が確認できる。
  - 結果はオレンジ色のコーヒーメーカーの美しい画像。
- ポイント: .exe でWindows入出力・Windowsファイルを開いているが、API統合コードを除き **バックエンドのコードは完全にLinux**。AIコンテナ化からクラウド/ローカルまでの可能性に期待。

---

## チャプター12: クロージング — オープンソース貢献者への謝辞とリンク（39:58頃）

- チームは長年オープンソースツールに取り組んできた。
- Clintのアイデアで、Terminal / WSL / WinUI / PowerToys の全コントリビューター一覧をエクスポートしたところ **16,000行超** に。＝ **16,000名超のオープンソースコントリビューター**。
- Coreutils を使い、特に貢献の大きいコントリビューター **Nora**（特にPowerToysで活躍）への感謝を grep で表示する小演出。
- 最後のスライドに全リンクを掲示（config file、Comfort shell（同一リポジトリ）、SPGO、Intelligent Terminal、winapp CLI、win-dev-skills、PowerToys がそれぞれリポジトリを持つ）。
- Q&Aへ移行。

---

## まとめ

### コアメッセージ
- Windowsプラットフォームチームは「Building **on** Windows（開発する体験）」と「Building **for** Windows（アプリを作るツール）」の両面で開発体験を強化している。
- 紹介された機能・ツールは **Windows本体を除きほぼすべてオープンソース**で、多くが「今朝公開されたばかり」。16,000名超のコントリビューターがこれらを支えている。
- WSL containers は「opinionated」な設計でCLIとAPIを協調させつつ、基盤VMの改善はDocker/Podman/Rancherにも無償還元される。
- 性能面ではSPGOがinstrumentationなしで現実的に性能を底上げ（Adobe Photoshop最大20%、デモで约33%）。

### 発表機能・ツール一覧

| 機能・ツール | カテゴリ | ポイント | 提供状況 |
|---|---|---|---|
| **Windows Developer Config**（winget構成ファイル） | Building on | Ubuntu/WSL/Git/GitHub CLI/Copilot CLI/VS Code等を冪等に一括導入 | 今朝GitHubで公開 |
| **Movable / Vertical Taskbar** | Building on | タスクバーを左/上/下へ配置 | Insider Programで提供中 |
| **新Runダイアログ** | Building on | PowerToys Command Paletteアーキテクチャを流用 | coming（提供予定） |
| **Intelligent Terminal** | Building on | エージェントが端末内で伴走。Copilot/Claude/Codex/Open Code対応 | 今朝GitHubで公開（実験的） |
| **WSL containers（CLI）** | Building on | wsl c / container、Containerfileでビルド、ポートフォワード | 今朝発表 |
| **Coreutils** | Building on | 多数のLinuxコアユーティリティをWindowsで実行（GitHub） | リリース済み |
| **Comfort shell** | Building on | Homebrew/ZSH/Starship/btop等をプリインストール | Windows Developer Config同梱 |
| **winapp CLI** | Building for | SDK/packaging/app identity/manifest/証明書/ビルドツールを単一CLIで | winget配布、オープンソース |
| **win-dev-skills**（プラグイン） | Building for | WinUI 3/Windows App SDKアプリ構築用skills/MCP/カスタムエージェント | 提供中 |
| **PowerToys grab and move** | Building for | Alt+クリックでウィンドウをどこからでも移動 | PowerToysに追加 |
| **Sample-based PGO（SPGO）** | Building for | HWカウンターでrelease buildから最適化。instrumentation不要 | 近日リポジトリ公開予定 |
| **WSL containers API（NuGet）** | Building for | C#からコンテナをアプリ組み込み。各アプリ専用WSL VM、GPU/volume対応 | 提供 |
| **lazywslc / Dev containers対応** | Building for | コンテナ管理TUI、VS Codeでのコンテナサポート | エコシステム改善 |

### エンジニア向け次のアクション
1. **Windows Developer Config** リポジトリを取得し、winget構成ファイルで開発環境を一括セットアップ（Comfort shellも同梱）。
2. **Intelligent Terminal** を試し、好みのエージェント（GitHub Copilot/Claude/Codex/Open Code）で端末内伴走の使い心地をフィードバック。
3. **wsl c / container** でネイティブLinuxコンテナを試用。Coreutilsで grep/wc/env 等をWindowsから直接利用。
4. **winapp CLI**（winget 1行インストール）+ **win-dev-skills** プラグインで、エージェントによるWinUI 3アプリ構築を体験（UIテスト同梱）。
5. **WSL Containers NuGet** を .csproj に追加し、dotnet build/dotnet run でLinuxコンテナをWindowsアプリへ組み込み（ポート/volume/GPUオプション）。
6. **SPGO** を自プロジェクトに適用し、release buildベースでコンパイル最適化（ビルド→xperfでプロファイル→SPT→SPD→再ビルド）。反復的に運用。
7. PowerToysの **grab and move** を有効化（Alt+クリックでウィンドウ移動）。
8. 最後のスライドのリンク集から各リポジトリにアクセスし、オープンソースとしてのコントリビュートも検討。
