module Layout exposing (view)

import Css exposing (..)
import Css.Media as Media exposing (only, screen, withMedia)
import Html.Styled exposing (Html, a, footer, h1, header, main_, p, text)
import Html.Styled.Attributes exposing (css, href)
import Metadata exposing (Metadata)
import Pages
import Pages.PagePath exposing (PagePath)


view :
    { title : String, body : List (Html msg) }
    -> { path : PagePath Pages.PathKey, frontmatter : Metadata }
    -> { title : String, body : List (Html msg) }
view document page =
    { title = document.title
    , body =
        [ siteHeader page.path
        , main_ [] document.body
        , siteFooter
        ]
    }


siteHeader : PagePath Pages.PathKey -> Html msg
siteHeader currentPath =
    header []
        [ h1
            [ css
                [ display block
                , width (px 620)
                , margin2 zero auto
                , padding2 (px 20) zero
                , withMedia [ only screen [ Media.maxWidth (px 480) ] ]
                    [ width (pct 100)
                    , padding (px 15)
                    ]
                , fontFamilies [ qt "Saira", sansSerif.value ]
                , fontSize (px 18)
                , fontWeight normal
                ]
            ]
            [ a
                [ href "/"
                , css
                    [ textDecoration none
                    , color inherit
                    ]
                ]
                [ text "y047aka.space" ]
            ]
        ]


siteFooter : Html msg
siteFooter =
    footer []
        [ p
            [ css
                [ display block
                , width (px 620)
                , margin2 zero auto
                , padding2 (px 20) zero
                , withMedia [ only screen [ Media.maxWidth (px 480) ] ]
                    [ width (pct 100)
                    , padding (px 15)
                    ]
                , textAlign right
                , fontFamilies [ qt "Saira", sansSerif.value ]
                , fontSize (px 14)
                ]
            ]
            [ text "© 2020 y047aka" ]
        ]
