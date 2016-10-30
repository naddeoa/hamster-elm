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
    | LoadFactIntoForm Fact


renderFactDate : Date -> String
renderFactDate date =
    let
        hour =
            -- time only comes out as gmy at the moment it seems
            toString (Date.hour date)

        minute =
            String.padLeft 2 '0' (toString (Date.minute date))
    in
        hour ++ ":" ++ minute


renderFactDates : Fact -> String
renderFactDates fact =
    case Fact.inProgress fact of
        True ->
            renderFactDate fact.startDate

        False ->
            renderFactDate fact.startDate ++ " - " ++ renderFactDate fact.endDate


parseMinutes : Fact -> Int
parseMinutes fact =
    Basics.floor (Basics.toFloat (fact.totalSeconds) / 60)


renderMinutes : Fact -> String
renderMinutes fact =
    formatMinutes (parseMinutes fact)




formatMinutes : Int -> String
formatMinutes totalMinutes =
    let
        minutes =
            totalMinutes % 60

        hours =
            Basics.floor (Basics.toFloat totalMinutes / 60)

        hourString =
            if hours > 0 then
                toString hours ++ "h "
            else
                ""
    in
        hourString ++ (toString minutes) ++ "m"


{-| TODO pull tables/rows into the component library
-}
renderFact : Fact -> Html Msg
renderFact fact =
    let
        duration =
            (Basics.toFloat fact.totalSeconds) / 60

        rowAttributes =
            if Fact.inProgress fact then
                [ Attributes.class "success" ]
            else
                []
    in
        Html.tr rowAttributes
            [ Html.td [] [ button "Load form" [ NormalButton, ExtraSmallButton ] [ onClick (LoadFactIntoForm fact) ] ]
            , Html.td [] [ text (renderFactDates fact) ]
            , Html.td [] [ text (renderMinutes fact) ]
            , Html.td [] [ text (Fact.toHamsterQuery fact) ]
            ]


renderTotals : Facts -> Html Msg
renderTotals facts =
    let
        minutes =
            (List.map parseMinutes facts)

        total =
            List.foldl (\fact1 fact2 -> fact1 + fact2) 0 minutes
    in
        Html.tr [ Attributes.class "info" ]
            [ Html.td [] []
            , Html.td [] []
            , Html.td [] [ text (formatMinutes total ++ "m") ]
            , Html.td [] []
            ]


renderFacts : Model -> Html Msg
renderFacts model =
    case List.isEmpty model.facts of
        True ->
            Html.p [] [ text "Nothing yet. Get to work!" ]

        False ->
            Html.table [ Attributes.class "table table-striped" ]
                [ Html.tbody [] ((List.map renderFact model.facts) ++ [ renderTotals model.facts ])
                ]


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


renderForm : Model -> Html Msg
renderForm model =
    form "activity-form"
        (Just (onSubmit (FormSubmit model.form)))
        [ textEntry
            (TextEntryModel "Name" "name" (Just "coding in elm"))
            [ value model.form.name, onInput FormNameChanged ]
            []
        , textEntry
            (TextEntryModel "Category" "category" (Just "Work"))
            [ value model.form.category, onInput FormCategoryChanged ]
            []
        , textEntry
            (TextEntryModel "Tags" "tags" (Just "elm, coding"))
            [ value model.form.tags, onInput FormTagsChanged ]
            []
        , formButton "Save" []
        ]


view : Model -> Html Msg
view model =
    let
        currentlyTracking =
            (List.any Fact.inProgress model.facts)

        stopTrackingButton =
            case currentlyTracking of
                True ->
                    button "Stop tracking" [ PrimaryButton ] [ onClick StopTracking ]

                False ->
                    button "Not currently tracking" [] [ Attributes.disabled True ]
    in
        div []
            [ pageTitle "Hamster dashboard" (Just "the elm time tracker")
            , container []
                [ gridColumn [ ExtraSmall 12, Medium 4 ]
                    []
                    [ h2 [] [ text "What are you doing?" ]
                    , renderForm model
                    ]
                , gridColumn [ ExtraSmall 12, Medium 8 ]
                    []
                    [ h2 [] [ text "What you've done today" ]
                    , renderFacts model
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

        LoadFactIntoForm fact ->
            let
                tags =
                    (String.join ", " (List.map (\tag -> tag.name) fact.tags))

                form =
                    Form fact.activity.name fact.activity.category tags
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
