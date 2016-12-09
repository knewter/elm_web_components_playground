module App exposing (..)

import Model exposing (Model)
import Msg exposing (Msg)
import Routes exposing (parseRoute)
import Navigation
import UrlParser as Url
import Date


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    ( { history = [ Url.parseHash parseRoute location ]
      , elevation = 2
      , date = Date.fromTime 0
      }
    , Cmd.none
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
