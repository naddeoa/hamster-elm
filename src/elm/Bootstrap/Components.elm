module Bootstrap.Components exposing (..)

{-| Docs
-}

import Html exposing (Html)
import Html.Attributes as Attributes
import Bootstrap.Properties as Properties exposing (..)


{-| Docs
-}
button : List (Property) -> List (Html.Attribute a) -> List (Html a) -> Html a
button properties attributes html =
    let
        buttonAttributes =
            Properties.merge (Button BaseButton :: properties) attributes
    in
        Html.button buttonAttributes html


{-| Docs
-}
form : List (Property) -> List (Html.Attribute a) -> List (Html a) -> Html a
form properties attributes html =
    let
        formAttributes =
            Properties.merge (HorizontalFormGroup :: properties) attributes
    in
        Html.form attributes html
