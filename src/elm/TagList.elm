module TagList exposing (view, update, Msg, Msg(Add), Msg(Remove), Msg(Pop), Model)

import Html exposing (Html, div, text, ul, li)
import Html.App
import List exposing (foldr, map, tail, filter)


-- Tutorial found at https://www.elm-tutorial.org/en/02-elm-arch/02-structure.html
-- Just like prop types


type alias Model =
    List String


type Msg
    = Add String
    | Remove String
    | Pop


update : Msg -> Model -> Model
update msg model =
    case msg of
        Add todo ->
            todo :: model

        Remove todo ->
            filter (\t -> t == todo) model

        Pop ->
            let
                rest =
                    tail model
            in
                case rest of
                    Just x ->
                        x

                    Nothing ->
                        []



-- TODO make use


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


tagToList : String -> Html a
tagToList tag =
    li [] [ text tag ]



-- Just like the render method


view : Model -> Html a
view model =
    ul []
        (map tagToList model)
