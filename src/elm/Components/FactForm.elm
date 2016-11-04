module Components.FactForm
    exposing
        ( FactForm
        , Event(..)
        , create
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
    = FactForm'
        { name : String
        , category : String
        , tags : String
        }


type Field
    = Name
    | Category
    | Tags


type Event
    = Change FactForm Field String
    | Submit FactForm


empty : FactForm
empty =
    FactForm' { name = "", category = "", tags = "" }


fromFact : Fact -> FactForm
fromFact fact =
    FactForm'
        { name = fact.activity.name
        , category = fact.activity.category
        , tags = String.join ", " (List.map (\tag -> tag.name) fact.tags)
        }


toFact : FactForm -> Fact
toFact (FactForm' { name, category, tags }) =
    Fact.simpleFact name category (String.split "," tags)


handle : Event -> FactForm
handle change =
    case change of
        Submit form ->
            form

        Change (FactForm' form) field value ->
            case field of
                Name ->
                    FactForm' { form | name = value }

                Category ->
                    FactForm' { form | category = value }

                Tags ->
                    FactForm' { form | tags = value }


create : FactForm -> Html Event
create factForm =
    let
        (FactForm' form) =
            factForm
    in
        Elements.form
            []
            [ Events.onSubmit <| Submit factForm ]
            [ Components.textEntry "Name"
                "name"
                "coding in elm"
                [ Attributes.value form.name, Events.onInput <| Change factForm Name ]
                []
            , Components.textEntry "Category"
                "category"
                "Work"
                [ Attributes.value form.category, Events.onInput <| Change factForm Category ]
                []
            , Components.textEntry "Tags"
                "tags"
                "elm, coding"
                [ Attributes.value form.tags, Events.onInput <| Change factForm Tags ]
                []
            , Elements.button [ Properties.PrimaryButton ] [] [ Html.text "Save" ]
            ]
