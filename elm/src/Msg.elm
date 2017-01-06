module Msg
    exposing
        ( Msg(..)
        , UsersMsg(..)
        , LoginMsg(..)
        , NewUserMsg(..)
        , BillingMsg(..)
        , CreditCardMsg(..)
        , NewPhotoMsg(..)
        )

import Navigation
import Routes exposing (Route)
import Date exposing (Date)
import Model exposing (SubscriptionModel, CurrentUserModel)
import FileReader exposing (NativeFile)
import Json.Decode as Decode


type Msg
    = Raise
    | Lower
    | UrlChange Navigation.Location
    | Users UsersMsg
    | Login LoginMsg
    | BecomeAuthenticated String CurrentUserModel
    | NewUrl Route
    | SetDate Date
    | Billing BillingMsg
    | NewPhoto NewPhotoMsg
    | NoOp


type NewPhotoMsg
    = SetNewPhoto (List NativeFile)
    | ReceivedNewPhotoAsDataUrl Decode.Value
    | RequestUploadSignature
    | ReceiveUploadSignature UploadSignatureModel


type alias UploadSignatureModel =
    { key : String
    , date : String
    , content_type : String
    , acl : String
    , success_action_status : String
    , action : String
    , aws_access_key_id : String
    , credential : String
    , policy : String
    , signature : String
    }


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
    | SetCurrentUser CurrentUserModel


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
