module View.Signup.CreateUser exposing (view)

import Polymer.Paper as Paper
import Html exposing (Html, Attribute, div, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Msg exposing (Msg(Users), UsersMsg(NewUser), NewUserMsg(..))
import Model exposing (Model)


view : Model -> Html Msg
view model =
    let
        newUser =
            model.users.newUser
    in
        Paper.card
            [ class "view-signup-create-user"
            , attribute "heading" "Create your account"
            , attribute "elevation" "2"
            ]
            [ div
                [ class "card-content" ]
                [ Paper.input
                    [ attribute "label" "Name"
                    , attribute "required" ""
                    , attribute "auto-validate" ""
                    , attribute "error-message" "This field is required!"
                    , value newUser.name
                    , onInput (\x -> Users <| NewUser <| SetNewUserName x)
                    ]
                    []
                , Paper.input
                    [ attribute "label" "Email"
                    , attribute "required" ""
                    , attribute "auto-validate" ""
                    , attribute "error-message" "This field is required!"
                    , value newUser.email
                    , onInput (\x -> Users <| NewUser <| SetNewUserEmail x)
                    ]
                    []
                , Paper.input
                    [ attribute "label" "Password"
                    , attribute "required" ""
                    , attribute "auto-validate" ""
                    , attribute "error-message" "This field is required!"
                    , type_ "password"
                    , value newUser.password
                    , onInput (\x -> Users <| NewUser <| SetNewUserPassword x)
                    ]
                    []
                , Paper.input
                    [ attribute "label" "Password Confirmation"
                    , attribute "required" ""
                    , attribute "auto-validate" ""
                    , attribute "error-message" "This field is required!"
                    , type_ "password"
                    , value newUser.passwordConfirmation
                    , onInput
                        (\x ->
                            Users <|
                                NewUser <|
                                    SetNewUserPasswordConfirmation x
                        )
                    ]
                    []
                ]
            , div
                [ class "card-actions" ]
                [ Paper.button
                    [ onClick <| Users <| NewUser <| CreateNewUser
                    ]
                    [ text "Sign Up" ]
                ]
            ]
