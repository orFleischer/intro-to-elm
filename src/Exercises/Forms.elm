module Exercises.Forms exposing (..)

{-

   Exercises: Try to add the following features to the viewValidation helper function:

   Check that the password is longer than 8 characters.
   Make sure the password contains upper case, lower case, and numeric characters.
   Use the functions from the String module for these exercises!

-}


import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)



-- MAIN
main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL
type alias Model =
    { name : String
    , password : String
    , passwordAgain : String
    }


init : Model
init =
    Model "" "" ""



-- UPDATE


type Msg
    = Name String
    | Password String
    | PasswordAgain String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Name name ->
            { model | name = name }

        Password password ->
            { model | password = password }

        PasswordAgain password ->
            { model | passwordAgain = password }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ viewInput "text" "Name" model.name Name
        , viewInput "password" "Password" model.password Password
        , viewInput "password" "Re-enter Password" model.passwordAgain PasswordAgain
        , viewValidation model
        ]


viewInput : String -> String -> String -> (String -> msg) -> Html msg
viewInput t p v toMsg =
    input [ type_ t, placeholder p, value v, onInput toMsg ] []


viewValidation : Model -> Html msg
viewValidation model =
    if model.password /= model.passwordAgain then
        div [ style "color" "red" ] [ text "Passwords do not match!" ]

    else if String.length model.password < 8 then
        div [ style "color" "red" ] [ text "Password must be at least 8 characters" ]

    else if not (containsNumerical model.password && containsLowerCase model.password && containsUpperCase model.password) then
        div [ style "color" "red" ] [ text "Password must have upper and lower case letters and digits" ]

    else
        div [ style "color" "green" ] [ text "OK" ]


containsNumerical : String -> Bool
containsNumerical str =
    String.any Char.isDigit str


containsUpperCase : String -> Bool
containsUpperCase str =
    String.any Char.isUpper str


containsLowerCase : String -> Bool
containsLowerCase str =
    String.any Char.isLower str
