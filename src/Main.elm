module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Date exposing (Date, now)
import Date.Format exposing (..)


--Model


type alias Model =
    { startDate : Date
    , loan : Float
    , interest : Float
    , annuity : Float
    , yearlyClearance : Float
    }


type alias Flags =
    String


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { startDate = stringToDate flags
      , loan = 0
      , interest = 0
      , annuity = 0
      , yearlyClearance = 0
      }
    , Cmd.none
    )

stringToDate: String -> Date
stringToDate value =
    value
    |> Date.fromString
    |> Result.withDefault (Date.fromTime 1495202978784)

dateToString: Date -> String
dateToString value =
     format "%Y-%m-%d" value 

--Messages


type Msg
    = ChangeStartDate String
    | ChangeLoan String
    | ChangeInterest
    | ChangeAnnuity
    | ChangeClearance



--View


view : Model -> Html Msg
view model =
    div []
        [ input [ type_ "date", value (dateToString model.startDate) ] [],
        text (dateToString model.startDate)
        
        ]



--Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


parseSummand : String -> Int
parseSummand =
    String.toInt >> Result.withDefault 0



--Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



--Main
--uncomment if needed -- import Html.App as App


main : Program Flags Model Msg
main =
    programWithFlags 
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
