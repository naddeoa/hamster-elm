module Main exposing (..)

import Html exposing (Html, div, text, input, h1, h2, label, ul, li)
import Html.Attributes as Attributes exposing (for, id, placeholder, value)
import Html.Events exposing (onSubmit, onInput, onClick)
import Html.App
import HamsterAPI exposing (HamsterMsg(Success, Error))
import HamsterClient exposing (call)
import HamsterCalls exposing (getTodaysFacts, createFact, stopTracking)
import Facts exposing (Facts)
import Fact exposing (Fact, simpleFact)
import NewEndTime exposing (NewEndTime)
import Date exposing (Date)
import String
import Components.Library as Components exposing (..)
import Bootstrap.Elements as Elements
import Bootstrap.Properties as Properties
import Bootstrap.Components
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
    | FetchedTodaysFacts (HamsterMsg Facts)
    | CreatedFact (HamsterMsg Fact)
    | StoppedTracking (HamsterMsg NewEndTime)
    | StopTracking
    | Log String String
    | FormChanged FactForm.FactFormChange
      -- | FormNameChanged String
      -- | FormCategoryChanged String
      -- | FormTagsChanged String
    | FormSubmit FactForm
    | LoadFactIntoForm Fact


view : Model -> Html Msg
view model =
    let
        currentlyTracking =
            (List.any Fact.inProgress model.facts)

        stopTrackingButton =
            case currentlyTracking of
                True ->
                    Elements.button [ Properties.PrimaryButton ] [ onClick StopTracking ] [ text "Stop tracking" ]

                False ->
                    Elements.button [] [ Attributes.disabled True ] [ text "Not currently tracking" ]

        formSection =
            Elements.column [ Properties.ExtraSmallColumn 12, Properties.MediumColumn 4 ]
                []
                [ h2 [] [ text "What are you doing?" ]
                , UserMessage.userMessage model.userMessages
                  -- TODO this is gross, I have to pass a single MyMsg TheirMsg instead, or map it
                , FactForm.factForm model.form
                ]
    in
        div []
            [ Components.titleWithSub "Hamster dashboard" (Just "the elm time tracker")
            , container []
                [ Html.App.map FormChanged formSection
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
        Log name string ->
            let
                dbg =
                    Debug.log name string
            in
                ( model, Cmd.none )

        StopTracking ->
            let
                hamsterClientCmd =
                    call stopTracking
            in
                ( model, Cmd.map StoppedTracking hamsterClientCmd )

        StoppedTracking newEndTimeMsg ->
            case newEndTimeMsg of
                Success request fact ->
                    update FetchTodaysFacts model

                Error request httpError ->
                    let
                        dbg =
                            Debug.log "error response" httpError
                    in
                        ( model, Cmd.none )

        FormSubmit form ->
            let
                hamsterClientCmd =
                    call (createFact (FactForm.toFact form))
            in
                ( model, Cmd.map CreatedFact hamsterClientCmd )

        FormChanged change ->
            ( { model | form = FactForm.handle change }, Cmd.none )

        CreatedFact factMsg ->
            case factMsg of
                Success request fact ->
                    -- ( { model | facts = facts }, Cmd.none )
                    update FetchTodaysFacts { model | userMessages = UserMessage.empty }

                Error request httpError ->
                    let
                        errorMessages =
                            UserMessage.ofErrors [ "Couldn't call the Hamster API" ]
                    in
                        ( { model | userMessages = errorMessages }, Cmd.none )

        FetchedTodaysFacts factsMsg ->
            case factsMsg of
                Success request facts ->
                    ( { model | facts = facts }, Cmd.none )

                Error request httpError ->
                    ( model, Cmd.none )

        FetchTodaysFacts ->
            let
                hamsterClientCmd =
                    call getTodaysFacts
            in
                ( model, Cmd.map FetchedTodaysFacts hamsterClientCmd )

        LoadFactIntoForm fact ->
            ( { model | form = FactForm.fromFact fact }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


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
