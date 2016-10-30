module Components.UserMessage
    exposing
        ( UserMessage
        , empty
        , getErrors
        , hasErrors
        , userMessage
        , ofErrors
        )

import String
import Html exposing (Html)
import Bootstrap.Components as Components
import Bootstrap.Properties as Properties


{-| Docs
-}
type UserMessage
    = UserMessage' Model


{-| Docs
-}
type alias Model =
    { errors : List String
    }


{-| Docs
-}
getErrors : UserMessage -> List String
getErrors messages =
    case messages of
        UserMessage' model ->
            model.errors


{-| Docs
-}
hasErrors : UserMessage -> Bool
hasErrors messages =
    List.isEmpty (getErrors messages)


{-| Docs
-}
empty : UserMessage
empty =
    UserMessage' { errors = [] }


{-| Docs
-}
ofErrors : List String -> UserMessage
ofErrors errors =
    UserMessage' { errors = errors }


{-| Docs
-}
userMessage : UserMessage -> Html a
userMessage messages =
    case hasErrors messages of
        True ->
            Html.div [] []

        False ->
            Components.contextBox (String.join ", " (getErrors messages)) Properties.DangerBackground
