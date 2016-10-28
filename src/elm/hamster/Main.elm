module Main exposing (..)

import Http
import Task
import HamsterAPI as API exposing (HamsterResponse, HamsterMsg(Error), HamsterMsg(Success), HamsterMsg)
import Json.Decode as Json exposing ((:=), string, int, object2)
import Html exposing (Html, text, ul, li)
import Html.App
import HamsterAPI as API exposing (HamsterRequest)
import HamsterCalls
import HamsterClient exposing (call, handle)
import Facts exposing (Facts)
import Fact exposing (Fact)
import Activity exposing (Activity)
import Tags exposing (Tags)
import Tag exposing (Tag)
import Date exposing (Date)


view : HamsterResponse payload -> Html (HamsterMsg payload)
view response =
    case response.data of
        Nothing ->
            ul []
                (List.map (\error -> li [] [ text error ]) response.errors)

        Just data ->
            response.toHtml data


update : HamsterMsg payload -> HamsterResponse payload -> ( HamsterResponse payload, Cmd (HamsterMsg payload) )
update msg model =
    let
        ( response, cmd ) =
            handle msg
    in
        ( response, Cmd.none )


model : HamsterResponse payload
model =
    API.emptyResponse


init =
    let
        activity =
            Activity "writing elm front end" "Work"

        tags =
            [ Tag Nothing "elm" ]

        fact =
            Fact Nothing (Date.fromTime 1477422711) (Date.fromTime 0) 0 "my description" activity tags
    in
        ( API.emptyResponse, (call (HamsterCalls.getTodaysFacts ())) )


subscriptions : HamsterResponse payload -> Sub (HamsterMsg payload)
subscriptions response =
    Sub.none


main =
    Html.App.program
        { update = update
        , view = view
        , init = init
        , subscriptions = subscriptions
        }
