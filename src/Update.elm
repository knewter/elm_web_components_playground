module Update exposing (update)

import Model exposing (Model)
import Msg exposing (Msg(..))
import Routes exposing (parseRoute)
import UrlParser as Url
import Navigation


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Raise ->
            ( { model | elevation = model.elevation + 1 }, Cmd.none )

        Lower ->
            ( { model | elevation = model.elevation - 1 }, Cmd.none )

        UrlChange location ->
            let
                newHistory =
                    Url.parseHash parseRoute location :: model.history
            in
                ( { model | history = newHistory }
                , Cmd.none
                )

        NewUrl route ->
            ( model
            , Navigation.newUrl <| "/#" ++ Routes.toString route
            )

        SetDate date ->
            ( { model | date = date }
            , Cmd.none
            )
