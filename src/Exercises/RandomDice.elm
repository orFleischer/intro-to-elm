module Exercises.RandomDice exposing (..)

{-

   Exercises: Here are a few ideas to make the example code on this page a bit more interesting!

   Instead of showing a number, show the die face as an image.
   Instead of showing an image of a die face, use elm/svg to draw it yourself.
   Create a weighted die with Random.weighted.
   Add a second die and have them both roll at the same time.
   Have the dice flip around randomly before they settle on a final value.

-}

import Browser
import Html exposing (..)
import Html.Events exposing (..)
import Random
import Svg exposing (Svg, circle, rect, svg)
import Svg.Attributes as Svg exposing (cx, cy, fill, height, r, rx, ry, stroke, strokeWidth, width, x, y)



{-
   elm install elm/random for dependencies
   elm install elm/svg
-}
-- MAIN


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


diceColors =
    { red = "#EB1124", white = "white" }



-- MODEL


type alias Model =
    { dieFace : Int
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model 1
    , Cmd.none
    )



-- UPDATE


type Msg
    = Roll
    | NewFace Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Roll ->
            ( model
            , Random.generate NewFace (Random.int 1 6)
            )

        NewFace newFace ->
            ( Model newFace
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
         [ h1 [] [ text (String.fromInt model.dieFace) ]
         , svg [] (dice 10 10 50 model.dieFace)
        , button [ onClick Roll ] [ text "Roll" ]
        ]

dice: Float -> Float -> Float -> Int -> List (Svg msg)
dice upperLeftX upperLeftY edgeLength diceFace =
    let
        edgeLengthStr = String.fromFloat edgeLength
        rectSvg = rect [ width edgeLengthStr
                             , height edgeLengthStr
                             , upperLeftX |> String.fromFloat |> x
                             , upperLeftY |> String.fromFloat |> y
                             , rx "2"
                             , ry "2"
                             , fill diceColors.red
                             , stroke "black"
                             , strokeWidth "2"][]
     in
        rectSvg :: (diceDots upperLeftX upperLeftY edgeLength diceFace)


diceDots: Float -> Float -> Float -> Int -> List (Svg msg)
diceDots x y edgeLength diceFace =
    case diceFace of
        1 -> [diceDotCenter x y edgeLength]
        2 -> [diceDotLowerLeft x y edgeLength, diceDotUpperRight x y edgeLength]
        3 -> [diceDotLowerLeft x y edgeLength, diceDotUpperRight x y edgeLength, diceDotCenter x y edgeLength]
        4 -> [diceDotLowerLeft x y edgeLength, diceDotLowerRight x y edgeLength, diceDotUpperLeft x y edgeLength, diceDotUpperRight x y edgeLength]
        5 -> [diceDotLowerLeft x y edgeLength, diceDotLowerRight x y edgeLength, diceDotUpperLeft x y edgeLength, diceDotUpperRight x y edgeLength, diceDotCenter x y edgeLength]
        _ -> [diceDotLowerLeft x y edgeLength, diceDotLowerRight x y edgeLength, diceDotUpperLeft x y edgeLength, diceDotUpperRight x y edgeLength, diceDotMiddleLeft x y edgeLength, diceDotMiddleRight x y edgeLength]


diceDotUpperLeft : Float -> Float -> Float -> Svg msg
diceDotUpperLeft diceX diceY diceEdgeLength =
    let
        radius = diceEdgeLength / 10
        centerX = diceX + radius + 2
        centerY = diceY + radius + 2
    in
        diceDot radius centerX centerY


diceDotLowerRight : Float -> Float -> Float -> Svg msg
diceDotLowerRight diceX diceY diceEdgeLength =
    let
        radius = diceEdgeLength / 10
        centerX = diceX + diceEdgeLength - 2 - radius
        centerY = diceY + diceEdgeLength - 2 - radius
    in
    diceDot radius centerX centerY


diceDotLowerLeft : Float -> Float -> Float -> Svg msg
diceDotLowerLeft diceX diceY diceEdgeLength =
    let
        radius = diceEdgeLength / 10
        centerX = diceX + radius + 2
        centerY = diceY + diceEdgeLength - 2 - radius
    in
    diceDot radius centerX centerY


diceDotCenter : Float -> Float -> Float -> Svg msg
diceDotCenter diceX diceY diceEdgeLength =
    let
        radius = diceEdgeLength / 10
        centerX = diceX + (diceEdgeLength / 2)
        centerY = diceY + (diceEdgeLength / 2)
    in
    diceDot radius centerX centerY


diceDotUpperRight : Float -> Float -> Float -> Svg msg
diceDotUpperRight diceX diceY diceEdgeLength =
    let
        radius = diceEdgeLength / 10
        centerX = diceX + diceEdgeLength - 2 - radius
        centerY = diceY + radius + 2
    in
    diceDot radius centerX centerY

diceDotMiddleLeft: Float -> Float -> Float -> Svg msg
diceDotMiddleLeft diceX diceY diceEdgeLength =
    let
            radius = diceEdgeLength / 10
            centerX = diceX + radius + 2
            centerY = diceY + (diceEdgeLength / 2)
    in
    diceDot radius centerX centerY

diceDotMiddleRight: Float -> Float -> Float -> Svg msg
diceDotMiddleRight diceX diceY diceEdgeLength =
        let
            radius = diceEdgeLength / 10
            centerX = diceX + diceEdgeLength - 2 - radius
            centerY = diceY + (diceEdgeLength / 2)
        in
        diceDot radius centerX centerY


diceDot : Float -> Float -> Float -> Svg msg
diceDot radius centerX centerY =
    circle
        [ radius |> String.fromFloat |> r
        , centerX |> String.fromFloat |> cx
        , centerY |> String.fromFloat |> cy
        , fill diceColors.white
        , Svg.strokeWidth "0.5"
        , Svg.stroke "black"
        ]
        []
