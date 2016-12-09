module Model exposing (Model)

import Routes exposing (Route(..))
import Date exposing (Date)


type alias Model =
    { history : List (Maybe Route)
    , elevation : Int
    , date : Date
    }
