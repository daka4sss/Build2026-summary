# Microsoft Build 2026 LIVE168「Claude Is in Copilot. Here's What That Actually Means」詳細まとめ

**登壇者**: Burke Holland（VS Code チーム、司会）、Tyler Leonhardt（VS Code チーム、Claude Agent 統合担当）
**セッションURL**: https://build.microsoft.com/en-US/sessions/LIVE168
**取得元**: 公式WebVTTトランスクリプト（medius.microsoft.com CAPTION）

---

## 全体像

本セッションは、Anthropic の Claude エージェントが Visual Studio Code および GitHub Copilot のエコシステムにどのように統合されているかを、VS Code チームの Tyler Leonhardt が Burke Holland とのカジュアルなトークショー形式で解説したものである。セッションタイトルにある「Claude Is in Copilot」とは、独立した別サブスクリプションを契約することなく、既存の Copilot サブスクリプションの課金基盤を維持したまま Claude の Agent SDK ハーネスを VS Code 内で選択・利用できるようになったことを指している。

実用的な意味合いとしては、Copilot CLI・Claude・Codex・Pi などの複数の「エージェントハーネス」（エージェントループとツール呼び出しロジックを含む実行基盤）をサブスクリプションを切り替えることなく自由に使い分けられる点が強調された。また、デスクトップの VS Code で起動したエージェントセッションをブラウザや端末から遠隔操作できる **Agent Host Protocol** も紹介された。デモはすべてライブで行われ、実際に Claude を使って「Compliment Fest」というイベント用 Web サイトを Copilot 経由で生成・修正するシナリオが用いられた。

---

## チャプター 1: 前置き ― 「Copilot なのか、そうでないのか」（00:00〜01:10）

Burke Holland が午後 1:15 頃の登壇者として Tyler Leonhardt を紹介し、本セッションのテーマを「Claude agents in Visual Studio Code」と告げる。Burke が「VS Code は Copilot ではない」と発言すると、Tyler は「そうでもあり、そうでもない（It is and it isn't）」と即答し、聴衆の興味を引く形でデモへの導入を行った。この一見矛盾した発言が、セッション全体のキーメッセージ――Claude は VS Code 内で動くが、課金は Copilot サブスクリプションに乗る――を端的に表している。

---

## チャプター 2: Claude Agent SDK の VS Code 統合 ― Copilot サブスクリプションで Claude を選択（01:10〜04:00）

Tyler は、Anthropic が公開している **Agent SDK**（Claude Code をラップする SDK）を VS Code が採用し、そのハーネスを Copilot サブスクリプションに紐付けた形で動作させていると説明した。VS Code のエージェント選択 UI には「Local」「Copilot CLI Cloud」「Copilot CLI」「Claude」「Codex」など複数の選択肢が並んでおり、ユーザーは同一サブスクリプションのまま好みのエージェントに切り替えられる。

Copilot エコシステムが提供する最大のメリットとして Tyler が挙げたのは **課金の一元化** である。Twitter や Reddit でその日ごとに「今一番人気のハーネス」が変わるほど競争が激しい中で、Copilot を使えば請求実装を変更せず乗り換えられると述べた。Burke が「複数サブスクリプションに入っていて毎月 20 ドルずつ引き落とされていることに気づいていない人は？」と会場に問いかけ多数の挙手を確認する場面もあり、統一課金の訴求力が改めて示された。

---

## チャプター 3: ライブデモ ― Compliment Fest Web サイトを Claude で生成（04:00〜05:20）

Tyler は「Compliment Fest」という自身が主催するインプロビゼーションイベント用 Web サイトを実例に使用した。友人がデザインしたイベントフライヤーの PDF を Copilot（Claude バックエンド）に渡し「このためのウェブサイトを作って」と指示しただけでサイトが生成された。さらに、「2026 年にはコンフェッティが必須」という笑いを交えながら、サイトにコンフェッティアニメーションを追加するデモも実施した。

このデモは、VS Code の通常のエージェントウィンドウ（Agents パネル）でも Claude が選択肢として表示されることを示すものでもあった。Burke との対話で「エージェント」と「ハーネス」の違いについて補足説明がなされ、「ハーネスとはエージェントループ・プロンプト・ツール呼び出しのコード全体を指し、Copilot・Claude Code・Codex・Pi などがそれぞれ一つのハーネスに相当する」と整理された。

---

## チャプター 4: Agent Host Protocol ― デスクトップのエージェントにブラウザ・スマートフォンから接続（05:20〜09:15）

