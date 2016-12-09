module View.DatePicker exposing (view)

import Html exposing (Html, node, div, p, text)
import Html.Attributes exposing (attribute, class)
import Html.Events exposing (on, onClick)
import Polymer.Paper as Paper
import Msg exposing (Msg)
import Model exposing (Model)
import Date exposing (Date)
import Date.Extra
import Json.Decode as Decode
import Msg exposing (Msg(SetDate, NewUrl))
import String
import Routes exposing (Route(Home))


view : Model -> Html Msg
view model =
    div
        [ class "view-date-picker" ]
        [ Paper.card
            [ attribute "heading" "Date picker"
            , attribute "elevation" "2"
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
        , Paper.card
            [ attribute "elevation" "2" ]
            [ p
                [ class "card-content" ]
                [ text "That's everything, go back home!" ]
            , div
                [ class "card-actions" ]
                [ Paper.button
                    [ onClick <| NewUrl Home ]
                    [ text "Home" ]
                ]
            ]
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
