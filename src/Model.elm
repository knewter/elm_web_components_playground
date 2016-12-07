module Model exposing (Model)

import Routes exposing (Route(..))


type alias Model =
    { history : List (Maybe Route)
    , elevation : Int
    }
