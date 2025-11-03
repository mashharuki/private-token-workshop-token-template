# Private Token Workshop - プライベートトークンプログラム

このプロジェクトは、Aleoブロックチェーン上でコンプライアンスを維持しつつプライバシーを保護するトークンプログラムです。

## 📋 プログラム概要

- **プログラム名**: `private_token_workshop.aleo`
- **機能**: パブリック/プライベートでのmintとtransfer機能
- **コンプライアンス**: OFAC制裁リストチェック統合

## 🚀 クイックスタート

### 前提条件

- Leo CLI がインストールされていること
- Rust がインストールされていること
- テストネットクレジット（デプロイ時に必要）

## 🔨 ビルド

プログラムをコンパイルしてAleoインストラクションに変換します。

```bash
cd token_template
leo build
```

**成功時の出力例:**
```
✅ Compiled 'private_token_workshop.aleo' into Aleo instructions.
```

## 🧪 テスト

テストを実行してプログラムの動作を確認します。

```bash
leo test
```

**注意**: 外部プログラム（`workshop_ofac.aleo`）への依存があるため、ローカルテストは制限されます。完全なテストはデプロイ後に行うことを推奨します。

## 📦 デプロイ

### 1. 環境変数の設定

`.env`ファイルを作成して、ネットワークと秘密鍵を設定します。

```bash
echo "NETWORK=testnet" > .env
echo "PRIVATE_KEY=<あなたの秘密鍵>" >> .env
ENDPOINT=https://api.explorer.provable.com/v1
```

### 2. テストネットクレジットの取得

