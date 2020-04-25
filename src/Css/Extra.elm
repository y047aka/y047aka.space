module Css.Extra exposing (palette)

import Color.Palette exposing (Palette)
import Css exposing (Style, backgroundColor, color)


palette : Palette -> List Style
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
    List.concat [ background, textColor ]
