module Color exposing (gray020, gray040, gray050, gray090, gray095)

import Css exposing (Color, hsl)


gray : Float -> Maybe Color
gray lightness =
    Just (hsl 0 0 lightness)


gray020 : Maybe Color
gray020 =
    gray 0.2


gray040 : Maybe Color
gray040 =
    gray 0.4


gray050 : Maybe Color
gray050 =
    gray 0.5


gray090 : Maybe Color
gray090 =
    gray 0.9


gray095 : Maybe Color
gray095 =
    gray 0.95
