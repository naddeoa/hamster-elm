module Activity exposing (..)

import Html exposing (Html, text, ul, li)
import Json.Decode as Json exposing ((:=), string, object2)
import Json.Encode as Encode exposing (encode, Value)
import HamsterAPI as API exposing (..)


type alias Activity =
    { name : String
    , category : String
    }


decode : Json.Decoder Activity
decode =
    object2 Activity
        ("name" := string)
        ("category" := string)


encode : Activity -> Value
encode activity =
    Encode.object
        [ ( "name", Encode.string activity.name )
        , ( "category", Encode.string activity.category )
        ]


toHtml : Activity -> Html a
toHtml activity =
    li []
        [ text (activity.name ++ ", " ++ activity.category) ]
