module GetTags exposing (..)

import Html exposing (Html, text, ul, li)
import Json.Decode as Json exposing ((:=), string, int, object2)
import Json.Encode as Encode exposing (Value)
import HamsterAPI as API exposing (..)
import Tags exposing (Tags)


hamsterCall : HamsterRequest Tags
hamsterCall =
    API.HamsterRequest Tags.decode Tags.toHtml "tags" Tags.encode
