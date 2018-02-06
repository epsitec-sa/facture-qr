module Components.Errors exposing (..)

import Json.Decode exposing (..)
import Http

type ErrorCode =
  None |
  MultipleFilesDropped | NetworkError | UnknownError |
  InvalidEncoding | InvalidInvoiceImage | GenerationError | ValidationError


errorCodeDecoder : Decoder ErrorCode
errorCodeDecoder =
    Json.Decode.string
        |> Json.Decode.andThen (\str ->
           case str of
               "None" ->
                    Json.Decode.succeed None
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

errorCodeString : ErrorCode -> String
errorCodeString error =
  case error of
      None ->
           ""
      MultipleFilesDropped ->
           "more than one file has been dropped"
      NetworkError ->
            "the request failed"
      UnknownError ->
           "unknown error"
      InvalidEncoding ->
           "file should be encoded with latin-1 but the following encoding was found :"
      InvalidInvoiceImage ->
           "could not decode invoice image"
      GenerationError ->
           "could not generate invoice image"
      ValidationError ->
           "could not validate invoice"


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
