module Color.Palette exposing (Palette, basic, button, buttonOnHover, init)

import Color exposing (gray020, gray040, gray090, gray095)
import Css exposing (Color)


type alias Palette =
    { background : Maybe Color
    , color : Maybe Color
    , optionalColor : Maybe Color
    , border : Maybe Color
    , shadow : Maybe Color
    }


init : Palette
init =
    { background = Nothing
    , color = Nothing
    , optionalColor = Nothing
    , border = Nothing
    , shadow = Nothing
    }


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
