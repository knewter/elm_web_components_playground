module Update exposing (update)

import Model
    exposing
        ( Model
        , BillingModel
        , CreditCardModel
        , initialCreditCardModel
        , UsersModel
        , LoginModel
        , NewUserModel
        )
import Msg
    exposing
        ( Msg(..)
        , UsersMsg(..)
        , NewUserMsg(..)
        , LoginMsg(..)
        , BillingMsg(..)
        , CreditCardMsg(..)
        )
import Routes exposing (parseRoute)
import UrlParser as Url
import Navigation
import Ports
import Api


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Raise ->
            ( { model | elevation = model.elevation + 1 }, Cmd.none )

        Lower ->
            ( { model | elevation = model.elevation - 1 }, Cmd.none )

        UrlChange location ->
            let
                newHistory =
                    Url.parseHash parseRoute location :: model.history
            in
                ( { model | history = newHistory }
                , Ports.closeDrawer ()
                )

        NewUrl route ->
            case route of
                Routes.Logout ->
                    { model | apiKey = Nothing }
                        |> update (NewUrl Routes.Login)

                _ ->
                    ( model
                    , Navigation.newUrl <| "#" ++ Routes.toString route
                    )

        SetDate date ->
            ( { model | date = date }
            , Cmd.none
            )

        Billing billingMsg ->
            let
                ( billingModel, billingCmd ) =
                    updateBilling billingMsg model.billing
            in
                ( { model | billing = billingModel }
                , billingCmd
                )

        Users usersMsg ->
            let
                ( users, usersCmd ) =
                    updateUsers usersMsg model.users
            in
                ( { model | users = users }
                , usersCmd
                )

        Msg.Login loginMsg ->
            let
                ( login, loginCmd ) =
                    updateLogin loginMsg model.login
            in
                ( { model | login = login }
                , loginCmd
                )

        BecomeAuthenticated apiKey ->
            { model | apiKey = Just apiKey }
                |> update (NewUrl Routes.Home)

        NoOp ->
            ( model, Cmd.none )


updateBilling : BillingMsg -> BillingModel -> ( BillingModel, Cmd Msg )
updateBilling msg model =
    case msg of
        CreditCard creditCardMsg ->
            ( { model
                | creditCard =
                    updateCreditCard creditCardMsg model.creditCard
              }
            , Cmd.none
            )

        AskForToken ->
            ( model
            , Ports.askForToken model.creditCard
            )

        ReceiveToken token ->
            ( { model
                | token = Just token
                , creditCard = Model.initialCreditCardModel
              }
            , Api.createSubscription
                { email = "foo@example.com"
                , token = token
                , plan = "basic"
                }
            )

        SubscriptionCreated subscription ->
            ( { model | subscription = Just subscription }
            , Navigation.newUrl <| "#" ++ Routes.toString Routes.Home
            )


updateCreditCard : CreditCardMsg -> CreditCardModel -> CreditCardModel
updateCreditCard msg model =
    case msg of
        SetName name ->
            { model | name = name }

        SetCcNumber ccNumber ->
            { model | ccNumber = ccNumber }

        SetCvc cvc ->
            { model | cvc = cvc }

        SetExpiration expiration ->
            { model | expiration = expiration }

        SetZip zip ->
            { model | zip = zip }


updateUsers : UsersMsg -> UsersModel -> ( UsersModel, Cmd Msg )
updateUsers usersMsg usersModel =
    case usersMsg of
        NewUser newUserMsg ->
            let
                ( newUser, newUserCmd ) =
                    updateNewUser newUserMsg usersModel.newUser
            in
                ( { usersModel | newUser = newUser }
                , newUserCmd
                )


updateLogin : LoginMsg -> LoginModel -> ( LoginModel, Cmd Msg )
updateLogin loginMsg loginModel =
    case loginMsg of
        SetUsername username ->
            ( { loginModel | username = username }
            , Cmd.none
            )

        SetPassword password ->
            ( { loginModel | password = password }
            , Cmd.none
            )

        AttemptLogin ->
            ( loginModel
            , Api.login loginModel
            )


updateNewUser : NewUserMsg -> NewUserModel -> ( NewUserModel, Cmd Msg )
updateNewUser newUserMsg newUserModel =
    case newUserMsg of
        SetNewUserName name ->
            { newUserModel | name = name } ! []

        SetNewUserEmail email ->
            { newUserModel | email = email } ! []

        SetNewUserPassword password ->
            { newUserModel | password = password } ! []

        SetNewUserPasswordConfirmation passwordConfirmation ->
            { newUserModel | passwordConfirmation = passwordConfirmation } ! []

        CreateNewUser ->
            ( newUserModel
            , Api.createNewUser newUserModel
            )
