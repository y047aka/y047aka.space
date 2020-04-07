module Color exposing (gray020, gray040, gray095)

import Css exposing (Color, hsl)


gray020 : Color
gray020 =
    gray 0.2


gray040 : Color
gray040 =
    gray 0.4


gray095 : Color
gray095 =
    gray 0.95


gray : Float -> Color
gray lightness =
    hsl 0 0 lightness
