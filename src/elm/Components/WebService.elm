module Components.WebService exposing (..)

import Json.Decode exposing (int, string, float, list, Decoder, decodeString)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)
import Components.Errors exposing (..)
import Debug

type alias Error = {
  errorCode: Components.Errors.ErrorCode,
  additionalInformation: String,
  message: String,
  stackTrace: String
}

type alias ValidationError = {
  xmlField : String,
  code : Components.Errors.ValidationErrorCode,
  line : Int,
  column : Int,
  message : String,
  additionalInfo : String
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



validationErrorDecoder : Json.Decode.Decoder ValidationError
validationErrorDecoder =
  decode ValidationError
    |> required "XmlField" string
    |> required "Code" Components.Errors.validationErrorCodeDecoder
    |> required "Line" int
    |> required "Column" int
    |> optional "Message" string ""
    |> optional "AdditionalInfo" string ""


decodeValidationErrors: String -> Result String (List ValidationError)
decodeValidationErrors str =
  decodeString (list validationErrorDecoder) str




debug : Error -> Cmd msg
debug err =
  Debug.log (err.message)
  Cmd.none

prettifyError : Error -> String
prettifyError err =
  Components.Errors.errorCodeString (err.errorCode) ++ " " ++ err.additionalInformation


prettifyValidationError : ValidationError -> String
prettifyValidationError err =
  err.xmlField ++ ":  " ++
  Components.Errors.validationErrorCodeString (err.code) ++ " " ++
  err.additionalInfo


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
