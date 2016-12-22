module Main exposing (..)

import App exposing (init, subscriptions)
import View exposing (view)
import Update exposing (update)
import Msg exposing (Msg(UrlChange))
import Model exposing (Model)
import Navigation


main : Program Never Model Msg
main =
    Navigation.program UrlChange
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
