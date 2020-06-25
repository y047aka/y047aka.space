module Markdown.Customized exposing (markdownToHtml)

import Color.Palette exposing (textLink, textLinkVisited)
import Css exposing (..)
import Css.Extra exposing (palette)
import Css.Global exposing (a, adjacentSiblings, blockquote, children, code, descendants, details, dl, each, h1, h2, h3, h4, h5, h6, hr, img, li, ol, p, selector, td, th, tr, ul)
import Html.Styled as Html exposing (Attribute, Html, div, text)
import Html.Styled.Attributes as Attr exposing (css, rel, target)
import Json.Encode exposing (null)
import Markdown.Html exposing (withAttribute)
import Markdown.Parser exposing (deadEndToString)
import Markdown.Renderer exposing (Renderer)
import Markdown.Renderer.Styled exposing (styledRenderer)
import Svg.Styled as Svg
import Svg.Styled.Attributes


markdownToHtml : List (Attribute msg) -> String -> Html msg
markdownToHtml attributes markdown =
    let
        deadEndsToString deadEnds =
            deadEnds
                |> List.map deadEndToString
                |> String.join "\n"
    in
    case
        markdown
            |> Markdown.Parser.parse
            |> Result.mapError deadEndsToString
            |> Result.andThen (\ast -> Markdown.Renderer.render customRenderer ast)
    of
        Ok rendered ->
            Html.div (css markdownStyles :: attributes) rendered

        Err errors ->
            text errors


isInternalLink : String -> Bool
isInternalLink url =
    let
        isProduction =
            String.startsWith url "https://y047aka.space"

        isLocalDevelopment =
            String.startsWith url "http://localhost:3000"
    in
    isProduction || isLocalDevelopment


isExternalLink : String -> Bool
isExternalLink url =
    not <| isInternalLink url


customRenderer : Renderer (Html msg)
customRenderer =
    { styledRenderer
        | link =
            \link content ->
                Html.a
                    ([ Attr.href link.destination
                     , case link.title of
                        Just title ->
                            Attr.title title

                        Nothing ->
                            Attr.property "none" null
                     ]
                        ++ (if isExternalLink link.destination then
                                [ Attr.target "_blank", rel "noopener" ]

                            else
                                []
                           )
                    )
                    content
        , html =
            Markdown.Html.oneOf
                [ Markdown.Html.tag "s"
                    (\children -> Html.s [] children)
                , Markdown.Html.tag "table"
                    (\children -> Html.table [] children)
                , Markdown.Html.tag "tr"
                    (\children -> Html.tr [] children)
                , Markdown.Html.tag "th"
                    (\children -> Html.th [] children)
                , Markdown.Html.tag "td"
                    (\children -> Html.td [] children)
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
    }


{-| Implemented with reference to [github-markdown-css](https://github.com/sindresorhus/github-markdown-css).
-}
markdownStyles : List Style
markdownStyles =
    [ paddingTop (px 20)
    , lineHeight (num 1.8)
    , property "word-wrap" "break-word"
    , descendants
        [ a
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
        , Css.Global.table
            [ borderSpacing zero
            , borderCollapse collapse
            ]
        , each [ th, td ]
            [ padding zero ]
        , each
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
        , hr
            [ height zero
            , padding zero
            , margin2 (px 24) zero
            , borderTopWidth (px 1)
            , borderStyle solid
            , borderColor (hex "#e1e4e8")
            ]
        , blockquote
            [ paddingLeft (em 1)
            , borderWidth zero
            , borderLeftWidth (em 0.25)
            , borderStyle solid
            , color (hex "#6a737d")
            , borderColor (hex "#dfe2e5")
            ]
        , each [ h1, h2, h3, h4, h5, h6 ]
            [ fontWeight (int 600)
            , nthChild "n+2"
                [ marginTop (px 29) ]
            ]
        , h1
            [ margin2 (px 28) zero
            , padding2 (px 17) zero
            , fontSize (em 1.125)
            , lineHeight (num 1.333)
            , textAlign center
            , borderTop2 (px 1) solid
            , borderBottom2 (px 1) solid
            ]
        , h2
            [ marginTop (px 2)
            , marginBottom (px 31)
            , fontSize (em 1.25)
            , lineHeight (num 1.25)
            ]
        , h3
            [ fontSize (em 1) ]
        , h4
            [ fontSize (em 1) ]
        , h5
            [ fontSize (em 0.875) ]
        , h6
            [ fontSize (em 0.85)
            , color (hex "#6a737d")
            ]
        , each [ ol, ul ]
            [ paddingLeft (em 2) ]
        , li
            [ children
                [ p [ marginTop (px 16) ] ]
            , nthChild "n+2"
                [ marginTop (em 0.25) ]
            ]
        , Css.Global.table
            [ display block
            , width (pct 100)
            , overflow auto
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
        , img
            [ maxWidth (pct 100) ]
        , each [ code, Css.Global.pre ]
            [ fontFamilies [ qt "SFMono-Regular", qt "Consolas", qt "Liberation Mono", qt "Menlo", monospace.value ]
            , fontSize (px 12)
            ]
        , code
            [ padding2 (em 0.2) (em 0.4)
            , margin zero
            , fontSize (pct 85)
            , backgroundColor (rgba 27 31 35 0.05)
            , borderRadius (px 3)
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
