module Msg exposing (Msg(..))

import Navigation
import Routes exposing (Route)
import Date exposing (Date)


type Msg
    = Raise
    | Lower
    | UrlChange Navigation.Location
    | NewUrl Route
    | SetDate Date
