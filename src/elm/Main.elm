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
    = PopFirst
    | PopSecond
    | Swap
    | Reset


update : Msg -> Model -> Model
update msg model =
    case msg of
        PopFirst ->
            { model
                | model1 = TagList.update TagList.Pop model.model1
            }

        PopSecond ->
            { model
                | model2 = TagList.update TagList.Pop model.model2
            }

        Swap ->
            let
                newModel2 =
                    model.model1

                newModel1 =
                    model.model2
            in
                { model
                    | model1 = newModel1
                    , model2 = newModel2
                }

        Reset ->
            init


init : Model
init =
    Model [ "a", "b", "c" ] [ "sticks" ]


view : Model -> Html Msg
view model =
    div []
        [ TagList.view model.model1
        , TagList.view model.model2
        , button [ onClick PopFirst ] [ text "Pop from first list" ]
        , button [ onClick Swap ] [ text "Swap the lists" ]
        , button [ onClick Reset ] [ text "Reset" ]
        ]


main =
    Html.App.beginnerProgram
        { model = init
        , view = view
        , update = update
        }
