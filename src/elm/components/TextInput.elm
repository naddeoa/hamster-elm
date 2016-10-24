module Main exposing (Model, Msg, view, update)

import Html exposing (Html, div, text, input)
import Html.Attributes exposing (placeholder)
import Html.Events exposing (onInput)
import Html.App


type alias Model =
    { label : String
    , placeholder : String
    , text : Maybe String
    }


type Msg
    = TextEntered String


view : Model -> Html Msg
view model =
    div []
        [ text model.label
        , input [ placeholder model.placeholder, onInput TextEntered ] []
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TextEntered text ->
            ( { model | text = Just text }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


init : ( Model, Cmd Msg )
init =
    ( Model "Name" "Placeholder" Nothing, Cmd.none )


main =
    Html.App.program
        { update = update
        , view = view
        , init = init
        , subscriptions = subscriptions
        }
