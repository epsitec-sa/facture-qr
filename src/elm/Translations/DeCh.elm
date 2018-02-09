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

    RValErrDoesNotExist -> "**le champ doit être saisi mais n'est pas présent"
    RValErrIsEmpty -> "**le champ doit être saisi mais n'est pas présent"
    RValErrMustBeEmpty -> "**le champ doit être vide"
    RValErrMustBeEqualTo -> "**le champ ne peut prendre que les valeurs suivantes :"
    RValErrLengthDifferent -> "**le champ doit avoir une longueur de"
    RValErrLengthExceeded -> "**le champ ne peut pas avoir une longueur supérieure à"
    RValErrLengthNotReached -> "**le champ ne peut pas avoir une longueur inferieure à"
    RValErrMustBeDifferentThan -> "**le champ ne peut pas prendre les valeurs suivantes :"
    RValErrDoesNotStartWith -> "**le champ doit commencer par"
    RValErrInvalid -> "**le champ n'est pas valable"
    RValErrFormatIsDifferentThan -> "**le format du champ doit être"
    RValErrQrReferenceInvalid -> "**la référence QR (QRR) n'est pas valable"
    RValErrCreditorReferenceInvalid -> "**la réference du créditeur (SCOR) n'est pas valable"
    RValErrNoReferenceInvalid -> "**aucune réference ne doit être saisie pour le type NON"
    RValErrValueExceeded -> "**la valeur ne peut pas être plus grande que"
    RValErrValueNotReached -> "**la valeur ne peut pas être plus petite que"
    RValErrInvalidTags -> "**erreur de formattage"
    RValErrUnknownTag -> "**la balise Swico n'est pas reconnue :"
    RValErrTagNotOrdered -> "**la balise Swico doit être plus grande que la précedente (les balises doivent être ordrées de façon croissante) :"
    RValErrTagAlreadyExists -> "**la balise Swico existe déjà (une balise ne peut apparaître qu'une seule fois) :"
    RValErrSwiftFormat -> "**le champ ne respecte pas l'encodage Swift"
    
