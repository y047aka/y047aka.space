module Static.Sub exposing (main)

import Color.Palette exposing (basic)
import Css exposing (..)
import Css.Extra exposing (orNoStyle)
import Css.Global exposing (children)
import Css.Media as Media exposing (only, screen, withMedia)
import DateFormat exposing (dayOfMonthSuffix, format, monthNameFull, yearNumber)
import Html.Styled exposing (Html, div, fromUnstyled, h1, header, main_, p, text)
import Html.Styled.Attributes exposing (css, href, name)
import Iso8601
import Json.Decode as D exposing (Decoder)
import Markdown
import Siteelm.Html.Styled as Html
import Siteelm.Html.Styled.Attributes as Attributes exposing (rel)
import Siteelm.Ogp as Ogp
import Siteelm.Page exposing (Page, page)
import Static.View exposing (siteFooter, siteHeader, viewArticle)
import Time exposing (Posix, Zone)
import Url.Builder exposing (crossOrigin)


main : Page Preamble
main =
    page
        { decoder = preambleDecoder
        , head = viewHead
        , body = viewBody
        }


type alias Preamble =
    { title : String
    , createdAt : Posix
    , updatedAt : Maybe Posix
    }


preambleDecoder : Decoder Preamble
preambleDecoder =
    D.map3 Preamble
        (D.field "title" D.string)
        (D.field "createdAt" Iso8601.decoder)
        (D.field "updatedAt" (D.nullable Iso8601.decoder))


viewHead : Preamble -> String -> List (Html Never)
viewHead preamble _ =
    let
        title =
            preamble.title ++ " | y047aka.space"

        siteUrl =
            "https://y047aka.space"

        description =
            "My Tanuki logo symbolizes this with a smart animal that works in a group to achieve a common goal."

        imageUrl =
            crossOrigin siteUrl [ "assets", "M3fRFrmf.jpg" ] []
    in
    [ Html.title [] title
    , Html.link [ rel "canonical", href siteUrl ]
    , Html.meta [ name "description", Attributes.content description ]
    , Ogp.title title
    , Ogp.type_ "article"
    , Ogp.url siteUrl
    , Ogp.image imageUrl
    , Ogp.siteName "y047aka.space"
    , Ogp.description description
    , Ogp.locale "ja_JP"
    , Ogp.twitterCard "summary"
    , Ogp.twitterSite "@y047aka"
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
            , withMedia [ only screen [ Media.maxWidth (px 480) ] ]
                [ width (pct 100)
                , padding (px 15)
                ]
            ]
        ]
        [ header []
            [ h1
                [ css
                    [ padding2 (px 5) zero
                    , fontFamilies [ qt "-apple-system", sansSerif.value ]
                    , fontSize (px 24)
                    , fontWeight (int 600)
                    ]
                ]
                [ text preamble.title ]
            , div
                [ css
                    [ color |> orNoStyle basic.optionalColor
                    , children
                        [ Css.Global.p
                            [ padding2 (px 5) zero
                            , fontSize (px 14)
                            , lineHeight (int 1)
                            ]
                        ]
                    ]
                ]
                [ p []
                    [ text "Posted: "
                    , text (dateString Time.utc preamble.createdAt)
                    ]
                , p []
                    [ text "Updated: "
                    , text
                        (preamble.updatedAt
                            |> Maybe.map (dateString Time.utc)
                            |> Maybe.withDefault ""
                        )
                    ]
                ]
            ]
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


dateString : Zone -> Posix -> String
dateString =
    format
        [ monthNameFull
        , DateFormat.text " "
        , dayOfMonthSuffix
        , DateFormat.text ", "
        , yearNumber
        ]
