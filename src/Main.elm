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
            [ profile
            , elm
            , motorsport
            , organizations
            ]
        , siteFooter
        ]
    }


siteHeader : Html Msg
siteHeader =
    Html.header [ class "site-header" ]
        [ h1 [] [ text "y047aka.me" ]
        ]


globalMenu : Html Msg
globalMenu =
    nav [ class "global-menu" ]
        [ let
            items =
                [ { name = "Github", url = "https://github.com/y047aka", icon = "github.svg" }
                , { name = "Twitter", url = "https://twitter.com/y047aka", icon = "twitter.svg" }
                , { name = "Qiita", url = "https://qiita.com/y047aka", icon = "qiita.svg" }
                , { name = "Blog", url = "https://blog.y047aka.me", icon = "blog.svg" }
                ]

            viewListItem item =
                li []
                    [ a [ href item.url, target "_blank" ]
                        [ img [ src ("/assets/images/" ++ item.icon) ] []
                        , text item.name
                        ]
                    ]
          in
          ul [] (List.map viewListItem items)
        ]


profile : Html Msg
profile =
    section [ class "profile" ]
        [ h1 [] [ text "Yoshitaka Totsuka" ]
        , div [ class "icon" ] []
        , p []
            [ img [ src "/assets/images/location.svg" ] []
            , text "Tokyo, Japan"
            ]
        ]


elm : Html Msg
elm =
    section [ class "elm" ]
        [ h1 [] [ text "Elm" ]
        , ul []
            [ li []
                [ a [ href "https://y047aka.github.io/elm-japan-logo-generator/", target "_blank" ]
                    [ h2 [] [ text "Elm Japan Logo Generator" ]
                    , text "Elm-jpのロゴに採用されました"
                    ]
                ]
            ]
        ]


motorsport : Html Msg
motorsport =
    section [ class "racing" ]
        [ h1 [] [ text "Motorsport" ]
        , ul []
            [ li []
                [ a [ href "https://motorsports-calendar.netlify.com", target "_blank" ]
                    [ h2 [] [ text "MOTOR SPORTS CALENDAR" ]
                    , text "2019年のモータースポーツ"
                    ]
                ]
            ]
        ]


organizations : Html Msg
organizations =
    section [ class "organization" ]
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
