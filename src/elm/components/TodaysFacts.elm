module Main exposing (..)

import HamsterAPI exposing (HamsterResponse, ResponseMsg)
import Html exposing (Html, div, text, input, h1, section, ul, li)
import Html.App
import HamsterClient
import HamsterCalls
import Facts exposing (Facts)


type alias Model =
    { facts : Facts
    , errors : List String
    }


type Msg
    = CallFinished (ResponseMsg Facts)


view : Model -> Html Msg
view model =
    case List.isEmpty model.errors of
        True ->
            section []
                [ h1 [] [ text "Today's facts" ]
                , case List.isEmpty model.facts of
                    True ->
                        text "no facts yet"

                    False ->
                        Facts.toHtml model.facts
                ]

        False ->
            section []
                [ h1 [] [ text "Couldn't get today's facts!" ]
                , ul [] (List.map (\error -> li [] [ text error ]) model.errors)
                ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CallFinished responseMsg ->
            let
                ( updatedFactsResponse, hamsterCmd ) =
                    HamsterClient.update responseMsg (HamsterAPI.responseOfPayload model.facts)
            in
                case updatedFactsResponse.data of
                    Nothing ->
                        ( Model [] updatedFactsResponse.errors, Cmd.none )

                    Just data ->
                        ( Model data [], Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


init : ( Model, Cmd Msg )
init =
    ( Model [] [], (Cmd.map (\responseMsg -> CallFinished responseMsg) (HamsterClient.call (HamsterCalls.getTodaysFacts ()))) )


main =
    Html.App.program
        { update = update
        , view = view
        , init = init
        , subscriptions = subscriptions
        }