module S3 exposing (uploadFile)

import Msg exposing (Msg(NewPhoto, NoOp), NewPhotoMsg(..))
import Model exposing (UploadSignatureModel)
import Http exposing (post, multipartBody, stringPart, send)
import FileReader as FR
import Json.Decode as Decode


uploadFile : UploadSignatureModel -> FR.NativeFile -> Cmd Msg
uploadFile uploadSignature nativeFile =
    post uploadSignature.action
        (makeMultiPart uploadSignature nativeFile)
        (Decode.succeed
            "works"
        )
        |> send (always NoOp)


makeMultiPart : UploadSignatureModel -> FR.NativeFile -> Http.Body
makeMultiPart uploadSignature nativeFile =
    multipartBody
        [ stringPart "key" uploadSignature.key
        , stringPart "AWSAccessKeyId" uploadSignature.aws_access_key_id
        , stringPart "acl" uploadSignature.acl
        , stringPart "success_action_status" "201"
        , stringPart "policy" uploadSignature.policy
        , stringPart "signature" uploadSignature.signature
        , stringPart "Content-Type" uploadSignature.content_type
        , FR.filePart "file" nativeFile
        ]
