module View.Forms exposing (view)

import Html exposing (Html, text, div, node, h2, p, a)
import Html.Attributes exposing (attribute, style, class, href, value)
import Html.Events exposing (onClick, onInput)
import Msg
    exposing
        ( Msg(NewUrl, Billing)
        , BillingMsg(..)
        , CreditCardMsg(..)
        )
import Model exposing (Model)
import Polymer.Paper as Paper
import Polymer.Attributes exposing (label)
import Routes exposing (Route(DatePicker))


view : Model -> Html Msg
view model =
    div
        [ class "view-forms" ]
        [ Paper.card
            [ attribute "heading" "Billing Information"
            , attribute "elevation" "2"
            ]
            (cardContent model)
        , nextCard model
        ]


cardContent : Model -> List (Html Msg)
cardContent model =
    case model.billing.token of
        Nothing ->
            cardFormContent model

        Just _ ->
            [ div
                [ style
                    [ ( "width", "100%" )
                    , ( "text-align", "center" )
                    ]
                ]
                [ node "paper-spinner"
                    [ class "card-content"
                    , attribute "active" ""
                    , style
                        [ ( "margin", "0 auto" )
                        ]
                    ]
                    []
                ]
            ]


cardFormContent : Model -> List (Html Msg)
cardFormContent model =
    let
        creditCard =
            model.billing.creditCard
    in
        [ div [ class "card-content" ]
            [ p [] [ text <| "Token: " ++ (toString model.billing.token) ]
            , Paper.input
                [ label "Name"
                , value creditCard.name
                , onInput <| Billing << CreditCard << SetName
                , attribute "required" ""
                , attribute "auto-validate" ""
                , attribute "error-message" "I need a name"
                ]
                []
            , node "gold-cc-input"
                [ label "Credit Card Number"
                , value creditCard.ccNumber
                , onInput <| Billing << CreditCard << SetCcNumber
                , attribute "required" ""
                , attribute "auto-validate" "true"
                , attribute "error-message" "This is not a valid credit card number"
                ]
                []
            , node "gold-cc-cvc-input"
                [ label "CVC"
                , value creditCard.cvc
                , onInput <| Billing << CreditCard << SetCvc
                , attribute "required" ""
                , attribute "auto-validate" ""
                , attribute "error-message" "CVC is required"
                ]
                []
            , node "gold-cc-expiration-input"
                [ label "Expiration"
                , value creditCard.expiration
                , onInput <| Billing << CreditCard << SetExpiration
                , attribute "required" ""
                , attribute "auto-validate" ""
                , attribute "error-message" "Expiration dates are important"
                ]
                []
            , node "gold-zip-input"
                [ label "Zip Code"
                , value creditCard.zip
                , onInput <| Billing << CreditCard << SetZip
                , attribute "required" ""
                , attribute "auto-validate" ""
                , attribute "error-message" "Please enter a valid zip code"
                ]
                []
            ]
        , div [ class "card-actions" ]
            [ Paper.button
                [ onClick <| Billing <| AskForToken ]
                [ text "Submit" ]
            ]
        ]


nextCard : Model -> Html Msg
nextCard model =
    Paper.card
        [ attribute "elevation" "2" ]
        [ p
            [ class "card-content" ]
            [ text "Neat, what else do you have?" ]
        , div
            [ class "card-actions" ]
            [ Paper.button
                [ onClick <| NewUrl DatePicker ]
                [ text "Next" ]
            ]
        ]
