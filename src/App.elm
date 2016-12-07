module App exposing (..)

import Html exposing (Html, text, div, node)
import Html.Attributes exposing (attribute, style, class)
import Html.Events exposing (onClick)
import Polymer.Paper as Paper


type alias Model =
    { message : String
    , elevation : Int
    }


init : ( Model, Cmd Msg )
init =
    ( { message = "Your Elm App is working!", elevation = 2 }, Cmd.none )


type Msg
    = Raise
    | Lower


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Raise ->
            ( { model | elevation = model.elevation + 1 }, Cmd.none )

        Lower ->
            ( { model | elevation = model.elevation - 1 }, Cmd.none )


view : Model -> Html Msg
view model =
    let
        drawer model =
            Paper.headerPanel
                [ attribute "drawer" "" ]
                [ Paper.toolbar
                    []
                    [ div [] [ text "Menu" ] ]
                , Paper.menu []
                    (List.map (\x -> Paper.item [] [ text x ]) [ "One", "Two", "Three", "Four" ])
                ]
    in
        Paper.drawerPanel
            []
            [ drawer model
            , mainContent model
            ]


card : Model -> Html Msg
card model =
    Paper.card
        [ style [ ( "margin", "1em" ) ]
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


mainContent : Model -> Html Msg
mainContent model =
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
        , card model
        ]


body : Model -> Html Msg
body model =
    div
        [ style
            [ ( "min-height", "2000px" )
            ]
        ]
        [ text model.message
        , Paper.input
            [ attribute "label" "Username" ]
            []
        , div
            []
            [ Paper.button
                [ attribute "raised" "raised"
                , style
                    [ ( "background", "#1E88E5" )
                    , ( "color", "white" )
                    ]
                ]
                [ text "Clicky" ]
            ]
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
