port module Ports
    exposing
        ( closeDrawer
        , askForStripeToken
        , receiveStripeToken
        , storeApiKey
        , receiveApiKey
        )

import Model exposing (CreditCardModel)
import Platform.Sub exposing (Sub)


-- OUTBOUND PORTS


port closeDrawer : () -> Cmd msg


port askForStripeToken : CreditCardModel -> Cmd msg


port storeApiKey : String -> Cmd msg



-- INBOUND PORTS


port receiveStripeToken : (String -> msg) -> Sub msg


port receiveApiKey : (String -> msg) -> Sub msg
