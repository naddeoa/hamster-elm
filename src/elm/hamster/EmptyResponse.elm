module EmptyResponse exposing (EmptyResponse, decode, encode, toHtml, toHamsterQuery)

import Html exposing (Html, div)
import Json.Decode as Json exposing ((:=), string, int, float, list, object1, object7)
import Json.Encode as Encode exposing (encode, Value)
import HamsterAPI as API exposing (..)
import Date exposing (Date, toTime)
import Tags exposing (Tags)
import Activity exposing (Activity)
import Dict exposing (Dict)


type alias EmptyResponse =
    Dict String String


decode : Json.Decoder EmptyResponse
decode =
    Json.dict string


encode : EmptyResponse -> Value
encode fact =
    Encode.object []


toHamsterQuery : EmptyResponse -> String
toHamsterQuery response =
    ""


toHtml : EmptyResponse -> Html a
toHtml fact =
    div [] []
