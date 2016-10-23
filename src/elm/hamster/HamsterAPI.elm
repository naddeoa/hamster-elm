module HamsterAPI exposing (..)

{-| Internal API for the Hamster calls and clients.

# Definition
@docs HamsterAPI

# Call interface
@docs HamsterCall, HamsterResponse

# Helpers
@docs endpoint

-}

import Json.Decode as Json exposing ((:=), string, int, object2)
import Json.Encode exposing (Value)
import Html exposing (Html, text, ul, li)
import Http


{-| Wrapping type for all hamster responses.
-}
type alias HamsterResponse payload =
    { errors : List String
    , data : Maybe payload
    , toHtml : payload -> Html (ResponseMsg payload)
    }


emptyResponse : HamsterResponse payload
emptyResponse =
    HamsterResponse [] Nothing (\payload -> text "")


{-| This is what the call files in this package return and what the client expects to consume.
It contains everything that the client needs to know about how to make a call to a method of the
Hamster REST API.
-}
type alias HamsterRequest payload =
    { decoder : Json.Decoder payload
    , toHtml : payload -> Html (ResponseMsg payload)
    , method : String
    , toJsonValue : payload -> Value
    }


{-| This is the message that is used to handle http responses in the client.
-}
type ResponseMsg payload
    = Success (HamsterRequest payload) payload
    | Error (HamsterRequest payload) Http.Error


{-| Helper function that returns the url of the Hamster API appended with the argument.

    endpoint("method") == "http://www.endpoint.com:2001/method"
-}
endpoint : String -> String
endpoint path =
    "http://localhost:3000/" ++ path
