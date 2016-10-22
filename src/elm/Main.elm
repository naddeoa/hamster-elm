module Main exposing (..)

import Html exposing (Html, div, text, button)
import Html.Events exposing (onClick)
import TagList


type alias Model =
    { model1 : TagList.Model
    , model2 : TagList.Model
    }


type Msg
    = PopFirst
    | PopSecond


updateModel : Msg -> Model -> Model
updateModel msg model =
    case msg of
        PopFirst ->
            { model
                | model1 = TagList.update TagList.Pop model.model1
            }

        PopSecond ->
            { model
                | model2 = TagList.update TagList.Pop model.model2
            }


init : Model
init =
    Model [ "fish" ] [ "sticks" ]


view : Model -> Html Msg
view model =
    div []
        [ TagList.view model.model1
        , TagList.view model.model2
        ]


type Msgs
    = Msg
    | TagList.Msg -- this isn't showing up as a syntax error to the compiler, even thou IntelliJ catches it


main : Html Msg
main =
    div []
        [ view init
        , button [] [ text "Pop from first list" ]
        ]
