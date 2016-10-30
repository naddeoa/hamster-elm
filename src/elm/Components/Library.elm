module Components.Library
    exposing
        ( container
        , gridRow
        , gridColumn
        , ColumnType(Medium, Large, Small, ExtraSmall)
        , textEntry
        , TextEntryModel
        , formButton
        , button
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


type ColumnType
    = Medium Int
    | MediumOffset Int
    | Large Int
    | LargeOffset Int
    | Small Int
    | SmallOffset Int
    | ExtraSmall Int
    | ExtraSmallOffset Int


columnClass : ColumnType -> String
columnClass columnType =
    let
        ( prefix, size ) =
            case columnType of
                Medium size ->
                    ( "col-md-", size )

                MediumOffset size ->
                    ( "col-md-offset-", size )

                Large size ->
                    ( "col-lg-", size )

                LargeOffset size ->
                    ( "col-lg-offset-", size )

                Small size ->
                    ( "col-sm-", size )

                SmallOffset size ->
                    ( "col-sm-offset-", size )

                ExtraSmall size ->
                    ( "col-xs-", size )

                ExtraSmallOffset size ->
                    ( "col-xs-offset-", size )
    in
        prefix ++ toString size


type Property
    = Column ColumnType
    | FormLabel
    | FormControl
    | FormGroup
    | HorizontalFormGroup
    | Button
    | PrimaryButton


generateClass : Property -> String
generateClass part =
    case part of
        Column columnType ->
            columnClass columnType

        FormLabel ->
            "control-label"

        FormControl ->
            "form-control"

        FormGroup ->
            "form-group"

        HorizontalFormGroup ->
            generateClass FormGroup ++ " form-horizontal"

        Button ->
            "btn"

        PrimaryButton ->
            generateClass Button ++ " btn-primary"


generateClasses : List Property -> String
generateClasses parts =
    String.join " " (List.map generateClass parts)


gridColumn : List ColumnType -> List (Html.Attribute a) -> List (Html a) -> Html a
gridColumn columnTypes attributes html =
    let
        columnClassString =
            generateClasses (List.map Column columnTypes)
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
                   , class (generateClass FormControl)
                   ]

        labelClass =
            generateClasses [ Column (Small 2) ]
    in
        div [ class (generateClass HorizontalFormGroup) ]
            [ label
                [ for model.id
                , class (generateClasses [ Column (Small 2), FormLabel ])
                ]
                [ text model.label ]
            , gridColumn [ Small 10 ] [] [ input inputAttributes [] ]
            ]


formButton : String -> List (Html.Attribute a) -> Html a
formButton labelText extraAttributes =
    let
        containerClass =
            generateClasses [ Column (SmallOffset 2), Column (Small 10) ]
    in
        div [ class containerClass ]
            [ button labelText [ PrimaryButton ] extraAttributes ]


button : String -> List Property -> List (Html.Attribute a) -> Html a
button labelText properties extraAttributes =
    let
        buttonClass =
            generateClasses ([ Button ] ++ properties)

        attributes =
            [ class buttonClass ] ++ extraAttributes
    in
        Html.button attributes [ text labelText ]
