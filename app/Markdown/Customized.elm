module Markdown.Customized exposing (markdownStyles, markdownToHtml, renderer)

import Css exposing (..)
import Css.Extra exposing (palette)
import Css.Global exposing (adjacentSiblings, blockquote, children, code, descendants, details, dl, each, ol, p, selector, td, th, tr, ul)
import Css.Palette exposing (textLink, textLinkVisited)
import Html.Styled as Html exposing (Attribute, Html, a, h1, h2, h3, h4, h5, h6, hr, text)
import Html.Styled.Attributes as Attr exposing (css, rel)
import Markdown.Block as Block exposing (Alignment(..), HeadingLevel, ListItem(..), Task(..))
import Markdown.Html exposing (withAttribute)
import Markdown.Parser exposing (deadEndToString)
import Markdown.Renderer exposing (Renderer)
import Svg.Styled as Svg
import Svg.Styled.Attributes


markdownToHtml : List (Attribute msg) -> String -> Html msg
markdownToHtml attributes markdown =
    case
        markdown
            |> Markdown.Parser.parse
            |> Result.mapError (\error -> error |> List.map deadEndToString |> String.join "\n")
            |> Result.andThen (\ast -> Markdown.Renderer.render renderer ast)
    of
        Ok rendered ->
            Html.div (css markdownStyles :: attributes) rendered

        Err errors ->
            text errors


renderer : Renderer (Html msg)
renderer =
    { heading = headingRenderer
    , paragraph = Html.p []
    , hardLineBreak = Html.br [] []
    , blockQuote = blockQuoteRenderer
    , strong = Html.strong []
    , emphasis = Html.em []
    , strikethrough = Html.del []
    , codeSpan = codeSpanRenderer
    , link = linkRenderer
    , image = imageRenderer
    , text = Html.text
    , unorderedList = unorderedListRenderer
    , orderedList = orderedListRenderer
    , html = htmlRenderer
    , codeBlock = codeBlockRenderer
    , thematicBreak = thematicBreakRenderer
    , table = tableRenderer
    , tableHeader = Html.thead []
    , tableBody = Html.tbody []
    , tableRow = Html.tr []
    , tableHeaderCell =
        \maybeAlignment ->
            let
                attrs =
                    maybeAlignment
                        |> Maybe.map (\alignment -> alignmentStyle alignment)
                        |> Maybe.map List.singleton
                        |> Maybe.withDefault []
            in
            Html.th [ css attrs ]
    , tableCell =
        \maybeAlignment ->
            let
                attrs =
                    maybeAlignment
                        |> Maybe.map (\alignment -> alignmentStyle alignment)
                        |> Maybe.map List.singleton
                        |> Maybe.withDefault []
            in
            Html.td [ css attrs ]
    }


headingRenderer : { level : HeadingLevel, rawText : String, children : List (Html msg) } -> Html msg
headingRenderer { level, children } =
    let
        commonStyles =
            [ fontWeight (int 600)
            , nthChild "n+2"
                [ marginTop (px 29) ]
            ]
    in
    case level of
        Block.H1 ->
            Html.styled h1
                [ batch commonStyles
                , margin2 (px 28) zero
                , padding2 (px 17) zero
                , fontSize (em 1.125)
                , lineHeight (num 1.333)
                , textAlign center
                , borderTop2 (px 1) solid
                , borderBottom2 (px 1) solid
                ]
                []
                children

        Block.H2 ->
            Html.styled h2
                [ batch commonStyles
                , marginTop (px 2)
                , marginBottom (px 31)
                , fontSize (em 1.25)
                , lineHeight (num 1.25)
                ]
                []
                children

        Block.H3 ->
            Html.styled h3
                [ batch commonStyles
                , fontSize (em 1)
                ]
                []
                children

        Block.H4 ->
            Html.styled h4
                [ batch commonStyles
                , fontSize (em 1)
                ]
                []
                children

        Block.H5 ->
            Html.styled h5
                [ batch commonStyles
                , fontSize (em 0.875)
                ]
                []
                children

        Block.H6 ->
            Html.styled h6
                [ batch commonStyles
                , fontSize (em 0.85)
                , color (hex "#6a737d")
                ]
                []
                children


blockQuoteRenderer : List (Html msg) -> Html msg
blockQuoteRenderer =
    Html.styled Html.blockquote
        [ paddingLeft (em 1)
        , borderWidth zero
        , borderLeftWidth (em 0.25)
        , borderStyle solid
        , color (hex "#6a737d")
        , borderColor (hex "#dfe2e5")
        ]
        []


