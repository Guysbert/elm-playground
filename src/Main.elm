module Main exposing (..)

import Html exposing (programWithFlags)
import State exposing (init, subscriptions, update)
import Types exposing (..)
import View exposing (view)


main : Program Flags Model Msg
main =
    programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
