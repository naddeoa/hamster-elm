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
