module View.Login exposing (view)

import Html exposing (Html, text, div, node, h2, p, br)
import Html.Attributes exposing (attribute, style, class)
import Html.Events exposing (onClick)
import Msg exposing (Msg(NewUrl))
import Model exposing (Model)
import Polymer.Paper as Paper
import Polymer.Attributes exposing (label)
import Routes exposing (Route(Cards))


view : Model -> Html Msg
view model =
    div
        [ class "view-login" ]
        [ Paper.card
            [ attribute "heading" "Login"
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
        , Paper.card
            [ attribute "elevation" "2" ]
            [ p [ class "card-content" ] [ text "Neat, what else do you have?" ]
            , div
                [ class "card-actions" ]
                [ Paper.button
                    [ onClick <| NewUrl Cards ]
                    [ text "Next" ]
                ]
            ]
        ]
