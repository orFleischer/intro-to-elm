module Exercises.TextFields exposing (..)

{-

   Exercise: Go to the example in the online editor here and show the length of the content
   in your view function. Use the String.length function!

   Note: If you want more info on exactly how the Change values are working in this program,
   jump ahead to the sections on custom types and pattern matching.

-}

import Browser
import Html exposing (Attribute, Html, div, input, label, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)



-- MAIN


main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
    { content : String
    }


init : Model
init =
    { content = "" }



-- UPDATE


type Msg
    = Change String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Change newContent ->
            { model | content = newContent }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ input [ placeholder "Text to reverse", value model.content, onInput Change ] []
        , div []
            [ label [] [ text "Reversed Content: " ]
            , text (String.reverse model.content)
            ]
        , div []
            [ label [] [ text "String Length: " ]
            , text (String.length model.content |> String.fromInt)
            ]
        ]
