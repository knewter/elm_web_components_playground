module Update exposing (update)

import Model
    exposing
        ( Model
        , BillingModel
        , CreditCardModel
        , initialCreditCardModel
        )
import Msg exposing (Msg(..), BillingMsg(..), CreditCardMsg(..))
import Routes exposing (parseRoute)
import UrlParser as Url
import Navigation
import Ports


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
            , Cmd.none
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
