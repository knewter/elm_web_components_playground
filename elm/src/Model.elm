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
        , NewUploadModel
        , NewPhotoModel
        , UploadSignatureModel
        , initialBillingModel
        , initialCreditCardModel
        , initialUsersModel
        , initialLoginModel
        , initialNewPhotoModel
        )

import Routes exposing (Route(..))
import Date exposing (Date)
import FileReader exposing (NativeFile)
import Dict exposing (Dict)


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
    , newPhoto : NewPhotoModel
    , photos : Dict Int NewPhotoModel
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


type alias NewPhotoModel =
    { newUpload : Maybe NewUploadModel
    , dataUrl : Maybe String
    }


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


type alias NewUploadModel =
    { filename : String
    , mimetype : String
    , nativeFile : NativeFile
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


initialNewPhotoModel : NewPhotoModel
initialNewPhotoModel =
    { newUpload = Nothing
    , dataUrl = Nothing
    }
