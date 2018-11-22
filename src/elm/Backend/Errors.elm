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
    DoesExist | DoesNotExist | IsEmpty | MustBeEmpty | MustBeEqualTo |
    LengthDifferent | LengthExceeded | LengthNotReached |
    MustBeDifferentThan | DoesNotStartWith |
    Invalid | FormatIsDifferentThan |
    QrReferenceInvalid | CreditorReferenceInvalid | NoReferenceInvalid | NoReferenceWithQrIban |
    ValueExceeded | ValueNotReached |
    InvalidTags | UnknownTag | TagNotOrdered | TagAlreadyExists | TagIsEmpty |
    SwiftFormat | VatAmountMissmatch | ZeroConditionMissing


validationErrorCodeDecoder : Decoder ValidationErrorCode
validationErrorCodeDecoder =
    Json.Decode.string
        |> Json.Decode.andThen (\str ->
           case str of
               "DoesExist" ->
                    Json.Decode.succeed DoesExist
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
               "NoReferenceWithQrIban" ->
                    Json.Decode.succeed NoReferenceWithQrIban
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
               "TagIsEmpty" ->
                    Json.Decode.succeed TagIsEmpty
               "SwiftFormat" ->
                    Json.Decode.succeed SwiftFormat
               "VatAmountMissmatch" ->
                    Json.Decode.succeed VatAmountMissmatch
               "ZeroConditionMissing" ->
                    Json.Decode.succeed ZeroConditionMissing
               somethingElse ->
                    Json.Decode.fail <| "Unknown validation error code: " ++ somethingElse
        )

validationErrorCodeString : ValidationErrorCode -> Language -> String
validationErrorCodeString error language =
  case error of
     DoesExist -> t language RValErrDoesExist
     DoesNotExist -> t language RValErrDoesNotExist
     IsEmpty -> t language RValErrIsEmpty
     MustBeEmpty -> t language RValErrMustBeEmpty
     MustBeEqualTo -> t language RValErrMustBeEqualTo
     LengthDifferent -> t language RValErrLengthDifferent
     LengthExceeded -> t language RValErrLengthExceeded
     LengthNotReached -> t language RValErrLengthNotReached
     MustBeDifferentThan -> t language RValErrMustBeDifferentThan
     DoesNotStartWith -> t language RValErrDoesNotStartWith
     Invalid -> t language RValErrInvalid
     FormatIsDifferentThan -> t language RValErrFormatIsDifferentThan
     QrReferenceInvalid -> t language RValErrQrReferenceInvalid
     CreditorReferenceInvalid -> t language RValErrCreditorReferenceInvalid
     NoReferenceInvalid -> t language RValErrNoReferenceInvalid
     NoReferenceWithQrIban -> t language RValErrNoReferenceWithQrIban
     ValueExceeded -> t language RValErrValueExceeded
     ValueNotReached -> t language RValErrValueNotReached
     InvalidTags -> t language RValErrInvalidTags
     UnknownTag -> t language RValErrUnknownTag
     TagNotOrdered -> t language RValErrTagNotOrdered
     TagAlreadyExists -> t language RValErrTagAlreadyExists
     TagIsEmpty -> t language RValErrTagIsEmpty
     SwiftFormat -> t language RValErrSwiftFormat
     VatAmountMissmatch -> t language RValErrVatAmountMissmatch
     ZeroConditionMissing -> t language RValErrZeroConditionMissing






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
