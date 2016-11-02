module Bootstrap.Elements
    exposing
        ( button
        , form
        , formGroup
        , formInput
        , formLabel
        , div
        , column
        , row
        , h1
        , h2
        , container
        , fluidContainer
        , element
        , table
        , tbody
        , responsiveTable
        , thead
        , td
        , tr
        , th
        , p
        )

{-| Docs
-}

import Html exposing (Html)
import Html.Attributes as Attributes
import Bootstrap.Properties as Properties exposing (..)


{-| Helper alias that represents the normal html functions that
the elm Html module exposes.
-}
type alias StandardElmHtmlFunction a =
    List (Html.Attribute a) -> List (Html a) -> Html a


{-| Docs private
-}
element : StandardElmHtmlFunction a -> List (Property) -> List (Html.Attribute a) -> List (Html a) -> Html a
element htmlFn properties attributes html =
    htmlFn (Properties.merge (properties) attributes) html


{-| Docs
-}
button : List (ButtonProperty) -> List (Html.Attribute a) -> List (Html a) -> Html a
button properties attributes html =
    element Html.button (List.map Button (BaseButton :: properties)) attributes html


{-| Docs
-}
form : List (Property) -> List (Html.Attribute a) -> List (Html a) -> Html a
form properties attributes html =
    element Html.form (HorizontalFormGroup :: properties) attributes html


{-| Docs
-}
formGroup : List (Property) -> List (Html.Attribute a) -> List (Html a) -> Html a
formGroup properties attributes html =
    element Html.div (FormGroup :: properties) attributes html


{-| TODO support input-group-addon for prefix symbols
-}
formInput : List (Property) -> List (Html.Attribute a) -> List (Html a) -> Html a
formInput properties attributes html =
    element Html.input (FormControl :: properties) attributes html


{-| Docs
-}
formLabel : List (Property) -> List (Html.Attribute a) -> List (Html a) -> Html a
formLabel properties attributes html =
    element Html.label (FormLabel :: properties) attributes html


{-| Docs
-}
table : List (TableProperty) -> List (Html.Attribute a) -> List (Html a) -> Html a
table properties attributes html =
    element Html.table (List.map Table (BaseTable :: properties)) attributes html


{-| Docs
-}
responsiveTable : List (TableProperty) -> List (Html.Attribute a) -> List (Html a) -> Html a
responsiveTable properties attributes html =
    div [ ResponsiveTableContainer ]
        []
        [ element Html.table (List.map Table (BaseTable :: properties)) attributes html
        ]


{-| Docs
-}
tbody : List (Property) -> List (Html.Attribute a) -> List (Html a) -> Html a
tbody properties attributes html =
    element Html.tbody properties attributes html


{-| Docs
-}
thead : List (Property) -> List (Html.Attribute a) -> List (Html a) -> Html a
thead properties attributes html =
    element Html.thead properties attributes html


{-| Docs
-}
tr : List (TableRowProperty) -> List (Html.Attribute a) -> List (Html a) -> Html a
tr properties attributes html =
    element Html.table (List.map TableRow properties) attributes html


{-| Docs
-}
td : List (TableCellProperty) -> List (Html.Attribute a) -> List (Html a) -> Html a
td properties attributes html =
    element Html.td (List.map TableCell properties) attributes html


{-| Docs
-}
th : List (TableCellProperty) -> List (Html.Attribute a) -> List (Html a) -> Html a
th properties attributes html =
    element Html.th (List.map TableCell properties) attributes html


{-| Docs
-}
div : List (Property) -> List (Html.Attribute a) -> List (Html a) -> Html a
div properties attributes html =
    element Html.div properties attributes html


{-| Docs
-}
p : List (Property) -> List (Html.Attribute a) -> List (Html a) -> Html a
p properties attributes html =
    element Html.p properties attributes html


{-| Docs
-}
h1 : List (Property) -> List (Html.Attribute a) -> List (Html a) -> Html a
h1 properties attributes html =
    element Html.h1 properties attributes html


{-| Docs
-}
h2 : List (Property) -> List (Html.Attribute a) -> List (Html a) -> Html a
h2 properties attributes html =
    element Html.h2 properties attributes html


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


{-| TODO make classes enum
-}
container : List (Html.Attribute a) -> List (Html a) -> Html a
container attributes html =
    element Html.div [ Container ] attributes html


{-| TODO make classes enum
-}
fluidContainer : List (Html.Attribute a) -> List (Html a) -> Html a
fluidContainer attributes html =
    element Html.div [ Container ] attributes html
