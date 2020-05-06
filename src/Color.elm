module Color exposing
    ( gray020, gray040, gray050, gray090, gray095
    , coolGray040, coolGray050, coolGray090, coolGray095
    )

{-|

@docs gray020, gray040, gray050, gray090, gray095
@docs coolGray040, coolGray050, coolGray090, coolGray095

-}

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


coolGray : Float -> Maybe Color
coolGray lightness =
    Just (hsl 210 0.05 lightness)


coolGray040 : Maybe Color
coolGray040 =
    coolGray 0.4


coolGray050 : Maybe Color
coolGray050 =
    coolGray 0.5


coolGray090 : Maybe Color
coolGray090 =
    coolGray 0.9


coolGray095 : Maybe Color
coolGray095 =
    coolGray 0.95
