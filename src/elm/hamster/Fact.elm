module Fact exposing (Fact, decode, encode, toHtml, toHamsterQuery, simpleFact)

import Html exposing (Html, text, ul, li)
import EncodeExtras exposing (encodeMaybe)
import Json.Decode as Decode exposing (Decoder, (:=), string, int, float, list, object1, object7, maybe)
import Json.Encode as Encode exposing (encode, Value)
import HamsterAPI as API exposing (..)
import Date exposing (Date, toTime)
import Tag exposing (Tag)
import Tags exposing (Tags)
import Activity exposing (Activity)


{-| Create a `Fact` with the bear minimum required data. This fact only
exists locally in the application.

    simpleFact "what I'm doing" "cateogry" ["tag1", "tag2"] == Fact
-}
simpleFact : String -> String -> List String -> Fact
simpleFact name category tags =
    Fact Nothing
        (Date.fromTime 0)
        (Date.fromTime 0)
        0
        "Description"
        (Activity name category)
        (List.map (\tag -> Tag Nothing tag) tags)


type alias Fact =
    { id : Maybe Int
    , startDate : Date
    , endDate : Date
    , totalSeconds : Int
    , description : String
    , activity : Activity
    , tags : Tags
    }


decode : Decoder Fact
decode =
    object7 Fact
        ("id" := maybe int)
        (Decode.object1 Date.fromTime ("startEpoch" := float))
        (Decode.object1 Date.fromTime ("endEpoch" := float))
        ("totalSeconds" := int)
        ("description" := string)
        ("activity" := Activity.decode)
        ("tags" := Tags.decode)


encode : Fact -> Value
encode fact =
    Encode.object
        [ ( "id", (encodeMaybe Encode.int fact.id) )
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
