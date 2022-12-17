module Route.Blog.Slug_ exposing (ActionData, Data, Model, Msg, route)

import Css exposing (..)
import Css.Extra exposing (orNoStyle)
import Css.Global exposing (children)
import Css.Media as Media exposing (only, screen, withMedia)
import Css.Palette as Palette
import DataSource exposing (DataSource)
import DataSource.Glob as Glob
import Date exposing (Date)
import Head
import Head.Seo as Seo
import Html.Styled exposing (Html, div, h1, header, text)
import Html.Styled.Attributes exposing (css)
import Json.Decode as Decode exposing (Decoder)
import Markdown.Customized
import MarkdownCodec
import Pages.Msg
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import RouteBuilder exposing (StatelessRoute, StaticPayload)
import Shared
import View exposing (View)


type alias Model =
    {}


type alias Msg =
    ()


type alias RouteParams =
    { slug : String }


route : StatelessRoute RouteParams Data ActionData
route =
    RouteBuilder.preRender
        { head = head
        , pages = pages
        , data = data
        }
        |> RouteBuilder.buildNoState { view = view }


type alias BlogPost =
    { filePath : String
    , slug : String
    }


pages : DataSource (List RouteParams)
pages =
    Glob.succeed BlogPost
        |> Glob.captureFilePath
        |> Glob.match (Glob.literal "content/blog/")
        |> Glob.capture Glob.wildcard
        |> Glob.match (Glob.literal ".md")
        |> Glob.toDataSource
        |> DataSource.map
            (List.map (\globData -> { slug = globData.slug }))


type alias Data =
    { metadata : ArticleMetadata
    , body : List (Html (Pages.Msg.Msg Msg))
    }


type alias ArticleMetadata =
    { title : String
    , description : String
    , published : Date
    , draft : Bool
    }


type alias ActionData =
    {}


data : RouteParams -> DataSource Data
data routeParams =
    MarkdownCodec.withFrontmatter Data
        frontmatterDecoder
        Markdown.Customized.renderer
        ("content/blog/" ++ routeParams.slug ++ ".md")


frontmatterDecoder : Decoder ArticleMetadata
frontmatterDecoder =
    Decode.map4 ArticleMetadata
        (Decode.field "title" Decode.string)
        (Decode.field "description" Decode.string)
        (Decode.field "published"
            (Decode.string
                |> Decode.andThen
                    (\isoString ->
                        Date.fromIsoString isoString
                            |> (\result ->
                                    case result of
                                        Ok okValue ->
                                            Decode.succeed okValue

                                        Err error ->
                                            Decode.fail error
                               )
                    )
            )
        )
        (Decode.field "draft" Decode.bool
            |> Decode.maybe
            |> Decode.map (Maybe.withDefault False)
        )


head :
    StaticPayload Data ActionData RouteParams
    -> List Head.Tag
head static =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "y047aka.space"
        , image =
            { url = Pages.Url.external "TODO"
            , alt = "y047aka.space logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = static.data.metadata.description
        , locale = Nothing
        , title = static.data.metadata.title
        }
        |> Seo.website


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data ActionData RouteParams
    -> View (Pages.Msg.Msg Msg)
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
                                , lineHeight (num 1)
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