codeSpanRenderer : String -> Html msg
codeSpanRenderer content =
    Html.styled Html.code
        [ padding2 (em 0.2) (em 0.4)
        , margin zero
        , fontSize (pct 85)
        , backgroundColor (rgba 27 31 35 0.05)
        , borderRadius (px 3)
        ]
        []
        [ Html.text content ]


linkRenderer : { title : Maybe String, destination : String } -> List (Html msg) -> Html msg
linkRenderer { title, destination } =
    let
        externalLinkAttrs =
            if isExternalLink destination then
                [ Attr.target "_blank", rel "noopener" ]

            else
                []

        titleAttrs =
            title
                |> Maybe.map (\title_ -> [ Attr.title title_ ])
                |> Maybe.withDefault []
    in
    Html.styled a
        [ whiteSpace preWrap
        , textDecoration none
        , palette textLink
        , hover
            [ textDecoration underline ]
        , visited
            [ palette textLinkVisited ]
        , Css.Global.withAttribute "target=_blank"
            [ after
                [ property "content" (qt "\\f35d")
                , position relative
                , top (px -1)
                , display inlineBlock
                , padding2 zero (px 5)
                , fontFamilies [ qt "Font Awesome 5 Free" ]
                , fontSize (px 12)
                , fontWeight (int 900)
                , textDecoration none
                , color inherit
                ]
            , visited
                [ after
                    [ palette textLinkVisited ]
                ]
            ]
        ]
        (Attr.href destination :: externalLinkAttrs ++ titleAttrs)


isExternalLink : String -> Bool
isExternalLink url =
    let
        isProduction =
            String.startsWith url "https://y047aka.space"

        isLocalDevelopment =
            String.startsWith url "http://localhost:3000"
    in
    not (isProduction || isLocalDevelopment)


imageRenderer : { alt : String, src : String, title : Maybe String } -> Html msg
imageRenderer imageInfo =
    case imageInfo.title of
        Just title ->
            Html.img
                [ Attr.src imageInfo.src
                , Attr.alt imageInfo.alt
                , Attr.title title
                , css [ maxWidth (pct 100) ]
                ]
                []

        Nothing ->
            Html.img
                [ Attr.src imageInfo.src
                , Attr.alt imageInfo.alt
                , css [ maxWidth (pct 100) ]
                ]
                []


unorderedListRenderer : List (ListItem (Html msg)) -> Html msg
unorderedListRenderer items =
    let
        listItem (Block.ListItem task_ children) =
            Html.li
                [ css
                    [ nthChild "n+2"
                        [ marginTop (em 0.25) ]
                    , Css.Global.children
                        [ p [ marginTop (px 16) ] ]
                    ]
                ]
                (checkbox task_ :: children)

        checkbox task =
            case task of
                Block.NoTask ->
                    Html.text ""

                Block.IncompleteTask ->
                    Html.input
                        [ Attr.disabled True
                        , Attr.checked False
                        , Attr.type_ "checkbox"
                        ]
                        []

                Block.CompletedTask ->
                    Html.input
                        [ Attr.disabled True
                        , Attr.checked True
                        , Attr.type_ "checkbox"
                        ]
                        []
    in
    Html.ul [ css [ paddingLeft (em 2) ] ]
        (List.map listItem items)


orderedListRenderer : Int -> List (List (Html msg)) -> Html msg
orderedListRenderer startingIndex items =
    let
        listItem itemBlocks =
            Html.styled Html.li
                [ children
                    [ p [ marginTop (px 16) ] ]
                , nthChild "n+2"
                    [ marginTop (em 0.25) ]
                ]
                []
                itemBlocks
    in
    Html.styled Html.ol
        [ paddingLeft (em 2) ]
        (case startingIndex of
            1 ->
                [ Attr.start startingIndex ]

            _ ->
                []
        )
        (List.map listItem items)


