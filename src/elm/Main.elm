module Main exposing (..)

import Html exposing (Html, div, text, input, h1, h2, label, ul, li)
import Html.Attributes as Attributes exposing (for, id, placeholder, value)
import Html.Events as Events
import Html.App
import Time exposing (Time)
import HamsterAPI
import HamsterClient
import HamsterCalls
import Facts exposing (Facts)
import Fact exposing (Fact)
import NewEndTime exposing (NewEndTime)
import Bootstrap.Elements as Elements
import Bootstrap.Properties as Properties
import Bootstrap.Components as Components
import Components.FactTable as FactTable
import Components.FactForm as FactForm exposing (FactForm)
import Components.UserMessage as UserMessage exposing (UserMessage)


type alias Model =
    { facts : Facts
    , form : FactForm
    , userMessages : UserMessage
    }


empty : Model
empty =
    Model [] FactForm.empty UserMessage.empty


type Msg
    = FetchTodaysFacts
    | FetchedTodaysFacts (HamsterAPI.HamsterMsg Facts)
    | CreatedFact (HamsterAPI.HamsterMsg Fact)
    | StoppedTracking (HamsterAPI.HamsterMsg NewEndTime)
    | APICallFinished (List String)
    | StopTracking
    | FormChanged FactForm.Event
    | CreateFact FactForm
    | LoadFactIntoForm Fact
    | Refresh Time


view : Model -> Html Msg
view model =
    let
        stopTrackingButton =
            case Facts.inProgress model.facts of
                True ->
                    Elements.button [ Properties.PrimaryButton ] [ Events.onClick StopTracking ] [ text "Stop tracking" ]

                False ->
                    Elements.button [] [ Attributes.disabled True ] [ text "Not currently tracking" ]

        formSection =
            Elements.column [ Properties.ExtraSmallColumn 12, Properties.MediumColumn 4 ]
                []
                [ h2 [] [ text "What are you doing?" ]
                , FactForm.create model.form
                ]
    in
        div []
            [ Components.titleWithSub "Hamster dashboard" (Just "the elm time tracker")
            , Elements.container []
                [ UserMessage.userMessage model.userMessages
                , Html.App.map FormChanged formSection
                , Elements.column [ Properties.ExtraSmallColumn 12, Properties.MediumColumn 8 ]
                    []
                    [ h2 [] [ text "What you've done today" ]
                    , FactTable.factTable model.facts LoadFactIntoForm
                    , stopTrackingButton
                    ]
                ]
            , Html.p [] []
            ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        StopTracking ->
            let
                hamsterClientCmd =
                    HamsterClient.call HamsterCalls.stopTracking
            in
                ( model, Cmd.map StoppedTracking hamsterClientCmd )

        StoppedTracking newEndTimeMsg ->
            case newEndTimeMsg of
                HamsterAPI.Success request fact ->
                    update FetchTodaysFacts model

                HamsterAPI.Error request httpError ->
                    ( model, Cmd.none )

        CreateFact form ->
            let
                hamsterClientCmd =
                    HamsterClient.call (HamsterCalls.createFact (FactForm.toFact form))
            in
                ( model, Cmd.map CreatedFact hamsterClientCmd )

        FormChanged event ->
            case event of
                FactForm.Submit form ->
                    update (CreateFact form) { model | form = form }

                FactForm.Change form field string ->
                    ( { model | form = FactForm.handle event }, Cmd.none )

        CreatedFact factMsg ->
            case factMsg of
                HamsterAPI.Success request fact ->
                    update FetchTodaysFacts { model | userMessages = UserMessage.empty }

                HamsterAPI.Error request httpError ->
                    update (APICallFinished [ toString httpError ]) model

        FetchedTodaysFacts factsMsg ->
            case factsMsg of
                HamsterAPI.Success request facts ->
                    ( { model | facts = facts, userMessages = UserMessage.empty }, Cmd.none )

                HamsterAPI.Error request httpError ->
                    update (APICallFinished [ toString httpError ]) model

        FetchTodaysFacts ->
            let
                hamsterClientCmd =
                    HamsterClient.call HamsterCalls.getTodaysFacts
            in
                ( model, Cmd.map FetchedTodaysFacts hamsterClientCmd )

        LoadFactIntoForm fact ->
            ( { model | form = FactForm.fromFact fact }, Cmd.none )

        Refresh time ->
            update FetchTodaysFacts model

        APICallFinished errors ->
            ( { model | userMessages = UserMessage.ofErrors <| [ "Couldn't call the Hamster API" ] ++ errors }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every (Time.second * 5) Refresh


init : ( Model, Cmd Msg )
init =
    update FetchTodaysFacts empty


main : Program Never
main =
    Html.App.program
        { update = update
        , view = view
        , init = init
        , subscriptions = subscriptions
        }
