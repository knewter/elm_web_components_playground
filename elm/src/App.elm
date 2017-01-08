module App exposing (..)

import Model exposing (Model)
import Msg exposing (Msg(Billing, BecomeAuthenticated), BillingMsg(ReceiveToken))
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
      , newPhoto = Model.initialNewPhotoModel
      }
    , Cmd.none
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Ports.receiveStripeToken <| Billing << ReceiveToken
        , Ports.receiveApiKey <|
            (\apiKey ->
                BecomeAuthenticated apiKey
                    { username = "knewter", hasSubscription = True }
            )
        ]