htmlRenderer : Markdown.Html.Renderer (List (Html msg) -> Html msg)
htmlRenderer =
    Markdown.Html.oneOf
        [ Markdown.Html.tag "s"
            (\children -> Html.s [] children)
        , Markdown.Html.tag "svg"
            (\w h viewBox children ->
                Svg.svg
                    [ Svg.Styled.Attributes.width w
                    , Svg.Styled.Attributes.height h
                    , Svg.Styled.Attributes.viewBox viewBox
                    ]
                    children
            )
            |> withAttribute "width"
            |> withAttribute "height"
            |> withAttribute "viewbox"
        , Markdown.Html.tag "circle"
            (\cx cy r fill children ->
                Svg.circle
                    [ Svg.Styled.Attributes.cx cx
                    , Svg.Styled.Attributes.cy cy
                    , Svg.Styled.Attributes.r r
                    , Svg.Styled.Attributes.fill fill
                    ]
                    children
            )
            |> withAttribute "cx"
            |> withAttribute "cy"
            |> withAttribute "r"
            |> withAttribute "fill"
        , Markdown.Html.tag "rect"
            (\x y w h rx ry fill children ->
                Svg.rect
                    [ Svg.Styled.Attributes.x x
                    , Svg.Styled.Attributes.y y
                    , Svg.Styled.Attributes.width w
                    , Svg.Styled.Attributes.height h
                    , Svg.Styled.Attributes.rx rx
                    , Svg.Styled.Attributes.ry ry
                    , Svg.Styled.Attributes.fill fill
                    ]
                    children
            )
            |> withAttribute "x"
            |> withAttribute "y"
            |> withAttribute "width"
            |> withAttribute "height"
            |> withAttribute "rx"
            |> withAttribute "ry"
            |> withAttribute "fill"
        ]


codeBlockRenderer : { body : String, language : Maybe String } -> Html msg
codeBlockRenderer { body } =
    Html.pre []
        [ Html.code [] [ text body ] ]


thematicBreakRenderer : Html msg
thematicBreakRenderer =
    Html.styled hr
        [ height zero
        , padding zero
        , margin2 (px 24) zero
        , borderTopWidth (px 1)
        , borderStyle solid
        , borderColor (hex "#e1e4e8")
        ]
        []
        []


tableRenderer : List (Html msg) -> Html msg
tableRenderer =
    Html.styled Html.table
        [ display block
        , width (pct 100)
        , overflow auto
        , borderSpacing zero
        , borderCollapse collapse
        , descendants
            [ th
                [ fontWeight (int 600) ]
            , each [ th, td ]
                [ padding2 (px 6) (px 13)
                , border3 (px 1) solid (hex "#dfe2e5")
                ]
            , tr
                [ backgroundColor (hex "#fff")
                , borderTop3 (px 1) solid (hex "#c6cbd1")
                , nthChild "2n"
                    [ backgroundColor (hex "#f6f8fa") ]
                ]
            ]
        ]
        []


alignmentStyle : Alignment -> Style
alignmentStyle alignment =
    textAlign <|
        case alignment of
            AlignLeft ->
                left

            AlignCenter ->
                center

            AlignRight ->
                right


{-| Implemented with reference to [github-markdown-css](https://github.com/sindresorhus/github-markdown-css).
-}
markdownStyles : List Style
markdownStyles =
    [ paddingTop (px 20)
    , lineHeight (num 1.8)
    , property "word-wrap" "break-word"
    , descendants
        [ each
            [ selector "ol ol"
            , selector "ul ol"
            ]
            [ listStyleType lowerRoman ]
        , each
            [ selector "ol ol ol"
            , selector "ol ul ol"
            , selector "ul ol ol"
            , selector "ul ul ol"
            ]
            [ listStyleType lowerAlpha ]
        , each
            [ blockquote
            , details
            , dl
            , ol
            , p
            , Css.Global.pre
            , Css.Global.table
            , ul
            ]
            [ adjacentSiblings
                [ each
                    [ blockquote
                    , details
                    , dl
                    , ol
                    , p
                    , Css.Global.pre
                    , Css.Global.table
                    , ul
                    ]
                    [ marginTop (px 29) ]
                ]
            ]
        , each [ code, Css.Global.pre ]
            [ fontFamilies [ qt "SFMono-Regular", qt "Consolas", qt "Liberation Mono", qt "Menlo", monospace.value ]
            , fontSize (px 12)
            ]
        , Css.Global.pre
            [ property "word-wrap" "normal"
            , children
                [ code
                    [ padding zero
                    , margin zero
                    , fontSize (pct 100)
                    , property "word-break" "normal"
                    , whiteSpace pre
                    , property "background" "transparent"
                    , border zero
                    ]
                ]
            ]
        , Css.Global.pre
            [ padding (px 16)
            , overflow auto
            , fontSize (pct 85)
            , lineHeight (num 1.45)
            , backgroundColor (hex "#f6f8fa")
            , borderRadius (px 3)
            , descendants
                [ code
                    [ display inline
                    , property "max-width" "auto"
                    , padding zero
                    , margin zero
                    , overflow visible
                    , lineHeight inherit
                    , property "word-wrap" "normal"
                    , backgroundColor initial
                    , border zero
                    ]
                ]
            ]
        ]
    ]
