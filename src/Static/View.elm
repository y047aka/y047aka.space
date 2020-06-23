module Static.View exposing (siteFooter, siteHeader)

import Css exposing (..)
import Css.Media as Media exposing (only, screen, withMedia)
import Html.Styled exposing (Html, a, footer, h1, header, p, text)
import Html.Styled.Attributes exposing (css, href)


siteHeader : Html Never
siteHeader =
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


siteFooter : Html Never
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
