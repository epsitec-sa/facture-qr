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

type alias Model = {
  error: Maybe Error,
  raw: Maybe String,
  validations: Maybe (List ValidationError),
  image: Maybe String
}

init : Model
init = {
    error = Nothing
    , raw = Nothing
    , validations = Nothing
    , image = Nothing
  }


setError : Model -> Error -> Model
setError model err =
  { model | error = Just (err) }

setNewError : Model -> Components.Errors.ErrorCode -> Model
setNewError model errCode =
  setError model (newError errCode)

setRaw : Model -> String -> Model
setRaw model raw =
  { model | raw = Just (raw) }

setValidations : Model -> List ValidationError -> Model
setValidations model validations =
  { model | validations = Just (validations) }

setImage : Model -> String -> Model
setImage model image =
  { model | image = Just (image) }





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

newError : Components.Errors.ErrorCode -> Error
newError errorCode = {
    errorCode = errorCode,
    additionalInformation = "",
    message = "",
    stackTrace = ""
  }
