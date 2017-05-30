module View exposing (..)

import Date exposing (Date)
import Date.Format exposing (format)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (..)


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


renderRates : List Rate -> List (Html Msg)
renderRates rates =
    List.map renderRow rates


dateToString : Date -> String
dateToString value =
    format "%Y-%m-01" value


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
