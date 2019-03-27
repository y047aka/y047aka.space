module Main exposing (main)

import Browser
import Html exposing (Html, a, div, footer, h1, img, li, nav, node, p, section, text, ul)
import Html.Attributes exposing (class, href, src, target)


main =
    Browser.document
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }



-- MODEL


type alias Model =
    { userState : String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model ""
    , Cmd.none
    )



-- UPDATE


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "y047aka.me"
    , body =
        [ siteHeader
        , node "main"
            []
            [ racing
            , profile
            ]
        , sideNav
        , siteFooter
        ]
    }


siteHeader : Html Msg
siteHeader =
    Html.header [ class "site-header" ]
        [ div [ class "icon" ] []
        , h1 [] [ text "Yoshitaka Totsuka / y047aka" ]
        , p []
            [ img [ src "/images/location.svg" ] []
            , text "Tokyo, Japan"
            ]
        ]


racing : Html Msg
racing =
    section []
        [ h1 [] [ text "Racing!!" ]
        , ul []
            [ li []
                [ a [ href "https://y047aka.github.io/MotorSportsCalendar/", target "_blank" ] [ text "MotorSportsCalendar" ]
                ]
            ]
        ]


profile : Html Msg
profile =
    section []
        [ h1 [] [ text "I'm belong to..." ]
        , ul []
            [ li []
                [ a [ href "http://spacemgz-telstar.com/", target "_blank" ] [ text "宇宙広報団体 TELSTAR" ]
                ]
            , li []
                [ a [ href "https://sorabatake.jp/", target "_blank" ] [ text "宙畑" ]
                ]
            ]
        ]


sideNav : Html Msg
sideNav =
    nav [ class "side-nav" ]
        [ ul []
            [ li []
                [ a [ href "https://github.com/y047aka", target "_blank" ]
                    [ img [ src "/images/github.svg" ] []
                    ]
                ]
            , li []
                [ a [ href "https://twitter.com/y047aka", target "_blank" ]
                    [ img [ src "/images/twitter.svg" ] []
                    ]
                ]
            ]
        ]


siteFooter : Html Msg
siteFooter =
    footer [ class "site-footer" ]
        [ p [ class "copyright" ] [ text "© 2018-2019 y047aka" ]
        ]
