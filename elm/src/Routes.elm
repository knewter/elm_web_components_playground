module Routes exposing (Route(..), parseRoute, toString)

import UrlParser as Url exposing ((</>), (<?>), s, int, stringParam, top)


type Route
    = Home
    | Login
    | Logout
    | NewUser
    | Cards
    | Forms
    | DatePicker
    | Photos


parseRoute : Url.Parser (Route -> a) a
parseRoute =
    Url.oneOf
        [ Url.map Home top
        , Url.map Login (s "login")
        , Url.map Logout (s "logout")
        , Url.map Cards (s "cards")
        , Url.map Forms (s "forms")
        , Url.map NewUser (s "users" </> s "new")
        , Url.map DatePicker (s "date-picker")
        , Url.map Photos (s "photos")
        ]


toString : Route -> String
toString route =
    case route of
        Home ->
            ""

        Login ->
            "login"

        Logout ->
            "logout"

        NewUser ->
            "users/new"

        Cards ->
            "cards"

        Forms ->
            "forms"

        DatePicker ->
            "date-picker"

        Photos ->
            "photos"
