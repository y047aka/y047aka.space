module Color.Scheme exposing (button, buttonOnHover, global)

import Color exposing (gray020, gray040, gray090, gray095)
import Color.Palette exposing (..)


global : Palette
global =
    seed
        |> setColor gray020


button : Palette
button =
    seed
        |> setBackground gray095
        |> setColor gray020
        |> setOptionalColor gray040


buttonOnHover : Palette
buttonOnHover =
    button
        |> setBackground gray090
