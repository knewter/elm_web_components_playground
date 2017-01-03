module Helpers exposing (isAuthenticated)

import Model exposing (Model)


isAuthenticated : Model -> Bool
isAuthenticated model =
    case model.users.currentUser of
        Nothing ->
            False

        Just currentUser ->
            currentUser.hasSubscription
