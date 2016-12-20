module Model
    exposing
        ( Model
        , BillingModel
        , CreditCardModel
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
    }


type alias CreditCardModel =
    { name : String
    , ccNumber : String
    , cvc : String
    , expiration : String
    , zip : String
    }


initialBillingModel : BillingModel
initialBillingModel =
    { token = Nothing
    , creditCard = initialCreditCardModel
    }


initialCreditCardModel : CreditCardModel
initialCreditCardModel =
    { name = ""
    , ccNumber = ""
    , cvc = ""
    , expiration = ""
    , zip = ""
    }
