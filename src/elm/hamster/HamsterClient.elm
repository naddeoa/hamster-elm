module HamsterClient exposing (call)

import Http
import Task
import HamsterAPI as API exposing (HamsterResponse, ResponseMsg(Error), ResponseMsg(Success), ResponseMsg)
import Json.Decode as Json exposing ((:=), string, int, object2)
import Html exposing (Html, text, ul, li)
import Html.App
import HamsterAPI as API exposing (HamsterRequest)
import HamsterCalls


{-| Perform a call to the Hamster REST endpoint using the supplied `Json.Decoder`.
-}
call : HamsterRequest payload -> Cmd (ResponseMsg payload)
call hamsterCall =
    Task.perform (Error hamsterCall) (Success hamsterCall) (Http.get hamsterCall.decoder (API.endpoint hamsterCall.method))
