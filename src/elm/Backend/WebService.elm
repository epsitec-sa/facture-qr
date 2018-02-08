module Backend.WebService exposing (..)

import Json.Decode exposing (int, string, float, list, Decoder, decodeString)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)
import Backend.Errors exposing (..)
import Debug


type alias Error = {
  errorCode: Backend.Errors.ErrorCode,
  additionalInformation: String,
  message: String,
  stackTrace: String
}

type alias ValidationError = {
  xmlField : String,
  code : Backend.Errors.ValidationErrorCode,
  line : Int,
  column : Int,
  length : Int,
  message : String,
  additionalInfo : String
}

type alias Decoding = {
  error: Maybe Error,
  raw: Maybe String
}

type alias Validation = {
  error: Maybe Error,
  validations: Maybe (List ValidationError)
}

type alias Generation = {
  error: Maybe Error,
  image: Maybe String
}

type alias Model = {
  error: Maybe Error,
  decoding: Decoding,
  validation: Validation,
  generation: Generation
}

init : Model
init = {
    error = Nothing,
    decoding = {
      error = Nothing,
      raw = Nothing
    },
    validation = {
      error = Nothing,
      validations = Nothing
    },
    generation = {
      error = Nothing,
      image = Nothing
    }
  }


setError : Model -> Error -> Model
setError model err =
  { model | error = Just (err) }

setNewError : Model -> Backend.Errors.ErrorCode -> Model
setNewError model errCode =
  setError model (newError errCode)



setDecodingErr : Decoding -> Error -> Decoding
setDecodingErr decoding err =
  { decoding | error = Just (err) }

setRawValue : Decoding -> String -> Decoding
setRawValue decoding raw =
  { decoding | raw = Just (raw) }

setRaw : Model -> String -> Model
setRaw model raw =
  { model | decoding = setRawValue model.decoding raw }

setDecodingError : Model -> Error -> Model
setDecodingError model err =
  { model | decoding = setDecodingErr model.decoding err }




setValidationsErr : Validation -> Error -> Validation
setValidationsErr validation err =
  { validation | error = Just (err) }

setValidationsValue : Validation -> List ValidationError -> Validation
setValidationsValue validation validations =
  { validation | validations = Just (validations) }

setValidations : Model -> List ValidationError -> Model
setValidations model validations =
  { model | validation = setValidationsValue model.validation validations }

setValidationsError : Model -> Error -> Model
setValidationsError model err =
  { model | validation = setValidationsErr model.validation err }



setGenerationErr : Generation -> Error -> Generation
setGenerationErr generation err =
  { generation | error = Just (err) }

setImageValue : Generation -> String -> Generation
setImageValue validation image =
  { validation | image = Just (image) }

setImage : Model -> String -> Model
setImage model image =
  { model | generation = setImageValue model.generation image }

setGenerationError : Model -> Error -> Model
setGenerationError model err =
  { model | generation = setGenerationErr model.generation err }



errorDecoder : Json.Decode.Decoder Error
errorDecoder =
  decode Error
    |> required "ErrorCode" Backend.Errors.errorCodeDecoder
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
    |> required "Code" Backend.Errors.validationErrorCodeDecoder
    |> required "Line" int
    |> required "Column" int
    |> required "Length" int
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
  Backend.Errors.errorCodeString (err.errorCode) ++ " " ++ err.additionalInformation


prettifyValidationError : ValidationError -> String
prettifyValidationError err =
  Backend.Errors.validationErrorCodeString (err.code) ++ " " ++
  err.additionalInfo

newError : Backend.Errors.ErrorCode -> Error
newError errorCode = {
    errorCode = errorCode,
    additionalInformation = "",
    message = "",
    stackTrace = ""
  }
