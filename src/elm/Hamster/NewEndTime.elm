module NewEndTime exposing (NewEndTime, decode, encode, toHamsterQuery)

import Html exposing (Html, div, text)
import Json.Decode as Json exposing ((:=), string, int, float, list, object1, object7)
import Json.Encode as Encode exposing (encode, Value)
import HamsterAPI as API exposing (..)
import Date exposing (Date, toTime)
import Tags exposing (Tags)
import Activity exposing (Activity)
import Dict exposing (Dict)
import Time exposing (Time)


type alias NewEndTime =
    { endEpoch : Time }


decode : Json.Decoder NewEndTime
decode =
    object1 NewEndTime
        ("endEpoch" := float)


encode : NewEndTime -> Value
encode newEndTime =
    Encode.object
        [ ( "endEpoch", Encode.float newEndTime.endEpoch )
        ]


toHamsterQuery : NewEndTime -> String
toHamsterQuery newEndTime =
    ""
