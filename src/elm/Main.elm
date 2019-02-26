import Browser
import Html exposing (Html, text, node, div, header, section, nav, footer, h1, h2, p, a, ul, li, img)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Task
import Time
import Http
import Json.Decode exposing (Decoder, field, string)

main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


-- MODEL

type Model
    = Failure
    | Loading
    | Success String

init : () -> (Model, Cmd Msg)
init _ =
    ( Loading, getRandomCatGif)


-- UPDATE

type Msg
    = MorePlease
    | GotGif (Result Http.Error String)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        MorePlease ->
            (Loading, getRandomCatGif)
        
        GotGif result ->
            case result of
                Ok url ->
                    (Success url, Cmd.none)
                
                Err _ ->
                    (Failure, Cmd.none)


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


-- VIEW

view : Model -> Html Msg
view model =
    div []
        [ siteHeader
        , node "main" []
            [ section []
                [ h2 [] [ text "Random NASCAR" ]
                , viewGif model
                ]
            , racing
            , profile
            ]
        , sideNav
        , siteFooter
        ]

siteHeader : Html Msg
siteHeader =
    header [ class "site-header" ]
        [ div [ class "icon" ] []
        , h1 [] [ text "Yoshitaka Totsuka / y047aka" ]
        , p []
            [ img [ src "/images/location.svg" ] []
            , text "Tokyo, Japan"
            ]
        ]

viewGif : Model -> Html Msg
viewGif model =
    case model of
        Failure ->
            div [] [ text "I could not load a random cat for some reason." ]
        
        Loading ->
            text "Loading"

        Success url ->
            div []
                [ text url 
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
        [ p [ class "copyright"] [ text "© 2018-2019 y047aka" ]
        ]


-- HTTP

getRandomCatGif : Cmd Msg
getRandomCatGif =
    Http.get
        { url = "https://api.giphy.com/v1/gifs/random?apikey=dc6zaTOxFJmzC&tag=NASCAR"
        , expect = Http.expectJson GotGif gifDecoder
        }

gifDecoder : Decoder String
gifDecoder =
    field "data" (field "image_url" string)
