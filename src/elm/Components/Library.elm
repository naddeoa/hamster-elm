module Components.Library
    exposing
        ( container
        , gridRow
        , gridColumn
        , ColumnType(Medium, Large, Small, ExtraSmall)
        , textEntry
        , TextEntryModel
        )

import Html exposing (..)
import Html.Attributes exposing (..)
import String


container : List (Html.Attribute a) -> List (Html a) -> Html a
container attributes html =
    div ([ class "container" ] ++ attributes) html


gridRow : List (Html.Attribute a) -> List (Html a) -> Html a
gridRow attributes html =
    div ([ class "row" ] ++ attributes) html


type ColumnType size
    = Medium Int
    | Large Int
    | Small Int
    | ExtraSmall Int


columnClass : ColumnType size -> String
columnClass columnType =
    case columnType of
        Medium size ->
            "col-md-" ++ toString size

        Large size ->
            "col-lg-" ++ toString size

        Small size ->
            "col-sm-" ++ toString size

        ExtraSmall size ->
            "col-xs-" ++ toString size


type FormComponent
    = FormLabel
    | FormControl
    | FormGroup
    | HorizontalFormGroup


formComponentClass : FormComponent -> String
formComponentClass formComponent =
    case formComponent of
        FormLabel ->
            "control-label"

        FormControl ->
            "form-control"

        FormGroup ->
            "form-group"

        HorizontalFormGroup ->
            formComponentClass FormGroup ++ " form-horizontal"


type ClassPart part
    = ColumnPart (ColumnType part)
    | FormPart FormComponent


generateClass : ClassPart a -> String
generateClass part =
    case part of
        ColumnPart columnType ->
            columnClass columnType

        FormPart formComponent ->
            formComponentClass formComponent


generateClasses : List (ClassPart a) -> String
generateClasses parts =
    String.join " " (List.map generateClass parts)


gridColumn : List (ColumnType Int) -> List (Html.Attribute a) -> List (Html a) -> Html a
gridColumn columnTypes attributes html =
    let
        columnClassString =
            generateClasses (List.map ColumnPart columnTypes)
    in
        div ([ class columnClassString ] ++ attributes) html


type alias TextEntryModel =
    { label : String
    , id : String
    , placeholder : Maybe String
    }


textEntry : TextEntryModel -> List (Html.Attribute a) -> Html a
textEntry model extraInputAttributes =
    let
        inputAttributes =
            extraInputAttributes
                ++ [ id model.id
                   , placeholder (Maybe.withDefault "" model.placeholder)
                   , class (generateClass (FormPart FormControl))
                   ]

        labelClass =
            generateClasses [ ColumnPart (Small 2) ]
    in
        div [ class (generateClass (FormPart HorizontalFormGroup)) ]
            [ label [ for model.id, class (generateClasses [ ColumnPart (Small 2), FormPart (FormLabel) ]) ] [ text model.label ]
            , gridColumn [ Small 10 ] [] [ input inputAttributes [] ]
            ]
