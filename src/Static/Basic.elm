module Static.Basic exposing (main)

import Css exposing (..)
import Css.Global exposing (global)
import Css.Reset exposing (ress)
import Html.Styled exposing (Html, a, h1, li, main_, section, span, text, ul)
import Html.Styled.Attributes as Attributes exposing (css, href, name)
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
            ]
        ]
        [ topSection
            { title = "I'm belong to..."
            , children =
                [ ul []
                    [ linkView
                        { title = "株式会社 Siiibo"
                        , sub = "自由、透明、公正な直接金融を創造する"
                        , url = "https://siiibo.com"
                        }
                    , linkView
                        { title = "宇宙広報団体 TELSTAR"
                        , sub = "宇宙への興味を 0 → 1 へ"
                        , url = "http://spacemgz-telstar.com/"
                        }
                    ]
                ]
            }
        , topSection
            { title = "Blog posts"
            , children =
                [ ul []
                    (List.map
                        (\article ->
                            linkView
                                { title = article.title
                                , sub = dateString Time.utc article.createdAt
                                , url = article.url
                                }
                        )
                        preamble.articles
                    )
                ]
            }
        ]
    , siteFooter
    ]


topSection : { title : String, children : List (Html Never) } -> Html Never
topSection { title, children } =
    section
        [ css [ padding2 (px 30) zero ] ]
        (h1
            [ css
                [ paddingBottom (px 10)
                , fontSize (px 16)
                , lineHeight (int 1)
                ]
            ]
            [ text title ]
            :: children
        )


linkView :
    { title : String
    , sub : String
    , url : String
    }
    -> Html Never
linkView { title, sub, url } =
    li
        [ css
            [ listStyle none
            , nthChild "n+2"
                [ marginTop (px 5) ]
            ]
        ]
        [ a
            [ href url
            , Attributes.target <|
                case String.left 1 url of
                    "/" ->
                        "_self"

                    _ ->
                        "_blank"
            , css
                [ display block
                , padding (px 20)
                , textDecoration none
                , backgroundColor (hsl 0 0 0.95)
                , borderRadius (px 10)
                ]
            ]
            [ h1
                [ css
                    [ fontSize (px 16)
                    , lineHeight (num 1.5)
                    , color (hsl 0 0 0.2)
                    ]
                ]
                [ text title ]
            , span
                [ css
                    [ fontSize (px 13)
                    , lineHeight (int 1)
                    , color (hsl 0 0 0.4)
                    ]
                ]
                [ text sub ]
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
