module Site exposing (config, tagline)

import DataSource
import Head
import LanguageTag exposing (emptySubtags)
import LanguageTag.Language exposing (ja)
import Pages.Manifest as Manifest
import Route
import SiteConfig exposing (SiteConfig)


type alias Data =
    ()


config : SiteConfig Data
config =
    { data = data
    , canonicalUrl = canonicalUrl
    , manifest = manifest
    , head = head
    }


data : DataSource.DataSource Data
data =
    DataSource.succeed ()


head : Data -> List Head.Tag
head _ =
    [ Head.sitemapLink "/sitemap.xml" ]


canonicalUrl : String
canonicalUrl =
    "https://y047aka.space"


manifest : Data -> Manifest.Config
manifest _ =
    Manifest.init
        { name = "y047aka.space"
        , description = tagline
        , startUrl = Route.Index |> Route.toPath
        , icons = []
        }
        |> Manifest.withLang (LanguageTag.build emptySubtags ja)
        |> Manifest.withShortName "y047aka.space"


tagline : String
tagline =
    "My Tanuki logo symbolizes this with a smart animal that works in a group to achieve a common goal."
