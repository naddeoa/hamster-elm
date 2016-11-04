module Components.FactForm
    exposing
        ( FactForm
        , Event(..)
        , factForm
        , toFact
        , fromFact
        , empty
        , handle
        )

import Html exposing (Html)
import Html.Attributes as Attributes
import Html.Events as Events
import Fact exposing (Fact)
import Bootstrap.Elements as Elements
import Bootstrap.Components as Components
import Bootstrap.Properties as Properties
import String


type FactForm
    = FactForm' Model


type Field
    = Name
    | Category
    | Tags


type Event
    = Change FactForm Field String
    | Submit FactForm


type alias Model =
    { name : String
    , category : String
    , tags : String
    }


name : String -> FactForm -> FactForm
name name form =
    let
        formModel =
            getModel form
    in
        FactForm' { formModel | name = name }


category : String -> FactForm -> FactForm
category category form =
    let
        formModel =
            getModel form
    in
        FactForm' { formModel | category = category }


tags : String -> FactForm -> FactForm
tags tags form =
    let
        formModel =
            getModel form
    in
        FactForm' { formModel | tags = tags }


empty : FactForm
empty =
    FactForm' { name = "", category = "", tags = "" }


getModel : FactForm -> Model
getModel form =
    case form of
        FactForm' model ->
            model


fromFact : Fact -> FactForm
fromFact fact =
    empty
        |> name fact.activity.name
        |> category fact.activity.category
        |> tags (String.join ", " (List.map (\tag -> tag.name) fact.tags))


toFact : FactForm -> Fact
toFact form =
    let
        model =
            getModel form
    in
        Fact.simpleFact model.name model.category (String.split "," model.tags)


handle : Event -> FactForm
handle change =
    case change of
        Submit form ->
            form

        Change form field value ->
            case field of
                Name ->
                    name value form

                Category ->
                    category value form

                Tags ->
                    tags value form


factForm : FactForm -> Html Event
factForm factForm =
    let
        form =
            getModel factForm
    in
        Elements.form
            []
            [ Events.onSubmit (Submit factForm) ]
            [ Components.textEntry "Name"
                "name"
                "coding in elm"
                [ Attributes.value form.name
                , Events.onInput <| Change factForm Name
                ]
                []
            , Components.textEntry "Category"
                "category"
                "Work"
                [ Attributes.value form.category
                , Events.onInput <| Change factForm Category
                ]
                []
            , Components.textEntry "Tags"
                "tags"
                "elm, coding"
                [ Attributes.value form.tags
                , Events.onInput <| Change factForm Tags
                ]
                []
            , Elements.button [ Properties.PrimaryButton ] [] [ Html.text "Save" ]
            ]
