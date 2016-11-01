module Bootstrap.Components
    exposing
        ( titleWithSub
        , textEntry
        , FormColumnSizes
        )

{-| Docs
-}

import Html exposing (Html)
import Html.Attributes as Attributes
import Bootstrap.Properties as Properties
import Bootstrap.Elements as Elements


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
        Elements.fluidContainer []
            [ Html.h1 []
                [ Html.text titleText
                , Html.i [ Attributes.style [ ( "whiteSpace", "noWrap" ) ] ] subTextHtml
                ]
            ]


type alias FormColumnSizes =
    List ( Properties.ColumnProperty, Properties.ColumnProperty )


{-| Docs
-}
textEntry : String -> String -> String -> FormColumnSizes -> Html a
textEntry label id placeholder customSizes =
    formSection customSizes
        [ Elements.formLabel [] [ Attributes.for id ] [ Html.text label ] ]
        [ Elements.formInput [] [ Attributes.id id, Attributes.placeholder placeholder ] [] ]


{-| Docs
-}
formSection : FormColumnSizes -> List (Html a) -> List (Html a) -> Html a
formSection customSizes leftHandContent rightHandContent =
    let
        ( customLabelSizes, customInputSizes ) =
            case List.isEmpty customSizes of
                True ->
                    ( [ Properties.MediumColumn 4 ], [ Properties.MediumColumn 8 ] )

                False ->
                    List.unzip customSizes
    in
        Elements.formGroup []
            []
            [ Elements.column customLabelSizes [] leftHandContent
            , Elements.column customInputSizes [] rightHandContent
            ]
