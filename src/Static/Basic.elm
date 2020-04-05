module Static.Basic exposing (main)

import Css exposing (..)
import Css.Global exposing (global)
import Css.Reset exposing (ress)
import Html.Styled exposing (Html, a, h1, li, main_, span, text, ul)
import Html.Styled.Attributes exposing (css, href, name)
import Iso8601
import Json.Decode as D exposing (Decoder)
import Siteelm.Html.Styled as Html
import Siteelm.Html.Styled.Attributes as Attributes exposing (charset, content, rel)
import Siteelm.Page exposing (Page, page)
import Static.View exposing (siteFooter, siteHeader)
import Time exposing (Month(..), Posix, Zone)


main : Page Preamble
main =
    page
        { decoder = preambleDecoder
        , head = viewHead
        , body = viewBody
        }


{-| Preamble is what you write on the head of the content files.
-}
type alias Preamble =
    { title : String
    , articles : List Article
    }


type alias Article =
    { url : String
    , title : String
    , createdAt : Posix
    , updatedAt : Maybe Posix

    -- Result (List DeadEnd) Posix
    }


{-| Preamble is passed as a JSON string. So it requires a decoder.
-}
preambleDecoder : Decoder Preamble
preambleDecoder =
    D.map2 Preamble
        (D.field "title" D.string)
        (D.field "articles" (D.list articleDecoder))


articleDecoder : Decoder Article
articleDecoder =
    D.map4 Article
        (D.field "url" D.string)
        (D.field "title" D.string)
        (D.field "createdAt" Iso8601.decoder)
        (D.field "updatedAt" (D.nullable Iso8601.decoder))


{-| Make contents inside the _head_ tag.
-}
viewHead : Preamble -> String -> List (Html Never)
viewHead preamble _ =
    [ Html.meta [ charset "utf-8" ]
    , Html.title [] (preamble.title ++ " | y047aka.space")
    , Html.meta [ name "description", Attributes.content "this is a simple static site generator for elm" ]
    , Html.link [ rel "stylesheet", href "https://fonts.googleapis.com/css2?family=Saira:wght@400;700&display=swap" ]
    , Html.link [ rel "stylesheet", href "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.15.10/styles/default.min.css" ]
    , Html.script "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.15.10/highlight.min.js" ""
    , Html.script "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.15.10/languages/elm.min.js" ""
    , Html.script "" "hljs.initHighlightingOnLoad();"
    , global ress
    ]


{-| Make contents inside the _body_ tag. The parameter "body" is usually something like markdown.
-}
viewBody : Preamble -> String -> List (Html Never)
viewBody preamble body =
    [ siteHeader
    , main_
        [ css
            [ width (px 620)
            , margin2 zero auto
            , padding2 (px 20) zero
            ]
        ]
        [ viewArticles preamble.articles ]
    , siteFooter
    ]


viewArticles : List Article -> Html Never
viewArticles articles =
    ul []
        (List.map
            viewArticle
            articles
        )


viewArticle : Article -> Html Never
viewArticle article =
    li
        [ css
            [ listStyle none
            , nthChild "n+1"
                [ marginTop (px 15) ]
            ]
        ]
        [ a
            [ href article.url
            , css
                [ display block
                , padding (px 20)
                , textDecoration none
                , backgroundColor (hsl 0 0 0.95)
                , borderRadius (px 15)
                ]
            ]
            [ h1
                [ css
                    [ fontSize (px 17)
                    , fontWeight bold
                    , lineHeight (num 1.5)
                    , color (hsl 0 0 0.2)
                    ]
                ]
                [ text article.title ]
            , span
                [ css
                    [ fontSize (px 13)
                    , lineHeight (int 1)
                    , color (hsl 0 0 0.4)
                    ]
                ]
                [ text (dateString Time.utc article.createdAt)
                ]
            ]
        ]


dateString : Zone -> Posix -> String
dateString zone posix =
    let
        year =
            Time.toYear zone posix
                |> String.fromInt

        month =
            Time.toMonth zone posix
                |> monthToString

        day =
            Time.toDay zone posix
                |> String.fromInt
    in
    month ++ " " ++ day ++ ", " ++ year


monthToString : Month -> String
monthToString month =
    case month of
        Jan ->
            "Jan"

        Feb ->
            "Feb"

        Mar ->
            "Mar"

        Apr ->
            "Apr"

        May ->
            "May"

        Jun ->
            "Jun"

        Jul ->
            "Jul"

        Aug ->
            "Aug"

        Sep ->
            "Sep"

        Oct ->
            "Oct"

        Nov ->
            "Nov"

        Dec ->
            "Dec"
