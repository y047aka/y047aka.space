module Index exposing (view)

import Css exposing (..)
import Css.Extra exposing (orNoStyle, palette)
import Css.Media as Media exposing (only, screen, withMedia)
import Css.Palette exposing (button, buttonOnHover)
import Date
import Html.Styled exposing (Html, a, h1, li, span, text, ul)
import Html.Styled.Attributes exposing (css, href)
import Metadata exposing (Metadata)
import Pages
import Pages.PagePath as PagePath exposing (PagePath)


type alias PostEntry =
    ( PagePath Pages.PathKey, Metadata.ArticleMetadata )


view : List ( PagePath Pages.PathKey, Metadata ) -> List (Html msg)
view posts =
    [ posts
        |> List.filterMap
            (\( path, metadata ) ->
                case metadata of
                    Metadata.Page meta ->
                        Nothing

                    Metadata.Article meta ->
                        if meta.draft then
                            Nothing

                        else
                            Just ( path, meta )

                    Metadata.BlogIndex ->
                        Nothing
            )
        |> List.sortWith postPublishDateDescending
        |> List.map postSummary
        |> ul []
    ]


postPublishDateDescending : PostEntry -> PostEntry -> Order
postPublishDateDescending ( _, metadata1 ) ( _, metadata2 ) =
    Date.compare metadata2.published metadata1.published


postSummary : PostEntry -> Html msg
postSummary ( postPath, post ) =
    li
        [ css
            [ listStyle none
            , nthChild "n+2"
                [ marginTop (px 5) ]
            ]
        ]
        [ linkToPost postPath
            [ title post.title
            , span
                [ css
                    [ fontSize (px 13)
                    , lineHeight (int 1)
                    , orNoStyle button.optionalColor color
                    ]
                ]
                [ text (Date.format "MMMM ddd, yyyy" post.published) ]
            ]
        ]


linkToPost : PagePath Pages.PathKey -> List (Html msg) -> Html msg
linkToPost postPath contents =
    let
        url =
            PagePath.toString postPath
    in
    a
        [ href url
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


title : String -> Html msg
title str =
    h1
        [ css
            [ fontSize (px 16)
            , fontWeight (int 600)
            , lineHeight (num 1.5)
            ]
        ]
        [ text str ]
