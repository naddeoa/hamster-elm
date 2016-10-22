module Main exposing (..)

import Html exposing (Html, div, text, button)
import Html.Events exposing (onClick)
import Html.App
import TagList


type alias Model =
    { model1 : TagList.Model
    , model2 : TagList.Model
    }


type Msg
    = Add


init : Model
init =
    Model (TagList.create [ "a", "b", "c" ]) (TagList.create [ "sticks" ])


view : Model -> Html Msg
view model =
    div []
        [ TagList.view model.model1
        , TagList.view model.model2
        , button [ onClick Add ] [ text "Pop from first list" ]
        ]


main : Html Msg
main =
    view init
