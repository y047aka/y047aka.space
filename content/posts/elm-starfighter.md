---
{
  "title": "Elm での開発用テンプレート elm-starfighter を作った",
  "description": "",
  "pubDate": "2019-07-06",
  "updated": "2019-08-24",
}
---

自作の Elm 開発用テンプレート「 [elm-starfighter](https://github.com/y047aka/elm-starfighter) 」が形になってきたので、その説明を書きます。

# elm-starfighter とは？

関数型言語 [Elm](https://elm-lang.org) を使った Web アプリケーション開発用のテンプレートです。webpack や Parcel といったモジュールバンドラーを使用せず、`npm scripts` で完結しています。Elm での開発に最低限必要なものをシンプルに使えるのが、elm-starfighter の特徴です。

- [elm-starfighter](https://github.com/y047aka/elm-starfighter)

## なぜ作ろうと思ったのか？

JavaScript での開発と同様に、Elm においても webpack や Parcel を使った開発方法が普及しています。しかし、Elm はモジュールバンドラーを必要とはしていないかもしれません。それならばモジュールバンドラーに頼らない、よりシンプルな開発ができるのではないかと考えました。

既に知られている [create-elm-app](https://github.com/halfzebra/create-elm-app) や [elm-webpack-starter](https://github.com/elm-community/elm-webpack-starter) に対して「毎回使うには大きすぎる」と感じたことも動機の 1 つです。Elm 入門者が簡単に使える開発ツールがあれば、Elm の持つ魅力をもっと引き出せるのではないかと思います。

## 開発の方針

### Elm 入門者に優しく

公式ガイドや『基礎からわかる Elm』を読んだあとで、すぐに使ってもらえるよう意識して作りました。使い方に迷うようなところがあれば改善していきたい。

### Elm の持つ魅力を引き出す

JavaScript と Elm では何が違うのかを意識しながら作りました。標準の `elm make` コマンドはデバッグ機能を使うことができますし、そこに開発用サーバー機能を付加した `elm-live` も非常に強力です。それらの良さを残しつつ、苦手な部分を補うようにしました。

### モジュールバンドラーと戦わない

適材適所を意識すること。例えば、Port を積極的に使うならモジュールバンドラーの方が有利のはず。
（私は Port をほとんど使わないので、推測で言っています）

## 謝辞

@ababup1192 さんには、開発初期の段階で多くの相談に乗っていただきました。ありがとうございました。

# 簡単に使えるので書くことがない

いちばん簡単な試し方は以下のコマンドを実行する方法です。

```
$ git clone https://github.com/y047aka/elm-starfighter.git
$ cd elm-startfighter
$ npm install
$ npm start
```

また、リポジトリのトップから緑色のボタン「Use this template」を選択すると、elm-starfighter を使った新しいリポジトリを作る事もできます。
![](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/406109/3faa5b0f-8ff3-9280-fa09-6ba62e3495e8.png)

## npm start

`npm start` を実行すると、

1.  `docs` にファイルが生成され
2.  開発用サーバーが起動し
3.  ブラウザに最初のページが表示されます

## npm run build

もう 1 つのコマンドは `npm run build` で起動します。

1.  `public` にファイルが生成されます

生成前のファイルはすべて `src` にあるので、いつも通りに開発を進められます。

```
src
 - index.html
 - main.js
 - Main.elm
 - style.sass または style.sass
 - assets（画像など）
```

## ディレクトリ名について

`docs` は Github Pages を、`public` は Netlify をすぐに使えるよう意図して設定しています。

# おわり

この記事の本編は、ここで終了です。
カスタマイズして使う場合には以下の付録を参考にしてください。

# 付録 1： package.json を読む

ここに elm-starfighter のすべてがあります。webpack や Parcel の姿はなく、代わりに `npm scripts` が並んでいます。`elm make` コマンドや `elm-live` を使っていることが分かりますね。これから `scripts` を詳しく見ていきましょう。

```package.json
{
  "scripts": {
    "clean": "rimraf docs public",
    "watch:html": "cpx -w src/index.html docs",
    "watch:assets": "cpx -w \"src/assets/**/*\" docs/assets",
    "watch:js": "cpx -w src/main.js docs",
    "watch:elm": "elm-live src/Main.elm --open --start-page=index.html --dir=docs -- --output=docs/elm.js",
    "watch:sass": "sass --watch src:docs",
    "watch": "sass src:docs && npm-run-all -p watch:*",
    "compile:html": "cpx src/index.html public",
    "compile:assets": "cpx \"src/assets/**/*\" public/assets",
    "compile:js": "cpx src/main.js public",
    "compile:elm": "elm make src/Main.elm --optimize --output=public/elm.optimized.js",
    "compile:sass": "sass --style=compressed --no-source-map src:public",
    "compile": "npm-run-all -p compile:*",
    "minify:elm": "google-closure-compiler --js=public/elm.optimized.js --js_output_file=public/elm.js && rimraf public/elm.optimized.js",
    "build": "npm-run-all -s clean compile minify:elm",
    "start": "npm-run-all -s clean watch",
    "test": "elm-test"
  },
  "devDependencies": {
    "cpx": "^1.5.0",
    "elm": "0.19.0-bugfix6",
    "elm-live": "3.4.0",
    "elm-test": "^0.19.0-rev6",
    "google-closure-compiler": "^20190819.0.0",
    "npm-run-all": "^4.1.5",
    "rimraf": "^3.0.0",
    "sass": "^1.22.10"
  }
}
```

## npm scripts

以下の 4 種類のコマンドを `start` と `build` から実行しています。

- clean
- watch
- compile
- minify:elm

### start

`clean` と `watch` を順番に実行します。

```json
"start": "npm-run-all -s clean watch"
```

生成したファイルは `docs` に出力されます。出力先のディレクトリ名を変更する場合は、以下のコマンド内の `docs` を新しい名前に書き直します。（実際には package.json をエディタで一括変換すれば問題ありません）

### clean

`docs` と `public` ディレクトリを 2 つとも削除します。このコマンドのみ、`build` と共有しています。

```json
"clean": "rimraf docs public"
```

### watch

「watch:」で始まるコマンドを、すべて同時に実行します。それぞれが `src` のファイルを監視し、変更があれば `docs` に出力します。

```json
"watch:html": "cpx -w src/index.html docs",
"watch:assets": "cpx -w \"src/assets/**/*\" docs/assets",
"watch:js": "cpx -w src/main.js docs",
"watch:elm": "elm-live src/Main.elm --open --start-page=index.html --dir=docs -- --output=docs/elm.js",
"watch:sass": "sass --watch src:docs",
"watch": "sass src:docs && npm-run-all -p watch:*"
```

開発用のサーバーは `watch:elm` の elm-live が起動しています。

### build

`clean` `compile` `minify:elm` を順番に実行しています。

```json
"build": "npm-run-all -s clean compile minify:elm",
```

生成したファイルは `public` に出力されます。出力先のディレクトリ名を変更する場合は、以下のコマンド内の `public` を新しい名前に書き直します。

### compile

「compile:」で始まるコマンドを、すべて同時に実行します。

```json
"compile:html": "cpx src/index.html public",
"compile:assets": "cpx \"src/assets/**/*\" public/assets",
"compile:js": "cpx src/main.js public",
"compile:elm": "elm make src/Main.elm --optimize --output=public/elm.optimized.js",
"compile:sass": "sass --style=compressed --no-source-map src:public"
"compile": "npm-run-all -p compile:*"
```

**注意：** minify まで実行しないと elm.js を出力できない実装になっています。cpx でどうにかしたい。（2019 年 7 月 6 日）

### minify:elm

elm.optimized.js を圧縮し、elm.js として出力します。

```json
"minify:elm": "google-closure-compiler --js=public/elm.optimized.js --js_output_file=public/elm.js && rimraf public/elm.optimized.js"
```

# 付録 2： devDependencies

使用した npm のパッケージについて簡単にコメントします。

### cpx

ファイル・フォルダのコピーを、Mac でも Windows でも出来るように。
`--watch` のオプションがあり、`devDependencies` の記述量を減らすことに繋がった。
（内部的には chokidar かな？）
cpx で上手くいかない場合は、ncp で妥協することになる。

### elm

Elm のコンパイラ。

### elm-live

browser-sync を試したものの、コンパイルエラーを無視してサーバーが起動してしまうため、 elm-live が最適という結論になった。

### elm-test

テスト（script 未実装）

### google-closure-compiler

Elm をコンパイルした後の js ファイルを圧縮する。
elm-minify が deprecated となり、こちらが推奨されていたので使用した。

### <s>node-sass</s>

<s>SASS を扱うために使用。いつか sass（Dart Sass）に変えるかもしれない。</s>
sass（Dart Sass）に変更しました。（2019 年 7 月 9 日）

### npm-run-all

コマンドの直列実行と並列実行を読みやすく記述できる。

### rimraf

フォルダの削除を、Mac でも Windows でも出来るように。
