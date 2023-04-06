module Route.Index exposing (ActionData, Data, Model, Msg, route)

import BackendTask exposing (BackendTask)
import BackendTask.File as File
import BackendTask.Glob as Glob
import Css exposing (..)
import Css.Extra exposing (orNoStyle, palette)
import Css.Media as Media exposing (only, screen, withMedia)
import Css.Palette exposing (button, buttonOnHover)
import Date exposing (Date)
import FatalError exposing (FatalError)
import Head
import Head.Seo as Seo
import Html.Styled exposing (Attribute, Html, a, h1, li, section, span, text, ul)
import Html.Styled.Attributes as Attributes exposing (css, href, rel)
import Json.Decode as Decode exposing (Decoder)
import Pages.Url
import PagesMsg exposing (PagesMsg)
import Path
import Route exposing (Route)
import RouteBuilder exposing (App, StatelessRoute)
import Shared
import View exposing (View)


type alias Model =
    {}


type alias Msg =
    ()


type alias RouteParams =
    {}


type alias Data =
    List ( Route, ArticleMetadata )


type alias ActionData =
    {}


route : StatelessRoute RouteParams Data ActionData
route =
    RouteBuilder.single
        { head = head
        , data = data
        }
        |> RouteBuilder.buildNoState { view = view }


data : BackendTask FatalError Data
data =
    allMetadata


type alias BlogPost =
    { filePath : String
    , slug : String
    }


blogPostsGlob : BackendTask FatalError (List { filePath : String, slug : String })
blogPostsGlob =
    Glob.succeed BlogPost
        |> Glob.captureFilePath
        |> Glob.match (Glob.literal "content/blog/")
        |> Glob.capture Glob.wildcard
        |> Glob.match (Glob.literal ".md")
        |> Glob.toBackendTask


allMetadata : BackendTask FatalError (List ( Route, ArticleMetadata ))
allMetadata =
    blogPostsGlob
        |> BackendTask.map
            (List.map
                (\{ filePath, slug } ->
                    BackendTask.map2 Tuple.pair
                        (BackendTask.succeed <| Route.Blog__Slug_ { slug = slug })
                        (BackendTask.allowFatal <| File.onlyFrontmatter frontmatterDecoder filePath)
                )
            )
        |> BackendTask.resolve
        |> BackendTask.map
            (List.filterMap
                (\( route_, metadata ) ->
                    if metadata.draft then
                        Nothing

                    else
                        Just ( route_, metadata )
                )
            )


type alias ArticleMetadata =
    { title : String
    , description : String
    , published : Date
    , draft : Bool
    }


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
            { url = [ "images", "icon-png.png" ] |> Path.join |> Pages.Url.fromPath
            , alt = "y047aka.space logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "My Tanuki logo symbolizes this with a smart animal that works in a group to achieve a common goal."
        , locale = Nothing
        , title = "y047aka.space"
        }
        |> Seo.website


view :
    App Data ActionData RouteParams
    -> Shared.Model
    -> View (PagesMsg Msg)
view app shared =
    { title = "y047aka.space"
    , body =
        [ topSection
            { title = "Elm"
            , children =
                [ ul [] <|
                    List.map siteSummary
                        [ { name = "elm-articles"
                          , url = "https://elm-articles.vercel.app"
                          }
                        ]
                ]
            }
        , topSection
            { title = "MotorSports"
            , children =
                [ ul [] <|
                    List.map siteSummary
                        [ { name = "MotorSportsCalendar 2020"
                          , url = "https://y047aka.github.io/MotorSportsCalendar/"
                          }
                        ]
                ]
            }
        , topSection
            { title = "Blog posts"
            , children =
                [ app.data
                    |> List.sortWith postPublishDateDescending
                    |> List.map postSummary
                    |> ul []
                ]
            }
        ]
    }


postPublishDateDescending : ( Route, ArticleMetadata ) -> ( Route, ArticleMetadata ) -> Order
postPublishDateDescending ( _, metadata1 ) ( _, metadata2 ) =
    Date.compare metadata2.published metadata1.published


topSection : { title : String, children : List (Html msg) } -> Html msg
topSection { title, children } =
    section
        [ css
            [ width (px 620)
            , margin2 zero auto
            , padding2 (px 25) zero
            , withMedia [ only screen [ Media.maxWidth (px 480) ] ]
                [ width (pct 100)
                , padding (px 15)
                ]
            ]
        ]
        (h1
            [ css
                [ paddingBottom (px 10)
                , fontFamilies [ qt "Saira", sansSerif.value ]
                , fontSize (px 16)
                , fontWeight (int 500)
                , lineHeight (num 1)
                ]
            ]
            [ text title ]
            :: children
        )


siteSummary : { name : String, url : String } -> Html msg
siteSummary { name, url } =
    li
        [ css
            [ listStyle none
            , nthChild "n+2"
                [ marginTop (px 5) ]
            ]
        ]
        [ linkToSite url
            [ title_ name
            , span
                [ css
                    [ fontSize (px 13)
                    , lineHeight (num 1)
                    , orNoStyle button.optionalColor color
                    ]
                ]
                [ text url ]
            ]
        ]


linkToSite : String -> List (Html msg) -> Html msg
linkToSite url contents =
    a
        [ href url
        , Attributes.target "_blank"
        , rel "noopener"
        , css
            [ display block
            , padding (px 20)
            , withMedia [ only screen [ Media.maxWidth (px 480) ] ]
                [ padding (px 15) ]
            , textDecoration none
            , borderRadius (px 10)
            , palette button
            , hover
                [ palette buttonOnHover ]
            ]
        ]
        contents


title_ : String -> Html msg
title_ str =
    h1
        [ css
            [ fontSize (px 16)
            , fontWeight (int 600)
            , lineHeight (num 1.5)
            ]
        ]
        [ text str ]


postSummary : ( Route, ArticleMetadata ) -> Html msg
postSummary ( route_, { title, published } ) =
    li
        [ css
            [ listStyle none
            , nthChild "n+2"
                [ marginTop (px 5) ]
            ]
        ]
        [ link route_
            [ css
                [ display block
                , padding (px 20)
                , withMedia [ only screen [ Media.maxWidth (px 480) ] ]
                    [ padding (px 15) ]
                , textDecoration none
                , borderRadius (px 10)
                , palette button
                , hover
                    [ palette buttonOnHover ]
                ]
            ]
            [ title_ title
            , span
                [ css
                    [ fontSize (px 13)
                    , lineHeight (num 1)
                    , orNoStyle button.optionalColor color
                    ]
                ]
                [ text (Date.format "MMMM ddd, yyyy" published) ]
            ]
        ]


link : Route -> List (Attribute msg) -> List (Html msg) -> Html msg
link route_ attrs children =
    Route.toLink
        (\anchorAttrs ->
            a
                (List.map Attributes.fromUnstyled anchorAttrs ++ attrs)
                children
        )
        route_
