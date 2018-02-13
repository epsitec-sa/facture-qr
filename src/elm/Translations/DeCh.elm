module Translations.DeCh exposing (..)
import Translations.Resources exposing (..)


t : Resource -> String
t resource =
  case resource of
    RTitle -> "Swico QR-Code Validator"
    RDropYourCode -> "Siehen Sie die Datei hierhin"
    RTabValidation -> "Validation"
    RTabImage -> "Erzeugtes Bild"
    RWaiting -> "Einen Augenblick..."
    RLine -> "Zeile"
    RField -> "Feld"

    RErrMultipleFilesDropped -> "es kann nur eine Datei auf einmal verarbeitet werden"
    RErrNetworkError -> "die Anfrage ist fehlgeschlagen (siehe js logs für mehr Details)"
    RErrUnknownError -> "ein unbekannter Fehler ist aufgetreten (siehe js logs für mehr Details)"
    RErrInvalidEncoding -> "der QR-Code muss mit dem Latin-1 Zeichensatz kodiert sein aber es wurde folgender Zeichensatz entdeckt:"
    RErrInvalidInvoiceImage -> "die Bilddatei konnte nicht dekodiert werden (siehe js logs für mehr Details)"
    RErrGenerationError -> "die Rechnungsbilddatei konnte nicht erzeugt werden (siehe js logs für mehr Details)"
    RErrValidationError -> "die QR-Rechnung konnte nicht validiert werden (siehe js logs für mehr Details)"

    RValErrDoesNotExist -> "das obligatorische Feld darf nicht leer sein"
    RValErrIsEmpty -> "das obligatorische Feld darf nicht leer sein"
    RValErrMustBeEmpty -> "das Feld muss leer sein"
    RValErrMustBeEqualTo -> "es dürfen nur folgende Werte im Feld stehen:"
    RValErrLengthDifferent -> "das Feld muss genau folgende Länge haben:"
    RValErrLengthExceeded -> "das Feld ist zu lang, die maximale Länge beträgt"
    RValErrLengthNotReached -> "das Feld ist zu kurz, die minimale Länge beträgt"
    RValErrMustBeDifferentThan -> "das Feld darf folgende Werte nicht enthalten:"
    RValErrDoesNotStartWith -> "das Feld muss mit folgender Zeichenkette beginnen:"
    RValErrInvalid -> "das Feld ist inkorrekt"
    RValErrFormatIsDifferentThan -> "das Feld muss folgendes Format respektieren:"
    RValErrQrReferenceInvalid -> "die QR Referenznummer (QRR) ist nicht korrekt"
    RValErrCreditorReferenceInvalid -> "die Creditor Referenz (SCOR) ist nicht korrekt"
    RValErrNoReferenceInvalid -> "für den typ NON darf keine Referenz existieren"
    RValErrValueExceeded -> "der Wert darf nicht grösser sein als"
    RValErrValueNotReached -> "der Wert darf nicht kleiner sein als"
    RValErrInvalidTags -> "das Formet des Swico Feldes ist inkorrekt"
    RValErrUnknownTag -> "folgende Swico Etikette ist inkorrekt:"
    RValErrTagNotOrdered -> "der Swico Tag muss grösser als die vorhergehende sein (die Tags müssen in aufsteigender Reihenfolge erscheinen):"
    RValErrTagAlreadyExists -> "der Swico Tag existiert schon (eine Etikette darf nur einmal erscheinen):"
    RValErrTagIsEmpty -> "der obligatorische Swico Tag darf nicht leer sein"
    RValErrSwiftFormat -> "das Feld respektiert nicht die Swift Kodierung"