Tyler のチームが開発中の **Agent Host Protocol** が紹介された。これはエージェントとクライアント間の通信プロトコルであり、あるマシン上で動いているエージェントホストに外部から接続してセッションを開始できる仕組みである。

デモでは以下の流れが示された。

1. VS Code で「Local Agent Host」を選択し、Claude（Opus）でセッションを開始する。
2. エージェントウィンドウ下部の「リモートセッションを許可」ボタンをオンにする。
3. ブラウザで `vscode.dev/agents` を開き、OAuth 認証を経てローカルマシンのエージェントセッションに接続する。
4. ブラウザ上で Opus を選択し、メッセージを送信するとローカルマシン上で処理が走る。

Burke が「スマートフォンでも開けるということ？」と確認すると、Tyler は「その通り。デスクトップからスマートフォンへ移行するシナリオ、または別のマシンへ接続するシナリオを想定している」と答えた。Burke が「家族と夕食を取る代わりにエージェントをプロンプトしろということか」と冗談を言い、会場の笑いを誘った。

---

## チャプター 5: クラウド上での Claude エージェント実行と PR 自動作成（09:15〜11:55）

最後に Tyler は、VS Code の **Settings / Cloud Agents** から「Claude Coding Agent」と「Codex Coding Agent」を有効化できることを紹介した。これにより、タスクをクラウド上の Claude エージェントに委譲（バックグラウンド実行）できる。

デモでは「Cloud」を選択して Claude に「hi」とメッセージを送信し、処理完了後にクラウド側の Claude エージェントが自動的にプルリクエストを作成する様子を確認した（デモ内容はコンフェッティ追加のコード変更）。Burke は「Copilot Agent に縛られていると思っていたが、Claude Agent に切り替えられるのか」と驚きを表し、Tyler は「それが選択の自由（Freedom of choice）だ」と強調した。

また Tyler は、Claude Code に存在するカスタマイズ（設定ファイルや MCP サーバー等）がそのまま VS Code 統合版でも動作することを補足した。複数サブスクリプションを保有しているユーザーも、同じツールセットを共有できるという点でメリットがあると述べた。

---

## まとめ

### セッション全体の結論

本セッションの核心は「Claude in Copilot」が何を意味するかの具体的な解説である。Copilot サブスクリプション一つで Claude Agent SDK ハーネスを VS Code 内から利用でき、ローカル実行・クラウド委譲・ブラウザ/スマートフォンからのリモート接続という三つの利用形態が既に実現または開発中であることが示された。エンタープライズにとっては、ハーネスを乗り換えても課金構造を変更しなくてよいという点が実務上の大きな利点となる。

### 発表された新機能・取り組み（ステータス）

| 機能・取り組み | 内容 | ステータス |
|---|---|---|
| VS Code への Claude Agent SDK 統合 | Anthropic の Agent SDK を Copilot サブスクリプションで利用可能に。エージェント選択 UI から Claude を選択できる | 本日より利用可能（Today） |
| VS Code エージェントウィンドウでの Claude 対応 | Agents パネルで Claude を選択してチャット・コーディングが可能 | 利用可能 |
| Cloud Agents（Claude Coding Agent） | Settings / Cloud Agents から Claude エージェントをクラウド上で実行し PR を自動作成 | 利用可能（有効化が必要） |
| Agent Host Protocol | エージェントホストとクライアント間の通信プロトコル。デスクトップのエージェントにブラウザ・スマートフォンから接続できる | 開発中（Working on right now） |
| vscode.dev/agents リモートセッション | ブラウザから OAuth 認証経由でローカルエージェントセッションに接続 | 開発中（デモ段階） |

### 技術者向けの次アクション

1. VS Code のエージェント選択 UI を開き、「Claude」オプションが表示されているか確認する。表示されていれば既存の Copilot サブスクリプションで今すぐ利用できる。
2. **Settings / Cloud Agents** を開いて「Claude Coding Agent」を有効化し、バックグラウンドでのクラウド実行とプルリクエスト自動作成を試す。
3. Claude Code 向けに作成済みの設定（CLAUDE.md や MCP サーバー設定など）は VS Code 統合版でも有効なため、既存の Claude Code 環境をそのまま持ち込めるか検証する。
4. **Agent Host Protocol** の仕様・リポジトリを GitHub 上で確認し（セッション中に URL が表示されたが読み取り不可だったため要検索）、将来的なリモートエージェント接続への対応準備を行う。
5. 複数の AI エージェントサブスクリプションを保有している場合、Copilot サブスクリプションに統合することでコストと管理コストの削減を検討する。
