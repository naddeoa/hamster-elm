module Main exposing (..)

import Html exposing (Html, div, text, input, h1, h2, label, form, fieldset, ul, li)
import Html.Attributes exposing (for, id, placeholder)
import Html.App
import HamsterAPI exposing (HamsterMsg(Success, Error))
import HamsterClient exposing (call)
import HamsterCalls exposing (getTodaysFacts)
import Facts exposing (Facts)
import Fact exposing (Fact, simpleFact)
import Date exposing (Date)


type alias Model =
    { facts : Facts
    }


type Msg
    = FetchTodaysFacts
    | FetchedTodaysFacts (HamsterMsg Facts)


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Hamster dashboard" ]
        , h2 [] [ text "What are you doing?" ]
        , form [ id "activity-form" ]
            [ fieldset [ for "activity-form" ]
                [ label [ for "activity-field" ] [ text "Current task" ]
                , input [ id "actvity-field", placeholder "name@category, #tag1 #tag2" ] []
                ]
            ]
        , h2 [] [ text "What you've done today" ]
        , ul [] (List.map (\fact -> li [] [ Fact.toHtml fact ]) model.facts)
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
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
    update FetchTodaysFacts (Model [])


main =
    Html.App.program
        { update = update
        , view = view
        , init = init
        , subscriptions = subscriptions
        }
