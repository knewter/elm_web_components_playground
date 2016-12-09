module View.DatePicker exposing (view)

import Html exposing (Html, node)
import Html.Attributes exposing (attribute, class)
import Html.Events exposing (on)
import Polymer.Paper as Paper
import Msg exposing (Msg)
import Model exposing (Model)
import Date exposing (Date)
import Date.Extra
import Json.Decode as Decode
import Msg exposing (Msg(SetDate))
import String


view : Model -> Html Msg
view model =
    Paper.card
        [ attribute "heading" "Date picker"
        , attribute "elevation" "2"
        , class "view-date-picker"
        ]
        [ node "paper-date-picker"
            [ model.date
                |> Date.Extra.toUtcFormattedString "YYYY-MM-dd"
                |> attribute "date"
            , on "date-changed" logDate
            , class "card-content"
            ]
            []
        ]


logDate : Decode.Decoder Msg
logDate =
    Decode.at [ "detail", "value" ] Decode.value
        |> Decode.map
            (\x ->
                (toString x)
                    |> String.dropLeft 1
                    |> String.dropRight 1
                    |> Date.Extra.fromIsoString
                    |> Maybe.withDefault (Date.fromTime 0)
                    |> SetDate
            )
