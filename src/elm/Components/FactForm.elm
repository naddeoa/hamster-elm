module Components.FactForm
    exposing
        ( factForm
        , empty
          -- , FactFormChange(..)
        , FactForm
        )

import Html exposing (Html)
import Components.Library as Library exposing (form)
import Html.Attributes as Attributes
import Html.Events as Events
import Fact exposing (Fact)
import Bootstrap.Elements as Elements
import Bootstrap.Properties as Properties
import String


-- TODO next up, make FactForm an opaque union type and move all of the FactForm logic into this file

type alias FactForm =
    { name : String
    , category : String
    , tags : String
    }


empty : FactForm
empty =
    { name = "", category = "", tags = "" }


toFact : FactForm -> Fact
toFact form =
    Fact.simpleFact form.name form.category (String.split "," form.tags)



-- TODO I have to find a way around passing 4 of these things...


factForm : FactForm -> (String -> a) -> (String -> a) -> (String -> a) -> (FactForm -> a) -> Html a
factForm factForm nameHandler categoryHandler tagsHandler submitHandler =
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



-- TODO LAME
-- type FactFormChange
--     = FormNameChanged String
--     | FormCategoryChanged String
--     | FormTagsChanged String
--     | FormSubmit FactForm
-- 1. simplify textEntry and move it into Bootstrap.Components
-- 2. use it to compose this newer form
-- createFact : Fact -> Html a
-- createFact fact =
--     Elements.form
