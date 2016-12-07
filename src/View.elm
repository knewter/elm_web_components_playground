module View exposing (view)

import Html exposing (Html, text, div, node, a)
import Html.Attributes exposing (attribute, style, class, href)
import Html.Events exposing (onClick)
import Polymer.Paper as Paper
import Model exposing (Model)
import Msg exposing (Msg(..))
import Routes exposing (Route(..))
import List.Extra


-- VIEW MODULES

import View.Login
import View.Cards
import View.Home


-- END VIEW MODULES


view : Model -> Html Msg
view model =
    Paper.drawerPanel
        []
        [ drawer model
        , body model
        ]


drawer : Model -> Html Msg
drawer model =
    let
        links =
            [ Home
            , Login
            , Cards
            ]

        selected =
            links
                |> List.Extra.elemIndex
                    (currentRoute model |> Maybe.withDefault Home)
                |> Maybe.withDefault 0
                |> toString
    in
        Paper.headerPanel
            [ attribute "drawer" "" ]
            [ Paper.toolbar
                []
                [ div [] [ text "Menu" ] ]
            , Paper.menu
                [ attribute "selected" selected
                ]
                (List.map menuLink links)
            ]


menuLink : Route -> Html Msg
menuLink route =
    Paper.item
        [ onClick <| NewUrl route ]
        [ text (toString route) ]


body : Model -> Html Msg
body model =
    Paper.headerPanel
        [ attribute "main" "" ]
        [ Paper.toolbar []
            [ Paper.iconButton
                [ attribute "icon" "menu"
                , attribute "paper-drawer-toggle" ""
                ]
                []
            , div
                [ class "title" ]
                [ text "Thousands of Spoons" ]
            ]
        , div
            [ style [ ( "padding", "1em" ) ] ]
            [ routeView model ]
        ]


currentRoute : Model -> Maybe Route
currentRoute model =
    List.head model.history
        |> Maybe.withDefault Nothing


routeView : Model -> Html Msg
routeView model =
    case currentRoute model of
        Just route ->
            case route of
                Home ->
                    View.Home.view model

                Login ->
                    View.Login.view model

                Cards ->
                    View.Cards.view model

                Forms ->
                    View.Login.view model

        Nothing ->
            text "404"
