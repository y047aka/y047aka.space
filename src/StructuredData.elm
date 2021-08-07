module StructuredData exposing (article, elmLang, person, softwareSourceCode)

import Json.Encode as Encode
import Pages.Url


{-| <https://schema.org/SoftwareSourceCode>
-}
softwareSourceCode :
    { codeRepositoryUrl : String
    , description : String
    , author : String
    , programmingLanguage : Encode.Value
    }
    -> Encode.Value
softwareSourceCode info =
    Encode.object
        [ ( "@type", Encode.string "SoftwareSourceCode" )
        , ( "codeRepository", Encode.string info.codeRepositoryUrl )
        , ( "description", Encode.string info.description )
        , ( "author", Encode.string info.author )
        , ( "programmingLanguage", info.programmingLanguage )
        ]


{-| <https://schema.org/ComputerLanguage>
-}
computerLanguage : { url : String, name : String, imageUrl : String, identifier : String } -> Encode.Value
computerLanguage info =
    Encode.object
        [ ( "@type", Encode.string "ComputerLanguage" )
        , ( "url", Encode.string info.url )
        , ( "name", Encode.string info.name )
        , ( "image", Encode.string info.imageUrl )
        , ( "identifier", Encode.string info.identifier )
        ]


elmLang : Encode.Value
elmLang =
    computerLanguage
        { url = "http://elm-lang.org/"
        , name = "Elm"
        , imageUrl = "http://elm-lang.org/"
        , identifier = "http://elm-lang.org/"
        }


{-| <https://schema.org/Article>
-}
article :
    { title : String
    , description : String
    , author : StructuredData { authorMemberOf | personOrOrganization : () } authorPossibleFields
    , publisher : StructuredData { publisherMemberOf | personOrOrganization : () } publisherPossibleFields
    , url : String
    , imageUrl : Pages.Url.Url
    , datePublished : String
    , mainEntityOfPage : Encode.Value
    }
    -> Encode.Value
article info =
    Encode.object
        [ ( "@context", Encode.string "http://schema.org/" )
        , ( "@type", Encode.string "Article" )
        , ( "headline", Encode.string info.title )
        , ( "description", Encode.string info.description )
        , ( "image", Encode.string (Pages.Url.toString info.imageUrl) )
        , ( "author", encode info.author )
        , ( "publisher", encode info.publisher )
        , ( "url", Encode.string info.url )
        , ( "datePublished", Encode.string info.datePublished )
        , ( "mainEntityOfPage", info.mainEntityOfPage )
        ]


type StructuredData memberOf possibleFields
    = StructuredData String (List ( String, Encode.Value ))


{-| <https://schema.org/Person>
-}
person :
    { name : String
    }
    ->
        StructuredData
            { personOrOrganization : () }
            { additionalName : ()
            , address : ()
            , affiliation : ()
            }
person info =
    StructuredData "Person" [ ( "name", Encode.string info.name ) ]


encode : StructuredData memberOf possibleFieldsPublisher -> Encode.Value
encode (StructuredData typeName fields) =
    Encode.object
        (( "@type", Encode.string typeName ) :: fields)
