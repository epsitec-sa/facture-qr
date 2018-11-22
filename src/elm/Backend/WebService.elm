module Backend.WebService exposing (..)
import Translations.Languages exposing (Language)

import Json.Decode exposing (int, string, float, list, bool, Decoder, decodeString)
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
  additionalInfo : String,
  warning : Bool
}

type alias SwicoPayload = {
  prefix : String,
  documentReference : String,
  documentDate : String,
  customerReference : String,
  vatNumber : String,
  vatDates : String,
  vatDetails : String,
  vatImportTaxes : String,
  conditions : String
}


type alias Decoding = {
  error: Maybe Error,
  raw: Maybe String
}

type alias Validation = {
  error: Maybe Error,
  validations: Maybe (List ValidationError)
}

type alias SwicoLine = {
  error: Maybe Error,
  payload: Maybe SwicoPayload
}

type alias Generation = {
  error: Maybe Error,
  image: Maybe String
}



type alias Model = {
  error: Maybe Error,
  decoding: Decoding,
  validation: Validation,
  swicoLine: SwicoLine,
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
    swicoLine = {
      error = Nothing,
      payload = Nothing
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



setSwicoLineErr : SwicoLine -> Error -> SwicoLine
setSwicoLineErr swicoLine err =
  { swicoLine | error = Just (err) }

setSwicoPayloadValue : SwicoLine -> SwicoPayload -> SwicoLine
setSwicoPayloadValue swicoLine payload =
  { swicoLine | payload = Just (payload) }

setSwicoPayload : Model -> SwicoPayload -> Model
setSwicoPayload model payload =
  { model | swicoLine = setSwicoPayloadValue model.swicoLine payload }

setSwicoLineError : Model -> Error -> Model
setSwicoLineError model err =
  { model | swicoLine = setSwicoLineErr model.swicoLine err }



setGenerationErr : Generation -> Error -> Generation
setGenerationErr generation err =
  { generation | error = Just (err) }

setImageValue : Generation -> String -> Generation
setImageValue generation image =
  { generation | image = Just (image) }

setNoImageValue : Generation -> Generation
setNoImageValue generation =
  { generation | image = Nothing }

setImage : Model -> String -> Model
setImage model image =
  { model | generation = setImageValue model.generation image }

setNoImage : Model -> Model
setNoImage model =
  { model | generation = setNoImageValue model.generation }

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
    |> optional "Warning" bool False


decodeValidationErrors: String -> Result String (List ValidationError)
decodeValidationErrors str =
  decodeString (list validationErrorDecoder) str



swicoPayloadDecoder : Json.Decode.Decoder SwicoPayload
swicoPayloadDecoder =
  decode SwicoPayload
    |> optional "Prefix" string ""
    |> optional "DocumentReference" string ""
    |> optional "DocumentDate" string ""
    |> optional "CustomerReference" string ""
    |> optional "VatNumber" string ""
    |> optional "VatDates" string ""
    |> optional "VatDetails" string ""
    |> optional "VatImportTaxes" string ""
    |> optional "Conditions" string ""


decodeSwicoPayload: String -> Result String (SwicoPayload)
decodeSwicoPayload str =
  decodeString (swicoPayloadDecoder) str



debug : Error -> Cmd msg
debug err =
  Debug.log (err.message)
  Cmd.none

prettifyError : Error -> Language -> String
prettifyError err language =
  (Backend.Errors.errorCodeString err.errorCode language) ++ " " ++ err.additionalInformation


prettifyValidationError : ValidationError -> Language -> String
prettifyValidationError err language =
  (Backend.Errors.validationErrorCodeString err.code language) ++ " " ++ err.additionalInfo

prettifyXmlField : String -> String
prettifyXmlField xmlField =
  case String.indexes ".Tag" xmlField of
    i::is -> String.left i xmlField
    [] -> xmlField


newError : Backend.Errors.ErrorCode -> Error
newError errorCode = {
    errorCode = errorCode,
    additionalInformation = "",
    message = "",
    stackTrace = ""
  }
