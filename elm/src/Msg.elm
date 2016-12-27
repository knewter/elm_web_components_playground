module Msg
    exposing
        ( Msg(..)
        , UsersMsg(..)
        , LoginMsg(..)
        , NewUserMsg(..)
        , BillingMsg(..)
        , CreditCardMsg(..)
        )

import Navigation
import Routes exposing (Route)
import Date exposing (Date)
import Model exposing (SubscriptionModel)


type Msg
    = Raise
    | Lower
    | UrlChange Navigation.Location
    | Users UsersMsg
    | Login LoginMsg
    | BecomeAuthenticated String
    | NewUrl Route
    | SetDate Date
    | Billing BillingMsg
    | NoOp


type BillingMsg
    = CreditCard CreditCardMsg
    | AskForToken
    | ReceiveToken String
    | SubscriptionCreated SubscriptionModel


type CreditCardMsg
    = SetName String
    | SetCcNumber String
    | SetCvc String
    | SetExpiration String
    | SetZip String


type UsersMsg
    = NewUser NewUserMsg


type LoginMsg
    = SetUsername String
    | SetPassword String
    | AttemptLogin


type NewUserMsg
    = SetNewUserName String
    | SetNewUserEmail String
    | SetNewUserPassword String
    | SetNewUserPasswordConfirmation String
    | CreateNewUser
