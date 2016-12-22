module Routes exposing (Route(..), parseRoute, toString)

import UrlParser as Url exposing ((</>), (<?>), s, int, stringParam, top)


type Route
    = Home
    | Login
    | Cards
    | Forms
    | DatePicker


parseRoute : Url.Parser (Route -> a) a
parseRoute =
    Url.oneOf
        [ Url.map Home top
        , Url.map Login (s "login")
        , Url.map Cards (s "cards")
        , Url.map Forms (s "forms")
        , Url.map DatePicker (s "date-picker")
        ]


toString : Route -> String
toString route =
    case route of
        Home ->
            ""

        Login ->
            "login"

        Cards ->
            "cards"

        Forms ->
            "forms"

        DatePicker ->
            "date-picker"
