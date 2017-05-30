module State exposing (..)

import Array exposing (Array, toList)
import Date exposing (..)
import Date.Extra.Duration exposing (..)
import Types exposing (..)


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        firstPayment =
            { rates = Array.empty
            , date = stringToDate flags
            , restBefore = 30000
            , interest = 3
            , annuity = 200
            }
    in
    ( { startDate = stringToDate flags
      , loan = 30000
      , interest = 3
      , annuity = 200
      , yearlyClearance = 10000
      , rates = calculateRates firstPayment
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        payment : Payment
        payment =
            { rates = Array.empty
            , date = model.startDate
            , restBefore = model.loan
            , interest = model.interest
            , annuity = model.annuity
            }
    in
    case msg of
        ChangeStartDate value ->
            ( { model | startDate = stringToDate value, rates = calculateRates { payment | date = stringToDate value } }, Cmd.none )

        ChangeAnnuity value ->
            ( { model | annuity = stringToFloat value, rates = calculateRates { payment | annuity = stringToFloat value } }, Cmd.none )

        ChangeLoan value ->
            ( { model | loan = stringToFloat value, rates = calculateRates { payment | restBefore = stringToFloat value } }, Cmd.none )

        ChangeInterest value ->
            ( { model | interest = stringToFloat value, rates = calculateRates { payment | interest = stringToFloat value } }, Cmd.none )

        ChangeClearance value ->
            ( { model | yearlyClearance = stringToFloat value, rates = calculateRates payment }, Cmd.none )


makePayment : Payment -> Payment
makePayment payment =
    let
        nextNumber =
            Array.length payment.rates + 1

        nextDate =
            Date.Extra.Duration.add Date.Extra.Duration.Month 1 payment.date

        absoluteInterest =
            (payment.restBefore / 12) * (payment.interest / 100)

        nextRest =
            payment.restBefore - payment.annuity

        nextRate =
            { number = nextNumber
            , date = nextDate
            , restBefore = payment.restBefore
            , annuity = payment.annuity
            , yearlyClearance = 0
            , payment = payment.annuity
            , clearance = payment.annuity - absoluteInterest
            , interest = absoluteInterest
            , restAfter = nextRest
            }
    in
    { rates = Array.push nextRate payment.rates
    , date = nextDate
    , restBefore = nextRest
    , interest = payment.interest
    , annuity = payment.annuity
    }


calculateRates : Payment -> List Rate
calculateRates payment =
    if payment.restBefore > 0 then
        calculateRates (makePayment payment)
    else
        toList payment.rates


stringToDate : String -> Date
stringToDate value =
    value
        |> Date.fromString
        |> Result.withDefault (Date.fromTime 0)


stringToFloat : String -> Float
stringToFloat =
    String.toFloat >> Result.withDefault 0


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
