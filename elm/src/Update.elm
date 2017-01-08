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
        , CurrentUserModel
        , NewPhotoModel
        , NewUploadModel
        )
import Msg
    exposing
        ( Msg(..)
        , UsersMsg(..)
        , NewUserMsg(..)
        , LoginMsg(..)
        , BillingMsg(..)
        , CreditCardMsg(..)
        , NewPhotoMsg(..)
        )
import Routes exposing (parseRoute)
import UrlParser as Url
import Navigation
import Ports
import Api
import Json.Decode as Decode
import FileReader exposing (readAsDataUrl)
import Task
import MimeType


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
                    { model
                        | apiKey = Nothing
                        , users = Model.initialUsersModel
                    }
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
                    updateBilling model.apiKey billingMsg model.billing

                newModel =
                    case billingMsg of
                        SubscriptionCreated subscription ->
                            let
                                users =
                                    model.users

                                currentUser =
                                    users.currentUser

                                newCurrentUser =
                                    case currentUser of
                                        Just user ->
                                            Just { user | hasSubscription = True }

                                        Nothing ->
                                            Nothing

                                newUsers =
                                    { users | currentUser = newCurrentUser }
                            in
                                { model | users = newUsers }

                        _ ->
                            model
            in
                ( { newModel | billing = billingModel }
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

        BecomeAuthenticated apiKey currentUser ->
            let
                ( usersModel, _ ) =
                    updateUsers (SetCurrentUser currentUser) model.users

                newUrl =
                    case currentUser.hasSubscription of
                        False ->
                            Routes.Forms

                        True ->
                            Routes.Home
            in
                ( { model | apiKey = Just apiKey, users = usersModel }
                , Cmd.batch
                    [ Navigation.newUrl <| "/#" ++ Routes.toString newUrl
                    , Ports.storeApiKey apiKey
                    ]
                )

        NewPhoto newPhotoMsg ->
            let
                ( newPhotoModel, newPhotoCmd ) =
                    updateNewPhoto model.apiKey newPhotoMsg model.newPhoto
            in
                ( { model | newPhoto = newPhotoModel }
                , newPhotoCmd
                )

        NoOp ->
            ( model, Cmd.none )


updateNewPhoto : Maybe String -> NewPhotoMsg -> NewPhotoModel -> ( NewPhotoModel, Cmd Msg )
updateNewPhoto apiKey newPhotoMsg newPhotoModel =
    case newPhotoMsg of
        SetNewPhoto nativeFiles ->
            let
                handleDataUrl result =
                    case result of
                        Err err ->
                            NoOp

                        Ok dataUrl ->
                            NewPhoto <| ReceivedNewPhotoAsDataUrl dataUrl

                maybeNativeFile =
                    List.head nativeFiles
            in
                case maybeNativeFile of
                    Nothing ->
                        { newPhotoModel | newUpload = Nothing } ! []

                    Just nativeFile ->
                        let
                            _ =
                                Debug.log "nativeFile" nativeFile

                            newUpload =
                                NewUploadModel
                                    nativeFile.name
                                    (Maybe.withDefault ""
                                        (Maybe.map
                                            MimeType.toString
                                            nativeFile.mimeType
                                        )
                                    )
                                    nativeFile
                        in
                            ( { newPhotoModel | newUpload = Just newUpload }
                            , readAsDataUrl nativeFile.blob
                                |> Task.attempt handleDataUrl
                            )

        ReceivedNewPhotoAsDataUrl value ->
            let
                dataUrl =
                    Decode.decodeValue Decode.string value
                        |> Result.toMaybe
            in
                { newPhotoModel | dataUrl = dataUrl } ! []

        RequestUploadSignature ->
            case newPhotoModel.newUpload of
                Nothing ->
                    let
                        _ =
                            Debug.log "RequestUploadSignature but no upload data" True
                    in
                        newPhotoModel ! []

                Just newUpload ->
                    newPhotoModel
                        ! [ Api.createUploadSignature
                                (Maybe.withDefault "" apiKey)
                                newUpload
                          ]

        ReceiveUploadSignature uploadSignature ->
            case newPhotoModel.newUpload of
                Nothing ->
                    let
                        _ =
                            Debug.log "ReceiveUploadSignature" "No newUpload"
                    in
                        newPhotoModel ! []

                Just newUpload ->
                    let
                        _ =
                            Debug.log "ReceiveUploadSignature" uploadSignature
                    in
                        newPhotoModel
                            ! []


updateBilling : Maybe String -> BillingMsg -> BillingModel -> ( BillingModel, Cmd Msg )
updateBilling apiKey msg model =
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
            , Ports.askForStripeToken model.creditCard
            )

        ReceiveToken token ->
            ( { model
                | token = Just token
                , creditCard = Model.initialCreditCardModel
              }
            , Api.createSubscription apiKey
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

        SetCurrentUser currentUser ->
            ( { usersModel | currentUser = Just currentUser }
            , Cmd.none
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
