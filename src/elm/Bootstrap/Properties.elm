module Bootstrap.Properties
    exposing
        ( ColumnProperty(..)
        , ButtonProperty(..)
        , AttributeProperty(..)
        , Property(..)
        , toAttributes
        , merge
        )

{-| Docs
-}

import String
import Html
import Html.Attributes as Attributes


{-| Docs
-}
type Property
    = Column ColumnProperty
    | Button ButtonProperty
    | HtmlAttribute AttributeProperty
    | FormLabel
    | FormControl
    | FormGroup
    | HorizontalFormGroup


{-| Docs
-}
type AttributeProperty
    = Class String


{-| Docs
-}
type ColumnProperty
    = MediumColumn Int
    | MediumOffsetColumn Int
    | MediumPullColumn Int
    | MediumPushColumn Int
    | LargeColumn Int
    | LargeOffsetColumn Int
    | LargePullColumn Int
    | LargePushColumn Int
    | SmallColumn Int
    | SmallOffsetColumn Int
    | SmallPullColumn Int
    | SmallPushColumn Int
    | ExtraSmallColumn Int
    | ExtraSmallOffsetColumn Int
    | ExtraSmallPullColumn Int
    | ExtraSmallPushColumn Int


{-| Docs
-}
type ButtonProperty
    = PrimaryButton
    | NormalButton
    | LargeButton
    | SmallButton
    | ExtraSmallButton
    | BaseButton
    | SuccessButton


{-| Docs
-}
type alias AttributeBundle =
    { classes : String
    }


{-| Docs
-}
emptyBundle : AttributeBundle
emptyBundle =
    { classes = "" }


{-| Docs
-}
generateAttributes : AttributeBundle -> List (Html.Attribute a)
generateAttributes bundle =
    [ Attributes.class bundle.classes ]


{-| Docs
-}
toAttributes : List Property -> List (Html.Attribute a)
toAttributes property =
    let
        bundle =
            generateAttributeBundles property
    in
        generateAttributes bundle

merge : List Property -> List (Html.Attribute a) -> List (Html.Attribute a)
merge properties attributes =
    toAttributes properties ++ attributes

{-| Docs
-}
combineBundles : AttributeBundle -> AttributeBundle -> AttributeBundle
combineBundles a b =
    { classes = a.classes ++ " " ++ b.classes }


{-| Docs
-}
generateAttributeBundles : List Property -> AttributeBundle
generateAttributeBundles properties =
    let
        bundles =
            List.map generateAttributeBundle properties
    in
        List.foldr combineBundles emptyBundle bundles


{-| Docs
-}
generateAttributeBundle : Property -> AttributeBundle
generateAttributeBundle property =
    case property of
        Column columnType ->
            { classes = columnClass columnType }

        FormLabel ->
            { classes = "control-label" }

        FormControl ->
            { classes = "form-control" }

        FormGroup ->
            { classes = "form-group" }

        HorizontalFormGroup ->
            { classes = "form-horizontal" }

        Button buttonType ->
            { classes = buttonClass buttonType }

        HtmlAttribute attribute ->
            { classes = htmlAttributeClass attribute }


{-| Docs
-}
htmlAttributeClass : AttributeProperty -> String
htmlAttributeClass attribute =
    case attribute of
        Class class ->
            class


{-| Docs
-}
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

        HtmlAttribute attribute ->
            case attribute of
                Class class ->
                    class


{-| Docs
-}
generateClasses : List Property -> String
generateClasses parts =
    String.join " " (List.map generateClass parts)


{-| Docs
-}
columnClass : ColumnProperty -> String
columnClass columnType =
    let
        ( prefix, size ) =
            case columnType of
                MediumColumn size ->
                    ( "col-md-", size )

                MediumOffsetColumn size ->
                    ( "col-md-offset-", size )

                MediumPullColumn size ->
                    ( "col-md-pull-", size )

                MediumPushColumn size ->
                    ( "col-md-pull-", size )

                LargeColumn size ->
                    ( "col-lg-", size )

                LargeOffsetColumn size ->
                    ( "col-lg-offset-", size )

                LargePullColumn size ->
                    ( "col-lg-pull-", size )

                LargePushColumn size ->
                    ( "col-lg-pull-", size )

                SmallColumn size ->
                    ( "col-sm-", size )

                SmallOffsetColumn size ->
                    ( "col-sm-offset-", size )

                SmallPullColumn size ->
                    ( "col-sm-pull-", size )

                SmallPushColumn size ->
                    ( "col-sm-pull-", size )

                ExtraSmallColumn size ->
                    ( "col-xs-", size )

                ExtraSmallOffsetColumn size ->
                    ( "col-xs-offset-", size )

                ExtraSmallPullColumn size ->
                    ( "col-xs-offset-", size )

                ExtraSmallPushColumn size ->
                    ( "col-xs-offset-", size )
    in
        prefix ++ toString size


{-| Docs
-}
buttonClass : ButtonProperty -> String
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
