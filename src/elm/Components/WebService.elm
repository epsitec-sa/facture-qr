module Components.WebService exposing (..)

import Json.Decode exposing (int, string, float, Decoder, decodeString)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)
import Components.Errors exposing (..)
import Debug

type alias Error = {
  errorCode: Components.Errors.ErrorCode,
  additionalInformation: String,
  message: String,
  stackTrace: String
}

errorDecoder : Json.Decode.Decoder Error
errorDecoder =
  decode Error
    |> required "ErrorCode" Components.Errors.errorCodeDecoder
    |> optional "AdditionalInformation" string ""
    |> required "Message" string
    |> optional "StackTrace" string ""

decodeError: String -> Result String Error
decodeError str =
  decodeString errorDecoder str


debug : Error -> Cmd msg
debug err =
  Debug.log (err.message)
  Cmd.none

prettify : Error -> String
prettify err =
  Components.Errors.errorCodeString (err.errorCode) ++ " " ++ err.additionalInformation

noError : Error
noError = {
    errorCode = Components.Errors.None,
    additionalInformation = "",
    message = "",
    stackTrace = ""
  }

newError : Components.Errors.ErrorCode -> Error
newError errorCode = {
    errorCode = errorCode,
    additionalInformation = "",
    message = "",
    stackTrace = ""
  }
