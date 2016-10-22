module Tag exposing (..)

import Html exposing (Html, text, span)
import Html.App exposing (beginnerProgram)


type alias Model =
    { id : Maybe String
    , name : String
    }


type Msg
    = UpdateName String
    | UpdateId String


create : String -> Model
create name =
    Model Nothing name


update : Msg -> Model -> Model
update msg model =
    case msg of
        UpdateName name ->
            { model
                | name = name
            }

        UpdateId id ->
            { model
                | id = Just id
            }


view : Model -> Html a
view model =
    span [] [ text model.name ]


init =
    { id = Just "Fish"
    , name = "fish"
    }


main =
    beginnerProgram
        { model = init
        , view = view
        , update = update
        }
