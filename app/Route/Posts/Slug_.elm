module Route.Posts.Slug_ exposing (ActionData, Data, Model, Msg, route)

import BackendTask exposing (BackendTask)
import BackendTask.Glob as Glob
import Css exposing (..)
import Css.Extra exposing (orNoStyle)
import Css.Global exposing (children)
import Css.Media as Media exposing (only, screen, withMedia)
import Css.Palette as Palette
import Date exposing (Date)
import FatalError exposing (FatalError)
import Head
import Head.Seo as Seo
import Html.Styled exposing (Html, div, h1, header, text)
import Html.Styled.Attributes exposing (css)
import Json.Decode as Decode exposing (Decoder)
import Markdown.Block exposing (Block)
import Markdown.Customized
import Markdown.Renderer
import Plugins.MarkdownCodec as MarkdownCodec
import Pages.Url
import PagesMsg exposing (PagesMsg)
import RouteBuilder exposing (App, StatelessRoute)
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


pages : BackendTask FatalError (List RouteParams)
pages =
    Glob.succeed BlogPost
        |> Glob.captureFilePath
        |> Glob.match (Glob.literal "content/posts/")
        |> Glob.capture Glob.wildcard
        |> Glob.match (Glob.literal ".md")
        |> Glob.toBackendTask
        |> BackendTask.map
            (List.map (\globData -> { slug = globData.slug }))


type alias Data =
    { metadata : ArticleMetadata
    , body : List Block
    }


type alias ArticleMetadata =
    { title : String
    , description : String
    , published : Date
    , draft : Bool
    }


type alias ActionData =
    {}


data : RouteParams -> BackendTask FatalError Data
data routeParams =
    MarkdownCodec.withFrontmatter Data
        frontmatterDecoder
        Markdown.Customized.renderer
        ("content/posts/" ++ routeParams.slug ++ ".md")


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
    App Data ActionData RouteParams
    -> List Head.Tag
head app =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "y047aka.space"
        , image =
            { url = Pages.Url.external "TODO"
            , alt = "y047aka.space logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = app.data.metadata.description
        , locale = Nothing
        , title = app.data.metadata.title
        }
        |> Seo.website


view :
    App Data ActionData RouteParams
    -> Shared.Model
    -> View (PagesMsg Msg)
view app sharedModel =
    { title = app.data.metadata.title ++ " - y047aka.space"
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
                    [ text app.data.metadata.title ]
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
                    [ publishedDateView app.data.metadata ]
                ]
            , div [ css Markdown.Customized.markdownStyles ] <|
                Result.withDefault [] <|
                    Markdown.Renderer.render Markdown.Customized.renderer app.data.body
            ]
        ]
    }


publishedDateView : { a | published : Date } -> Html msg
publishedDateView metadata =
    text (Date.format "MMMM ddd, yyyy" metadata.published)
