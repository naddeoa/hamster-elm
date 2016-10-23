module GetActivities exposing (..)

import Html exposing (Html, text, ul, li)
import Json.Decode as Json exposing ((:=), string, object2)
import HamsterAPI as API exposing (..)


type alias Activity =
    { activity : String
    , category : String
    }


type alias Activities =
    List Activity


hamsterCall : HamsterCall Activities
hamsterCall =
    HamsterCall decode toHtml "activities/"


decode : Json.Decoder Activities
decode =
    let
        activity =
            object2 Activity
                ("activity" := string)
                ("category" := string)
    in
        Json.list activity


toHtml : Activities -> Html (ResponseMsg Activities)
toHtml activities =
    ul []
        (List.map (\activity -> li [] [ text (activity.activity ++ ", " ++ activity.category) ]) activities)
