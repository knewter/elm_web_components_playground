module View.Cards exposing (view)

import Html exposing (Html, text, div, node, h2)
import Html.Attributes exposing (attribute, style, class)
import Html.Events exposing (onClick)
import Msg exposing (Msg(..))
import Model exposing (Model)
import Polymer.Paper as Paper
import Polymer.Attributes exposing (label)


view : Model -> Html Msg
view model =
    Paper.card
        [ class "view-cards"
        , attribute "heading" "MegaSpoon"
        , attribute "image" "https://unsplash.it/420/230"
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
