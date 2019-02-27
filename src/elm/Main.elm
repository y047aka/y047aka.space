import Browser
--import Html exposing (Html, text, node, div, header, section, nav, footer, h1, h2, p, a, ul, li, img)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode
-- import Task exposing (Task)

main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }


-- MODEL

type alias Model =
    { input : String
    , userState : UserState
    }

type UserState
    = Init
    | Waiting
    | Loaded User
    | Failed Http.Error

init : () -> (Model, Cmd Msg)
init _ =
    ( Model "" Init
    , Cmd.none
    )


-- UPDATE

type Msg
    = Input String
    | Send
    | Recieve (Result Http.Error User)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Input newInput ->
            ( { model | input = newInput }, Cmd.none )
        
        Send ->
            ( { model
                | input = ""
                , userState = Waiting
              }
            , Http.get
                { url = "https://api.github.com/users/" ++ model.input
                , expect = Http.expectJson Recieve userDecoder
                }
            )

        Recieve (Ok user) ->
            ( { model | userState = Loaded user }, Cmd.none )
        
        Recieve (Err error) ->
            ( { model | userState = Failed error }, Cmd.none )

-- VIEW

view : Model -> Html Msg
view model =
    div []
        [ siteHeader
        , node "main" []
            [ section []
                [ Html.form [ onSubmit Send ]
                    [ input
                        [ onInput Input
                        , autofocus True
                        , placeholder "Github name"
                        , value model.input
                        ]
                        []
                    , button
                        [ disabled
                            ((model.userState == Waiting) || String.isEmpty (String.trim model.input))
                        ]
                        [ text "Submit" ]
                    , case model.userState of
                        Init ->
                            text ""
                        
                        Waiting ->
                            text "Waiting..."
                        
                        Loaded user ->
                            a
                            [ href user.htmlUrl
                            , target "_blank"
                            ]
                            [ img [ src user.avatarUrl, width 200 ] []
                            , div [] [ text user.name ]
                            , div []
                                [ case user.bio of
                                    Just bio ->
                                        text bio
                                    
                                    Nothing ->
                                        text ""
                                ]
                            ]
                        
                        Failed error ->
                            div [] [ text (Debug.toString error) ]
                    ]
                ]
            , racing
            , profile
            ]
        , sideNav
        , siteFooter
        ]

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
        [ p [ class "copyright"] [ text "© 2018-2019 y047aka" ]
        ]


-- HTTP

-- https://y047aka.github.io/MotorSportsData/NASCAR/Daytona500.json


-- Data
type alias User =
    { login : String
    , avatarUrl : String
    , name : String
    , htmlUrl : String
    , bio : Maybe String
    }

userDecoder : Decode.Decoder User
userDecoder =
    Decode.map5 User
        (Decode.field "login" Decode.string)
        (Decode.field "avatar_url" Decode.string)
        (Decode.field "name" Decode.string)
        (Decode.field "html_url" Decode.string)
        (Decode.maybe (Decode.field "bio" Decode.string))

