module TextInput exposing (Model, view)

import Html exposing (Html, div, text, input)
import Html.Attributes exposing (placeholder)
import Html.Events exposing (onInput)
import Html.App


type alias Model =
    { label : String
    , placeholder : String
    , text : Maybe String
    }


view : Model -> Html a
view model =
    div []
        [ text model.label
        , input [ placeholder model.placeholder ] []
        ]
