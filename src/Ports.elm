port module Ports exposing (closeDrawer, askForToken)

import Model exposing (CreditCardModel)


-- OUTBOUND PORTS


port closeDrawer : () -> Cmd msg


port askForToken : CreditCardModel -> Cmd msg
