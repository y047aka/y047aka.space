module Api exposing (routes)

import ApiRoute exposing (ApiRoute)
import DataSource exposing (DataSource)
import Html exposing (Html)
import LanguageTag exposing (emptySubtags)
import LanguageTag.Language exposing (ja)
import Pages.Manifest as Manifest
import Route exposing (Route)


routes :
    DataSource (List Route)
    -> (Maybe { indent : Int, newLines : Bool } -> Html Never -> String)
    -> List (ApiRoute ApiRoute.Response)
routes getStaticRoutes htmlToString =
    []


manifest : Manifest.Config
manifest =
    Manifest.init
        { name = "y047aka.space"
        , description = "My Tanuki logo symbolizes this with a smart animal that works in a group to achieve a common goal."
        , startUrl = Route.Index |> Route.toPath
        , icons = []
        }
        |> Manifest.withLang (LanguageTag.build emptySubtags ja)
