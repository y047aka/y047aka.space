module Color.Scheme exposing (basic, button, buttonOnHover)

import Color exposing (gray020, gray040, gray090, gray095)
import Color.Palette exposing (..)


basic : Palette
basic =
    { init | color = gray020 }


button : Palette
button =
    { basic
        | background = gray095
        , optionalColor = gray040
    }


buttonOnHover : Palette
buttonOnHover =
    { button | background = gray090 }
