module Main exposing (Model, Msg, update, view)

import HamsterCalls
import Html exposing (Html, div, text, input, button)
import Html.App
import Html.Events exposing (onClick)
import HamsterAPI exposing (HamsterMsg)
import NewEndTime exposing (NewEndTime)
import Html.Attributes exposing (disabled)
import HamsterClient exposing (call, handle)
import Time exposing (Time)


type alias Model =
    { label : String
    , currentlyTracking : Bool
    , waitingForTrackingResults : Bool
    , lastStoppedTime : Maybe Time
    }


getReadableLastStoppedTime : Model -> String
getReadableLastStoppedTime model =
    case model.lastStoppedTime of
        Nothing ->
            "Not currently tracking"

        Just time ->
            "Have not tracked since " ++ (toString time)


getButtonLabel : Model -> String
getButtonLabel model =
    if model.waitingForTrackingResults then
        "Waiting for a response..."
    else if model.currentlyTracking then
        model.label
    else
        getReadableLastStoppedTime model


type Msg
    = TrackingStopped (HamsterMsg NewEndTime)
    | StopTracking
    | NoOp


view : Model -> Html Msg
view model =
    let
        ( disabledState, buttonText ) =
            ( model.waitingForTrackingResults || not model.currentlyTracking, getButtonLabel model )
    in
        button [ disabled disabledState, onClick StopTracking ] [ text buttonText ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        StopTracking ->
            if model.currentlyTracking && not model.waitingForTrackingResults then
                let
                    hamsterCmd =
                        HamsterClient.call (HamsterCalls.stopTracking ())

                    cmd =
                        Cmd.map (\hamsterResponse -> TrackingStopped hamsterResponse) hamsterCmd
                in
                    ( { model | waitingForTrackingResults = True }, cmd )
            else
                ( model, Cmd.none )

        TrackingStopped hamsterMsg ->
            let
                ( response, hamsterCmd ) =
                    handle hamsterMsg

                newEndEpoch =
                    Maybe.map (\data -> data.endEpoch) response.data
            in
                ( { model
                    | waitingForTrackingResults = False
                    , lastStoppedTime = newEndEpoch
                    , currentlyTracking = False
                  }
                , Cmd.none
                )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


init : ( Model, Cmd Msg )
init =
    ( Model "Stop tracking" True False Nothing, Cmd.none )


main =
    Html.App.program
        { update = update
        , view = view
        , init = init
        , subscriptions = subscriptions
        }
