module Components.FactForm
    exposing
        ( FactForm
        , factForm
        , fact
        , empty
        , name
        , category
        , tags
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


fact : FactForm -> Fact
fact form =
    let
        model =
            getModel form
    in
        Fact.simpleFact model.name model.category (String.split "," model.tags)



-- TODO I have to find a way around passing 4 of these things...


factForm : FactForm -> (String -> a) -> (String -> a) -> (String -> a) -> (FactForm -> a) -> Html a
factForm factForm nameHandler categoryHandler tagsHandler submitHandler =
    let
        form =
            getModel factForm
    in
        Library.form "activity-form"
            (Just (Events.onSubmit (submitHandler factForm)))
            [ Library.textEntry
                (Library.TextEntryModel "Name" "name" (Just "coding in elm"))
                [ Attributes.value form.name, Events.onInput nameHandler ]
                []
            , Library.textEntry
                (Library.TextEntryModel "Category" "category" (Just "Work"))
                [ Attributes.value form.category, Events.onInput categoryHandler ]
                []
            , Library.textEntry
                (Library.TextEntryModel "Tags" "tags" (Just "elm, coding"))
                [ Attributes.value form.tags, Events.onInput tagsHandler ]
                []
            , Library.formButton "Save" []
            ]



-- TODO LAME
-- type FactFormChange
--     = FormNameChanged String
--     | FormCategoryChanged String
--     | FormTagsChanged String
--     | FormSubmit Model
-- 1. simplify textEntry and move it into Bootstrap.Components
-- 2. use it to compose this newer form
-- createFact : Fact -> Html a
-- createFact fact =
--     Elements.form
