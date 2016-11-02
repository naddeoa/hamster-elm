module Components.FactForm
    exposing
        ( factForm
          -- , FactFormChange(..)
        , FactFormModel
        )

import Html exposing (Html)
import Components.Library as Library exposing (form)
import Html.Attributes as Attributes
import Html.Events as Events
import Fact exposing (Fact)
import Bootstrap.Elements as Elements
import Bootstrap.Properties as Properties


type alias FactFormModel =
    { name : String
    , category : String
    , tags : String
    }


empty : FactFormModel
empty =
    { name = "", category = "", tags = "" }



-- TODO LAME
-- type FactFormChange
--     = FormNameChanged String
--     | FormCategoryChanged String
--     | FormTagsChanged String
--     | FormSubmit FactFormModel


-- TODO I have to find a way around passing 4 of these things...
factForm : FactFormModel -> (String -> a) -> (String -> a) -> (String -> a) -> (FactFormModel -> a) -> Html a
factForm factForm nameHandler categoryHandler tagsHandler submitHandler=
    form "activity-form"
        (Just (Events.onSubmit (submitHandler factForm)))
        [ Library.textEntry
            (Library.TextEntryModel "Name" "name" (Just "coding in elm"))
            [ Attributes.value factForm.name, Events.onInput nameHandler ]
            []
        , Library.textEntry
            (Library.TextEntryModel "Category" "category" (Just "Work"))
            [ Attributes.value factForm.category, Events.onInput categoryHandler ]
            []
        , Library.textEntry
            (Library.TextEntryModel "Tags" "tags" (Just "elm, coding"))
            [ Attributes.value factForm.tags, Events.onInput tagsHandler ]
            []
        , Library.formButton "Save" []
        ]









-- 1. simplify textEntry and move it into Bootstrap.Components
-- 2. use it to compose this newer form
-- createFact : Fact -> Html a
-- createFact fact =
--     Elements.form

