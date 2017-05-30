module View exposing (..)

import Date exposing (Date)
import Date.Format exposing (format)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (..)


renderRateRow : Rate -> Html Msg
renderRateRow rate =
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


renderRateTable : List Rate -> Html Msg
renderRateTable rates =
    table []
        ([ tr []
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
            ++ List.map renderRateRow rates
        )


dateToString : Date -> String
dateToString value =
    format "%Y-%m-01" value


renderInputField : String -> String -> String -> String -> (String -> Msg) -> Html Msg
renderInputField id_ name presetValue type__ onInputMsg =
    div [ class "clearfix" ]
        [ div [ class "col col-3" ]
            [ label [ for id_ ] [ text name ]
            ]
        , div [ class "col col-3" ]
            [ input [ id id_, type_ type__, value presetValue, onInput onInputMsg ] []
            ]
        ]


view : Model -> Html Msg
view model =
    div [ class "clearfix" ]
        [ h1 [] [ text "Tilgungsrechner" ]
        , renderInputField "start-date" "Beginn" (dateToString model.startDate) "date" ChangeStartDate
        , renderInputField "loan" "Darlehen" (toString model.loan) "number" ChangeLoan
        , renderInputField "interest" "Zinssatz(%)" (toString model.interest) "number" ChangeInterest
        , renderInputField "annuity" "Annuität" (toString model.annuity) "number" ChangeAnnuity
        , renderInputField "yearly-clearance" "Jährliche Tilgung" (toString model.yearlyClearance) "number" ChangeClearance
        , div [ class "clearfix" ]
            [ renderRateTable model.rates ]
        ]
