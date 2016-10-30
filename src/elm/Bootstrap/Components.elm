module Bootstrap.Components exposing (..)

{-| Docs
-}

import Html exposing (Html)
import Html.Attributes as Attributes
import Bootstrap.Properties exposing (..)


{-| Docs
-}
button : List (Html.Attribute a) -> List (Html a) -> List (Property) -> Html a
button attributes html properties =
    let
        buttonClass =
            generateClasses ([ Button BaseButton ] ++ properties)

        buttonAttributes =
            [ Attributes.class buttonClass ] ++ attributes
    in
        Html.button buttonAttributes html


{-| Docs
-}
form : String -> Maybe (Html.Attribute a) -> List (Html a) -> Html a
form htmlId submitHandlerMaybe html =
    let
        formClass =
            generateClass HorizontalFormGroup

        attributes =
            case submitHandlerMaybe of
                Nothing ->
                    [ Attributes.id htmlId, Attributes.class formClass ]

                Just submitHandler ->
                    [ Attributes.id htmlId, submitHandler, Attributes.class formClass ]
    in
        Html.form attributes [ Html.fieldset [ Attributes.for htmlId ] html ]
