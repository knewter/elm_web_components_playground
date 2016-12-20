module View.Cards exposing (view)

import Html exposing (Html, text, div, node, h2, p)
import Html.Attributes exposing (attribute, style, class)
import Html.Events exposing (onClick)
import Msg exposing (Msg(Raise, Lower, NewUrl))
import Model exposing (Model)
import Polymer.Paper as Paper
import Routes exposing (Route(Forms))


view : Model -> Html Msg
view model =
    div
        [ class "view-cards" ]
        [ Paper.card
            [ attribute "heading" "MegaSpoon"
            , attribute "image" "http://lorempixel.com/420/230"
            , attribute "elevation" (toString model.elevation)
            , attribute "animated" "true"
            ]
            [ div
                [ class "card-content"
                , style [ ( "position", "relative" ) ]
                ]
                [ Paper.fab
                    [ attribute "icon" "add"
                    , style [ ( "position", "absolute" ), ( "right", "16px" ), ( "top", "-32px" ) ]
                    ]
                    []
                , text "a lonely card"
                ]
            , div
                [ class "card-actions" ]
                [ Paper.button [ onClick Lower ] [ text "Lower" ]
                , Paper.button [ onClick Raise ] [ text "Raise" ]
                ]
            ]
        , Paper.card
            [ attribute "elevation" "2" ]
            [ p [ class "card-content" ] [ text "Neat, what else do you have?" ]
            , div
                [ class "card-actions" ]
                [ Paper.button
                    [ onClick <| NewUrl Forms ]
                    [ text "Next" ]
                ]
            ]
        ]
