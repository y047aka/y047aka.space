module Css.Extra exposing (palette)

import Color.Palette exposing (Palette)
import Css exposing (Style, backgroundColor, batch, color)


palette : Palette -> Style
palette p =
    let
        background =
            case p.background of
                Just c ->
                    [ backgroundColor c ]

                Nothing ->
                    []

        textColor =
            case p.color of
                Just c ->
                    [ color c ]

                Nothing ->
                    []
    in
    [ background, textColor ]
        |> List.concat
        |> batch
