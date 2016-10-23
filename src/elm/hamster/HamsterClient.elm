module HamsterClient exposing (..)

import GetTags
import Http
import Task
import HamsterAPI as API exposing (HamsterResponse, ResponseMsg(Error), ResponseMsg(Success), ResponseMsg)
import Json.Decode as Json exposing ((:=), string, int, object2)
import Html exposing (Html, text, ul, li)
import Html.App
import HamsterAPI as API exposing (HamsterCall)
import GetTags


{-| Perform a call to the Hamster REST endpoint using the supplied `Json.Decoder`.
-}
call : HamsterCall payload -> Cmd (ResponseMsg payload)
call hamsterCall =
    Task.perform Error Success (Http.get hamsterCall.decoder (API.endpoint hamsterCall.method))



-- Stuff just for the main test


update : ResponseMsg payload -> HamsterResponse payload -> ( HamsterResponse payload, Cmd (ResponseMsg payload) )
update msg response =
    case msg of
        Success decodedTags ->
            ( HamsterResponse [] (Just decodedTags), Cmd.none )

        Error err ->
            case err of
                Http.NetworkError ->
                    ( HamsterResponse [ "network error" ] Nothing, Cmd.none )

                Http.Timeout ->
                    ( HamsterResponse [ "network timeout" ] Nothing, Cmd.none )

                Http.UnexpectedPayload payload ->
                    ( HamsterResponse [ payload ] Nothing, Cmd.none )

                Http.BadResponse status response ->
                    ( HamsterResponse [ "Bad response", toString (status), response ] Nothing, Cmd.none )


view : HamsterResponse payload -> Html (ResponseMsg payload)
view response =
    case response.data of
        Nothing ->
            ul []
                (List.map (\error -> li [] [ text error ]) response.errors)

        Just data ->
            text "worked"


init : HamsterCall payload -> ( HamsterResponse payload, Cmd (ResponseMsg payload) )
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
