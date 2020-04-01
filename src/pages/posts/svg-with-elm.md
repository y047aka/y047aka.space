---
module: Static.Sub
date: 2020-01-02
title: elm/svgを使ってみよう（SVGの基礎知識）
---

この記事では、

- SVG の基本的な書き方
- Elm での記述方法
- 利用できるパッケージ

について見ていきます。

## SVG ってなんだろう？

Scalable Vector Graphics の頭文字をとって、SVG と呼ばれています。
解像度に制限されないベクター画像のための XML 文法として利用されています。

### 仕様について

SVG の仕様は W3C によって開発・勧告されています。
ドキュメントが充実しているので、積極的に活用しましょう。

<a href="https://www.w3.org/TR/SVG11/" target="_blank">
    Scalable Vector Graphics (SVG) 1.1 (Second Edition)<span>www.w3.org</span>
</a>

triple_underscore さんによる日本語訳を参考にするのも良いと思います。

<a href="https://triple-underscore.github.io/SVG11/" target="_blank">
    SVG 1.1 仕様 （第２版） 日本語訳<span>triple-underscore.github.io</span>
</a>

### SVG で何ができるのか？

画像の形式は .jpg, .png, .gif など数多くありますが、

- 解像度に制限されない
- ベクターである
- XML で記述できる

といった他にはない特徴を持つことが、SVG の強みです。
HTML 同様のスタイル指定や、アニメーションができるのも魅力ですね。

アイコンやロゴイメージへの活用はもちろん、インタラクティブなコンテンツの作成、データの可視化（ビジュアライゼーション）やジェネラティブ・アートなどがブラウザ上で簡単に実現できてしまいます。

すでに必須技術の 1 つと化した SVG ですが、これからも新しい使い方が発見されることでしょう。

### 基本的な書き方

SVG を構成しているのは要素と属性です。
そのため、HTML と同じ感覚で記述することができます。

SVG として記述されたコードは…

```SVG
<svg width="120" height="120" viewBox="0 0 120 120">
    <rect x="10" y="10" width="100" height="100" rx="15" ry="15" fill="red" />
    <circle cx="50" cy="50" r="50" fill="blue" />
</svg>
```

ブラウザによって画像としてレンダリングされます。

<svg width="120" height="120" viewBox="0 0 120 120">
    <rect x="10" y="10" width="100" height="100" rx="15" ry="15" fill="red" />
    <circle cx="50" cy="50" r="50" fill="blue" />
</svg>

y 軸が下向きなので少しだけ違和感があるかもしれませんが、HTML の読み書きができれば SVG も問題なく扱えるはずです。

## Elm で SVG を記述しよう

同じことを Elm でもやってみましょう。
Ellie に同じサンプルコードを用意しました。

<a href="https://ellie-app.com/5x8N5hXk3RFa1" target="_blank">
    elm/svg sample<span>Ellie</span>
</a>

```Elm
import Svg exposing (Svg, svg, rect, circle)
import Svg.Attributes exposing (width, height, viewBox, x, y, rx, ry, cx, cy, r, fill)

main : Svg msg
main =
    svg
        [ width "120"
        , height "120"
        , viewBox "0 0 120 120"
        ]
        [ rect
                [ x "10"
                , y "10"
                , width "100"
                , height "100"
                , rx "15"
                , ry "15"
                , fill "red"
                ]
                []
        , circle
                [ cx "50"
                , cy "50"
                , r "50"
                , fill "blue"
                ]
                []
        ]
```

記法の都合でコードが縦長になりましたが、元の SVG と対応しているのがよく分かります。
もう少し丁寧に解説をしてみます。

### モジュールのインポート

```Elm
import Svg exposing (Svg, svg, rect, circle)
import Svg.Attributes exposing (width, height, viewBox, x, y, rx, ry, cx, cy, r, fill)
```

コードの先頭で、2 つのモジュール Svg と Svg.Attributes をインポートしました。
これらは Elm が公式に提供しているパッケージ elm/svg に含まれています。

<a href="https://package.elm-lang.org/packages/elm/svg/latest/" target="_blank">
    svg 1.0.1<span>Elm Packages</span>
</a>

この記事のサンプルコードは、リンク先のサンプルコードをより分かりやすくなるように書き直したものです。

### main 関数の初期化

Svg の関数は Html と同様に扱うことができます。

```Elm
main : Svg msg
main =
    svg
        [ width "120"
        , height "120"
        , viewBox "0 0 120 120"
        ]
        []
```

svg の第一引数には width, height, viewBox を指定しました。

| 属性    | 説明                               |
| ------- | ---------------------------------- |
| width   | 画像の "幅 (px)"                   |
| height  | 画像の "高さ (px)"                 |
| viewBox | 描画領域の "x 座標 y 座標 幅 高さ" |

viewBox は見慣れない属性かもしれません。
この領域内に作成された図形が画面にレンダリングされます。

