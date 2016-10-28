module Main exposing (..)

import Html exposing (Html, div, text, input, h1, h2, label, form, fieldset, ul, li, button)
import Html.Attributes exposing (for, id, placeholder, value)
import Html.Events exposing (onSubmit, onInput)
import Html.App
import HamsterAPI exposing (HamsterMsg(Success, Error))
import HamsterClient exposing (call)
import HamsterCalls exposing (getTodaysFacts, createFact)
import Facts exposing (Facts)
import Fact exposing (Fact, simpleFact)
import Date exposing (Date)
import String


type alias Model =
    { facts : Facts
    , form :
        { name : String
        , category : String
        , tags : String
        }
    }


empty : Model
empty =
    Model [] { name = "", category = "", tags = "" }


type Msg
    = FetchTodaysFacts
    | FetchedTodaysFacts (HamsterMsg Facts)
    | CreateFact String
    | CreatedFact (HamsterMsg Fact)
    | Log String String
    | FormNameChanged String
    | FormCategoryChanged String
    | FormTagsChanged String


renderFacts : Model -> Html a
renderFacts model =
    case List.isEmpty model.facts of
        True ->
            text "Nothing yet. Get to work!"

        False ->
            ul [] (List.map (\fact -> li [] [ Fact.toHtml fact ]) model.facts)


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
        , form [ id "activity-form" ]
            [ fieldset [ for "activity-form" ]
                [ textInput "Name" "coding in elm" model.form.name FormNameChanged
                , textInput "Category" "Work" model.form.category FormCategoryChanged
                , textInput "Tags" "coding, elm" model.form.tags FormTagsChanged
                , button [] [ text "Save" ]
                ]
            ]
        , h2 [] [ text "What you've done today" ]
        , renderFacts model
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

        CreatedFact fact ->
            ( model, Cmd.none )

        -- TODO implement this next
        CreateFact factString ->
            let
                response =
                    Nothing

                -- call (createFact (fromFactString factString))
            in
                update FetchTodaysFacts model

        FetchedTodaysFacts factMsg ->
            case factMsg of
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


main =
    Html.App.program
        { update = update
        , view = view
        , init = init
        , subscriptions = subscriptions
        }
