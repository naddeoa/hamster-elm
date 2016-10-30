module Components.Library
    exposing
        ( container
        , fluidContainer
        , gridRow
        , gridColumn
        , ColumnType(Medium, Large, Small, ExtraSmall)
        , ButtonType(PrimaryButton, NormalButton, LargeButton, SmallButton, ExtraSmallButton, SuccessButton)
        , textEntry
        , TextEntryModel
        , formButton
        , button
        , form
        , pageTitle
        )

import Html exposing (Html)
import Html.Attributes as Attributes
import Html.Events as Events
import String


{-| TODO make classes enum
-}
container : List (Html.Attribute a) -> List (Html a) -> Html a
container attributes html =
    Html.div ([ Attributes.class "container" ] ++ attributes) html


{-| TODO make classes enum
-}
fluidContainer : List (Html.Attribute a) -> List (Html a) -> Html a
fluidContainer attributes html =
    Html.div ([ Attributes.class "container-fluid" ] ++ attributes) html


gridRow : List (Html.Attribute a) -> List (Html a) -> Html a
gridRow attributes html =
    Html.div ([ Attributes.class "row" ] ++ attributes) html


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


type ButtonType
    = PrimaryButton
    | NormalButton
    | LargeButton
    | SmallButton
    | ExtraSmallButton
    | BaseButton
    | SuccessButton


type Property
    = Column ColumnType
    | FormLabel
    | FormControl
    | FormGroup
    | HorizontalFormGroup
    | Button ButtonType


buttonClass : ButtonType -> String
buttonClass buttonType =
    case buttonType of
        BaseButton ->
            "btn"

        PrimaryButton ->
            "btn-primary"

        NormalButton ->
            "btn-default"

        LargeButton ->
            "btn-lg"

        SmallButton ->
            "btn-sm"

        ExtraSmallButton ->
            "btn-xs"

        SuccessButton ->
            "btn-success"


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
            "form-horizontal"

        Button buttonType ->
            buttonClass buttonType


generateClasses : List Property -> String
generateClasses parts =
    String.join " " (List.map generateClass parts)


gridColumn : List ColumnType -> List (Html.Attribute a) -> List (Html a) -> Html a
gridColumn columnTypes attributes html =
    let
        columnClassString =
            generateClasses (List.map Column columnTypes)
    in
        Html.div ([ Attributes.class columnClassString ] ++ attributes) html


type alias TextEntryModel =
    { label : String
    , id : String
    , placeholder : Maybe String
    }


pageTitle : String -> Maybe String -> Html a
pageTitle titleText subTextMaybe =
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


textEntry : TextEntryModel -> List (Html.Attribute a) -> Html a
textEntry model extraInputAttributes =
    let
        inputAttributes =
            extraInputAttributes
                ++ [ Attributes.id model.id
                   , Attributes.placeholder (Maybe.withDefault "" model.placeholder)
                   , Attributes.class (generateClass FormControl)
                   ]

        labelClass =
            generateClasses [ Column (Small 2) ]
    in
        formGroup
            [ Html.label
                [ Attributes.for model.id
                , Attributes.class (generateClasses [ Column (Small 2), FormLabel ])
                ]
                [ Html.text model.label ]
            , gridColumn [ Small 10 ] [] [ Html.input inputAttributes [] ]
            ]


formGroup : List (Html a) -> Html a
formGroup html =
    Html.div [ Attributes.class (generateClass FormGroup) ] html


formButton : String -> List (Html.Attribute a) -> Html a
formButton labelText extraAttributes =
    let
        containerClass =
            generateClasses [ Column (SmallOffset 2), Column (Small 10) ]
    in
        formGroup
            [ Html.div [ Attributes.class containerClass ]
                [ button labelText [ PrimaryButton ] extraAttributes ]
            ]


button : String -> List ButtonType -> List (Html.Attribute a) -> Html a
button labelText properties extraAttributes =
    let
        buttonClass =
            generateClasses ([ Button BaseButton ] ++ (List.map Button properties))

        attributes =
            [ Attributes.class buttonClass ] ++ extraAttributes
    in
        Html.button attributes [ Html.text labelText ]
