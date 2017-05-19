module Main exposing (..)

import Html exposing (Html, Attribute, button, div, text, input, program, br)
import Html.Attributes exposing (type_)
import Html.Events exposing (onClick, onInput)

--Model

type alias Model =
    {a: Int, 
    b: Int,
    c: Int}

init: (Model, Cmd Msg)
init = 
    ({a = 0, b = 0, c= 0}, Cmd.none)

--Messages

type Msg
    = ChangeA String
    | ChangeB String
    | Sum

--View

view: Model -> Html Msg
view model = 
        div []
            [
                input [type_ "number", onInput ChangeA][],
                br [][],
                input [type_ "number", onInput ChangeB][],
                br[][], 
            
            button[onClick Sum][text "+"],
            text (toString model.c)
            ]

--Update

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        ChangeA value ->
            ({ model | a = parseSummand value }, Cmd.none)
        ChangeB value ->
            ({ model | b = parseSummand value }, Cmd.none)
        Sum ->
            ({ model | c = model.a + model.b }, Cmd.none)


parseSummand : String -> Int
parseSummand =
    String.toInt >> Result.withDefault 0


--Subscriptions

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


--Main

--uncomment if needed -- import Html.App as App
main: Program Never Model Msg
main =
  program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
