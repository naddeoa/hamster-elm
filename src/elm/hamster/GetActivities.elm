module GetActivities exposing (..)

import Html exposing (Html, text, ul, li)
import Json.Decode as Json exposing ((:=), string, object2)
import Json.Encode as Encode exposing (encode, Value)
import HamsterAPI as API exposing (..)


type alias Activity =
    { name : String
    , category : String
    }


type alias Activities =
    List Activity


hamsterCall : HamsterCall Activities
hamsterCall =
    HamsterCall decode toHtml "activities/" encodeActivities


decode : Json.Decoder Activities
decode =
    let
        activity =
            object2 Activity
                ("name" := string)
                ("category" := string)
    in
        Json.list activity


encodeActivity : Activity -> Value
encodeActivity activity =
    Encode.object
        [ ( "name", Encode.string activity.name )
        , ( "category", Encode.string activity.category )
        ]


encodeActivities : Activities -> Value
encodeActivities activities =
    Encode.list (List.map encodeActivity activities)


toHtml : Activities -> Html (ResponseMsg Activities)
toHtml activities =
    ul []
        (List.map (\activity -> li [] [ text (activity.name ++ ", " ++ activity.category) ]) activities)
