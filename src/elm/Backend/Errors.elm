module Backend.Errors exposing (..)
import Translations.Languages exposing (t, Language)
import Translations.Resources exposing (..)

import Json.Decode exposing (..)
import Http

type ErrorCode =
  MultipleFilesDropped | NetworkError | UnknownError |
  InvalidEncoding | InvalidInvoiceImage | GenerationError | ValidationError


errorCodeDecoder : Decoder ErrorCode
errorCodeDecoder =
    Json.Decode.string
        |> Json.Decode.andThen (\str ->
           case str of
               "MultipleFilesDropped" ->
                    Json.Decode.succeed MultipleFilesDropped
               "UnknownError" ->
                    Json.Decode.succeed UnknownError
               "InvalidEncoding" ->
                    Json.Decode.succeed InvalidEncoding
               "InvalidInvoiceImage" ->
                    Json.Decode.succeed InvalidInvoiceImage
               "GenerationError" ->
                    Json.Decode.succeed GenerationError
               "ValidationError" ->
                    Json.Decode.succeed ValidationError
               somethingElse ->
                    Json.Decode.fail <| "Unknown error code: " ++ somethingElse
        )

errorCodeString : ErrorCode -> Language -> String
errorCodeString error language =
  case error of
      MultipleFilesDropped -> t language RErrMultipleFilesDropped
      NetworkError -> t language RErrNetworkError
      UnknownError -> t language RErrUnknownError
      InvalidEncoding -> t language RErrInvalidEncoding
      InvalidInvoiceImage -> t language RErrInvalidInvoiceImage
      GenerationError -> t language RErrGenerationError
      ValidationError -> t language RErrValidationError


type ValidationErrorCode =
    DoesNotExist | IsEmpty | MustBeEmpty | MustBeEqualTo |
    LengthDifferent | LengthExceeded | LengthNotReached |
    MustBeDifferentThan | DoesNotStartWith |
    Invalid | FormatIsDifferentThan |
    QrReferenceInvalid | CreditorReferenceInvalid | NoReferenceInvalid |
    ValueExceeded | ValueNotReached |
    InvalidTags | UnknownTag | TagNotOrdered | TagAlreadyExists |
    SwiftFormat


validationErrorCodeDecoder : Decoder ValidationErrorCode
validationErrorCodeDecoder =
    Json.Decode.string
        |> Json.Decode.andThen (\str ->
           case str of
               "DoesNotExist" ->
                    Json.Decode.succeed DoesNotExist
               "IsEmpty" ->
                    Json.Decode.succeed IsEmpty
               "MustBeEmpty" ->
                    Json.Decode.succeed MustBeEmpty
               "MustBeEqualTo" ->
                    Json.Decode.succeed MustBeEqualTo
               "LengthDifferent" ->
                    Json.Decode.succeed LengthDifferent
               "LengthExceeded" ->
                    Json.Decode.succeed LengthExceeded
               "LengthNotReached" ->
                    Json.Decode.succeed LengthNotReached
               "MustBeDifferentThan" ->
                    Json.Decode.succeed MustBeDifferentThan
               "DoesNotStartWith" ->
                    Json.Decode.succeed DoesNotStartWith
               "Invalid" ->
                    Json.Decode.succeed Invalid
               "FormatIsDifferentThan" ->
                    Json.Decode.succeed FormatIsDifferentThan
               "QrReferenceInvalid" ->
                    Json.Decode.succeed QrReferenceInvalid
               "CreditorReferenceInvalid" ->
                    Json.Decode.succeed CreditorReferenceInvalid
               "NoReferenceInvalid" ->
                    Json.Decode.succeed NoReferenceInvalid
               "ValueExceeded" ->
                    Json.Decode.succeed ValueExceeded
               "ValueNotReached" ->
                    Json.Decode.succeed ValueNotReached
               "InvalidTags" ->
                    Json.Decode.succeed InvalidTags
               "UnknownTag" ->
                    Json.Decode.succeed UnknownTag
               "TagNotOrdered" ->
                    Json.Decode.succeed TagNotOrdered
               "TagAlreadyExists" ->
                    Json.Decode.succeed TagAlreadyExists
               "SwiftFormat" ->
                    Json.Decode.succeed SwiftFormat
               somethingElse ->
                    Json.Decode.fail <| "Unknown validation error code: " ++ somethingElse
        )

validationErrorCodeString : ValidationErrorCode -> String
validationErrorCodeString error =
  case error of
     DoesNotExist ->
          "le champ doit être saisi mais n'est pas présent"
     IsEmpty ->
          "le champ doit être saisi mais n'est pas présent"
     MustBeEmpty ->
          "le champ doit être vide"
     MustBeEqualTo ->
          "le champ ne peut prendre que les valeurs suivantes :"
     LengthDifferent ->
          "le champ doit avoir une longueur de"
     LengthExceeded ->
          "le champ ne peut pas avoir une longueur supérieure à"
     LengthNotReached ->
          "le champ ne peut pas avoir une longueur inferieure à"
     MustBeDifferentThan ->
          "le champ ne peut pas prendre les valeurs suivantes :"
     DoesNotStartWith ->
          "le champ doit commencer par"
     Invalid ->
          "le champ n'est pas valable"
     FormatIsDifferentThan ->
          "le format du champ doit être"
     QrReferenceInvalid ->
          "la référence QR (QRR) n'est pas valable"
     CreditorReferenceInvalid ->
          "la réference du créditeur (SCOR) n'est pas valable"
     NoReferenceInvalid ->
          "aucune réference ne doit être saisie pour le type NON"
     ValueExceeded ->
          "la valeur ne peut pas être plus grande que"
     ValueNotReached ->
          "la valeur ne peut pas être plus petite que"
     InvalidTags ->
          "erreur de formattage"
     UnknownTag ->
          "la balise Swico n'est pas reconnue :"
     TagNotOrdered ->
          "la balise Swico doit être plus grande que la précedente (les balises doivent être ordrées de façon croissante) :"
     TagAlreadyExists ->
          "la balise Swico existe déjà (une balise ne peut apparaître qu'une seule fois) :"
     SwiftFormat ->
          "le champ ne respecte pas l'encodage Swift"






httpErrorString : Http.Error -> String
httpErrorString error =
    case error of
        Http.BadUrl text ->
            "Bad Url: " ++ text
        Http.Timeout ->
            "Http Timeout"
        Http.NetworkError ->
            "Network Error"
        Http.BadStatus response ->
            "Bad Http Status: " ++ toString response.status.code
        Http.BadPayload message response ->
            "Bad Http Payload: "
                ++ toString message
                ++ " ("
                ++ toString response.status.code
                ++ ")"
