module Exercises.TimeClock exposing (..)

{-

   Exercises:

   Add a button to pause the clock, turning the Time.every subscription off.
   Make the digital clock look nicer. Maybe add some style attributes.
   Use elm/svg to make an analog clock with a red second hand!

-}

import Browser
import Html exposing (..)
import Html.Events exposing (onClick)
import Svg exposing (Svg, circle, line, svg)
import Svg.Attributes exposing (cx, cy, dominantBaseline, fill, r, stroke, strokeWidth, style, textAnchor, x, x1, x2, y, y1, y2)
import Task
import Time



{-
   elm install elm/time for dependencies
-}
-- MAIN


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { zone : Time.Zone
    , time : Time.Posix
    , isRunning : Bool
    }

clockCenterRadiusDivider = 5

degIntervalSecAndMin =
    360 / 60


degIntervalHour =
    360 / 12


degClockOffset =
    270


clockProperties =
    { clockCenterX = 100
    , clockCenterY = 100
    , clockRadius = 45
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model Time.utc (Time.millisToPosix 0) True
    , Task.perform AdjustTimeZone Time.here
    )



-- UPDATE


type Msg
    = Tick Time.Posix
    | AdjustTimeZone Time.Zone
    | StopResume


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick newTime ->
            ( { model | time = newTime }
            , Cmd.none
            )

        AdjustTimeZone newZone ->
            ( { model | zone = newZone }
            , Cmd.none
            )

        StopResume ->
            ( { model | isRunning = not model.isRunning }
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    if model.isRunning then
        Time.every 1000 Tick

    else
        Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    let
        hour =
            Time.toHour model.zone model.time

        minute =
            Time.toMinute model.zone model.time

        second =
            Time.toSecond model.zone model.time
    in
    div []
        [ h1 [] [ text (writeTime hour minute second) ]
        , svg [] (drawClock hour minute second)
        , button [ onClick StopResume ]
            [ text
                (if model.isRunning then
                    "stop"

                 else
                    "resume"
                )
            ]
        ]


writeTime : Int -> Int -> Int -> String
writeTime hours minutes seconds =
    [ hours, minutes, seconds ] |> List.map timePortion2Str |> String.join ":"


timePortion2Str : Int -> String
timePortion2Str timePortion =
    timePortion |> String.fromInt |> padTimePortions


drawClock : Int -> Int -> Int -> List (Svg msg)
drawClock hours minutes seconds =
    [ drawClockBody (), drawSecondsHand seconds, drawMinutesHand minutes, modBy 12 hours |> drawHoursHand, drawClockCenter () ] ++ drawNumbers ()


drawClockBody : () -> Svg msg
drawClockBody _ =
    circle
        [ cx (String.fromInt clockProperties.clockCenterX)
        , cy (String.fromInt clockProperties.clockCenterX)
        , r (String.fromInt clockProperties.clockRadius)
        , fill "white"
        , stroke "black"
        , strokeWidth "1.5"
        ]
        []

drawClockCenter : () -> Svg msg
drawClockCenter _ =
    circle
        [ cx (String.fromInt clockProperties.clockCenterX)
        , cy (String.fromInt clockProperties.clockCenterX)
        , r (String.fromFloat ((clockProperties.clockRadius) / clockCenterRadiusDivider))
        ]
        []

drawNumbers : () -> List (Svg msg)
drawNumbers _ =
    let
        effectiveRadius = clockProperties.clockRadius / 1.19
    in
    [12, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
        |> List.map (\time -> (time, toFloat time * degIntervalHour + degClockOffset |> degrees))
        |> List.map (\(time, currentDegInRad) -> (time, getX2 effectiveRadius clockProperties.clockCenterX currentDegInRad, getY2 effectiveRadius clockProperties.clockCenterY currentDegInRad))
        |> List.map (\(time, hourX, hourY) -> Svg.text_ [x (String.fromFloat hourX), y (String.fromFloat hourY), dominantBaseline "middle", textAnchor "middle"][text (String.fromInt time)] )

drawHand : Float -> Float -> List (Attribute msg) -> Int -> Svg msg
drawHand degInterval handRadiusDivider handLineAttr time =
    let
        effectiveRadius = clockProperties.clockRadius / handRadiusDivider
        currentDegInRad =
            toFloat time * degInterval + degClockOffset |> degrees

        clockHandX2 =
            getX2 effectiveRadius clockProperties.clockCenterX currentDegInRad

        clockHandY2 =
            getY2 effectiveRadius clockProperties.clockCenterY currentDegInRad
    in
    drawLine clockHandX2 clockHandY2 handLineAttr


drawSecondsHand : Int -> Svg msg
drawSecondsHand =
    drawHand degIntervalSecAndMin 1.20 [ stroke "red", strokeWidth "1" ]


drawMinutesHand : Int -> Svg msg
drawMinutesHand =
    drawHand degIntervalSecAndMin 1.5 [ stroke "brown", strokeWidth "3" ]


drawHoursHand : Int -> Svg msg
drawHoursHand =
    drawHand degIntervalHour 1.70 [ stroke "black", strokeWidth "4" ]


drawLine : Float -> Float -> List (Attribute msg) -> Svg msg
drawLine secondX secondY lineAttrs =
    let
        finalListAttrs =
            [ x1 (String.fromFloat clockProperties.clockCenterX)
            , y1 (String.fromFloat clockProperties.clockCenterY)
            , x2 (String.fromFloat secondX)
            , y2 (String.fromFloat secondY)
            ]
                ++ lineAttrs
    in
    line finalListAttrs []


getY2 radius centerY degInRad =
    radius * sin degInRad + centerY


getX2 radius centerX degInRad =
    radius * cos degInRad + centerX


padTimePortions : String -> String
padTimePortions time =
    if String.length time == 1 then
        "0" ++ time

    else
        time
