module Fact exposing (Fact, decode, encode, toHtml, toHamsterQuery)

import Html exposing (Html, text, ul, li)
import Json.Decode as Json exposing ((:=), string, int, float, list, object1, object7)
import Json.Encode as Encode exposing (encode, Value)
import HamsterAPI as API exposing (..)
import Date exposing (Date, toTime)
import Tags exposing (Tags)
import Activity exposing (Activity)


type alias Fact =
    { id : Int
    , startDate : Date
    , endDate : Date
    , totalSeconds : Int
    , description : String
    , activity : Activity
    , tags : Tags
    }


decode : Json.Decoder Fact
decode =
    object7 Fact
        ("id" := int)
        (Json.object1 Date.fromTime ("startEpoch" := float))
        (Json.object1 Date.fromTime ("endEpoch" := float))
        ("totalSeconds" := int)
        ("description" := string)
        ("activity" := Activity.decode)
        ("tags" := Tags.decode)


encode : Fact -> Value
encode fact =
    Encode.object
        [ ( "id", Encode.int fact.id )
        , ( "startEpoch", Encode.float (Date.toTime fact.startDate) )
        , ( "endEpoch", Encode.float (Date.toTime fact.endDate) )
        , ( "totalSeconds", Encode.int fact.totalSeconds )
        , ( "description", Encode.string fact.description )
        , ( "activity", Activity.encode fact.activity )
        , ( "tags", Tags.encode fact.tags )
        ]


toHamsterQuery : Fact -> String
toHamsterQuery fact =
    (Activity.toHamsterQuery fact.activity) ++ ", " ++ (Tags.toHamsterQuery fact.tags)


toHtml : Fact -> Html a
toHtml fact =
    li []
        [ text (toHamsterQuery fact) ]
