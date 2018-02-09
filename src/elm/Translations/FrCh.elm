module Translations.FrCh exposing (..)
import Translations.Resources exposing (..)


t : Resource -> String
t resource =
  case resource of
    RTitle -> "Validateur de QR-code"
    RDropYourCode -> "Veuillez draguer votre QR-code sans peur."
    RWeWillValidateIt -> "On va s'en charger ;-)"
    RTabValidation -> "Validation"
    RTabImage -> "Image générée"

    RErrMultipleFilesDropped -> "un seul fichier peut être droppé à la fois"
    RErrNetworkError -> "la requête a échoué"
    RErrUnknownError -> "erreur inconnue"
    RErrInvalidEncoding -> "le fichier doit être encodé avec du Latin-1 mais l'encodage suivant a été détecté :"
    RErrInvalidInvoiceImage -> "impossible de decoder l'image"
    RErrGenerationError -> "impossible de générer l'image de facture qr"
    RErrValidationError -> "impossible de valider la facture qr"

    RValErrDoesNotExist -> "le champ doit être saisi mais n'est pas présent"
    RValErrIsEmpty -> "le champ doit être saisi mais n'est pas présent"
    RValErrMustBeEmpty -> "le champ doit être vide"
    RValErrMustBeEqualTo -> "le champ ne peut prendre que les valeurs suivantes :"
    RValErrLengthDifferent -> "le champ doit avoir une longueur de"
    RValErrLengthExceeded -> "le champ ne peut pas avoir une longueur supérieure à"
    RValErrLengthNotReached -> "le champ ne peut pas avoir une longueur inferieure à"
    RValErrMustBeDifferentThan -> "le champ ne peut pas prendre les valeurs suivantes :"
    RValErrDoesNotStartWith -> "le champ doit commencer par"
    RValErrInvalid -> "le champ n'est pas valable"
    RValErrFormatIsDifferentThan -> "le format du champ doit être"
    RValErrQrReferenceInvalid -> "la référence QR (QRR) n'est pas valable"
    RValErrCreditorReferenceInvalid -> "la réference du créditeur (SCOR) n'est pas valable"
    RValErrNoReferenceInvalid -> "aucune réference ne doit être saisie pour le type NON"
    RValErrValueExceeded -> "la valeur ne peut pas être plus grande que"
    RValErrValueNotReached -> "la valeur ne peut pas être plus petite que"
    RValErrInvalidTags -> "erreur de formattage"
    RValErrUnknownTag -> "la balise Swico n'est pas reconnue :"
    RValErrTagNotOrdered -> "la balise Swico doit être plus grande que la précedente (les balises doivent être ordrées de façon croissante) :"
    RValErrTagAlreadyExists -> "la balise Swico existe déjà (une balise ne peut apparaître qu'une seule fois) :"
    RValErrSwiftFormat -> "le champ ne respecte pas l'encodage Swift"
