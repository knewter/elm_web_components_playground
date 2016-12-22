module Model
    exposing
        ( Model
        , BillingModel
        , CreditCardModel
        , NewSubscriptionModel
        , SubscriptionModel
        , initialBillingModel
        , initialCreditCardModel
        )

import Routes exposing (Route(..))
import Date exposing (Date)


type alias Model =
    { history : List (Maybe Route)
    , elevation : Int
    , date : Date
    , billing : BillingModel
    }


type alias BillingModel =
    { token : Maybe String
    , creditCard : CreditCardModel
    , subscription : Maybe SubscriptionModel
    }


type alias CreditCardModel =
    { name : String
    , ccNumber : String
    , cvc : String
    , expiration : String
    , zip : String
    }


type alias NewSubscriptionModel =
    { email : String
    , token : String
    , plan : String
    }


type alias SubscriptionModel =
    { id : String
    }


initialBillingModel : BillingModel
initialBillingModel =
    { token = Nothing
    , creditCard = initialCreditCardModel
    , suscription = Nothing
    }


initialCreditCardModel : CreditCardModel
initialCreditCardModel =
    { name = ""
    , ccNumber = ""
    , cvc = ""
    , expiration = ""
    , zip = ""
    }
