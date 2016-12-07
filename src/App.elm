module App exposing (..)

import Html exposing (Html, text, div, node)
import Html.Attributes exposing (attribute, style, class)
import Html.Events exposing (onClick)
import WebComponents.App exposing (appDrawer, appDrawerLayout, appToolbar, appHeader, appHeaderLayout)
import WebComponents.Paper exposing (input, button, iconButton, paperMenu, paperItem, paperCard, paperFab)


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
    appDrawerLayout
        []
        [ appDrawer
            []
            [ paperMenu []
                (List.map (\x -> paperItem [] [ text x ]) [ "One", "Two", "Three", "Four" ])
            ]
        , header model
        , creditCardForm model
        ]


creditCardForm : Model -> Html Msg
creditCardForm model =
    node "paper-card"
        [ style
            [ ( "padding", "1em" )
            , ( "width", "50%" )
            , ( "margin", "1em" )
            ]
        , attribute "heading" "Billing Information"
        , attribute "elevation" "2"
        ]
        [ div [ class "card-content" ]
            [ input
                [ attribute "label" "Name"
                , attribute "required" ""
                , attribute "auto-validate" ""
                , attribute "error-message" "I need a name"
                ]
                []
            , node "gold-cc-input"
                [ attribute "label" "Credit Card Number"
                , attribute "required" ""
                , attribute "auto-validate" "true"
                , attribute "error-message" "This is not a valid credit card number"
                ]
                []
            , node "gold-cvc-input"
                [ attribute "label" "CVC"
                , attribute "required" ""
                , attribute "auto-validate" ""
                , attribute "error-message" "CVC is required"
                ]
                []
            , node "gold-cc-expiration-input"
                [ attribute "label" "Expiration"
                , attribute "required" ""
                , attribute "auto-validate" ""
                , attribute "error-message" "Expiration dates are important"
                ]
                []
            , node "gold-zip-input"
                [ attribute "label" "Zip Code"
                , attribute "required" ""
                , attribute "auto-validate" ""
                , attribute "error-message" "Please enter a valid zip code"
                ]
                []
            ]
        , div [ class "card-actions" ]
            [ button
                []
                [ text "Submit" ]
            ]
        ]


card : Model -> Html Msg
card model =
    paperCard
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
            [ paperFab
                [ attribute "icon" "add"
                , style [ ( "position", "absolute" ), ( "right", "16px" ), ( "top", "-32px" ) ]
                ]
                []
            , text "a lonely card"
            ]
        , div
            [ class "card-actions" ]
            [ button [ onClick Lower ] [ text "Lower" ]
            , button [ onClick Raise ] [ text "Raise" ]
            ]
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
        , input
            [ attribute "label" "Username" ]
            []
        , div
            []
            [ button
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
