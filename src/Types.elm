module Types exposing (..)

import Array exposing (Array)
import Date exposing (Date)


type alias Flags =
    String


type alias Model =
    { startDate : Date
    , loan : Float
    , interest : Float
    , annuity : Float
    , yearlyClearance : Float
    , rates : List Rate
    }


type Msg
    = ChangeStartDate String
    | ChangeLoan String
    | ChangeInterest String
    | ChangeAnnuity String
    | ChangeClearance String


type alias Rate =
    { number : Int
    , date : Date
    , restBefore : Float
    , annuity : Float
    , yearlyClearance : Float
    , payment : Float
    , clearance : Float
    , interest : Float
    , restAfter : Float
    }


type alias Payment =
    { rates : Array Rate
    , date : Date
    , restBefore : Float
    , interest : Float
    , annuity : Float
    }
