module View exposing (view)

import Html exposing (Html, text, div, node, a)
import Html.Attributes exposing (attribute, style, class, href)
import Html.Events exposing (onClick)
import Polymer.App as App
import Polymer.Paper as Paper
import Model exposing (Model)
import Msg exposing (Msg(..))
import Routes exposing (Route(..))
import List.Extra
import Helpers exposing (isAuthenticated)


-- VIEW MODULES

import View.Login
import View.Cards
import View.Home
import View.Forms
import View.DatePicker
import View.Signup.CreateUser
import View.Photos


-- END VIEW MODULES


view : Model -> Html Msg
view model =
    case isAuthenticated model of
        True ->
            authenticatedView model

        False ->
            unauthenticatedView model


authenticatedView : Model -> Html Msg
authenticatedView model =
    App.drawerLayout
        []
        [ drawer model
        , body model
        ]


unauthenticatedView : Model -> Html Msg
unauthenticatedView model =
    div
        [ style [ ( "padding", "1em" ) ] ]
        [ div
            [ style [ ( "width", "66%" ), ( "margin", "0 auto" ) ] ]
            [ routeView model ]
        ]


drawer : Model -> Html Msg
drawer model =
    let
        unauthenticatedLinks =
            [ Home
            , Routes.Login
            , NewUser
            ]

        authenticatedLinks =
            [ Home
            , Forms
            , Routes.Logout
            ]

        subscribedLinks =
            [ Home
            , Routes.Logout
            , Cards
            , DatePicker
            , Routes.Photos
            ]

        links =
            case model.users.currentUser of
                Nothing ->
                    unauthenticatedLinks

                Just currentUser ->
                    case currentUser.hasSubscription of
                        True ->
                            subscribedLinks

                        False ->
                            authenticatedLinks

        selected =
            links
                |> List.Extra.elemIndex
                    (currentRoute model |> Maybe.withDefault Home)
                |> Maybe.withDefault 0
                |> toString
    in
        App.drawer
            []
            [ div
                [ class "drawer-contents" ]
                [ App.toolbar
                    []
                    [ div [] [ text "Menu" ] ]
                , Paper.menu
                    [ attribute "selected" selected
                    ]
                    (List.map menuLink links)
                ]
            ]


menuLink : Route -> Html Msg
menuLink route =
    Paper.item
        [ onClick <| NewUrl route ]
        [ text (toString route) ]


body : Model -> Html Msg
body model =
    App.headerLayout
        []
        [ App.header
            [ attribute "effects" "waterfall"
            , attribute "fixed" ""
            ]
            [ App.toolbar
                []
                [ Paper.iconButton
                    [ attribute "icon" "menu"
                    , attribute "drawer-toggle" ""
                    ]
                    []
                , div
                    [ class "title" ]
                    [ text "Thousands of Spoons" ]
                ]
            ]
        , div
            []
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

                Routes.Login ->
                    View.Login.view model

                Routes.Logout ->
                    text "logging you out"

                NewUser ->
                    View.Signup.CreateUser.view model

                Cards ->
                    View.Cards.view model

                Forms ->
                    View.Forms.view model

                DatePicker ->
                    View.DatePicker.view model

                Routes.Photos ->
                    View.Photos.view model

        Nothing ->
            text "404"
