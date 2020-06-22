module Markdown.Customized exposing (markdownToHtml)

import Css exposing (..)
import Html.Styled as Html exposing (Attribute, Html, div, text)
import Html.Styled.Attributes as Attr exposing (rel, target)
import Json.Encode exposing (null)
import Markdown.Parser exposing (deadEndToString)
import Markdown.Renderer exposing (Renderer)
import Markdown.Renderer.Styled exposing (styledRenderer)


markdownToHtml : List (Attribute msg) -> String -> Html msg
markdownToHtml attributes markdown =
    let
        deadEndsToString deadEnds =
            deadEnds
                |> List.map deadEndToString
                |> String.join "\n"
    in
    case
        markdown
            |> Markdown.Parser.parse
            |> Result.mapError deadEndsToString
            |> Result.andThen (\ast -> Markdown.Renderer.render customRenderer ast)
    of
        Ok rendered ->
            div attributes rendered

        Err errors ->
            text errors


isInternalLink : String -> Bool
isInternalLink url =
    let
        isProduction =
            String.startsWith url "https://y047aka.space"

        isLocalDevelopment =
            String.startsWith url "http://localhost:3000"
    in
    isProduction || isLocalDevelopment


isExternalLink : String -> Bool
isExternalLink url =
    not <| isInternalLink url


customRenderer : Renderer (Html msg)
customRenderer =
    { styledRenderer
        | link =
            \link content ->
                Html.a
                    ([ Attr.href link.destination
                     , case link.title of
                        Just title ->
                            Attr.title title

                        Nothing ->
                            Attr.property "none" null
                     ]
                        ++ (if isExternalLink link.destination then
                                [ Attr.target "_blank", rel "noopener" ]

                            else
                                []
                           )
                    )
                    content
    }
