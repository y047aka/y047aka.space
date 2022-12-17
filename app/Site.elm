module Site exposing (config)

import DataSource exposing (DataSource)
import Head
import SiteConfig exposing (SiteConfig)


config : SiteConfig
config =
    { canonicalUrl = "https://y047aka.space"
    , head = head
    }


head : DataSource (List Head.Tag)
head =
    [ Head.sitemapLink "/sitemap.xml"
    ]
        |> DataSource.succeed
