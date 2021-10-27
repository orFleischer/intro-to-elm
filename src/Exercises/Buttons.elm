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
type alias Model = Int

init : Model
init =
  0


-- UPDATE

type Msg = Increment | Decrement | Reset

update : Msg -> Model -> Model
update msg model =
  case msg of
    Increment ->
      model + 1

    Decrement ->
      model - 1

    Reset ->
         0



-- VIEW

view : Model -> Html Msg
view model =
    div []
    [      div [style "float" "left"]
            [ button [ onClick Decrement ] [ text "-" ]
            , div [] [ text (String.fromInt model) ]
            , button [ onClick Increment ] [ text "+" ]
            ]
            ,
            div []
            [
              button [style "margin-top" "18px" , style "margin-left" "10px" , onClick Reset ] [ text "Reset Count!!" ]
            ]
    ]
