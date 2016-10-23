module HamsterCalls exposing (..)

{-| Collection of functions that will return `HamsterAPI.HamsterRequest`s for
the various Hamster API calls that can be made.

# Calls
@doc getActivities, getTags
-}

import HamsterAPI as API exposing (..)
import Activities exposing (Activities)
import Tags exposing (Tags)


{-| Get a list of `Activity` from Hamster. What comes back
depends on what the user of this the Hamster install has created in their routine usage.
-}
getActivities : String -> HamsterRequest Activities
getActivities search =
    HamsterRequest Activities.decode Activities.toHtml ("activities/" ++ search) Activities.encode


{-| Get a list of `Tag` from hamster. What comes back
depends on what the user of this the Hamster install has created in their routine usage.
-}
getTags : () -> HamsterRequest Tags
getTags () =
    API.HamsterRequest Tags.decode Tags.toHtml "tags" Tags.encode

