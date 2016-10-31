module Bootstrap.Components exposing (titleWithSub)

{-| Docs
-}

import Html exposing (Html)
import Html.Attributes as Attributes
import Bootstrap.Properties as Properties exposing (..)
import Bootstrap.Elements exposing (..)


{-| TODO delete me
-}
titleWithSub : String -> Maybe String -> Html a
titleWithSub titleText subTextMaybe =
    let
        subTextHtml =
            case subTextMaybe of
                Nothing ->
                    []

                Just subText ->
                    [ Html.small [] [ Html.text (" " ++ subText) ] ]
    in
        fluidContainer []
            [ Html.h1 []
                [ Html.text titleText
                , Html.i [ Attributes.style [ ( "whiteSpace", "noWrap" ) ] ] subTextHtml
                ]
            ]
