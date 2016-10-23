module HamsterClient exposing (..)

import GetTags
import Http
import Task
import HamsterAPI as API exposing (HamsterResponse, ResponseMsg(Error), ResponseMsg(Success), ResponseMsg)
import Json.Decode as Json exposing ((:=), string, int, object2)
import Html exposing (Html, text, ul, li)
import Html.App
import HamsterAPI as API exposing (HamsterRequest)
import GetTags
import GetActivities


{-| Perform a call to the Hamster REST endpoint using the supplied `Json.Decoder`.
-}
call : HamsterRequest payload -> Cmd (ResponseMsg payload)
call hamsterCall =
    Task.perform (Error hamsterCall) (Success hamsterCall) (Http.get hamsterCall.decoder (API.endpoint hamsterCall.method))



-- Stuff just for the main test


update : ResponseMsg payload -> HamsterResponse payload -> ( HamsterResponse payload, Cmd (ResponseMsg payload) )
update msg response =
    case msg of
        Success hamsterCall decodedTags ->
            ( HamsterResponse [] (Just decodedTags) hamsterCall.toHtml, Cmd.none )

        Error hamsterCall err ->
            case err of
                Http.NetworkError ->
                    ( HamsterResponse [ "network error" ] Nothing hamsterCall.toHtml, Cmd.none )

                Http.Timeout ->
                    ( HamsterResponse [ "network timeout" ] Nothing hamsterCall.toHtml, Cmd.none )

                Http.UnexpectedPayload payload ->
                    ( HamsterResponse [ payload ] Nothing hamsterCall.toHtml, Cmd.none )

                Http.BadResponse status response ->
                    ( HamsterResponse [ "Bad response", toString (status), response ] Nothing hamsterCall.toHtml, Cmd.none )


view : HamsterResponse payload -> Html (ResponseMsg payload)
view response =
    case response.data of
        Nothing ->
            ul []
                (List.map (\error -> li [] [ text error ]) response.errors)

        Just data ->
            response.toHtml data


init : HamsterRequest payload -> ( HamsterResponse payload, Cmd (ResponseMsg payload) )
init hamsterCall =
    ( API.emptyResponse
    , call hamsterCall
    )


subscriptions : HamsterResponse payload -> Sub (ResponseMsg payload)
subscriptions response =
    Sub.none


main =
    Html.App.program
        { update = update
        , view = view
        , init = init GetTags.hamsterCall
        , subscriptions = subscriptions
        }
