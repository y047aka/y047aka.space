---
title: "Elm + CSS の検討と実践記録"
description: ""
pubDate: "2020-05-16"
---

Elm で CSS を扱う方法の検討と、[elm-css](https://package.elm-lang.org/packages/rtfeldman/elm-css/latest) に至るまでの記録です。

## 選択肢

Elm のアプリケーションで CSS を扱うための方法にはどのようなものがあるでしょうか？

#### HTML で CSS ファイルを読み込む

最もオーソドックスな方法です。
Sass などのプリプロセッサや PostCSS などの仕組みも問題なく使うことができます。
ただし、この方法が Elm で常に使えるわけではありません。
Ellie などのオンラインエディタや、HTML を生成しない `elm reactor` などで実行する場合は CSS を読み込むことはできず、インラインに記述するなどの工夫が必要です。

#### CSS フレームワーク

[Bulma](https://bulma.io/)、[Tailwind CSS](https://tailwindcss.com/)、[Semantic UI](https://semantic-ui.com/) などがあります。
このうち Bulma については 3 ヶ月ほど使ってみました。
用意されているスタイルだけでは足りない場合は、自分でスタイルを書く必要があります。

#### elm-ui

従来 CSS が担っていたレイアウトの定義を Elm で記述できるようにしたライブラリです。
レイアウト以外のスタイルは別の方法で指定する必要がありますが、使い勝手の良いライブラリとして人気を集めています。
（私はまだ使ったことがない）

#### elm-css

私が現在使っている方法です。
プロパティや値が型つきで定義されていて、Elm のファイル内でスタイルを指定できます。
これまで日本ではあまり注目されていませんでしたが、この記事をきっかけにして普及するといいな。

「HTML で CSS ファイルを読み込む」と「elm-css」について、詳しく見てみましょう。

## 記録： HTML で CSS ファイルを読み込む

Elm を初めてからしばらくは、使い慣れた HTML で CSS ファイルを読み込む方法を採用していました。
[elm-live](https://www.elm-live.com/) というツールが非常に便利だったため、モジュールバンドラー不要の開発を実現していました。
当時の私が書いていた CSS は一般的な CSS 設計とは異なるスタイルでしたが、「Elm で CSS を扱う」という目的は充分に達成していました。

#### elm-live のリロード機能

elm-live の v3 系では CSS ファイルの更新を感知してブラウザをリロードする機能あり、非常に快適に開発を進めることができました。
4.0.0 で大きな変更がありこの機能は省略されてしまいましたが、今後復活することを期待しています。

[Watching css files? · Issue #196 · wking-io/elm-live](https://github.com/wking-io/elm-live/issues/196)

#### 別の方法を探す

実際のところ、elm-live から CSS のライブリロード機能がなくなったことは、私が別の方法を模索するきっかけになりました。
CSS フレームワークの Bulma を試していたりもしましたが、ここでは省略します。
ジンジャーさんが書かれている [CSS フレームワークを使いたくない - ジンジャー研究室](http://jinjor-labo.hatenablog.com/entry/2019/03/13/084116)
は、私の感想にかなり近いと思います。
とはいえ、デザインをフォーマットする手段としては有効だと感じます。

## 記録： elm-css

2020 年に入り elm-css を導入しました。
そして、この試みは今のところ上手くいっています。
elm-css の特徴や使ってみての感想を以下に列挙します。

#### 型の存在

プロパティや値に応じた型が用意されているため、コンパイル時に記述のミスを発見することができます。
CSS であることに変わりはないので、詳細度やその他いくつかの問題に対しては CSS を記述する時と同じように気をつける必要があります。

#### locally scoped CSS

記述したスタイルにはランダムな class 名が付与されます。
これを HTML の要素と紐付けることでローカルなスコープを実現しています。
クラスを使ったセレクタも書けるようになっているので、ローカルなスコープ以外の方法で紐付けたい場合に使いましょう。

#### CSS のプロパティや値はそのまま

過去に CSS の経験があれば、知識をそのまま活用できます。
すべてが網羅されているわけではありませんが、不足があれば新たに関数を作って補うことができます。
「CSS でできることは、elm-css でも同じようにできる」という認識で良さそうです。

#### 動的な値を含めることができる

数値を Elm で計算して含めることも、ロジックに応じてプロパティ単位で指定を変更することもできます。
なんでもできてしまうので、やりすぎに注意する必要はあるかもしれません。

#### 関心の分離

CSS in Elm の採用にあたって気になる部分だと思うのですが、elm-css の採用検討にあたってはそれほど重要ではないと感じています。
書き方の工夫で大きく変わるので、採用後に色々と検討してみると良いと思います。
「関心の分離」は個人的には重要なので、いつか詳しい記事を書くつもり。

#### コンパイルが必要

アプリケーションが小さいうちはそれほど気になりませんが、スタイルを変更するたびにコンパイルが必要です。
大きくなると少しストレスに感じるかもしれません。
そのうち慣れます。

## Q & A

#### 学習コスト

CSS を書けるのであれば、それほど苦労はしないと思います。
プロパティや値のほとんどは、スネークケースをキャメルケースにすれば使うことができます。
よく言われる「デザイナーとの協業」については試したことがないのでわかりません。
CSS in JS を採用している人に聞いてみたい。

#### 捨てやすさ

すべてのプロパティや値は CSS と共通なので、クラスを改めて指定する手間さえ惜しまなければ適当に変換できるはずです。

#### CSS に型安全は過剰？

型安全が elm-css のすべてではないので総合的に判断すれば良いと思います。

#### 擬似クラス、擬似要素、メディアクエリは使える？

使えます。

#### PostCSS は使える？

現行の elm-css だけでは PostCSS は使えません。
必要な機能は関数として作ってしまえば、それほど困ることはないのかなと考えています。

#### リセット CSS がほしい

[y047aka/elm-reset-css](https://package.elm-lang.org/packages/y047aka/elm-reset-css/latest/) を作りました。

#### elm-css を既存の CSS と組み合わせたい

HTML ファイルで既存の CSS を読み込みつつ、適宜 elm-css の指定を追加できます。
既存の CSS から elm-css へと段階的な移行もできますね。

#### CSS ファイルを生成したい

過去に [elm-css-webpack-loader](https://github.com/tcoopman/elm-css-webpack-loader) や [ThinkAlexandria/css-in-elm](https://package.elm-lang.org/packages/ThinkAlexandria/css-in-elm/latest/) が開発されていたので、参考にすると良さそうです。
私は今のところ試していません。

## 参考

elm-css を採用している事例の紹介です。

#### noredink-ui

NoRedInk 社製の UI ウィジェット集です。
実践的な使い方はこのパッケージの実装を参考にするのが良いかも。
[NoRedInk/noredink-ui](https://package.elm-lang.org/packages/NoRedInk/noredink-ui/latest/)

#### elm-css patterns

elm-css のレイアウトパターン集です。
綺麗にまとまっているので、elm-ui との比較検討をする場合に役立ちそう。
[elm-css patterns](https://elmcsspatterns.io/)

## 今後の展望

いま試しているものや、未来の可能性など。

#### Palette の導入

CSS で最も難しいことのひとつが色の管理です。
変数を活用する方法は既存の CSS でも普及していますが、私は background / color / border などをセットにした Palette という単位を試しています。
今のところ上手く機能しているので、elm-css を使う利点の 1 つとして考えています。
[https://github.com/y047aka/y047aka.space/blob/master/src/Color/Palette.elm](https://github.com/y047aka/y047aka.space/blob/master/src/Color/Palette.elm)

#### elm-ui との関係性

レイアウトに関するスタイルのみを CSS から切り離すことへの違和感が強く、私自身は [elm-ui](https://package.elm-lang.org/packages/mdgriffith/elm-ui/latest/) を使ったことがありませんでした。
elm-css を深めていく中で、いまは elm-ui の手法を一部取り入れる可能性もあると考えています。

#### CSS への期待

elm-css を導入した背景には、CSS 設計（BEM など）への反発もありました。
従来の CSS 設計とは異なる新しいパラダイムの登場や CSS 自体のさらなる進化を期待しています。
