module Components.FactTable
    exposing
        ( factTable
        )

import Html exposing (Html)
import Html.Attributes as Attributes
import Html.Events as Events
import Date exposing (Date)
import String
import Fact exposing (Fact)
import Facts exposing (Facts)
import Bootstrap.Properties as Properties exposing (..)
import Bootstrap.Elements as Elements


renderFactDate : Date -> String
renderFactDate date =
    let
        hour =
            -- time only comes out as gmy at the moment it seems
            toString (Date.hour date)

        minute =
            String.padLeft 2 '0' (toString (Date.minute date))
    in
        hour ++ ":" ++ minute


renderFactDates : Fact -> String
renderFactDates fact =
    case Fact.inProgress fact of
        True ->
            renderFactDate fact.startDate

        False ->
            renderFactDate fact.startDate ++ " - " ++ renderFactDate fact.endDate


parseMinutes : Fact -> Int
parseMinutes fact =
    Basics.floor (Basics.toFloat (fact.totalSeconds) / 60)


renderMinutes : Fact -> String
renderMinutes fact =
    formatMinutes (parseMinutes fact)


formatMinutes : Int -> String
formatMinutes totalMinutes =
    let
        minutes =
            totalMinutes % 60

        hours =
            Basics.floor (Basics.toFloat totalMinutes / 60)

        hourString =
            if hours > 0 then
                toString hours ++ "h "
            else
                ""
    in
        hourString ++ (toString minutes) ++ "m"


renderTotals : Facts -> Html a
renderTotals facts =
    let
        minutes =
            (List.map parseMinutes facts)

        total =
            List.foldl (\fact1 fact2 -> fact1 + fact2) 0 minutes
    in
        Html.tr [ Attributes.class "info" ]
            [ Html.td [] []
            , Html.td [] []
            , Html.td [] [ Html.text (formatMinutes total ++ "m") ]
            , Html.td [] []
            ]


renderFact : Fact -> Html a
renderFact fact =
    let
        duration =
            (Basics.toFloat fact.totalSeconds) / 60

        rowAttributes =
            if Fact.inProgress fact then
                [ Attributes.class "success" ]
            else
                []
    in
        Html.tr rowAttributes
            [ Html.td []
                [ Elements.button
                    [ Button NormalButton, Button ExtraSmallButton ]
                    []
                    [ Html.text "Load form" ]
                ]
            , Html.td [] [ Html.text (renderFactDates fact) ]
            , Html.td [] [ Html.text (renderMinutes fact) ]
            , Html.td [] [ Html.text (Fact.toHamsterQuery fact) ]
            ]


factTable : Facts -> Html a
factTable facts =
    Elements.responsiveTable []
        []
        [ Elements.tbody [] [] ((List.map renderFact facts) ++ [ renderTotals facts ]) ]
