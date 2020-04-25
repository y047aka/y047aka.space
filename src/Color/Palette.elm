module Color.Palette exposing (Palette, init)

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
