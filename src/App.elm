module App exposing (..)

import Html exposing (Html, text, div, node)
import Html.Attributes exposing (attribute, style)
import WebComponents.App exposing (appDrawer, appDrawerLayout, appToolbar, appHeader, appHeaderLayout)


type alias Model =
    { message : String
    }


init : ( Model, Cmd Msg )
init =
    ( { message = "Your Elm App is working!" }, Cmd.none )


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


view : Model -> Html Msg
view model =
    appDrawerLayout
        []
        [ appDrawer
            []
            [ text "drawer content" ]
        , header model
        , body model
        ]


header : Model -> Html Msg
header model =
    appHeaderLayout
        []
        [ appHeader
            [ attribute "reveals" ""
            ]
            [ appToolbar
                []
                [ node "paper-icon-button"
                    [ attribute "icon" "menu"
                    , attribute "drawer-toggle" ""
                    ]
                    []
                , div
                    [ attribute "main-title" "" ]
                    [ text "Thousands of Spoons" ]
                ]
            ]
        ]


body : Model -> Html Msg
body model =
    div
        [ style
            [ ( "min-height", "2000px" )
            ]
        ]
        [ text model.message
        , node "paper-input"
            [ attribute "label" "Username" ]
            []
        , div
            []
            [ node "paper-button"
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
