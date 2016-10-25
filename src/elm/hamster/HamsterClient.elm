module HamsterClient exposing (call, handle)

import Http exposing (empty)
import Task
import HamsterAPI as API exposing (HamsterResponse, HamsterMsg(Error), HamsterMsg(Success), HamsterMsg)
import Json.Decode as Json exposing ((:=), string, int, object2)
import Html exposing (Html, text, ul, li)
import Html.App
import HamsterAPI as API exposing (HamsterRequest, HttpMethod(GET), HttpMethod(POST))
import HamsterCalls


{-| Handle a call response from the Hamster API.
-}
handle : HamsterMsg payload -> ( HamsterResponse payload, Cmd (HamsterMsg payload) )
handle msg =
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
call : HamsterRequest payload -> Cmd (HamsterMsg payload)
call hamsterRequest =
    let
        request =
            case hamsterRequest.verb of
                POST ->
                    Http.post hamsterRequest.decoder (API.endpoint hamsterRequest.method) empty

                GET ->
                    Http.get hamsterRequest.decoder (API.endpoint hamsterRequest.method)
    in
        Task.perform (Error hamsterRequest) (Success hamsterRequest) request
