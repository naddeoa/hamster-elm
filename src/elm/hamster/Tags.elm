module Tags exposing (..)

import Html exposing (Html, text, ul, li)
import Json.Decode as Json exposing ((:=), string, int, object2)
import Json.Encode as Encode exposing (Value)
import HamsterAPI as API exposing (..)
import Tag exposing (Tag)


{-| Represents a collection of tags in Hamster
-}
type alias Tags =
    List Tag


decode : Json.Decoder (Tags)
decode =
    Json.list Tag.decode


encode : Tags -> Value
encode tags =
    Encode.list (List.map Tag.encode tags)


toHtml : Tags -> Html a
toHtml tags =
    ul []
        (List.map (Tag.toHtml) tags)
