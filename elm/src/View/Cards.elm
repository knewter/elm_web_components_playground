module View.Cards exposing (view)

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
import Model exposing (Model, UploadSignatureModel)
import Msg
    exposing
        ( Msg(Raise, Lower, NewUrl)
        , NewPhotoMsg
            ( SetNewPhoto
            , RequestUploadSignature
            )
        )
import Polymer.Paper as Paper
import Routes exposing (Route(Forms))
import Json.Decode as Decode
import FileReader as FR exposing (parseSelectedFiles)


view : Model -> Html Msg
view model =
    let
        placeholderImage =
            "http://lorempixel.com/420/230"

        newPhoto =
            model.newPhoto

        imageUrl =
            Maybe.withDefault placeholderImage newPhoto.dataUrl
    in
        div
            [ class "view-cards" ]
            [ Paper.card
                [ attribute "heading" "MegaSpoon"
                , attribute "image" imageUrl
                , attribute "elevation" (toString model.elevation)
                , attribute "animated" "true"
                ]
                [ div
                    [ class "card-content"
                    , style [ ( "position", "relative" ) ]
                    ]
                    [ Paper.fab
                        [ attribute "icon" "add"
                        , style [ ( "position", "absolute" ), ( "right", "16px" ), ( "top", "-32px" ) ]
                        ]
                        []
                    , p [] [ text "a lonely card" ]
                    , input
                        [ type_ "file"
                        , accept "image/*"
                        , attribute "capture" "camera"
                        , class "photo-input"
                        , onChangeFile
                        ]
                        []
                    ]
                , div
                    [ class "card-actions" ]
                    [ Paper.button
                        [ onClick <| Msg.NewPhoto RequestUploadSignature ]
                        [ text "Save" ]
                    , Paper.button [ onClick Lower ] [ text "Lower" ]
                    , Paper.button [ onClick Raise ] [ text "Raise" ]
                    ]
                ]
            , Paper.card
                [ attribute "elevation" "2" ]
                [ p [ class "card-content" ] [ text "Neat, what else do you have?" ]
                , div
                    [ class "card-actions" ]
                    [ Paper.button
                        [ onClick <| NewUrl Forms ]
                        [ text "Next" ]
                    ]
                ]
            ]


onChangeFile : Attribute Msg
onChangeFile =
    on "change"
        (Decode.map
            (Msg.NewPhoto << SetNewPhoto)
            parseSelectedFiles
        )
