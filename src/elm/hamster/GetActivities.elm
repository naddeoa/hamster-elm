module GetActivities exposing (..)

import Html exposing (Html, text, ul, li)
import HamsterAPI as API exposing (..)
import Activity
import Activities exposing (Activities)


hamsterCall : HamsterRequest Activities
hamsterCall =
    HamsterRequest Activities.decode Activities.toHtml "activities/" Activities.encode
