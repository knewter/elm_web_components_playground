module Api exposing (createSubscription, login, createNewUser)

import Http exposing (Response)
import HttpBuilder exposing (..)
import Model
    exposing
        ( NewSubscriptionModel
        , LoginModel
        , NewUserModel
        , CurrentUserModel
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
        |> withExpect (Http.expectStringResponse decodeApiKeyAndUser)
        |> send handleLoginComplete


createNewUser : NewUserModel -> Cmd Msg
createNewUser newUser =
    post (apiUrl "users")
        |> withJsonBody (newUserEncoder newUser)
        |> withTimeout (10 * Time.second)
        |> withExpect (Http.expectStringResponse decodeApiKeyAndUser)
        |> send handleLoginComplete


createSubscription : Maybe String -> NewSubscriptionModel -> Cmd Msg
createSubscription apiKey subscription =
    post (apiUrl "subscriptions")
        |> withJsonBody (subscriptionEncoder subscription)
        |> withTimeout (10 * Time.second)
        |> withExpect (Http.expectJson subscriptionDecoder)
        |> withHeader "authorization" (bearer apiKey)
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


handleLoginComplete : Result Http.Error ( String, CurrentUserModel ) -> Msg
handleLoginComplete result =
    case result of
        Ok ( apiKey, currentUserModel ) ->
            BecomeAuthenticated apiKey currentUserModel

        Err errorString ->
            let
                _ =
                    Debug.log "error logging in" errorString
            in
                NoOp


bearer : Maybe String -> String
bearer apiKey =
    "Bearer "
        ++ (Maybe.withDefault "" apiKey)


decodeApiKeyAndUser : Response String -> Result String ( String, CurrentUserModel )
decodeApiKeyAndUser { headers, status, body } =
    let
        bearerTokenResult =
            headers
                |> Dict.get "authorization"
                -- Drop 'Bearer '
                |>
                    Maybe.map (String.dropLeft 7)
                |> Result.fromMaybe "Couldn't find authorization header."

        decodedCurrentUser =
            Decode.decodeString decodeCurrentUser body
    in
        case decodedCurrentUser of
            Err err ->
                Err err

            Ok currentUser ->
                case bearerTokenResult of
                    Err bearerTokenErr ->
                        Err bearerTokenErr

                    Ok bearerToken ->
                        case status.code of
                            200 ->
                                Ok ( bearerToken, currentUser )

                            201 ->
                                Ok ( bearerToken, currentUser )

                            _ ->
                                Err "Got an unsuccessful response"


decodeCurrentUser : Decode.Decoder CurrentUserModel
decodeCurrentUser =
    Decode.field "data" <|
        Decode.map2 CurrentUserModel
            (Decode.field "username" Decode.string)
            (Decode.succeed False)
