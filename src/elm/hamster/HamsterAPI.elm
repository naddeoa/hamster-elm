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
import Http exposing (Body)


{-| Wrapping type for all hamster responses.
-}
type alias HamsterResponse payload =
    { errors : List String
    , data : Maybe payload
    , toHtml : payload -> Html (HamsterMsg payload)
    }


{-| Reference to an empty response object
-}
emptyResponse : HamsterResponse payload
emptyResponse =
    HamsterResponse [] Nothing (\payload -> text "")


{-| Create a response object that contains the given payload, without any errors
and with a simple toString function for its html renderer.
-}
responseOfPayload : payload -> HamsterResponse payload
responseOfPayload payload =
    HamsterResponse [] (Just payload) (\payload -> text (toString payload))


{-| This is what the call files in this package return and what the client expects to consume.
It contains everything that the client needs to know about how to make a call to a method of the
Hamster REST API.
-}
type alias HamsterRequest payload =
    { decoder : Json.Decoder payload
    , toHtml : payload -> Html (HamsterMsg payload)
    , method : String
    , toJsonValue : payload -> Value
    , verb : HttpMethod
    , body : Maybe payload
    }

{-| Enumeration of the supported verbs in the Hamster API
-}
type HttpMethod
    = POST
    | GET

{-| Convert an `HttpMethod` into its string form. Useful for actually making requests with them.

    getVerb POST == "POST"
-}
getVerb : HttpMethod -> String
getVerb method =
    case method of
        POST ->
            "POST"

        GET ->
            "GET"


{-| This is the message that is used to handle http responses in the client.
-}
type HamsterMsg payload
    = Success (HamsterRequest payload) payload
    | Error (HamsterRequest payload) Http.Error


{-| Helper function that returns the url of the Hamster API appended with the argument.

    endpoint("method") == "http://www.endpoint.com:2001/method"
-}
endpoint : String -> String
endpoint path =
    "http://localhost:3000/" ++ path
