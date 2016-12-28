module Model
    exposing
        ( Model
        , BillingModel
        , CreditCardModel
        , NewSubscriptionModel
        , SubscriptionModel
        , LoginModel
        , UsersModel
        , NewUserModel
        , CurrentUserModel
        , initialBillingModel
        , initialCreditCardModel
        , initialUsersModel
        , initialLoginModel
        )

import Routes exposing (Route(..))
import Date exposing (Date)


type alias NewUserModel =
    { name : String
    , email : String
    , password : String
    , passwordConfirmation : String
    }


type alias UsersModel =
    { newUser : NewUserModel
    , currentUser : Maybe CurrentUserModel
    }


type alias CurrentUserModel =
    { username : String
    , hasSubscription : Bool
    }


type alias LoginModel =
    { username : String
    , password : String
    }


type alias Model =
    { history : List (Maybe Route)
    , elevation : Int
    , date : Date
    , billing : BillingModel
    , users : UsersModel
    , login : LoginModel
    , apiKey : Maybe String
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
    , subscription = Nothing
    }


initialCreditCardModel : CreditCardModel
initialCreditCardModel =
    { name = ""
    , ccNumber = ""
    , cvc = ""
    , expiration = ""
    , zip = ""
    }


initialUsersModel : UsersModel
initialUsersModel =
    { newUser = initialNewUserModel
    , currentUser = Nothing
    }


initialNewUserModel : NewUserModel
initialNewUserModel =
    { name = ""
    , email = ""
    , password = ""
    , passwordConfirmation = ""
    }


initialLoginModel : LoginModel
initialLoginModel =
    { username = ""
    , password = ""
    }
