module Bootstrap.Components exposing (button, form, div)

{-| Docs
-}

import Html exposing (Html)
import Html.Attributes as Attributes
import Bootstrap.Properties as Properties exposing (..)


{-| Docs
-}
button : List (Property) -> List (Html.Attribute a) -> List (Html a) -> Html a
button properties attributes html =
    element Html.button (Button BaseButton :: properties) attributes html


{-| Docs
-}
form : List (Property) -> List (Html.Attribute a) -> List (Html a) -> Html a
form properties attributes html =
    element Html.form (HorizontalFormGroup :: properties) attributes html


{-| Docs
-}
div : List (Property) -> List (Html.Attribute a) -> List (Html a) -> Html a
div properties attributes html =
    element Html.div properties attributes html

{-| Docs
-}
h1: List (Property) -> List (Html.Attribute a) -> List (Html a) -> Html a
h1 properties attributes html =
    element Html.h1 properties attributes html


{-| Docs
-}
row : List (Html.Attribute a) -> List (Html a) -> Html a
row attributes html =
    element Html.div [ Row ] attributes html


{-| Docs
-}
column : List (ColumnProperty) -> List (Html.Attribute a) -> List (Html a) -> Html a
column properties attributes html =
    element Html.div (List.map Column properties) attributes html


{-| Docs private
-}
element : (List (Html.Attribute a) -> List (Html a) -> Html a) -> List (Property) -> List (Html.Attribute a) -> List (Html a) -> Html a
element htmlFn properties attributes html =
    htmlFn (Properties.merge (properties) attributes) html


