module Activities exposing (..)

import Html exposing (Html, text, ul, li)
import Json.Decode as Json exposing ((:=), string, object2)
import Json.Encode as Encode exposing (encode, Value)
import HamsterAPI as API exposing (..)
import Activity exposing (Activity)


{-| Represents a collection of `Activity`.
-}
type alias Activities =
    List Activity


decode : Json.Decoder Activities
decode =
    Json.list Activity.decode


encode : Activities -> Value
encode activities =
    Encode.list (List.map Activity.encode activities)


toHtml : Activities -> Html a
toHtml activities =
    ul []
        (List.map (Activity.toHtml) activities)
