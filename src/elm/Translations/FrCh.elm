module Translations.FrCh exposing (..)
import Translations.Resources exposing (..)


t : Resource -> String
t resource =
  case resource of
    RTitle -> "Validateur de QR-code"
    RDropYourCode -> "Veuillez draguer votre QR-code sans peur."
    RWeWillValidateIt -> "On va s'en charger ;-)"

    RErrMultipleFilesDropped -> "un seul fichier peut être droppé à la fois"
    RErrNetworkError -> "la requête a échoué"
    RErrUnknownError -> "erreur inconnue"
    RErrInvalidEncoding -> "le fichier doit être encodé avec du Latin-1 mais l'encodage suivant a été détecté :"
    RErrInvalidInvoiceImage -> "impossible de decoder l'image"
    RErrGenerationError -> "impossible de générer l'image de facture qr"
    RErrValidationError -> "impossible de valider la facture qr"
