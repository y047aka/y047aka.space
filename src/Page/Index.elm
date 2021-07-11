module Page.Index exposing (Data, Model, Msg, page)

import Css exposing (..)
import Css.Extra exposing (orNoStyle, palette)
import Css.Media as Media exposing (only, screen, withMedia)
import Css.Palette exposing (button, buttonOnHover)
import DataSource exposing (DataSource)
import Head
import Head.Seo as Seo
import Html
import Html.Styled exposing (Html, a, h1, li, section, span, text, toUnstyled, ul)
import Html.Styled.Attributes as Attributes exposing (css, href, rel)
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import View exposing (View)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    {}


page : Page RouteParams Data
page =
    Page.single
        { head = head
        , data = data
        }
        |> Page.buildNoState { view = view }


data : DataSource Data
data =
    DataSource.succeed ()


head : StaticPayload Data RouteParams -> List Head.Tag
head static =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "y047aka.space"
        , image =
            { url = Pages.Url.external "TODO"
            , alt = "elm-pages logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "TODO"
        , locale = Nothing
        , title = "TODO title" -- metadata.title -- TODO
        }
        |> Seo.website


type alias Data =
    ()


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = "y047aka.space"
    , body =
        [ topSection
            { title = "Elm"
            , children =
                [ ul [] <|
                    List.map siteSummary
                        [ { name = "elm-articles"
                          , url = "https://elm-articles.vercel.app"
                          }
                        ]
                ]
            }
        , topSection
            { title = "MotorSports"
            , children =
                [ ul [] <|
                    List.map siteSummary
                        [ { name = "MotorSportsCalendar 2020"
                          , url = "https://y047aka.github.io/MotorSportsCalendar/"
                          }
                        ]
                ]
            }
        ]
    }


topSection : { title : String, children : List (Html msg) } -> Html msg
topSection { title, children } =
    section
        [ css
            [ width (px 620)
            , margin2 zero auto
            , padding2 (px 25) zero
            , withMedia [ only screen [ Media.maxWidth (px 480) ] ]
                [ width (pct 100)
                , padding (px 15)
                ]
            ]
        ]
        (h1
            [ css
                [ paddingBottom (px 10)
                , fontFamilies [ qt "Saira", sansSerif.value ]
                , fontSize (px 16)
                , fontWeight (int 500)
                , lineHeight (int 1)
                ]
            ]
            [ text title ]
            :: children
        )


siteSummary : { name : String, url : String } -> Html msg
siteSummary { name, url } =
    li
        [ css
            [ listStyle none
            , nthChild "n+2"
                [ marginTop (px 5) ]
            ]
        ]
        [ linkToSite url
            [ title_ name
            , span
                [ css
                    [ fontSize (px 13)
                    , lineHeight (int 1)
                    , orNoStyle button.optionalColor color
                    ]
                ]
                [ text url ]
            ]
        ]


linkToSite : String -> List (Html msg) -> Html msg
linkToSite url contents =
    a
        [ href url
        , Attributes.target "_blank"
        , rel "noopener"
        , css
            [ display block
            , padding (px 20)
            , withMedia [ only screen [ Media.maxWidth (px 480) ] ]
                [ padding (px 15) ]
            , textDecoration none
            , borderRadius (px 10)
            , palette button
            , hover
                [ palette buttonOnHover ]
            ]
        ]
        contents


title_ : String -> Html msg
title_ str =
    h1
        [ css
            [ fontSize (px 16)
            , fontWeight (int 600)
            , lineHeight (num 1.5)
            ]
        ]
        [ text str ]
