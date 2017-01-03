module View.Login exposing (view)

import Html
    exposing
        ( Html
        , text
        , div
        , node
        , h2
        , p
        , br
        )
import Html.Attributes
    exposing
        ( attribute
        , style
        , class
        , type_
        )
import Html.Events
    exposing
        ( onClick
        , onInput
        )
import Msg
    exposing
        ( Msg(NewUrl, Login)
        , LoginMsg(..)
        )
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
                    [ label "Username"
                    , onInput <| Login << SetUsername
                    ]
                    []
                , Paper.input
                    [ label "Password"
                    , type_ "password"
                    , onInput <| Login << SetPassword
                    ]
                    []
                ]
            , div
                [ class "card-actions" ]
                [ Paper.button
                    [ class "colored"
                    , onClick <| Login AttemptLogin
                    ]
                    [ text "Login" ]
                ]
            ]
        ]
