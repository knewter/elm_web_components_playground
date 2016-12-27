module App exposing (..)

import Model exposing (Model)
import Msg exposing (Msg(Billing), BillingMsg(ReceiveToken))
import Routes exposing (parseRoute)
import Navigation
import UrlParser as Url
import Date
import Ports


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    ( { history = [ Url.parseHash parseRoute location ]
      , elevation = 2
      , date = Date.fromTime 0
      , billing = Model.initialBillingModel
      , users = Model.initialUsersModel
      , login = Model.initialLoginModel
      , apiKey = Nothing
      }
    , Cmd.none
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Ports.receiveToken <| Billing << ReceiveToken
