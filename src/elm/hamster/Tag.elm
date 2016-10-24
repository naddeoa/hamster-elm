module Tag exposing (Tag, decode, encode, toHamsterQuery, toHtml)

import Html exposing (Html, text, ul, li)
import Json.Decode as Json exposing ((:=), string, int, object2, maybe)
import Json.Encode as Encode exposing (Value)
import HamsterAPI as API exposing (..)
import Maybe exposing (withDefault, map)


{-| Represents a tag in Hamster
-}
type alias Tag =
    { id : Maybe Int
    , name : String
    }


decode : Json.Decoder Tag
decode =
    object2 Tag
        ("id" := maybe int)
        ("name" := string)


encode : Tag -> Value
encode tag =
    Encode.object
        [ ( "id"
          , case tag.id of
                Nothing ->
                    Encode.null

                Just id ->
                    Encode.int id
          )
        , ( "name", Encode.string tag.name )
        ]


toHamsterQuery : Tag -> String
toHamsterQuery tag =
    "#" ++ tag.name


toHtml : Tag -> Html a
toHtml tag =
    let
        id =
            withDefault "" (map (\id -> " (" ++ (toString id) ++ ")") tag.id)
    in
        li []
            [ text (tag.name ++ id) ]
