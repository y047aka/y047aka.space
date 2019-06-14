module Main exposing (main)

import Browser
import Html exposing (Html, a, div, footer, h1, h2, img, li, nav, node, p, section, text, ul)
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
        , globalMenu
        , node "main"
            []
            [ racing
            , profile
            ]
        , siteFooter
        ]
    }


siteHeader : Html Msg
siteHeader =
    Html.header [ class "site-header" ]
        [ div [ class "icon" ] []
        , h1 [] [ text "Yoshitaka Totsuka / y047aka" ]
        , p []
            [ img [ src "/assets/images/location.svg" ] []
            , text "Tokyo, Japan"
            ]
        ]


globalMenu : Html Msg
globalMenu =
    nav [ class "global-menu" ]
        [ ul []
            [ li []
                [ a [ href "https://github.com/y047aka", target "_blank" ]
                    [ img [ src "/assets/images/github.svg" ] []
                    , text "Github"
                    ]
                ]
            , li []
                [ a [ href "https://twitter.com/y047aka", target "_blank" ]
                    [ img [ src "/assets/images/twitter.svg" ] []
                    , text "Twitter"
                    ]
                ]
            , li []
                [ a [ href "https://qiita.com/y047aka", target "_blank" ]
                    [ img [ src "/assets/images/qiita.svg" ] []
                    , text "Qiita"
                    ]
                ]
            , li []
                [ a [ href "https://blog.y047aka.me", target "_blank" ]
                    [ img [ src "/assets/images/blog.svg" ] []
                    , text "Blog"
                    ]
                ]
            ]
        ]


racing : Html Msg
racing =
    section []
        [ h1 [] [ text "Racing!!" ]
        , ul []
            [ li []
                [ a [ href "https://y047aka.github.io/MotorSportsCalendar/", target "_blank" ]
                    [ h2 [] [ text "MOTOR SPORTS CALENDAR" ] ]
                ]
            ]
        ]


profile : Html Msg
profile =
    section []
        [ h1 [] [ text "I'm belong to..." ]
        , ul []
            [ li []
                [ a [ href "http://spacemgz-telstar.com/", target "_blank" ]
                    [ h2 [] [ text "宇宙広報団体 TELSTAR" ]
                    , text "宇宙への興味を 0 → 1 へ"
                    ]
                ]
            , li []
                [ a [ href "https://sorabatake.jp/", target "_blank" ]
                    [ h2 [] [ text "宙畑" ]
                    , text "宇宙産業を日本の誇る基幹産業に。"
                    ]
                ]
            , li []
                [ a [ href "https://outsense.jp/", target "_blank" ]
                    [ h2 [] [ text "OUTSENSE" ]
                    , text "あなたをどこにでも住めるようにする。そう、それが宇宙でもね。"
                    ]
                ]
            ]
        ]


siteFooter : Html Msg
siteFooter =
    footer [ class "site-footer" ]
        [ p [ class "copyright" ] [ text "© 2018-2019 y047aka" ]
        ]
