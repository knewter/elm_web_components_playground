module Msg exposing (Msg(..))

import Navigation
import Routes exposing (Route)


type Msg
    = Raise
    | Lower
    | UrlChange Navigation.Location
    | NewUrl Route
