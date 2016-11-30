module App exposing (..)

import Html exposing (Html, text, div, node)
import Html.Attributes exposing (attribute, style)


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
    div
        []
        [ header model
        , body model
        ]


header : Model -> Html Msg
header model =
    node "app-header-layout"
        []
        [ node "app-header"
            [ attribute "reveals" ""
            ]
            [ node "app-toolbar"
                []
                [ div
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
