module Translations.FrCh exposing (..)
import Translations.Resources exposing (..)


t : Resource -> String
t resource =
  case resource of
    RTitle -> "Validateur de facture QR avec format Swico"
    RDropYourCode -> "Glissez le fichier à analyser ici"
    RTabValidation -> "Validation"
    RTabSwicoLine -> "Ligne Swico"
    RTabImage -> "Image générée"
    RWaiting -> "En attente..."
    RLine -> "Ligne"
    RField -> "champ"

    RErrMultipleFilesDropped -> "Un seul fichier peut être traité à la fois"
    RErrNetworkError -> "La requête a échoué (voir log js pour plus de détails)"
    RErrUnknownError -> "Erreur inconnue (voir log js pour plus de détails)"
    RErrInvalidEncoding -> "Le QR-code doit être encodé avec du Latin-1 mais l'encodage suivant a été détecté :"
    RErrInvalidInvoiceImage -> "Impossible de decoder l'image (voir log js pour plus de détails)"
    RErrGenerationError -> "Impossible de générer l'image de la facture (voir log js pour plus de détails)"
    RErrValidationError -> "Impossible de valider la facture QR (voir log js pour plus de détails)"

    RValErrDoesNotExist -> "le champ est obligatoire et ne peut pas être vide"
    RValErrIsEmpty -> "le champ est obligatoire et ne peut pas être vide"
    RValErrMustBeEmpty -> "le champ doit être vide"
    RValErrMustBeEqualTo -> "le champ ne peut prendre que la(les) valeur(s) suivante(s) :"
    RValErrLengthDifferent -> "le champ doit avoir une longueur exacte de"
    RValErrLengthExceeded -> "le champ ne peut pas avoir une longueur supérieure à"
    RValErrLengthNotReached -> "le champ ne peut pas avoir une longueur inferieure à"
    RValErrMustBeDifferentThan -> "le champ ne peut pas prendre les valeurs suivantes :"
    RValErrDoesNotStartWith -> "le champ doit commencer par"
    RValErrInvalid -> "le champ n'est pas valable"
    RValErrFormatIsDifferentThan -> "le format du champ doit être"
    RValErrQrReferenceInvalid -> "la référence QR (QRR) n'est pas valable"
    RValErrCreditorReferenceInvalid -> "la réference du créditeur (SCOR) n'est pas valable"
    RValErrNoReferenceInvalid -> "aucune réference ne doit être saisie pour le type NON"
    RValErrNoReferenceWithQrIban -> "le type NON n'est pas valable avec un QR-Iban"
    RValErrValueExceeded -> "la valeur ne peut pas être plus grande que"
    RValErrValueNotReached -> "la valeur ne peut pas être plus petite que"
    RValErrInvalidTags -> "le champ Swico n'est pas formatté correctement"
    RValErrUnknownTag -> "la balise Swico n'est pas reconnue :"
    RValErrTagNotOrdered -> "la balise Swico doit être plus grande que la précedente (les balises doivent être ordrées de façon croissante) :"
    RValErrTagAlreadyExists -> "la balise Swico existe déjà (une balise ne peut apparaître qu'une seule fois) :"
    RValErrTagIsEmpty -> "la balise Swico est obligatoire et ne peut pas être vide"
    RValErrSwiftFormat -> "le champ ne respecte pas l'encodage Swift"
