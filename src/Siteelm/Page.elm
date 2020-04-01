module Siteelm.Page exposing (Page, page)

import Browser
import Css exposing (..)
import Css.Global exposing (children, main_)
import Html.Styled exposing (Html, text, toUnstyled)
import Html.Styled.Attributes exposing (css)
import Json.Decode exposing (Decoder, decodeString)
import Siteelm.Html.Styled as Html


{-| Generate a Program for static page. You need to give a decoder for your
preamble model and a view function which takes the preamble and
plain text body (e.g. markdown text).
-}
page :
    { decoder : Decoder a
    , head : a -> String -> List (Html Never)
    , body : a -> String -> List (Html Never)
    }
    -> Page a
page { decoder, head, body } =
    Browser.document
        { init = \f -> ( decode decoder f, Cmd.none )
        , update = \_ m -> ( m, Cmd.none )
        , view = \m -> { title = "", body = [ toUnstyled <| renderPage head body m ] }
        , subscriptions = always Sub.none
        }


type alias Page a =
    Program Flags (Model a) Never


type alias Model a =
    { preamble : Maybe a
    , body : String
    }


type alias Flags =
    { preamble : String
    , body : String
    }


decode : Decoder a -> Flags -> Model a
decode decoder flags =
    let
        preamble =
            flags.preamble
                |> decodeString decoder
                |> Result.toMaybe
    in
    { preamble = preamble
    , body = flags.body
    }


renderPage : (a -> String -> List (Html Never)) -> (a -> String -> List (Html Never)) -> Model a -> Html Never
renderPage head body model =
    case model.preamble of
        Just p ->
            Html.html []
                [ Html.head [] (head p model.body)
                , Html.body
                    [ css
                        [ minHeight (vh 100)
                        , property "display" "flex"
                        , flexDirection column
                        , children
                            [ main_
                                [ flex (int 1) ]
                            ]
                        ]
                    ]
                    (body p model.body)
                ]

        Nothing ->
            text ""