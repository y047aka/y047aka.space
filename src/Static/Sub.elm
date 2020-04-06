module Static.Sub exposing (main)

import Css exposing (..)
import Html.Styled exposing (Html, a, fromUnstyled, h2, main_, nav, text)
import Html.Styled.Attributes exposing (class, css, href)
import Json.Decode as D exposing (Decoder)
import Markdown
import Siteelm.Html.Styled as Html
import Siteelm.Html.Styled.Attributes exposing (rel)
import Siteelm.Page exposing (Page, page)
import Static.View exposing (siteFooter, siteHeader, viewArticle)


main : Page Preamble
main =
    page
        { decoder = preambleDecoder
        , head = viewHead
        , body = viewBody
        }


type alias Preamble =
    { title : String
    }


preambleDecoder : Decoder Preamble
preambleDecoder =
    D.map Preamble
        (D.field "title" D.string)


viewHead : Preamble -> String -> List (Html Never)
viewHead preamble _ =
    [ Html.title [] (preamble.title ++ " | y047aka.space")
    , Html.link [ rel "stylesheet", href "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.15.10/styles/default.min.css" ]
    , Html.script "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.15.10/highlight.min.js" ""
    , Html.script "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.15.10/languages/elm.min.js" ""
    , Html.script "" "hljs.initHighlightingOnLoad();"
    ]


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
        [ nav []
            [ a [ href "/", class "prev" ] [ text "home" ]
            ]
        , h2 [] [ text preamble.title ]
        , viewArticle []
            [ fromUnstyled <|
                Markdown.toHtmlWith markdownOptions [] body
            ]
        ]
    , siteFooter
    ]


markdownOptions : Markdown.Options
markdownOptions =
    { githubFlavored = Just { tables = True, breaks = False }
    , defaultHighlighting = Nothing
    , sanitize = False
    , smartypants = False
    }
