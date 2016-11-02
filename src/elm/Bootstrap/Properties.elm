module Bootstrap.Properties
    exposing
        ( Property(..)
        , ColumnProperty(..)
        , ButtonProperty(..)
        , AttributeProperty(..)
        , TableProperty(..)
        , TableRowProperty(..)
        , TableCellProperty(..)
        , BackgroundProperty(..)
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
    | Table TableProperty
    | TableRow TableRowProperty
    | TableCell TableCellProperty
    | Background BackgroundProperty
    | Row
    | Container
    | FormLabel
    | FormControl
    | FormGroup
    | HorizontalFormGroup
    | ResponsiveTableContainer


type BackgroundProperty
    = PrimaryBackground
    | SuccessBackground
    | InfoBackground
    | WarningBackground
    | DangerBackground


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
type TableProperty
    = BorderedTable
    | HoverTable
    | CondensedTable
    | StripedTable
    | BaseTable


{-| Docs
-}
type TableRowProperty
    = SuccessRow
    | ActiveRow
    | InfoRow
    | WarningRow
    | DangerRow


{-| Docs
-}
type TableCellProperty
    = SuccessCell
    | ActiveCell
    | InfoCell
    | WarningCell
    | DangerCell


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

        Row ->
            { classes = "row" }

        Container ->
            { classes = "container" }

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

        Table property ->
            { classes = tableClass property }

        TableRow property ->
            { classes = tableRowClass property }

        ResponsiveTableContainer ->
            { classes = "table-responsive" }

        TableCell property ->
            { classes = tableCellClass property }

        Background property ->
            { classes = backgroundClass property }


{-| Docs
-}
backgroundClass : BackgroundProperty -> String
backgroundClass property =
    case property of
        PrimaryBackground ->
            "bg-primary"

        SuccessBackground ->
            "bg-success"

        InfoBackground ->
            "bg-info"

        WarningBackground ->
            "bg-warning"

        DangerBackground ->
            "bg-danger"


{-| Docs
-}
tableCellClass : TableCellProperty -> String
tableCellClass property =
    case property of
        SuccessCell ->
            "success"

        ActiveCell ->
            "active"

        InfoCell ->
            "info"

        WarningCell ->
            "warning"

        DangerCell ->
            "danger"


tableRowClass : TableRowProperty -> String
tableRowClass property =
    case property of
        SuccessRow ->
            "success"

        ActiveRow ->
            "active"

        InfoRow ->
            "info"

        WarningRow ->
            "warning"

        DangerRow ->
            "danger"


tableClass : TableProperty -> String
tableClass property =
    case property of
        BorderedTable ->
            "table-bordered"

        HoverTable ->
            "table-hover"

        CondensedTable ->
            "table-condensed"

        StripedTable ->
            "table-striped"

        BaseTable ->
            "table"


{-| Docs
-}
htmlAttributeClass : AttributeProperty -> String
htmlAttributeClass attribute =
    case attribute of
        Class class ->
            class


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
