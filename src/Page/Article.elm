module Page.Article exposing (view)

import Css exposing (..)
import Css.Extra exposing (orNoStyle)
import Css.Global exposing (children)
import Css.Media as Media exposing (only, screen, withMedia)
import Css.Palette as Palette
import Date exposing (Date)
import Html.Styled exposing (Html, div, h1, header, text)
import Html.Styled.Attributes exposing (css)
import Metadata exposing (ArticleMetadata)


view : ArticleMetadata -> Html msg -> { title : String, body : List (Html msg) }
view metadata viewForPage =
    { title = metadata.title
    , body =
        [ div
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
                    [ text metadata.title ]
                , div
                    [ css
                        [ orNoStyle Palette.default.optionalColor color
                        , children
                            [ Css.Global.p
                                [ padding2 (px 5) zero
                                , fontSize (px 14)
                                , lineHeight (int 1)
                                ]
                            ]
                        ]
                    ]
                    [ publishedDateView metadata ]
                ]
            , viewForPage
            ]
        ]
    }


publishedDateView : { a | published : Date } -> Html msg
publishedDateView metadata =
    text (Date.format "MMMM ddd, yyyy" metadata.published)
