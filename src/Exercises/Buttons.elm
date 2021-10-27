module Exercises.Buttons exposing (..)

{----------------------------------------------------------------------------
    Exercise: Add a button to reset the counter to zero:

    1. Add a Reset variant to the Msg type
    2. Add a Reset branch in the update function
    3. Add a button in the view function.

    If that goes well, try adding another button to increment by steps of 10.
-----------------------------------------------------------------------------}


import Browser
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)


-- MAIN
main =
  Browser.sandbox { init = init, update = update, view = view }

-- MODEL
type alias Model = {increment1: Int, increment2: Int}

init : Model
init = Model 0 0


-- UPDATE

type IncrementType = One | Two
type Msg = Increment IncrementType Int | Decrement IncrementType Int | Reset IncrementType

update : Msg -> Model -> Model
update msg model =
  case msg of
    Increment One steps ->
      {model | increment1 = model.increment1 + steps}

    Decrement One steps ->
      {model | increment1 = model.increment1 - steps}

    Reset One ->
      {model | increment1 = 0}

    Increment Two steps ->
      {model | increment2 = model.increment2 + steps}

    Decrement Two steps ->
       {model | increment2 = model.increment2 - steps}

    Reset Two ->
       {model | increment2 = 0}


chooseIncrement: IncrementType -> Model -> Int
chooseIncrement incrementType model =
    case incrementType of
        One ->
            model.increment1
        Two ->
            model.increment2





incrementButton: IncrementType -> Int -> Model -> Html Msg
incrementButton incrementType steps model =
    div [style "margin" "10px", style "float" "left"]
    [ div []
                [ button [ onClick (Decrement incrementType steps) ] [ text "-" ]
                , div [] [ text (String.fromInt (chooseIncrement incrementType model)) ]
                , button [ onClick (Increment incrementType steps) ] [ text "+" ]
                ]
                ,
                div []
                [
                  button [style "margin-top" "18px" , style "margin-left" "10px" , onClick (Reset incrementType) ] [ text "Reset Count!!" ]
                ]
               ]



-- VIEW
view : Model -> Html Msg
view model =
    let
        incrementBy2 : Model -> Html Msg
        incrementBy2 = incrementButton Two 2

        incrementBy1 : Model -> Html Msg
        incrementBy1 = incrementButton One 1
    in
    div []
    [
        incrementBy1 model
        ,  incrementBy2 model
    ]
