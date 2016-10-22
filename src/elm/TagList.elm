module TagList exposing (..)

import Html exposing (Html, div, text, ul, li)
import Html.App
import List exposing (foldr, map, tail, filter)
import Tag


type alias Model =
    List Tag.Model


empty : Model
empty =
    []


create : List String -> Model
create tags =
    List.map Tag.create tags


type Msg
    = Add String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Add tagName ->
            Tag.create tagName :: model


view : Model -> Html a
view model =
    ul []
        (map (\tag -> li [] [ text tag.name ]) model)
