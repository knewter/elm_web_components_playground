module View.Login exposing (view)

import Html exposing (Html, text, div, node, h2)
import Html.Attributes exposing (attribute, style, class)
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
            , ( "width", "50%" )
            , ( "margin", "0 auto" )
            ]
        , attribute "heading" "Login"
        , attribute "elevation" "2"
        ]
        [ div
            [ class "card-content" ]
            [ Paper.input
                [ label "Username" ]
                []
            , Paper.input
                [ label "Password" ]
                []
            ]
        , div
            [ class "card-actions" ]
            [ Paper.button
                [ class "colored" ]
                [ text "Login" ]
            ]
        ]