慣れるまでは、サンプルのように "0 0 (width に指定した値) (height に指定した値)" という指定が無難でしょう。
必要に応じて SVG の仕様や解説記事を検索してください。

<a href="https://triple-underscore.github.io/SVG11/struct.html#NewDocument" target="_blank">
    SVG 文書片を定義する： svg 要素<span>文書構造 – SVG 1.1 （第２版）</span>
</a>

### 四角形（矩形）を描く：rect

矩形は「くけい」と読みます。
これを知っていると、次は「矩計（かなばかり）図」が読めなくなります。

```Elm
rect
    [ x "10"
    , y "10"
    , width "100"
    , height "100"
    , rx "15"
    , ry "15"
    , fill "red"
    ]
    []
```

| 属性   | 説明                     |
| ------ | ------------------------ |
| x      | "x 座標 (px)"            |
| y      | "y 座標 (px)"            |
| width  | "幅 (px)"                |
| height | "高さ (px)"              |
| rx     | "角丸の x 軸半径　(px)"  |
| ry     | "角丸の y 軸半径　(px)"  |
| fill   | 塗りつぶし色の指定（色） |

<a href="https://triple-underscore.github.io/SVG11/shapes.html#RectElement" target="_blank">
    rect 要素<span>基本図形 – SVG 1.1 （第２版）</span>
</a>

### 円を描く：circle

```Elm
circle
    [ cx "50"
    , cy "50"
    , r "50"
    , fill "blue"
    ]
    []
```

| 属性 | 説明                     |
| ---- | ------------------------ |
| cx   | "中心の x 座標 (px)"     |
| cy   | "中心の y 座標 (px)"     |
| r    | "円の半径　(px)"         |
| fill | 塗りつぶし色の指定（色） |

楕円にしたいときは ellipse を使います。

<a href="https://triple-underscore.github.io/SVG11/shapes.html#CircleElement" target="_blank">
    circle 要素<span>基本図形 – SVG 1.1 （第２版）</span>
</a>

### そのほかの図形

パス・基本図形・テキストなどの要素と、様々なアトリビュートを組み合わせて、表現豊かな SVG を作成することができます。

<a href="https://triple-underscore.github.io/SVG11/paths.html" target="_blank">
    パス – SVG 1.1 （第２版）<span>https://triple-underscore.github.io</span>
</a>

<a href="https://triple-underscore.github.io/SVG11/shapes.html" target="_blank">
    基本図形 – SVG 1.1 （第２版）<span>https://triple-underscore.github.io</span>
</a>

<a href="https://triple-underscore.github.io/SVG11/text.html" target="_blank">
    テキスト – SVG 1.1 （第２版）<span>https://triple-underscore.github.io</span>
</a>

## 利用できる Elm のパッケージ

Elm Packages で使えそうなパッケージを探してみましょう。

<a href="https://package.elm-lang.org" target="_blank">
    Elm Packages<span>https://package.elm-lang.org</span>
</a>

### SVG の基本となるパッケージ

Elm では、SVG を扱うために 2 種類のパッケージが用意されています。

| パッケージ              | 説明                             |
| ----------------------- | -------------------------------- |
| elm/svg                 | Elm 公式の SVG パッケージ        |
| elm-community/typed-svg | 属性の型情報を付加したパッケージ |

どちらも SVG 用の基本的なモジュールを含み、互換性のあるパッケージです。
好みに応じて使い分けると良いでしょう。
データの可視化など、より複雑な SVG を扱う際には elm-community/typed-svg の使用をお薦めします。

### SVG の表現力を高めるパッケージ

より複雑な SVG を作成するためのパッケージも用意されています。
データの可視化（ビジュアライゼーション）や、ジェネラティブ・アートに挑戦してみるのも良いですね！

| パッケージ                  | 説明                                                        |
| --------------------------- | ----------------------------------------------------------- |
| gampleman/elm-visualization | D3.js に由来するデータ可視化用のライブラリ                  |
| terezka/line-charts         | グラフ / チャート用のパッケージ                             |
| gicentre/elm-vega           | Port を介して JavaScript の Vega を利用するためのパッケージ |

また、path を記述するためのパッケージは複数存在するようです。

| パッケージ                          | 説明                                                            |
| ----------------------------------- | --------------------------------------------------------------- |
| Spaxe/svg-pathd                     | d 属性を、M, L, Z などオリジナルの SVG と同様の記法で記述できる |
| folkertdev/svg-path-lowlevel        | d 属性を、SVG の記法よりも読みやすく宣言的に記述できる          |
| folkertdev/one-true-path-experiment | 配列から path を生成するためのパッケージ                        |

### 注意：廃止されたパッケージ

以下のパッケージは elm/svg よりも前に使用されていたもので、現在は廃止されています。
ブラウザの検索結果に出ることがあるので注意してください。

| パッケージ     | 説明 |
| -------------- | ---- |
| evancz/elm-svg | 廃止 |
| elm-lang/svg   | 廃止 |

## SVG は難しくない！

でしょ？
