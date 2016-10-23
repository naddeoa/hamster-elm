module GetTags exposing (..)

import Html exposing (Html, text, ul, li)
import Json.Decode as Json exposing ((:=), string, int, object2)
import Json.Encode as Encode exposing (Value)
import HamsterAPI as API exposing (..)


type alias Tag =
    { id : Int
    , name : String
    }


type alias Tags =
    List Tag


hamsterCall : HamsterCall Tags
hamsterCall =
    API.HamsterCall decode toHtml "tags" encodeTags


decode : Json.Decoder (Tags)
decode =
    let
        tag =
            object2 Tag
                ("id" := int)
                ("name" := string)
    in
        Json.list tag


encodeTag : Tag -> Value
encodeTag tag =
    Encode.object
        [ ( "id", Encode.int tag.id )
        , ( "name", Encode.string tag.name )
        ]


encodeTags : Tags -> Value
encodeTags tags =
    Encode.list (List.map encodeTag tags)


toHtml : Tags -> Html (ResponseMsg Tags)
toHtml tags =
    ul []
        (List.map (\tag -> li [] [ text tag.name ]) tags)
