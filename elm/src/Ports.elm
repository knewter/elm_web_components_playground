port module Ports exposing (closeDrawer, askForToken, receiveToken)

import Model exposing (CreditCardModel)


-- OUTBOUND PORTS


port closeDrawer : () -> Cmd msg


port askForToken : CreditCardModel -> Cmd msg



-- INBOUND PORTS


port receiveToken : (String -> msg) -> Sub msg
