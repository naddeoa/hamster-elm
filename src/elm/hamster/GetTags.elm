module GetTags exposing (..)

import Html exposing (Html, text, ul, li)
import Json.Decode as Json exposing ((:=), string, int, object2)
import HamsterAPI as API exposing (..)


-- Types in the payload


type alias Tag =
    { id : Int
    , name : String
    }


type alias Tags =
    List Tag


hamsterCall : HamsterCall Tags
hamsterCall =
    API.HamsterCall decode view "tags"


decode : Json.Decoder (Tags)
decode =
    let
        tag =
            object2 Tag
                ("id" := int)
                ("name" := string)
    in
        Json.list tag


view : Tags -> Html ResponseMsg
view tags =
    ul []
        (List.map (\tag -> li [] [ text tag.name ]) tags)
