module GetActivities exposing (..)

import Http
import Json.Decode as Json exposing ((:=), string, object2)
import Task exposing (..)
import Html exposing (Html, text, ul, li)
import Html.App
import HamsterAPI as API exposing (HamsterResponse)


-- Types in the payload


type alias Activity =
    { activity : String
    , category : String
    }


type alias Activities =
    List Activity


type alias GetActivitiesResponse =
    HamsterResponse Activities



-- Decoder for JSON


decodeTags : Json.Decoder Activities
decodeTags =
    let
        activity =
            object2 Activity
                ("activity" := string)
                ("category" := string)
    in
        Json.list activity


type Msg
    = Success Activities
    | Error Http.Error



-- Function that creates our HTTP task


getActivities : String -> Cmd Msg
getActivities search =
    Task.perform Error Success (Http.get decodeTags (API.endpoint "activities/" ++ search))



-- Stuff just for the main test


init : () -> ( Activities, Cmd Msg )
init () =
    ( []
    , getActivities ""
    )


update : Msg -> Activities -> ( Activities, Cmd Msg )
update msg tags =
    case msg of
        Success decodedActivities ->
            ( decodedActivities, Cmd.none )

        Error err ->
            case err of
                Http.NetworkError ->
                    ( [ Activity "network" "error" ], Cmd.none )

                Http.Timeout ->
                    ( [ Activity "" "timeout" ], Cmd.none )

                Http.UnexpectedPayload payload ->
                    ( [ Activity "" payload ], Cmd.none )

                Http.BadResponse _ _ ->
                    ( [ Activity "" "bad response" ], Cmd.none )


view : Activities -> Html Msg
view activities =
    ul []
        (List.map (\activity -> li [] [ text (activity.activity ++ activity.category) ]) activities)


subscriptions : Activities -> Sub Msg
subscriptions model =
    Sub.none


main =
    Html.App.program
        { update = update
        , view = view
        , init = init ()
        , subscriptions = subscriptions
        }
