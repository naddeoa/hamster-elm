module HamsterClient exposing (call, handle)

import Http exposing (empty)
import Task
import HamsterAPI as API exposing (HamsterResponse, HamsterMsg(Error), HamsterMsg(Success), HamsterMsg)
import Json.Decode as Json exposing ((:=), string, int, object2)
import Json.Encode as Encode
import Html exposing (Html, text, ul, li)
import Html.App
import HamsterAPI as API exposing (HamsterRequest, HttpMethod(GET), HttpMethod(POST))
import HamsterCalls
import Debug
import Task exposing (Task)


post : Json.Decoder value -> String -> Http.Body -> Task Http.Error value
post decoder url body =
  let request =
        { verb = "POST"
        , headers = [("Content-Type","application/json")]
        , url = url
        , body = body
        }
  in
      Http.fromJson decoder (Http.send Http.defaultSettings request)


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
                    let
                        body =
                            case hamsterCall.body of
                                Nothing ->
                                    ""

                                Just payload ->
                                    Encode.encode 0 (hamsterCall.toJsonValue payload)
                    in
                        ( HamsterResponse
                            [ toString hamsterCall
                            , toString err
                            , body
                            ]
                            Nothing
                            hamsterCall.toHtml
                        , Cmd.none
                        )

                Http.Timeout ->
                    ( HamsterResponse [ toString hamsterCall, toString err ] Nothing hamsterCall.toHtml, Cmd.none )

                Http.UnexpectedPayload payload ->
                    ( HamsterResponse [ toString hamsterCall, toString err, payload ] Nothing hamsterCall.toHtml, Cmd.none )

                Http.BadResponse status response ->
                    ( HamsterResponse [ toString hamsterCall, toString err, toString status, response ] Nothing hamsterCall.toHtml, Cmd.none )


{-| Perform a call to the Hamster REST endpoint using the supplied `Json.Decoder`.
-}
call : HamsterRequest payload -> Cmd (HamsterMsg payload)
call hamsterRequest =
    let
        request =
            case hamsterRequest.verb of
                POST ->
                    let
                        body =
                            case hamsterRequest.body of
                                Nothing ->
                                    empty

                                Just payload ->
                                    Http.string (Encode.encode 0 (hamsterRequest.toJsonValue payload))
                    in
                        post hamsterRequest.decoder (API.endpoint hamsterRequest.method) body

                GET ->
                    Http.get hamsterRequest.decoder (API.endpoint hamsterRequest.method)
    in
        Task.perform (Error hamsterRequest) (Success hamsterRequest) request
