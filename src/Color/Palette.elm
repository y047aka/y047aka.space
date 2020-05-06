module Color.Palette exposing (Palette, basic, button, buttonOnHover, init)

import Color exposing (coolGray040, coolGray050, coolGray090, coolGray095, gray020)
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
    { init
        | color = gray020
        , optionalColor = coolGray050
    }


button : Palette
button =
    { basic
        | background = coolGray095
        , optionalColor = coolGray040
    }


buttonOnHover : Palette
buttonOnHover =
    { button | background = coolGray090 }
