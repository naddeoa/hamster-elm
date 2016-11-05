module EncodeExtras exposing (encodeMaybe)

import Json.Encode as Encode exposing (Value)
import Json.Decode as Decode


encodeMaybe : (a -> Value) -> Maybe a -> Value
encodeMaybe encoder maybe =
    case maybe of
        Nothing ->
            Encode.null

        Just a ->
            encoder a
