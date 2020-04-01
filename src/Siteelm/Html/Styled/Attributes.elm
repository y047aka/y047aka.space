module Siteelm.Html.Styled.Attributes exposing (charset, content, data, rel, role)

import Html.Styled exposing (Attribute)
import Html.Styled.Attributes exposing (attribute)


content : String -> Attribute msg
content =
    attribute "content"


charset : String -> Attribute msg
charset =
    attribute "charset"


rel : String -> Attribute msg
rel =
    attribute "rel"


role : String -> Attribute msg
role =
    attribute "role"


data : String -> String -> Attribute msg
data name value =
    attribute (String.join "-" [ "data", name ]) value
