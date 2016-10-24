module HamsterClient exposing (call, update)

import Http
import Task
import HamsterAPI as API exposing (HamsterResponse, ResponseMsg(Error), ResponseMsg(Success), ResponseMsg)
import Json.Decode as Json exposing ((:=), string, int, object2)
import Html exposing (Html, text, ul, li)
import Html.App
import HamsterAPI as API exposing (HamsterRequest)
import HamsterCalls


update : ResponseMsg payload -> HamsterResponse payload -> ( HamsterResponse payload, Cmd (ResponseMsg payload) )
update msg response =
    case msg of
        Success hamsterCall payload ->
            ( HamsterResponse [] (Just payload) hamsterCall.toHtml, Cmd.none )

        Error hamsterCall err ->
            case err of
                Http.NetworkError ->
                    ( HamsterResponse [ "network error" ] Nothing hamsterCall.toHtml, Cmd.none )

                Http.Timeout ->
                    ( HamsterResponse [ "network timeout" ] Nothing hamsterCall.toHtml, Cmd.none )

                Http.UnexpectedPayload payload ->
                    ( HamsterResponse [ "UnexpectedPayload ", payload ] Nothing hamsterCall.toHtml, Cmd.none )

                Http.BadResponse status response ->
                    ( HamsterResponse [ "BadResponse", toString (status), response ] Nothing hamsterCall.toHtml, Cmd.none )


{-| Perform a call to the Hamster REST endpoint using the supplied `Json.Decoder`.
-}
call : HamsterRequest payload -> Cmd (ResponseMsg payload)
call hamsterCall =
    Task.perform (Error hamsterCall) (Success hamsterCall) (Http.get hamsterCall.decoder (API.endpoint hamsterCall.method))
