module Color exposing (gray020, gray040, gray090, gray095, transparent)

import Css exposing (Color, hsl, hsla)


transparent : Color
transparent =
    hsla 0 0 0 0


gray : Float -> Color
gray lightness =
    hsl 0 0 lightness


gray020 : Color
gray020 =
    gray 0.2


gray040 : Color
gray040 =
    gray 0.4


gray090 : Color
gray090 =
    gray 0.9


gray095 : Color
gray095 =
    gray 0.95
