module Hamster exposing (..)

import Html exposing (Html, text, ul, li)
import Http
import Json.Decode as Json exposing ((:=), string, int, object2)
import Task exposing (..)
import Dict
import Html.App


-- Types in the payload


type alias Tag =
    { id : Int
    , name : String
    }



-- Decoder for JSON


decodeTags : Json.Decoder (List Tag)
decodeTags =
    let
        tag =
            object2 Tag
                ("id" := int)
                ("name" := string)
    in
        Json.list tag


type Msg
    = Success (List Tag)
    | Error Http.Error



-- Function that creates our HTTP task


getTags : () -> Cmd Msg
getTags () =
    Task.perform Error Success (Http.get decodeTags "http://localhost:3000/tags")


init : () -> ( List Tag, Cmd Msg )
init () =
    ( [ Tag 0 "Fish" ]
    , getTags ()
    )



-- Stuff just for the main test


update : Msg -> List Tag -> ( List Tag, Cmd Msg )
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


view : List Tag -> Html Msg
view tags =
    ul []
        (List.map (\tag -> li [] [text tag.name]) tags)


subscriptions : List Tag -> Sub Msg
subscriptions model =
    Sub.none


main =
    Html.App.program
        { update = update
        , view = view
        , init = init ()
        , subscriptions = subscriptions
        }
