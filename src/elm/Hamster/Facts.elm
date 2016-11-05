module Facts exposing (Facts, decode, encode, empty, isEmpty, inProgress)

import Html exposing (Html, text, ul, li)
import Json.Decode as Json exposing ((:=), string, int, list, object1, object7)
import Json.Encode as Encode exposing (encode, Value)
import HamsterAPI as API exposing (..)
import Fact exposing (Fact)


type alias Facts =
    List Fact


empty : Facts
empty =
    []


isEmpty : Facts -> Bool
isEmpty facts =
    List.isEmpty facts


decode : Json.Decoder Facts
decode =
    Json.list Fact.decode

inProgress : Facts -> Bool
inProgress facts =
    List.any Fact.inProgress facts

encode : Facts -> Value
encode facts =
    Encode.list (List.map Fact.encode facts)
