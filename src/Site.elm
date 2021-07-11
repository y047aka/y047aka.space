module Site exposing (config)

import DataSource
import Head
import Pages.Manifest as Manifest
import Route
import SiteConfig exposing (SiteConfig)


type alias Data =
    ()


config : SiteConfig Data
config =
    \_ ->
        { data = data
        , canonicalUrl = "https://y047aka.netlify.com"
        , manifest = manifest
        , head = head
        }


data : DataSource.DataSource Data
data =
    DataSource.succeed ()


head : Data -> List Head.Tag
head static =
    [ Head.sitemapLink "/sitemap.xml"
    ]


manifest : Data -> Manifest.Config
manifest static =
    Manifest.init
        { name = "y047aka.space"
        , description = "My Tanuki logo symbolizes this with a smart animal that works in a group to achieve a common goal."
        , startUrl = Route.Index |> Route.toPath
        , icons = []
        }
