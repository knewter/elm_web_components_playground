module Api
    exposing
        ( createSubscription
        , login
        , createNewUser
        , createUploadSignature
        )

import Http exposing (Response)
import HttpBuilder exposing (..)
import Model
    exposing
        ( NewSubscriptionModel
        , LoginModel
        , NewUserModel
        , CurrentUserModel
        , UploadSignatureModel
        , NewUploadModel
        )
import Msg
    exposing
        ( Msg(NoOp, Billing, BecomeAuthenticated, NewPhoto)
        , BillingMsg(SubscriptionCreated)
        , NewPhotoMsg(ReceiveUploadSignature, RequestUploadSignature)
        )
import Time
import Json.Decode as Decode exposing (Decoder, string)
import Json.Decode.Pipeline exposing (decode, required)
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


createUploadSignature : String -> NewUploadModel -> Cmd Msg
createUploadSignature apiKey newUpload =
    post (apiUrl "upload_signatures")
        |> withHeader "authorization" ("Bearer " ++ apiKey)
        |> withJsonBody (newUploadEncoder newUpload)
        |> withTimeout (10 * Time.second)
        |> withExpect (Http.expectJson <| uploadSignatureDecoder)
        |> send handleCreateUploadSignatureComplete


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


handleCreateUploadSignatureComplete : Result Http.Error UploadSignatureModel -> Msg
handleCreateUploadSignatureComplete result =
    case result of
        Ok uploadSignature ->
            NewPhoto <| ReceiveUploadSignature uploadSignature

        Err errorString ->
            let
                _ =
                    Debug.log "error creating upload signature" errorString
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
            Decode.decodeString (dataDecoder decodeCurrentUser) body
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
    Decode.map2 CurrentUserModel
        (Decode.field "username" Decode.string)
        (Decode.succeed False)


uploadSignatureDecoder : Decoder UploadSignatureModel
uploadSignatureDecoder =
    decode UploadSignatureModel
        |> required "key" string
        |> required "date" string
        |> required "content_type" string
        |> required "acl" string
        |> required "success_action_status" string
        |> required "action" string
        |> required "aws_access_key_id" string
        |> required "credential" string
        |> required "policy" string
        |> required "signature" string


newUploadEncoder : NewUploadModel -> Encode.Value
newUploadEncoder newUpload =
    Encode.object
        [ ( "filename", Encode.string newUpload.filename )
        , ( "mimetype", Encode.string newUpload.mimetype )
        ]


dataDecoder : Decoder a -> Decoder a
dataDecoder decoder =
    Decode.field "data" decoder
