module View.Forms exposing (view)

import Html exposing (Html, text, div, node, h2, p, a)
import Html.Attributes exposing (attribute, style, class, href)
import Html.Events exposing (onClick)
import Msg exposing (Msg)
import Model exposing (Model)
import Polymer.Paper as Paper
import Polymer.Attributes exposing (label)


view : Model -> Html Msg
view model =
    Paper.card
        [ style
            [ ( "padding", "1em" )
            , ( "width", "80%" )
            , ( "margin", "0 auto" )
            ]
        , attribute "heading" "Billing Information"
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
