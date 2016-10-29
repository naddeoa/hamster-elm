module Components.Library
    exposing
        ( container
        , gridRow
        , gridColumn
        , ColumnType(Medium, Large, Small, ExtraSmall)
        , textEntry
        , TextEntryModel
        , formButton
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
    | MediumOffset Int
    | Large Int
    | LargeOffset Int
    | Small Int
    | SmallOffset Int
    | ExtraSmall Int
    | ExtraSmallOffset Int


columnClass : ColumnType size -> String
columnClass columnType =
    let
        (prefix, size) =
            case columnType of
                Medium size ->
                    ("col-md-", size)

                MediumOffset size ->
                    ("col-md-offset-", size)

                Large size ->
                    ("col-lg-", size)

                LargeOffset size ->
                    ("col-lg-offset-", size)

                Small size ->
                    ("col-sm-", size)

                SmallOffset size ->
                    ("col-sm-offset-", size)

                ExtraSmall size ->
                    ("col-xs-", size)

                ExtraSmallOffset size ->
                    ("col-xs-offset-", size)
    in
        prefix ++ toString size


type FormComponent
    = FormLabel
    | FormControl
    | FormGroup
    | HorizontalFormGroup
    | Button
    | PrimaryButton


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

        Button ->
            "btn"

        PrimaryButton ->
            formComponentClass Button ++ " btn-primary"


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
            [ label
                [ for model.id
                , class (generateClasses [ ColumnPart (Small 2), FormPart (FormLabel) ])
                ]
                [ text model.label ]
            , gridColumn [ Small 10 ] [] [ input inputAttributes [] ]
            ]





formButton : String -> List (Html.Attribute a) -> Html a
formButton labelText extraAttributes =
    let
        containerClass =
            generateClasses [ ColumnPart (SmallOffset 2), ColumnPart (Small 10) ]

        buttonClass =
            generateClasses [ FormPart PrimaryButton ]

        attributes =
            [ class buttonClass ] ++ extraAttributes
    in
        div [ class containerClass ]
            [ button attributes [ text labelText ] ]
