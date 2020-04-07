module Color.Palette exposing (Palette, seed, setBackground, setBorder, setColor, setOptionalColor, setShadow)

import Color exposing (transparent)
import Css exposing (Color)


type alias Palette =
    { background : Color
    , color : Color
    , optionalColor : Color
    , border : Color
    , shadow : Color
    }


seed : Palette
seed =
    { background = transparent
    , color = transparent
    , optionalColor = transparent
    , border = transparent
    , shadow = transparent
    }


setBackground : Color -> Palette -> Palette
setBackground background palette =
    { palette | background = background }


setColor : Color -> Palette -> Palette
setColor color palette =
    { palette | color = color }


setOptionalColor : Color -> Palette -> Palette
setOptionalColor optionalColor palette =
    { palette | optionalColor = optionalColor }


setBorder : Color -> Palette -> Palette
setBorder border palette =
    { palette | border = border }


setShadow : Color -> Palette -> Palette
setShadow shadow palette =
    { palette | shadow = shadow }
