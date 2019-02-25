import Browser
import Html exposing (Html, text, node, div, header, section, nav, footer, h1, p, a, ul, li, img)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Task
import Time

main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


-- MODEL

type alias Model =
    { zone: Time.Zone
    , time: Time.Posix
    }

init : () -> (Model, Cmd Msg)
init _ =
    ( Model Time.utc (Time.millisToPosix 0)
    , Task.perform AdjustTimeZone Time.here
    )


-- UPDATE

type Msg
    = Tick Time.Posix
    | AdjustTimeZone Time.Zone

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Tick newTime ->
            ( { model | time = newTime }
            , Cmd.none
            )

        AdjustTimeZone newZone ->
            ( { model | zone = newZone }
            , Cmd.none
            )


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every 1000 Tick


-- VIEW

view : Model -> Html Msg
view model = div []
    [ header [ class "site-header" ]
        [ div [ class "icon" ] []
        , h1 [] [ text "Yoshitaka Totsuka / y047aka" ]
        , p []
            [ img [ src "/images/location.svg" ] []
            , text "Tokyo, Japan"
            ]
        ]
    , node "main" []
        [ section []
            [
                let
                    hour   = String.fromInt (Time.toHour   model.zone model.time)
                    minute = String.fromInt (Time.toMinute model.zone model.time)
                    second = String.fromInt (Time.toSecond model.zone model.time)
                in
                    h1 [] [ text (hour ++ ":" ++ minute ++ ":" ++ second) ]
            ]
        , section []
            [ h1 [] [ text "Racing!!" ]
            , ul []
                [ li []
                    [ a [ href "https://y047aka.github.io/MotorSportsCalendar/", target "_blank" ] [ text "MotorSportsCalendar" ]
                    ]
                ]
            ]
        , section []
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
        ]
    , nav [ class "side-nav" ]
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
    , footer [ class "site-footer" ]
        [ p [ class "copyright"] [ text "© 2018-2019 y047aka" ] ]
    ]

