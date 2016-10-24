module Main exposing (..)

import Http
import Task
import HamsterAPI as API exposing (HamsterResponse, ResponseMsg(Error), ResponseMsg(Success), ResponseMsg)
import Json.Decode as Json exposing ((:=), string, int, object2)
import Html exposing (Html, text, ul, li)
import Html.App
import HamsterAPI as API exposing (HamsterRequest)
import HamsterCalls
import HamsterClient exposing (call, update)


-- Stuff just for the main test


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
    ( API.emptyResponse, call hamsterCall )


subscriptions : HamsterResponse payload -> Sub (ResponseMsg payload)
subscriptions response =
    Sub.none


main =
    Html.App.program
        { update = update
        , view = view
        , init = init (HamsterCalls.getTodaysFacts ())
        , subscriptions = subscriptions
        }
