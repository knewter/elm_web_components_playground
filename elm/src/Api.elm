module Api exposing (createSubscription)

import Http exposing (Response)
import HttpBuilder exposing (..)
import Model exposing (SubscriptionModel)
import Msg exposing (Msg(NoOp, Billing), BillingMsg(SubscriptionCreated))
import Time
import Json.Decode as Decode
import Json.Encode as Encode


baseUrl : String
baseUrl =
    "http://localhost:4000/api/"


apiUrl : String -> String
apiUrl url =
    baseUrl ++ url


createSubscription : SubscriptionModel -> Cmd Msg
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
            Billing <| SubscriptionCreated subscriptionId

        Err errorString ->
            let
                _ =
                    Debug.log "error creating subscription" errorString
            in
                NoOp


subscriptionDecoder : Decode.Decoder String
subscriptionDecoder =
    Decode.field "id" Decode.string


subscriptionEncoder : SubscriptionModel -> Encode.Value
subscriptionEncoder subscription =
    Encode.object
        [ ( "email", Encode.string subscription.email )
        , ( "token", Encode.string subscription.token )
        , ( "plan", Encode.string subscription.plan )
        ]
