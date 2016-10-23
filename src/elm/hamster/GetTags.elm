module GetTags exposing (..)

import Html exposing (Html, text, ul, li)
import Http
import Json.Decode as Json exposing ((:=), string, int, object2)
import Task exposing (..)
import Dict
import Html.App
import HamsterAPI as API exposing (HamsterResponse)


-- Types in the payload


type alias Tag =
    { id : Int
    , name : String
    }


type alias Tags =
    List Tag


type alias HamsterCall a =
    { errors : List String
    , data : a
    }



-- Decoder for JSON


decodeTags : Json.Decoder (Tags)
decodeTags =
    let
        tag =
            object2 Tag
                ("id" := int)
                ("name" := string)
    in
        Json.list tag


type Msg
    = Success (Tags)
    | Error Http.Error



-- Function that creates our HTTP task


getTags : () -> Cmd Msg
getTags () =
    Task.perform Error Success (Http.get decodeTags (API.endpoint "tags"))



-- Stuff just for the main test


init : () -> ( Tags, Cmd Msg )
init () =
    ( []
    , getTags ()
    )


update : Msg -> Tags -> ( Tags, Cmd Msg )
update msg tags =
    case msg of
        Success decodedTags ->
            ( decodedTags, Cmd.none )

        Error err ->
            case err of
                Http.NetworkError ->
                    ( [ Tag -1 "network error" ], Cmd.none )

                Http.Timeout ->
                    ( [ Tag -1 "timeout" ], Cmd.none )

                Http.UnexpectedPayload payload ->
                    ( [ Tag -1 payload ], Cmd.none )

                Http.BadResponse _ _ ->
                    ( [ Tag -1 "bad response" ], Cmd.none )


view : Tags -> Html Msg
view tags =
    ul []
        (List.map (\tag -> li [] [ text tag.name ]) tags)


subscriptions : Tags -> Sub Msg
subscriptions model =
    Sub.none


main =
    Html.App.program
        { update = update
        , view = view
        , init = init ()
        , subscriptions = subscriptions
        }
