module View.Photos exposing (view)

import Html
    exposing
        ( Html
        , Attribute
        , text
        , div
        , node
        , h2
        , p
        , input
        )
import Html.Attributes
    exposing
        ( attribute
        , style
        , class
        , type_
        , accept
        )
import Html.Events exposing (onClick, on)
import Model exposing (Model, NewPhotoModel)
import Msg exposing (Msg)
import Polymer.Paper as Paper
import Json.Decode as Decode
import FileReader as FR exposing (parseSelectedFiles)
import Dict


view : Model -> Html Msg
view model =
    let
        photoViews =
            model.photos
                |> Dict.toList
                |> List.map (viewPhoto << Tuple.second)
    in
        div
            [ class "view-cards" ]
        <|
            photoViews
                ++ [ filePicker
                   , uploadButton
                   ]


uploadButton : Html Msg
uploadButton =
    Paper.button
        [ onClick <| Msg.Photos Msg.RequestPhotoUploadSignatures ]
        [ text "Upload" ]


filePicker : Html Msg
filePicker =
    input
        [ type_ "file"
        , attribute "multiple" "multiple"
        , accept "image/*"
        , class "photo-input"
        , onChangeFile
        ]
        []


viewPhoto : NewPhotoModel -> Html Msg
viewPhoto newPhoto =
    Paper.card
        [ attribute "heading" ""
        , attribute "image" (Maybe.withDefault "" newPhoto.dataUrl)
        , attribute "elevation" "2"
        ]
        [ div
            [ class "card-content" ]
            [ p [] [ text "a lonely card" ]
            ]
        ]


onChangeFile : Attribute Msg
onChangeFile =
    on "change"
        (Decode.map
            (Msg.Photos << Msg.SetPhotos)
            parseSelectedFiles
        )
