module Components.FactForm
    exposing
        ( FactForm
        , FactFormChange
        , factForm
        , toFact
        , fromFact
        , empty
        , handle
        )

import Html exposing (Html)
import Components.Library as Library exposing (form)
import Html.Attributes as Attributes
import Html.Events as Events
import Fact exposing (Fact)
import Bootstrap.Elements as Elements
import Bootstrap.Properties as Properties
import String


type FactForm
    = FactForm' Model


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


handle : FactFormChange -> FactForm
handle change =
    case change of
        FormNameChanged form newName ->
            name newName form

        FormCategoryChanged form newCategory ->
            category newCategory form

        FormTagsChanged form newTags ->
            tags newTags form

        FormSubmit form ->
            form


factForm : FactForm -> Html FactFormChange
factForm factForm =
    let
        form =
            getModel factForm
    in
        Library.form "activity-form"
            (Just (Events.onSubmit (FormSubmit factForm)))
            [ Library.textEntry
                (Library.TextEntryModel "Name" "name" (Just "coding in elm"))
                [ Attributes.value form.name, Events.onInput (FormNameChanged factForm) ]
                []
            , Library.textEntry
                (Library.TextEntryModel "Category" "category" (Just "Work"))
                [ Attributes.value form.category, Events.onInput (FormCategoryChanged factForm) ]
                []
            , Library.textEntry
                (Library.TextEntryModel "Tags" "tags" (Just "elm, coding"))
                [ Attributes.value form.tags, Events.onInput (FormTagsChanged factForm) ]
                []
            , Library.formButton "Save" []
            ]


type FactFormChange
    = FormNameChanged FactForm String
    | FormCategoryChanged FactForm String
    | FormTagsChanged FactForm String
    | FormSubmit FactForm
