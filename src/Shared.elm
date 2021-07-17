module Shared exposing (Data, Model, Msg(..), SharedMsg(..), template)

import Browser.Navigation
import Css exposing (..)
import Css.Extra exposing (palette)
import Css.Global exposing (global)
import Css.Media as Media exposing (only, screen, withMedia)
import Css.Palette as Palette
import Css.Reset exposing (ress)
import DataSource
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, href)
import Pages.Flags
import Pages.PageUrl exposing (PageUrl)
import Path exposing (Path)
import SharedTemplate exposing (SharedTemplate)
import View exposing (View)


template : SharedTemplate Msg Model Data SharedMsg msg
template =
    { init = init
    , update = update
    , view = view
    , data = data
    , subscriptions = subscriptions
    , onPageChange = Just OnPageChange
    , sharedMsg = SharedMsg
    }


type Msg
    = OnPageChange
        { path : Path
        , query : Maybe String
        , fragment : Maybe String
        }
    | SharedMsg SharedMsg


type alias Data =
    ()


type SharedMsg
    = NoOp


type alias Model =
    { showMobileMenu : Bool
    }


init :
    Maybe Browser.Navigation.Key
    -> Pages.Flags.Flags
    ->
        Maybe
            { path :
                { path : Path
                , query : Maybe String
                , fragment : Maybe String
                }
            , metadata : route
            , pageUrl : Maybe PageUrl
            }
    -> ( Model, Cmd Msg )
init navigationKey flags maybePagePath =
    ( { showMobileMenu = False }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnPageChange _ ->
            ( { model | showMobileMenu = False }, Cmd.none )

        SharedMsg globalMsg ->
            ( model, Cmd.none )


subscriptions : Path -> Model -> Sub Msg
subscriptions _ _ =
    Sub.none


data : DataSource.DataSource Data
data =
    DataSource.succeed ()


view :
    Data
    ->
        { path : Path
        , frontmatter : route
        }
    -> Model
    -> (Msg -> msg)
    -> View msg
    -> { body : Html.Html msg, title : String }
view sharedData page model toMsg pageView =
    let
        globalCustomStyles =
            [ Css.Global.body
                [ fontFamilies [ qt "-apple-system", qt "BlinkMacSystemFont", sansSerif.value ]
                , property "font-feature-settings" (qt "palt")
                , palette Palette.default
                ]
            ]
    in
    { title = pageView.title
    , body =
        [ global (ress ++ globalCustomStyles)
        , siteHeader
        , main_ [] pageView.body
        , siteFooter
        ]
            |> div []
            |> toUnstyled
    }


siteHeader : Html msg
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
            [ text "© 2021 y047aka" ]
        ]
