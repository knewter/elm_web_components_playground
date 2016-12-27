module Api exposing (createSubscription, login, createNewUser)

import Http exposing (Response)
import HttpBuilder exposing (..)
import Model
    exposing
        ( NewSubscriptionModel
        , LoginModel
        , NewUserModel
        )
import Msg
    exposing
        ( Msg(NoOp, Billing, BecomeAuthenticated)
        , BillingMsg(SubscriptionCreated)
        )
import Time
import Json.Decode as Decode
import Json.Encode as Encode
import Encoders exposing (newUserEncoder, loginEncoder)
import Dict


baseUrl : String
baseUrl =
    "http://localhost:4000/api/"


apiUrl : String -> String
apiUrl url =
    baseUrl ++ url


login : LoginModel -> Cmd Msg
login loginModel =
    post (apiUrl "authenticate")
        |> withJsonBody (loginEncoder loginModel)
        |> withTimeout (10 * Time.second)
        |> withExpect (Http.expectStringResponse decodeApiKeyFromHeader)
        |> send handleLoginComplete


createNewUser : NewUserModel -> Cmd Msg
createNewUser newUser =
    post (apiUrl "users")
        |> withJsonBody (newUserEncoder newUser)
        |> withTimeout (10 * Time.second)
        |> withExpect (Http.expectStringResponse decodeApiKeyFromHeader)
        |> send handleLoginComplete


createSubscription : NewSubscriptionModel -> Cmd Msg
createSubscription subscription =
    post (apiUrl "subscriptions")
        |> withJsonBody (subscriptionEncoder subscription)
        |> withTimeout (10 * Time.second)
        |> withExpect (Http.expectJson subscriptionDecoder)
        |> send handleCreateSubscriptionComplete


handleCreateSubscriptionComplete : Result Http.Error String -> Msg
handleCreateSubscriptionComplete result =
    case result of
        Ok subscriptionId ->
            Billing <| SubscriptionCreated { id = subscriptionId }

        Err errorString ->
            let
                _ =
                    Debug.log "error creating subscription" errorString
            in
                NoOp


subscriptionDecoder : Decode.Decoder String
subscriptionDecoder =
    Decode.field "id" Decode.string


subscriptionEncoder : NewSubscriptionModel -> Encode.Value
subscriptionEncoder subscription =
    Encode.object
        [ ( "email", Encode.string subscription.email )
        , ( "token", Encode.string subscription.token )
        , ( "plan", Encode.string subscription.plan )
        ]


handleLoginComplete : Result Http.Error String -> Msg
handleLoginComplete result =
    case result of
        Ok apiKey ->
            BecomeAuthenticated apiKey

        Err errorString ->
            let
                _ =
                    Debug.log "error logging in" errorString
            in
                NoOp


decodeApiKeyFromHeader : Response String -> Result String String
decodeApiKeyFromHeader { headers, status } =
    let
        bearerTokenResult =
            headers
                |> Dict.get "authorization"
                -- Drop 'Bearer '
                |>
                    Maybe.map (String.dropLeft 7)
                |> Result.fromMaybe "Couldn't find authorization header."
    in
        case status.code of
            200 ->
                bearerTokenResult

            201 ->
                bearerTokenResult

            _ ->
                Err "Got an unsuccessful response"
