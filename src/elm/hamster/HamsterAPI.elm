module HamsterAPI exposing (..)


type alias HamsterResponse a =
    { errors : List String
    , data : a
    }


endpoint : String -> String
endpoint path =
    "http://localhost:3000/" ++ path
