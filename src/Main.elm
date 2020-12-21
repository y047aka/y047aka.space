module Main exposing (main)

import Color
import Css exposing (..)
import Css.Extra exposing (palette)
import Css.Global exposing (global)
import Css.Palette as Palette
import Css.Reset exposing (ress)
import Date
import Head
import Head.Seo as Seo
import Html
import Html.Styled exposing (Html, div, toUnstyled)
import Json.Decode
import Layout
import Markdown.Customized exposing (markdownToHtml)
import Metadata exposing (Metadata)
import Page.Article
import Page.Top
import Pages exposing (images, pages)
import Pages.Manifest as Manifest
import Pages.Manifest.Category
import Pages.PagePath exposing (PagePath)
import Pages.Platform
import Pages.StaticHttp as StaticHttp


manifest : Manifest.Config Pages.PathKey
manifest =
    { backgroundColor = Just Color.white
    , categories = [ Pages.Manifest.Category.education ]
    , displayMode = Manifest.Standalone
    , orientation = Manifest.Portrait
    , description = "My Tanuki logo symbolizes this with a smart animal that works in a group to achieve a common goal."
    , iarcRatingId = Nothing
    , name = "y047aka.space"
    , themeColor = Just Color.white
    , startUrl = pages.index
    , shortName = Just "y047aka.space"
    , sourceIcon = images.iconPng
    , icons = []
    }


type alias Rendered =
    Html Msg



-- the intellij-elm plugin doesn't support type aliases for Programs so we need to use this line
-- main : Platform.Program Pages.Platform.Flags (Pages.Platform.Model Model Msg Metadata Rendered) (Pages.Platform.Msg Msg Metadata Rendered)


main : Pages.Platform.Program Model Msg Metadata Rendered Pages.PathKey
main =
    Pages.Platform.init
        { init = \_ -> init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , documents = [ markdownDocument ]
        , manifest = manifest
        , canonicalSiteUrl = canonicalSiteUrl
        , onPageChange = Nothing
        , internals = Pages.internals
        }
        |> Pages.Platform.withFileGenerator generateFiles
        |> Pages.Platform.toProgram


generateFiles :
    List
        { path : PagePath Pages.PathKey
        , frontmatter : Metadata
        , body : String
        }
    ->
        StaticHttp.Request
            (List
                (Result
                    String
                    { path : List String
                    , content : String
                    }
                )
            )
generateFiles siteMetadata =
    StaticHttp.succeed []


markdownDocument : { extension : String, metadata : Json.Decode.Decoder Metadata, body : String -> Result error (Html msg) }
markdownDocument =
    { extension = "md"
    , metadata = Metadata.decoder
    , body = \markdownBody -> Ok (markdownToHtml [] markdownBody)
    }


type alias Model =
    {}


init : ( Model, Cmd Msg )
init =
    ( Model, Cmd.none )


type alias Msg =
    ()


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        () ->
            ( model, Cmd.none )


subscriptions : Metadata -> PagePath Pages.PathKey -> Model -> Sub Msg
subscriptions _ _ _ =
    Sub.none


view :
    List ( PagePath Pages.PathKey, Metadata )
    ->
        { path : PagePath Pages.PathKey
        , frontmatter : Metadata
        }
    ->
        StaticHttp.Request
            { view : Model -> Rendered -> { title : String, body : Html.Html Msg }
            , head : List (Head.Tag Pages.PathKey)
            }
view siteMetadata page =
    let
        globalCustomStyles =
            [ Css.Global.body
                [ fontFamilies [ qt "-apple-system", qt "BlinkMacSystemFont", sansSerif.value ]
                , property "font-feature-settings" (qt "palt")
                , palette Palette.default
                ]
            ]
    in
    StaticHttp.succeed
        { view =
            \model viewForPage ->
                Layout.view (pageView model siteMetadata page viewForPage) page
                    |> (\document ->
                            { title = document.title
                            , body = toUnstyled <| div [] (global (ress ++ globalCustomStyles) :: document.body)
                            }
                       )
        , head = head page.frontmatter
        }


pageView :
    Model
    -> List ( PagePath Pages.PathKey, Metadata )
    -> { path : PagePath Pages.PathKey, frontmatter : Metadata }
    -> Rendered
    -> { title : String, body : List Rendered }
pageView model siteMetadata page viewForPage =
    case page.frontmatter of
        Metadata.Page metadata ->
            { title = metadata.title
            , body = [ viewForPage ]
            }

        Metadata.Article metadata ->
            Page.Article.view metadata viewForPage

        Metadata.BlogIndex ->
            { title = "y047aka.space"
            , body = Page.Top.view siteMetadata
            }


commonHeadTags : List (Head.Tag Pages.PathKey)
commonHeadTags =
    []



{- Read more about the metadata specs:

   <https://developer.twitter.com/en/docs/tweets/optimize-with-cards/overview/abouts-cards>
   <https://htmlhead.dev>
   <https://html.spec.whatwg.org/multipage/semantics.html#standard-metadata-names>
   <https://ogp.me/>
-}


head : Metadata -> List (Head.Tag Pages.PathKey)
head metadata =
    commonHeadTags
        ++ (case metadata of
                Metadata.Page meta ->
                    Seo.summary
                        { canonicalUrlOverride = Nothing
                        , siteName = "y047aka.space"
                        , image =
                            { url = images.iconPng
                            , alt = "y047aka.space logo"
                            , dimensions = Nothing
                            , mimeType = Nothing
                            }
                        , description = siteTagline
                        , locale = Nothing
                        , title = meta.title
                        }
                        |> Seo.website

                Metadata.Article meta ->
                    Seo.summary
                        { canonicalUrlOverride = Nothing
                        , siteName = "y047aka.space"
                        , image =
                            { url = images.iconPng
                            , alt = meta.description
                            , dimensions = Nothing
                            , mimeType = Nothing
                            }
                        , description = meta.description
                        , locale = Nothing
                        , title = meta.title
                        }
                        |> Seo.article
                            { tags = []
                            , section = Nothing
                            , publishedTime = Just (Date.toIsoString meta.published)
                            , modifiedTime = Nothing
                            , expirationTime = Nothing
                            }

                Metadata.BlogIndex ->
                    Seo.summary
                        { canonicalUrlOverride = Nothing
                        , siteName = "y047aka.space"
                        , image =
                            { url = images.iconPng
                            , alt = "y047aka.space logo"
                            , dimensions = Nothing
                            , mimeType = Nothing
                            }
                        , description = siteTagline
                        , locale = Nothing
                        , title = "y047aka.space"
                        }
                        |> Seo.website
           )


canonicalSiteUrl : String
canonicalSiteUrl =
    "https://y047aka.netlify.com"


siteTagline : String
siteTagline =
    "My Tanuki logo symbolizes this with a smart animal that works in a group to achieve a common goal."