デプロイには手数料が必要です。[テストネットフォーセット](https://faucet.aleo.org/)からクレジットを取得してください。

### 3. デプロイ実行

```bash
source .env
leo deploy --network testnet
```

以下のようになればOK!

```bash
🛠️  Deployment Plan Summary
──────────────────────────────────────────────
🔧 Configuration:
  Private Key:        APrivateKey1zkp2NJQ7JzR6...
  Address:            aleo1yzxkqudh9at6jjh3d4f...
  Endpoint:           https://api.explorer.provable.com/v1
  Network:            testnet
  Consensus Version:  11

📦 Deployment Tasks:
  • private_token_workshop.aleo  │ priority fee: 0  │ fee record: no (public fee)

📊 Deployment Summary for private_token_workshop.aleo
──────────────────────────────────────────────
  Total Variables:      175,388
  Total Constraints:    127,217
  Max Variables:        2,097,152
  Max Constraints:      2,097,152

💰 Cost Breakdown (credits)
  Transaction Storage:  4.287000
  Program Synthesis:    0.302605
  Namespace:            1.000000
  Constructor:          0.002000
  Priority Fee:         0.000000
  Total Fee:            5.591605
──────────────────────────────────────────────
```

## 📖 メソッド呼び出し方法

### 1. mint_public - パブリックトークンの発行

パブリックマッピングに記録される形式でトークンを発行します。

```bash
leo run mint_public <受取人アドレス> <金額>
```

**例:**
```bash
leo run mint_public aleo1rhgdu77hgyqd3xjj8ucu3jj9r2krwz6mnzyd80gncr5fxcwlh5rsvzp9px 100u64
```

**パラメータ:**
- `recipient` (address): トークンを受け取るアドレス
- `amount` (u64): 発行するトークン量

**動作:**
- OFAC制裁リストに対して受取人アドレスをチェック
- `balances`マッピングの受取人残高を更新
- オンチェーンで残高が公開される

以下のようになればOK!

```json
{
  program_id: private_token_workshop.aleo,
  function_name: mint_public,
  arguments: [
    aleo1rhgdu77hgyqd3xjj8ucu3jj9r2krwz6mnzyd80gncr5fxcwlh5rsvzp9px,
    100u64,
    {
      program_id: workshop_ofac.aleo,
      function_name: address_check,
      arguments: [
        3945141883375476130743366659011577342275372042624438262538757342426909353342field
      ]
    }
  
  ]
}
```

---

### 2. mint_private - プライベートトークンの発行

プライベートレコードとしてトークンを発行します。

```bash
leo run mint_private <受取人アドレス> <金額>
```

**例:**
```bash
leo run mint_private aleo1rhgdu77hgyqd3xjj8ucu3jj9r2krwz6mnzyd80gncr5fxcwlh5rsvzp9px 50u64
```

**パラメータ:**
- `recipient` (address): トークンを受け取るアドレス
- `amount` (u64): 発行するトークン量

**動作:**
- OFAC制裁リストに対して受取人アドレスをチェック
- 新しい`Token`レコードを作成
- レコードの内容は受取人のみが知ることができる
- ゼロ知識証明により検証可能

**出力例:**

```json
{
  owner: aleo1rhgdu77hgyqd3xjj8ucu3jj9r2krwz6mnzyd80gncr5fxcwlh5rsvzp9px.private,
  amount: 50u64.private,
  _nonce: 6248617742400486139301751460470359670298306417478254389280191187544158303746group.public,
  _version: 1u8.public
},
{
  program_id: private_token_workshop.aleo,
  function_name: mint_private,
  arguments: [
    {
      program_id: workshop_ofac.aleo,
      function_name: address_check,
      arguments: [
        3945141883375476130743366659011577342275372042624438262538757342426909353342field
      ]
    }
  
  ]
}
```

---

### 3. transfer_public - パブリックトークンの転送

パブリックマッピング上で送信者から受取人へトークンを転送します。

```bash
leo run transfer_public <受取人アドレス> <金額>
```

**例:**
```bash
leo run transfer_public aleo1s3ws5tra87fjycnjrwsjcrnw2qxr8jfqqdugnf0xzqqw29q9m5pqem2u4t 25u64
```

**パラメータ:**
- `recipient` (address): トークンを受け取るアドレス
- `amount` (u64): 転送するトークン量

**動作:**
- OFAC制裁リストに対して受取人アドレスをチェック
- `self.signer`（トランザクション開始者）から`amount`を減算
- `recipient`の残高に`amount`を加算
- すべての残高変更がオンチェーンで公開される

**注意:**
- 送信者の残高が不足している場合、トランザクションは失敗します
- 送信者は`self.signer`として自動的に決定されます

以下のようになればOK!

```json
{
  program_id: private_token_workshop.aleo,
  function_name: transfer_public,
  arguments: [
    aleo1yzxkqudh9at6jjh3d4ffkn3dmu6yfndm0mym6hzj48w6kua0j58sshtfmz,
    aleo1s3ws5tra87fjycnjrwsjcrnw2qxr8jfqqdugnf0xzqqw29q9m5pqem2u4t,
    25u64,
    {
      program_id: workshop_ofac.aleo,
      function_name: address_check,
      arguments: [
        8262976664323574687514719411225956605314326284618329588497599327151503201791field
      ]
    }
  
  ]
}
```

---

### 4. transfer_private - プライベートトークンの転送

プライベートレコードを使用してトークンを転送します。

```bash
leo run transfer_private '{sender_token_record}' <受取人アドレス> <金額>
```

**例:**
```bash
leo run transfer_private '{
  owner: aleo1rhgdu77hgyqd3xjj8ucu3jj9r2krwz6mnzyd80gncr5fxcwlh5rsvzp9px.private,
  amount: 100u64.private,
  _nonce: 1234567890group.public
}' aleo1s3ws5tra87fjycnjrwsjcrnw2qxr8jfqqdugnf0xzqqw29q9m5pqem2u4t 40u64
```

**パラメータ:**
- `sender` (Token record): 送信者が所有するトークンレコード
- `recipient` (address): トークンを受け取るアドレス
- `amount` (u64): 転送するトークン量

**動作:**
- OFAC制裁リストに対して受取人アドレスをチェック
- 送信者のレコードを消費
- 2つの新しいレコードを作成:
  1. 受取人用: `amount`のトークン
  2. 送信者用: 残高（元の金額 - `amount`）

**出力例:**
```
// 受取人のレコード
{
  owner: aleo1s3ws5tra87fjycnjrwsjcrnw2qxr8jfqqdugnf0xzqqw29q9m5pqem2u4t.private,
  amount: 40u64.private,
  _nonce: <新しいnonce>.public
}

// 送信者の新しいレコード（お釣り）
{
  owner: aleo1rhgdu77hgyqd3xjj8ucu3jj9r2krwz6mnzyd80gncr5fxcwlh5rsvzp9px.private,
  amount: 60u64.private,
  _nonce: <新しいnonce>.public
}
```

**重要:**
- レコードは一度しか使用できません（UTXO モデル）
- プライベート転送では金額が秘匿されます
- ゼロ知識証明により、金額を明かさずに検証可能

---

## 🔍 実行例のワークフロー

### シナリオ: Alice が Bob にプライベートトークンを送る

```bash
# 1. Alice 用にプライベートトークンを発行（100トークン）
leo run mint_private aleo1alice... 100u64

# 出力されたレコードをコピー
# {
#   owner: aleo1alice....private,
#   amount: 100u64.private,
#   _nonce: 123456group.public
# }

# 2. Alice が Bob に 40トークンを転送
leo run transfer_private '{
  owner: aleo1alice....private,
  amount: 100u64.private,
  _nonce: 123456group.public
}' aleo1bob... 40u64

# 3. 2つのレコードが出力される:
#    - Bob のレコード (40トークン)
#    - Alice の新しいレコード (60トークン)
```

### シナリオ: パブリック転送

```bash
# 1. Alice 用にパブリックトークンを発行（200トークン）
leo run mint_public aleo1alice... 200u64

# 2. Alice が Bob に 75トークンを転送
leo run transfer_public aleo1bob... 75u64

# 3. オンチェーンの残高が更新される:
#    - Alice: 125トークン
#    - Bob: 75トークン
```

---

## 📊 パブリック vs プライベート比較

| 特徴 | パブリック | プライベート |
|------|-----------|------------|
| **残高の可視性** | オンチェーンで全員が見える | 所有者のみが知っている |
| **データ構造** | Mapping（address => u64） | Record（owner, amount） |
| **トランザクション履歴** | 完全に追跡可能 | プライバシー保護 |
| **ガス効率** | より効率的 | ZK証明のため高コスト |
| **使用例** | 監査が必要な場合 | プライバシーが重要な場合 |

---

## 🔐 セキュリティとコンプライアンス

### OFAC制裁チェック

すべてのmintとtransfer操作は、`workshop_ofac.aleo`プログラムを通じて受取人アドレスの制裁チェックを実行します。

```leo
let address_check: Future = workshop_ofac.aleo/address_check(recipient);
```

制裁対象アドレスへの転送は自動的に拒否されます。

---

## 🛠️ トラブルシューティング

### ビルドエラー

**エラー:** プログラム名が一致しない
```
Error: Program name mismatch
```

**解決策:**
- `src/main.leo`の`program private_token_workshop.aleo {`
- `program.json`の`"program": "private_token_workshop.aleo"`

両方が一致していることを確認してください。

### デプロイエラー

**エラー:** クレジット不足
```
Error: Insufficient credits
```

**解決策:**
[テストネットフォーセット](https://faucet.aleo.org/)からクレジットを取得してください。

### 転送エラー

**エラー:** 残高不足（パブリック転送）
```
Error: Mapping operation failed
```

**解決策:**
送信者の残高が十分か確認してください。`balances`マッピングを確認。

**エラー:** 無効なレコード（プライベート転送）
```
Error: Invalid record
```

**解決策:**
- レコードが正しい形式か確認
- レコードが既に使用されていないか確認（レコードは一度のみ使用可能）

---

## 📚 追加リソース

- [Aleo Developer Docs](https://developer.aleo.org)
- [Leo Language Documentation](https://docs.leo-lang.org)
- [Aleo Discord](https://discord.gg/aleo)
- [テストネットエクスプローラー](https://testnet.explorer.provable.com)
- [テストネットフォーセット](https://faucet.aleo.org/)

---

## 📝 プログラム情報

- **バージョン**: 0.1.0
- **ライセンス**: MIT
- **依存関係**: `workshop_ofac.aleo` (ネットワーク依存)

---

## 🎯 次のステップ

1. ✅ プログラムをビルド
2. ✅ テストネットにデプロイ
3. ✅ mint_public/mint_privateでトークンを発行
4. ✅ transfer_public/transfer_privateで転送をテスト
5. 💡 BONUSタスク: `convert_public_to_private`などの追加機能を実装

Happy coding! 🚀

## Leo Playground

Leo Playgroundでも実装可能

コントラクトをデプロイしたトランザクション

[at1qxe4rz6z4zu3d7ud9eengk4nypv55v3emzft37ln3usfpah4tspq4c63hx](https://testnet.explorer.provable.com/transaction/at1qxe4rz6z4zu3d7ud9eengk4nypv55v3emzft37ln3usfpah4tspq4c63hx)

修正後のコントラクトをデプロイしたトランザクション

[at1s5y5azyc8dlzyew0k7rmf8cnrnn4p7d3lgdfjxk74tqkqk8hegqsw449xt](https://testnet.aleoscan.io/transaction?id=at1s5y5azyc8dlzyew0k7rmf8cnrnn4p7d3lgdfjxk74tqkqk8hegqsw449xt)

Exampleのコントラクトをデプロイしたトランザクション

[at1kn5sluxjy9tdczqy4z9l3qgdnqamyx65qxr9vqdjqey9y0d5k5rqqr8eka](https://testnet.aleoscan.io/transaction?id=at1kn5sluxjy9tdczqy4z9l3qgdnqamyx65qxr9vqdjqey9y0d5k5rqqr8eka)

デプロイしたコントラクト

[private_token_workshop.aleo](https://testnet.explorer.provable.com/program/private_token_workshop.aleo)

デプロイした修正後のコントラクト

[private_token_workshop2.aleo](https://testnet.aleoscan.io/program?id=private_token_workshop2.aleo)

Exampleのコントラクト

[private_token_workshop3.aleo](https://testnet.aleoscan.io/program?id=private_token_workshop3.aleo)

トークンのミント(パブリック)

[at1zvm04wa2e9l3xzcrxyjap7v7wjqqk42d7pyxcf92dkaml79jmgrqk9qy9l](https://testnet.explorer.provable.com/transaction/at1zvm04wa2e9l3xzcrxyjap7v7wjqqk42d7pyxcf92dkaml79jmgrqk9qy9l)

修正後のトークンのミント(パブリック)

[au16jsn4528nrr0p9dtwkj00fxwrlkq6wrh35zfuww4lpxqw7v82q9smus45k](https://testnet.aleoscan.io/transition?id=au16jsn4528nrr0p9dtwkj00fxwrlkq6wrh35zfuww4lpxqw7v82q9smus45k)

トークンの送金(パブリック)

[at1csg8rumv8puax23g7uvtpxv2ztrljrqya0lam8rzq7y30qcplc8sv0qwsc](https://testnet.explorer.provable.com/transaction/at1csg8rumv8puax23g7uvtpxv2ztrljrqya0lam8rzq7y30qcplc8sv0qwsc)

修正後のトークンの送金(パブリック)

[]()

トークンのミント(プライベート)

[at1fm02epu6jkhlf075fr0xkahueha86y93pm2mrdkz9kxqxxyujqxqqj7w9z](https://testnet.explorer.provable.com/transaction/at1fm02epu6jkhlf075fr0xkahueha86y93pm2mrdkz9kxqxxyujqxqqj7w9z)

トークンの送金(プライベート)

呼び出し方が少し特徴的

[at1csxxv8njel890n8n28cnz4f44xlxz5rywpy0p4505w9gl2pzmyzsx08kjf](https://testnet.explorer.provable.com/transaction/at1csxxv8njel890n8n28cnz4f44xlxz5rywpy0p4505w9gl2pzmyzsx08kjf)


引数に必要なプライベートレコードは以下のようなデータ

```json
{"type":"execute","id":"at1pdduudn7m6m5dccm066nn307wes7q070lep2mewhs564nkjqjg9syd6wd2","execution":{"transitions":[{"id":"au1fk3rzc6lwy5cj3f5z6sjzqtdfl805tdcx07kjsjud8n0glw5lggsea9rph","program":"private_token_workshop3.aleo","function":"mint_private","inputs":[{"type":"private","id":"7607735846984392092108297483448753168388099341002978712259198841418004552179field","value":"ciphertext1qgq8xwvdtxhf2xdqvx5mzq84r5z2xscz5zyfsrytykwprm098yjeyrus55lmwq227kpxrxlnt9que7ckpas0r6v00yx3rham55vy8fzhqqscwdpa"},{"type":"private","id":"3859728027916988747637891792351781403348444157127148007236684513675750604535field","value":"ciphertext1qyq23gpmtl88wqpljfun4zhhark3adkal9g39cupqx9uvut2hfstwqcjpxs7c"}],"outputs":[{"type":"record","id":"3094681958689356229701281630365338798832604507388276626455028509614422314531field","checksum":"565973683958235761882804182381112222113746022422494243745958360641764063463field","value":"record1qvqsp24jva4uzssdja9vcxy7hu9umv8rxn8vk02u6gyr2k4cumnajhgjqyrxzmt0w4h8ggcqqgqspcy2sry36shmh9kcx9l5xnfp43dldhuydgfht3t7lytjq0fle9splwex3z3s3ntf0e9l2havdlzeq8vud0mzd4t8ldgkh7gq2w5va5yswhsp4v","sender_ciphertext":"1010686463871930595183324760397745104010547537345668418728744709670100056895field"}],"tpk":"2115157735500665868593576545357060140415980452880534253117344531727028737491group","tcm":"3807839340299054748057300031878610453304009079405233566536367239608639038196field","scm":"5002929544947284515614443584434504478209613349597646453243573448363502731353field"}],"global_state_root":"sr1mcpjcqmfjd0gap6h80q6zt6qx07wr7wlgupq03rqu4uuya3yjgqq5r42xj","proof":"proof1qyqsqqqqqqqqqqqpqqqqqqqqqqqdye4hehfkddpqyr6c826eczythur77m6tur797qwexgx33s644fww37w5cw0th2hxxdx6ysglxxvqqywv8p7wxlnarn5d9wx06htur2rfneplkzzkzfqre989ydd2ck2898v0dxpa583stzt2y6q0j7c2nqy73m0f3snk75t0h85sxxa2wh8hxcue6clg5f5v3cetu8grsydmh8dg5heg460d8lfg6zsq0nx4czqvm82rhl2y3khh457uxa0tg44pu7856ypt3asl88488hvz33c8dpf60msg373j748yrwcrvgev0luq3n7qu03sglg4dn8nv9zts9j2rhu4xwndka36al5s3qr62dgxgve6gglaqlw7uec0uzfql3jv5pjcrgctu9xd5l4zq0ycxa38a33tf0fdqkr4faygn043xr9rg47w775w2rat9shppg335t6eqajmn0gcqxef9c3u3f5j5vcf3fg9vlpgju493xdj6aae00grzd6uvxt8kgq7t097xhlh8qqm0fg8jqjxglkrqqq6tr8kgz95mr2kq6fr7cl93w67an8229hn3ysscne7m6qslhggaa23tqj4uy3q29csjdkgunnfs2qenh9cqvm2pcdqql2rlpchuyvswketd3hqglg4d4926k7lyc9me5phcjnd5qdz9d3v2qesygugtg5q0xd073wl9szwg7cm89v82t72emvs3y906djyjsjra7hh72dnasyt00qu8q2tw923pmpdp7rznk7ysl4l6u96gl9n3rj3a24e64h55quvsduhrwu56fv59va9mp8cqvwyayff6y99h5zyv9lq3p7hsw7dpd9hsad8g82jejvyzd3td3m7dkguzlgf2ldfrsz00axy4q7ehzssxvjwwza6xgyzeyhnzv5j8tx3wktx6gwn25w0rdwxsj3044kawmc3k2k9sa4ap8smajrax6jkhr07p0r6ect0lv9ma8fw892zwtekk5ra03tsqp8gc880cg759s6zvg9ektrfhwh77hq2k3g7rhl0capgcqfmrt27vuzzx20djn3u6y352lh609klj24lhqgxlrecqwlgj7qhqxml8rdsftmnw9fypeh2wjaqjhjt354k60xegqpytnvdwmynz693p8k2ujlynqnutnsa602ktehxtz03qtwlwqsheq4y0rrgj52tx0gqqvqqqqqqqqqqqjxyk64dtj3vejft570qjqkgsu9u2l3dexl88terqv9rfemv60ty9kwmme5p42kqxnpfp8l9uxycsyqgmk9yxafu0y5fvhh3e44mxfrd3eczgpxw6mfe9n78qrseh9lg8jpl90rj0eu74r2005hw5f5dy6vqqx0alew27rva9zrsdfljetvy3pv3kt9gsqkmekhkrra8c7urq77s5gjwpvphz0hacsv5p07tk8277n0w9r72l7mz9glgtvdu0wn2fux6jn9gj4crrhs3ecxlzye2txq0qyqqhjlahk"},"fee":{"transition":{"id":"au1cvwmqlqk5znmlz8p4n98kxvfgdr2f0kl2xw2av2ud57xg8yz9cyqgxfq7y","program":"credits.aleo","function":"fee_public","inputs":[{"type":"public","id":"6784467948756382464075276434303825333068980517174898555349966121856353458835field","value":"1544u64"},{"type":"public","id":"2437489865318637089210090883805639381706945363808225563150647007709646954882field","value":"0u64"},{"type":"public","id":"8319333219555644895614866964943217314043026022920371208853088696619259763054field","value":"2025055004281174487836075243350340846075630842714508690753139215459377372033field"}],"outputs":[{"type":"future","id":"6836319581811806172574636332109996080178887190058340774064928632251525626716field","value":"{\n  program_id: credits.aleo,\n  function_name: fee_public,\n  arguments: [\n    aleo1yzxkqudh9at6jjh3d4ffkn3dmu6yfndm0mym6hzj48w6kua0j58sshtfmz,\n    1544u64\n  ]\n}"}],"tpk":"5497275478625997288785463746490384999614040752422500386340592612693657113946group","tcm":"5446046678278946931531199900134070928226507339861553636184693590161306682872field","scm":"7654456553502048669697924560195269954276979287950985430439428457030125383508field"},"global_state_root":"sr1kq4x47vaadsn6cedjmlfya3zd608ktt45v30hmrnp74cdq5hrcrqvyzzc8","proof":"proof1qyqsqqqqqqqqqqqpqqqqqqqqqqq28wc9nwpr8jq6k24swmc9lhrc4xft6969422v7f5c9lctfvcvkurlkvmxx53khsduh8pamkrq6jgqqxu6t68jxl7ypl2llnma6z4wcknu65nre2u0qrgudkq2xjtwj6rax4nr0udtdymevzdv5p43uzeg9qd0hsdx3vgudr2ql72dc623eegh6j0h6cxmndx7fhr8fxy33mkh3grufw0y9nt7yzxhr2z47lyfjzqqcl8tu24kh9tls6vv9fhu5rt8wfclrqdnq8zz0nzuftr5srn9vk08p7f5um45lk7v5xja9ju8xlvp4vdjd0yaf0rz2zn0ulx7afmjlr5y2sq023vv8hrze6llw5nmykss8y9c6jn7jcgt7gdw4yx0tjzspscwkuh8xlmrfrqtvqxqkfsj6gtyw2g22fxkjjd2s6tgdhqwn4pqcz2w04qjassc4dgrhyvk34vls9pttlhhgxdq5paaamd5w6gc5qjfdn7phrjuapln5x8xk2f73p23huk743j4taxnjdnaw7qv7jrugqx6lusscksnj5rshgauwcdr9y20sqxzpwp0kk2qa2lensuxurze4rjf3f60eaqptcdsdv8c8p7sdqqxdjagaeq2shwpy0rc7m7rs84wst87w2lymwx332clsqlymr5ekdpfserdr7wsc6wudukle6qs3cyqp0v78ydlug9rfz9vy92h76nfkt64ukhku0mwjgchf8r3f46k7yxhn2azy4evdkuvgsl2up3a8uceqgd3jpwg0xah98vzleyfjgpz5ygfffsftlk5r93zhsuz58grw6ugrk2u35hvfcrvzs2yzdz3w2xppu7vhxx8s8vws2nx2u0f9q9rf3rt2j4f70p6jt5amvs05t72uuqs0v3w47x325ltwf7esuwmaus3lqushf2wqgw806pg78enutsccwgj7ghqjyq2p7nmu6ynkf7ef0mfp3f0mz07pm3detmqncgn4cjhpyxx2cq29hwq7uekp65ps40pw534ec0neccney647xp6hsqpmj0nsypslmhrnkflmdagd6nw4mngcsdwsc5nawfgrsyav4qdzwmd8k9dqs82w7swew0f5slx9wcddqstsf5y2kezhmnhz33phj9fg7tqzqmqru09ezgnmxz8480echlxnquh9w6gh7hcmaxrprcg2ap5j53c2gc9qvqqqqqqqqqqpx0u0te7akpf3smpluumfssn238ny5ta67mraktl9zsxkval2wyj59mw5kl43kaqf2cu8jx4fx6usqqqxvc8k6wwqlrfm3eq729ef7wx02vh9x2tk96a79awnytfqhwcwrtjvvta7wgxmvxqx8dp74h29ysqq884ekslm59vwqn7vd9690rsgt0pzysgfc9s5suckwc3hzrdhmksejxjzxtre5hhtxkdkfh9l9fk8jaf6fak7wm5vpw6dzwe08r4umz0v6h38k8emsz52lwc66943xjesyqq50nkfq"}}
```

