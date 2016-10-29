module Main exposing (..)

import Html exposing (Html, div, text, input, h1, h2, label, form, fieldset, ul, li, button)
import Html.Attributes exposing (for, id, placeholder, value)
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
import Components.Library exposing (..)


type alias Model =
    { facts : Facts
    , form : Form
    }


type alias Form =
    { name : String
    , category : String
    , tags : String
    }


empty : Model
empty =
    Model [] { name = "", category = "", tags = "" }


toFact : Form -> Fact
toFact form =
    simpleFact form.name form.category (String.split "," form.tags)


type Msg
    = FetchTodaysFacts
    | FetchedTodaysFacts (HamsterMsg Facts)
    | CreatedFact (HamsterMsg Fact)
    | StoppedTracking (HamsterMsg NewEndTime)
    | StopTracking
    | Log String String
    | FormNameChanged String
    | FormCategoryChanged String
    | FormTagsChanged String
    | FormSubmit Form


renderFacts : Model -> Html a
renderFacts model =
    case List.isEmpty model.facts of
        True ->
            text "Nothing yet. Get to work!"

        False ->
            ul [] (List.map (\fact -> li [] [ Fact.toHtml fact, text (toString (Date.toTime fact.endDate)) ]) model.facts)


textInput : String -> String -> String -> (String -> a) -> Html a
textInput labelText placeholderText valueText msg =
    div []
        [ label [ for "activity-field" ] [ text labelText ]
        , input
            [ id "actvity-field"
            , placeholder placeholderText
            , value valueText
            , onInput msg
            ]
            []
        ]


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Hamster dashboard" ]
        , h2 [] [ text "What are you doing?" ]
        , form [ id "activity-form", onSubmit (FormSubmit model.form) ]
            [ fieldset [ for "activity-form" ]
                [ textEntry
                    (TextEntryModel "Name" "name" (Just "coding in elm"))
                    [ value model.form.name, onInput FormNameChanged ]
                , textEntry
                    (TextEntryModel "Category" "category" (Just "Work"))
                    [ value model.form.category, onInput FormCategoryChanged ]
                , textEntry
                    (TextEntryModel "Tags" "tags" (Just "coding, elm"))
                    [ value model.form.tags, onInput FormTagsChanged ]
                , button [] [ text "Save" ]
                ]
            ]
        , h2 [] [ text "What you've done today" ]
        , renderFacts model
        , button [ onClick StopTracking ] [ text "Stop tracking" ]
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
                    call (createFact (toFact form))
            in
                ( model, Cmd.map CreatedFact hamsterClientCmd )

        FormNameChanged name ->
            let
                { form } =
                    model
            in
                ( { model | form = { form | name = name } }, Cmd.none )

        FormCategoryChanged category ->
            let
                { form } =
                    model
            in
                ( { model | form = { form | category = category } }, Cmd.none )

        FormTagsChanged tags ->
            let
                { form } =
                    model
            in
                ( { model | form = { form | tags = tags } }, Cmd.none )

        CreatedFact factMsg ->
            case factMsg of
                Success request fact ->
                    -- ( { model | facts = facts }, Cmd.none )
                    update FetchTodaysFacts model

                Error request httpError ->
                    let
                        dbg =
                            Debug.log "error response" httpError
                    in
                        ( model, Cmd.none )

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
