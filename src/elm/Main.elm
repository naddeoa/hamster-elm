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
import Components.FactForm as FactForm


type alias Model =
    { facts : Facts
    , form : FactForm.FactFormModel
    , userMessages : UserMessages
    }


type alias UserMessages =
    { errors : List String
    }


emptyUserMessages : UserMessages
emptyUserMessages =
    { errors = [] }


renderUserMessages : UserMessages -> Html a
renderUserMessages messages =
    let
        errorMessages =
            String.join ", " messages.errors
    in
        case List.isEmpty messages.errors of
            True ->
                Html.div [] []

            False ->
                Bootstrap.Components.contextBox errorMessages Properties.DangerBackground


empty : Model
empty =
    Model [] { name = "", category = "", tags = "" } { errors = [] }


toFact : FactForm.FactFormModel -> Fact
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
    | FormSubmit FactForm.FactFormModel
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
    in
        div []
            [ Components.titleWithSub "Hamster dashboard" (Just "the elm time tracker")
            , container []
                [ Elements.column [ Properties.ExtraSmallColumn 12, Properties.MediumColumn 4 ]
                    []
                    [ h2 [] [ text "What are you doing?" ]
                    , renderUserMessages model.userMessages
                      -- TODO this is gross, I have to pass a single MyMsg TheirMsg instead, or map it
                    , FactForm.factForm model.form FormNameChanged FormCategoryChanged FormTagsChanged FormSubmit
                    ]
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
                    update FetchTodaysFacts { model | userMessages = emptyUserMessages }

                Error request httpError ->
                    let
                        dbg =
                            Debug.log "error response" httpError

                        errorMessages =
                            UserMessages [ "Couldn't call the Hamster API" ]
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
            let
                tags =
                    (String.join ", " (List.map (\tag -> tag.name) fact.tags))

                form =
                    FactForm.FactFormModel fact.activity.name fact.activity.category tags
            in
                ( { model | form = form }, Cmd.none )


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
