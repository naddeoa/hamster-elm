module GetTags exposing (..)

import Html exposing (Html, text, ul, li)
import Json.Decode as Json exposing ((:=), string, int, object2)
import HamsterAPI as API exposing (..)


type alias Tag =
    { id : Int
    , name : String
    }


type alias Tags =
    List Tag


hamsterCall : HamsterCall Tags
hamsterCall =
    API.HamsterCall decode toHtml "tags"


decode : Json.Decoder (Tags)
decode =
    let
        tag =
            object2 Tag
                ("id" := int)
                ("name" := string)
    in
        Json.list tag


toHtml : Tags -> Html (ResponseMsg Tags)
toHtml tags =
    ul []
        (List.map (\tag -> li [] [ text tag.name ]) tags)
