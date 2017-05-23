module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Date exposing (Date, now)
import Date.Format exposing (..)
import Date.Extra.Duration exposing (Duration)


--Model


type alias Model =
    { startDate : Date
    , loan : Float
    , interest : Float
    , annuity : Float
    , yearlyClearance : Float
    , rates : List Rate
    }


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


type alias Flags =
    String


calculateAbsoluteInterest : Float -> Float -> Float
calculateAbsoluteInterest restSum interest =
    (restSum / 12) * (interest/100)


calculateRates : List Rate -> Date -> Float -> Float -> Float -> List Rate
calculateRates rates date restBefore interest annuity =
    if restBefore > 0 then
        List.append 
            [ { number = (List.length rates) + 1
              , date = Date.Extra.Duration.add Date.Extra.Duration.Day 2 date
              , restBefore = restBefore
              , annuity = annuity
              , yearlyClearance = 0
              , payment = annuity
              , clearance = annuity - (calculateAbsoluteInterest restBefore interest)
              , interest = calculateAbsoluteInterest restBefore interest
              , restAfter = restBefore - annuity
              }
            ]
            (calculateRates rates (Date.Extra.Duration.add Date.Extra.Duration.Day 1 date) (restBefore - annuity) interest annuity)
    else
        rates


renderRates : List Rate -> List (Html Msg)
renderRates rates =
    List.map renderRow rates


renderRow : Rate -> Html Msg
renderRow rate =
    tr []
        [ td [] [ text (toString rate.number) ]
        , td [] [ text (dateToString rate.date) ]
        , td [] [ text (toString rate.restBefore) ]
        , td [] [ text (toString rate.annuity) ]
        , td [] [ text (toString rate.yearlyClearance) ]
        , td [] [ text (toString rate.payment) ]
        , td [] [ text (toString rate.clearance) ]
        , td [] []
        , td [] [ text (toString rate.interest) ]
        , td [] [ text (toString rate.restAfter) ]
        ]


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { startDate = stringToDate flags
      , loan = 30000
      , interest = 3
      , annuity = 200
      , yearlyClearance = 10000
      , rates = calculateRates [] (stringToDate flags) 30000 3 200
      }
    , Cmd.none
    )


stringToDate : String -> Date
stringToDate value =
    value
        |> Date.fromString
        |> Result.withDefault (Date.fromTime 0)


dateToString : Date -> String
dateToString value =
    format "%Y-%m-01" value



--Messages


type Msg
    = ChangeStartDate String
    | ChangeLoan String
    | ChangeInterest String
    | ChangeAnnuity String
    | ChangeClearance String



--View


view : Model -> Html Msg
view model =
    div [ class "clearfix" ]
        [ h1 [] [ text "Tilgungsrechner" ]
        , div [ class "clearfix" ]
            [ div [ class "col col-3" ]
                [ label [ for "start-date" ] [ text "Beginn" ]
                ]
            , div [ class "col col-3" ]
                [ input [ id "start-date", type_ "date", value (dateToString model.startDate), onInput ChangeStartDate ] []
                ]
            ]
        , div [ class "clearfix" ]
            [ div [ class "col col-3" ]
                [ label [ for "loan" ] [ text "Darlehen" ]
                ]
            , div [ class "col col-3" ]
                [ input [ id "loan", type_ "number", value (toString model.loan), onInput ChangeLoan ] []
                ]
            ]
        , div [ class "clearfix" ]
            [ div [ class "col col-3" ]
                [ label [ for "interest" ] [ text "Zinssatz(%)" ]
                ]
            , div [ class "col col-3" ]
                [ input [ id "interest", type_ "number", value (toString model.interest), onInput ChangeInterest ] []
                ]
            ]
        , div [ class "clearfix" ]
            [ div [ class "col col-3" ]
                [ label [ for "annuity" ] [ text "Annuität" ]
                ]
            , div [ class "col col-3" ]
                [ input [ id "annuity", type_ "number", value (toString model.annuity), onInput ChangeAnnuity ] []
                ]
            ]
        , div [ class "clearfix" ]
            [ div [ class "col col-3" ]
                [ label [ for "yearly-clearance" ] [ text "Jährliche Tilgung" ]
                ]
            , div [ class "col col-3" ]
                [ input [ id "yearly-clearance", type_ "number", value (toString model.yearlyClearance), onInput ChangeClearance ] []
                ]
            ]
        , div [ class "clearfix" ]
            [ table []
                (List.append
                    [ tr []
                        [ th [] [ text "Nr" ]
                        , th [] [ text "Datum" ]
                        , th [] [ text "Restschuld vorher" ]
                        , th [] [ text "Annuität" ]
                        , th [] [ text "Sondertilgung" ]
                        , th [] [ text "Zahlungsbetrag" ]
                        , th [] [ text "Tilgung" ]
                        , th [] [ text "Tigung %" ]
                        , th [] [ text "Zinsen" ]
                        , th [] [ text "Restschuld nachher" ]
                        ]
                    ]
                    (renderRates model.rates)
                )
            ]
        ]



--Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeStartDate value ->
            ( { model | startDate = (stringToDate value), rates = calculateRates [] model.startDate model.loan model.interest model.annuity }, Cmd.none )

        ChangeAnnuity value ->
            ( { model | annuity = (stringToFloat value), rates = calculateRates [] model.startDate model.loan model.interest (stringToFloat value) }, Cmd.none )

        ChangeLoan value ->
            ( { model | loan = (stringToFloat value), rates = calculateRates [] model.startDate (stringToFloat value) model.interest model.annuity }, Cmd.none )

        ChangeInterest value ->
            ( { model | interest = (stringToFloat value), rates = calculateRates [] model.startDate model.loan (stringToFloat value) model.annuity }, Cmd.none )

        ChangeClearance value ->
            ( { model | yearlyClearance = (stringToFloat value), rates = calculateRates [] model.startDate model.loan model.interest model.annuity }, Cmd.none )


stringToFloat : String -> Float
stringToFloat =
    String.toFloat >> Result.withDefault 0



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
