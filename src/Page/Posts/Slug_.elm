module Page.Posts.Slug_ exposing (Data, Model, Msg, page)

import Article
import Css exposing (..)
import Css.Extra exposing (orNoStyle)
import Css.Global exposing (children)
import Css.Media as Media exposing (only, screen, withMedia)
import Css.Palette as Palette
import DataSource exposing (DataSource)
import Date exposing (Date)
import Head
import Head.Seo as Seo
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css)
import Markdown.Customized
import MarkdownCodec
import OptimizedDecoder
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Path
import Shared
import StructuredData
import View exposing (View)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    { slug : String }


page : Page RouteParams Data
page =
    Page.prerender
        { data = data
        , head = head
        , routes = routes
        }
        |> Page.buildNoState { view = view }


routes : DataSource.DataSource (List RouteParams)
routes =
    Article.blogPostsGlob
        |> DataSource.map
            (List.map
                (\globData ->
                    { slug = globData.slug }
                )
            )


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = static.data.metadata.title ++ " - y047aka.space"
    , body =
        [ div
            [ css
                [ width (px 620)
                , margin2 zero auto
                , padding2 (px 20) zero
                , withMedia [ only screen [ Media.maxWidth (px 480) ] ]
                    [ width (pct 100)
                    , padding (px 15)
                    ]
                ]
            ]
            [ header []
                [ h1
                    [ css
                        [ padding2 (px 5) zero
                        , fontFamilies [ qt "-apple-system", sansSerif.value ]
                        , fontSize (px 24)
                        , fontWeight (int 600)
                        ]
                    ]
                    [ text static.data.metadata.title ]
                , div
                    [ css
                        [ orNoStyle Palette.default.optionalColor color
                        , children
                            [ Css.Global.p
                                [ padding2 (px 5) zero
                                , fontSize (px 14)
                                , lineHeight (int 1)
                                ]
                            ]
                        ]
                    ]
                    [ publishedDateView static.data.metadata ]
                ]
            , div [ css Markdown.Customized.markdownStyles ] static.data.body
            ]
        ]
    }


publishedDateView : { a | published : Date } -> Html msg
publishedDateView metadata =
    text (Date.format "MMMM ddd, yyyy" metadata.published)


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    let
        metadata =
            static.data.metadata
    in
    Head.structuredData
        (StructuredData.article
            { title = metadata.title
            , description = metadata.description
            , author = StructuredData.person { name = "" }
            , publisher = StructuredData.person { name = "" }
            , url = ""
            , imageUrl = Pages.Url.external ""
            , datePublished = Date.toIsoString metadata.published
            , mainEntityOfPage =
                StructuredData.softwareSourceCode
                    { codeRepositoryUrl = "https://github.com/y047aka/y047aka.space"
                    , description = "My site."
                    , author = "Yoshitaka Totsuka"
                    , programmingLanguage = StructuredData.elmLang
                    }
            }
        )
        :: (Seo.summaryLarge
                { canonicalUrlOverride = Nothing
                , siteName = "y047aka.space"
                , image =
                    { url = [ "images", "icon-png.png" ] |> Path.join |> Pages.Url.fromPath
                    , alt = "y047aka.space logo"
                    , dimensions = Nothing
                    , mimeType = Nothing
                    }
                , description = metadata.description
                , locale = Nothing
                , title = metadata.title
                }
                |> Seo.article
                    { tags = []
                    , section = Nothing
                    , publishedTime = Just (Date.toIsoString metadata.published)
                    , modifiedTime = Nothing
                    , expirationTime = Nothing
                    }
           )


type alias Data =
    { metadata : ArticleMetadata
    , body : List (Html Msg)
    }


data : RouteParams -> DataSource Data
data route =
    MarkdownCodec.withFrontmatter Data
        frontmatterDecoder
        Markdown.Customized.renderer
        ("content/posts/" ++ route.slug ++ ".md")


type alias ArticleMetadata =
    { title : String
    , description : String
    , published : Date
    , draft : Bool
    }


frontmatterDecoder : OptimizedDecoder.Decoder ArticleMetadata
frontmatterDecoder =
    OptimizedDecoder.map4 ArticleMetadata
        (OptimizedDecoder.field "title" OptimizedDecoder.string)
        (OptimizedDecoder.field "description" OptimizedDecoder.string)
        (OptimizedDecoder.field "published"
            (OptimizedDecoder.string
                |> OptimizedDecoder.andThen
                    (\isoString ->
                        Date.fromIsoString isoString
                            |> OptimizedDecoder.fromResult
                    )
            )
        )
        (OptimizedDecoder.field "draft" OptimizedDecoder.bool
            |> OptimizedDecoder.maybe
            |> OptimizedDecoder.map (Maybe.withDefault False)
        )
