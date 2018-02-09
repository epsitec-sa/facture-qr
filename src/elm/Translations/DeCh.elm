module Translations.DeCh exposing (..)
import Translations.Resources exposing (..)


t : Resource -> String
t resource =
  case resource of
    RTitle -> "QR-Code Validator"
    RDropYourCode -> "Drop your code or your QR code here without fear."
    RWeWillValidateIt -> "We will validate it very carefully ;-)"

    RErrMultipleFilesDropped -> "more than one file has been dropped"
    RErrNetworkError -> "the request failed"
    RErrUnknownError -> "unknown error"
    RErrInvalidEncoding -> "file should be encoded with latin-1 but the following encoding was found :"
    RErrInvalidInvoiceImage -> "could not decode invoice image"
    RErrGenerationError -> "could not generate invoice image"
    RErrValidationError -> "could not validate invoice"
