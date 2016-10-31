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
        , titleWithSub
        )

import Html exposing (Html)
import Html.Attributes as Attributes
import Html.Events as Events
import String
import List
import Bootstrap.Properties as Properties
import Bootstrap.Elements as Elements
import Facts exposing (Facts)
import Fact exposing (Fact)
import Date exposing (Date)


{-| Docs
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
    | MediumPull Int
    | Large Int
    | LargeOffset Int
    | LargePull Int
    | Small Int
    | SmallOffset Int
    | SmallPull Int
    | ExtraSmall Int
    | ExtraSmallOffset Int
    | ExtraSmallPull Int


columnClass : ColumnType -> String
columnClass columnType =
    let
        ( prefix, size ) =
            case columnType of
                Medium size ->
                    ( "col-md-", size )

                MediumOffset size ->
                    ( "col-md-offset-", size )

                MediumPull size ->
                    ( "col-md-pull-", size )

                Large size ->
                    ( "col-lg-", size )

                LargeOffset size ->
                    ( "col-lg-offset-", size )

                LargePull size ->
                    ( "col-lg-pull-", size )

                Small size ->
                    ( "col-sm-", size )

                SmallOffset size ->
                    ( "col-sm-offset-", size )

                SmallPull size ->
                    ( "col-sm-pull-", size )

                ExtraSmall size ->
                    ( "col-xs-", size )

                ExtraSmallOffset size ->
                    ( "col-xs-offset-", size )

                ExtraSmallPull size ->
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


textEntry : TextEntryModel -> List (Html.Attribute a) -> List ( ColumnType, ColumnType ) -> Html a
textEntry model extraInputAttributes customSizes =
    let
        ( customLabelSizes, customInputSizes ) =
            case List.isEmpty customSizes of
                True ->
                    ( [ Medium 4 ], [ Medium 8 ] )

                False ->
                    List.unzip customSizes

        inputAttributes =
            extraInputAttributes
                ++ [ Attributes.id model.id
                   , Attributes.placeholder (Maybe.withDefault "" model.placeholder)
                   , Attributes.class (generateClass FormControl)
                   ]

        labelClasses =
            [ FormLabel ] ++ List.map Column customLabelSizes

        columnClasses =
            customInputSizes
    in
        formGroup
            [ Html.label
                [ Attributes.for model.id
                , Attributes.class (generateClasses labelClasses)
                ]
                [ Html.text model.label ]
            , gridColumn columnClasses [] [ Html.input inputAttributes [] ]
            ]


formGroup : List (Html a) -> Html a
formGroup html =
    Html.div [ Attributes.class (generateClass FormGroup) ] html


formButton : String -> List (Html.Attribute a) -> Html a
formButton labelText extraAttributes =
    let
        containerClass =
            generateClasses [ Column (MediumOffset 4), Column (Medium 8) ]
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
