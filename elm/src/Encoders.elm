module Encoders
    exposing
        ( newUserEncoder
        , loginEncoder
        )

import Json.Encode as Encode
import Model exposing (NewUserModel, LoginModel)


newUserEncoder : NewUserModel -> Encode.Value
newUserEncoder newUser =
    Encode.object
        [ ( "user"
          , Encode.object
                [ ( "name", Encode.string newUser.name )
                , ( "email", Encode.string newUser.email )
                , ( "username", Encode.string newUser.email )
                , ( "password", Encode.string newUser.password )
                , ( "password_confirmation", Encode.string newUser.passwordConfirmation )
                ]
          )
        ]


loginEncoder : LoginModel -> Encode.Value
loginEncoder loginModel =
    Encode.object
        [ ( "email", Encode.string loginModel.username )
        , ( "password", Encode.string loginModel.password )
        ]
