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
    let
        creditCard =
            model.billing.creditCard
    in
        div
            [ class "view-forms" ]
            [ Paper.card
                [ attribute "heading" "Billing Information"
                , attribute "elevation" "2"
                ]
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
                        , attribute "required" ""
                        , attribute "auto-validate" ""
                        , attribute "error-message" "Please enter a valid zip code"
                        ]
                        []
                    ]
                , div [ class "card-actions" ]
                    [ Paper.button
                        []
                        [ text "Submit" ]
                    ]
                ]
            , Paper.card
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
            ]
