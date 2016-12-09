module View.Forms exposing (view)

import Html exposing (Html, text, div, node, h2, p, a)
import Html.Attributes exposing (attribute, style, class, href)
import Html.Events exposing (onClick)
import Msg exposing (Msg(NewUrl))
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
            [ div [ class "card-content" ]
                [ Paper.input
                    [ label "Name"
                    , attribute "required" ""
                    , attribute "auto-validate" ""
                    , attribute "error-message" "I need a name"
                    ]
                    []
                , node "gold-cc-input"
                    [ label "Credit Card Number"
                    , attribute "required" ""
                    , attribute "auto-validate" "true"
                    , attribute "error-message" "This is not a valid credit card number"
                    ]
                    []
                , node "gold-cvc-input"
                    [ label "CVC"
                    , attribute "required" ""
                    , attribute "auto-validate" ""
                    , attribute "error-message" "CVC is required"
                    ]
                    []
                , node "gold-cc-expiration-input"
                    [ label "Expiration"
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
                    [ text "Home" ]
                ]
            ]
        ]
