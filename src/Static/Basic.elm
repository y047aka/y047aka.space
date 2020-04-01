module Static.Basic exposing (main)

import Css exposing (auto, margin2, padding2, px, width, zero)
import Css.Global exposing (global)
import Css.Reset exposing (ress)
import Html.Styled exposing (Html, a, div, h2, li, main_, text, ul)
import Html.Styled.Attributes exposing (class, css, href, name)
import Json.Decode as D exposing (Decoder)
import Siteelm.Html.Styled as Html
import Siteelm.Html.Styled.Attributes exposing (charset, content, rel)
import Siteelm.Page exposing (Page, page)
import Static.View exposing (siteFooter, siteHeader)


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
    , date : String
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
    D.map3 Article
        (D.field "url" D.string)
        (D.field "title" D.string)
        (D.field "date" D.string)


{-| Make contents inside the _head_ tag.
-}
viewHead : Preamble -> String -> List (Html Never)
viewHead preamble _ =
    [ Html.meta [ charset "utf-8" ]
    , Html.title [] (preamble.title ++ " | y047aka.space")
    , Html.meta [ name "description", content "this is a simple static site generator for elm" ]
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
        [ div []
            [ h2 [] [ text "get preambles in a directory" ]
            , div [ class "inner" ]
                [ div []
                    [ text "Use \"preamblesIn\" parameter to get preambles of files in a specified directory."
                    ]
                , div []
                    [ text "Be aware that there are some parameters which Siteelm automatically sets in an preamble. At the moment, a property \"url\" is that."
                    ]
                , ul []
                    (List.map
                        viewArticle
                        preamble.articles
                    )
                ]
            ]
        ]
    , siteFooter
    ]


viewArticle : Article -> Html Never
viewArticle article =
    li []
        [ a [ href article.url ]
            [ text article.title
            ]
        ]
