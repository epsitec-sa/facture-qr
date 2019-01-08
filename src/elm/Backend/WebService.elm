module Backend.WebService exposing (..)
import Translations.Languages exposing (Language)

import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (..)
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
  raw : String,
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

type alias DefaultProcedure = {
  raw : String
}

type alias EBillProcedure = {
  raw : String,
  businessCaseDate : String,
  dueDate : String,
  referenceNumber : String,
  payableAmountCanBeModified : String,
  billerID : String,
  emailAddress : String,
  billRecipientID : String
}

type AlternativeProcedurePayload
  = Default DefaultProcedure
  | EBill EBillProcedure


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

type alias AlternativeProcedure = {
  error: Maybe Error,
  payload: Maybe AlternativeProcedurePayload
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
  alternativeProcedure1: AlternativeProcedure,
  alternativeProcedure2: AlternativeProcedure,
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
    alternativeProcedure1 = {
      error = Nothing,
      payload = Nothing
    },
    alternativeProcedure2 = {
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



setAlternativeProcedureErr : AlternativeProcedure -> Error -> AlternativeProcedure
setAlternativeProcedureErr altProc err =
  { altProc | error = Just (err) }

setAlternativeProcedurePayloadValue : AlternativeProcedure -> AlternativeProcedurePayload -> AlternativeProcedure
setAlternativeProcedurePayloadValue altProc payload =
  { altProc | payload = Just (payload) }


setAlternativeProcedurePayload : Int -> Model -> AlternativeProcedurePayload -> Model
setAlternativeProcedurePayload index model payload =
  case index of
    1 ->
      { model | alternativeProcedure1 = setAlternativeProcedurePayloadValue model.alternativeProcedure1 payload }
    2 ->
      { model | alternativeProcedure2 = setAlternativeProcedurePayloadValue model.alternativeProcedure2 payload }
    somethingElse ->
      { model | alternativeProcedure1 = setAlternativeProcedurePayloadValue model.alternativeProcedure1 payload }
  

setAlternativeProcedureError : Int -> Model -> Error -> Model
setAlternativeProcedureError index model err =
  case index of
    1 ->
      { model | alternativeProcedure1 = setAlternativeProcedureErr model.alternativeProcedure1 err }
    2 ->
      { model | alternativeProcedure2 = setAlternativeProcedureErr model.alternativeProcedure2 err }
    somethingElse ->
      { model | alternativeProcedure1 = setAlternativeProcedureErr model.alternativeProcedure1 err }




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
    |> optional "Raw" string ""
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


decodeAlternativeProcedurePayload: String -> Result String (AlternativeProcedurePayload)
decodeAlternativeProcedurePayload str =
  decodeString (alternativeProcedurePayloadDecoder) str


alternativeProcedurePayloadDecoder : Json.Decode.Decoder AlternativeProcedurePayload
alternativeProcedurePayloadDecoder =
  Json.Decode.field "Type" Json.Decode.string
    |> Json.Decode.andThen (\str ->
      case str of
        "default" -> defaultProcedureDecoder
        "eBill" -> eBillProcedureDecoder
        somethingElse ->
          Json.Decode.fail <| "Unsupported procedure type: " ++ somethingElse)


defaultProcedureDecoder : Json.Decode.Decoder AlternativeProcedurePayload
defaultProcedureDecoder =
  map Default <| 
    (decode DefaultProcedure
      |> optional "Raw" string "")

eBillProcedureDecoder : Json.Decode.Decoder AlternativeProcedurePayload
eBillProcedureDecoder =
  map EBill <|
    (decode EBillProcedure
      |> optional "Raw" string ""
      |> optional "BusinessCaseDate" string ""
      |> optional "DueDate" string ""
      |> optional "ReferenceNumber" string ""
      |> optional "PayableAmountCanBeModified" string "False"
      |> optional "BillerID" string ""
      |> optional "EmailAddress" string ""
      |> optional "BillRecipientID" string "")


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
