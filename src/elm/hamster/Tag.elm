module Tag exposing (..)

import Html exposing (Html, text, ul, li)
import Json.Decode as Json exposing ((:=), string, int, object2)
import Json.Encode as Encode exposing (Value)
import HamsterAPI as API exposing (..)


{-| Represents a tag in Hamster
-}
type alias Tag =
    { id : Int
    , name : String
    }


encode : Tag -> Value
encode tag =
    Encode.object
        [ ( "id", Encode.int tag.id )
        , ( "name", Encode.string tag.name )
        ]


decode : Json.Decoder (Tag)
decode =
    object2 Tag
        ("id" := int)
        ("name" := string)


toHtml : Tag -> Html a
toHtml tag =
    li []
        [ text (tag.name ++ " (" ++ toString (tag.id) ++ ")") ]
