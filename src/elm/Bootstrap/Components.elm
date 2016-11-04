module Bootstrap.Components
    exposing
        ( titleWithSub
        , textEntry
        , FormColumnSizes
        , contextBox
        )

{-| Docs
-}

import Html exposing (Html)
import Html.Attributes as Attributes
import Bootstrap.Properties as Properties
import Bootstrap.Elements as Elements
import String


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


transitionEverything : List Properties.Property
transitionEverything =
    [ Properties.HtmlAttribute <| Properties.Class "hamster-transition" ]


hidden : List Properties.Property
hidden =
    [ Properties.HtmlAttribute <| Properties.Class "hamster-hidden" ]


{-| Docs
-}
contextBox : String -> Properties.BackgroundProperty -> Html a
contextBox message background =
    let
        visibility =
            case String.isEmpty message of
                True ->
                    hidden

                False ->
                    []

        backgroundStyle =
            case background of
                Properties.PrimaryBackground ->
                    [ ( "backgroundColor", "#fff" ) ]

                _ ->
                    []
    in
        Elements.p
            ([ Properties.Background background ] ++ visibility ++ transitionEverything)
            [ Attributes.style ([ ( "padding", "15px" ) ] ++ backgroundStyle) ]
            [ Html.text message ]


type alias FormColumnSizes =
    List ( Properties.ColumnProperty, Properties.ColumnProperty )


{-| Docs TODO where do you pass in onInput? This has to change
-}
textEntry : String -> String -> String -> List (Html.Attribute a) -> FormColumnSizes -> Html a
textEntry label id placeholder attributes customSizes =
    formSection customSizes
        [ Elements.formLabel [] [ Attributes.for id ] [ Html.text label ] ]
        [ Elements.formInput [] (attributes ++ [ Attributes.id id, Attributes.placeholder placeholder ]) [] ]


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
