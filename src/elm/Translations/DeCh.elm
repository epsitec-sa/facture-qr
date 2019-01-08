module Translations.DeCh exposing (t)

import Translations.Resources exposing (..)


t : Resource -> String
t resource =
    case resource of
        RTitle ->
            "Validator für QR-Rechnung und strukturierte Rechnungsinformationen"

        RDropYourCode ->
            "Ziehen Sie die Datei (Bild oder Text) hierhin"

        RTabValidation ->
            "Dateninhalt"

        RTabSwicoLine ->
            "Rechnungsinformationen"

        RTabImage ->
            "Zahlteil ansehen"

        RTabAlternativeProcedures -> 
            "**Procédures alternatives"

        RWaiting ->
            "Einen Augenblick..."

        RLine ->
            "Zeile"

        RField ->
            "Feld"

        RRaw ->
            "Rohzeile:"

        RPrefix ->
            "Präfix"

        RDocumentReference ->
            "Rechnungsnummer"

        RDocumentDate ->
            "Belegdatum"

        RCustomerReference ->
            "Kundenreferenz"

        RVatNumber ->
            "UID Nummer"

        RVatDates ->
            "Datum der Leistung"

        RVatDetails ->
            "Sätze für die Rechnung"

        RVatImportTax ->
            "Reine MWST bei der Einfuhr"

        RConditions ->
            "Liste des Konditionen"

        RDiscount ->
            "Skonto auf"

        RTotalBill ->
            "für den gesamten Betrag"

        RImport ->
            " reine MWST bei einem Warenimport"

        RDays ->
            "Tage"

        ROn ->
            "auf"

        RFrom ->
            "von"

        RTo ->
            "bis zum"

        RAlternativeProcedure -> 
            "**Procédure alternative"

        RBusinessCaseDate -> 
            "**Date de l'opération bancaire ou date de la facture"

        RDueDate -> 
            "**Date d'échéance"

        RReferenceNumber -> 
            "**Référence de facturation ou numéro de facture"

        RPayableAmountCanBeModified -> 
            "**Montant modifiable"

        RBillerID -> 
            "**Identification de l'émetteur de la facture"

        REmailAddress -> 
            "**Adresse e-mail du destinataire de la facture"

        RBillRecipientID -> 
            "**Identification alternative du destinataire de la facture"

        RReferencedBill -> 
            "**Identification de la facture originale"

        RYes -> 
            "Ja"

        RNo -> 
            "Nein"

        RErrMultipleFilesDropped ->
            "Es kann nur eine Datei auf einmal verarbeitet werden"

        RErrNetworkError ->
            "Die Anfrage ist fehlgeschlagen (siehe js logs für mehr Details)"

        RErrUnknownError ->
            "Ein unbekannter Fehler ist aufgetreten (siehe js logs für mehr Details)"

        RErrInvalidEncoding ->
            "Der QR-Code muss mit dem UTF-8 Zeichensatz kodiert sein aber es wurde folgender Zeichensatz entdeckt:"

        RErrInvalidInvoiceImage ->
            "Die Bilddatei konnte nicht dekodiert werden (siehe js logs für mehr Details)"

        RErrGenerationError ->
            "Die Rechnungsbilddatei konnte nicht erzeugt werden (siehe js logs für mehr Details)"

        RErrValidationError ->
            "Die QR-Rechnung konnte nicht validiert werden (siehe js logs für mehr Details)"

        RValErrDoesExist ->
            "die Zeile darf nicht existieren"

        RValErrDoesNotExist ->
            "das Feld darf leer sein, muss aber existieren"

        RValErrIsEmpty ->
            "das obligatorische Feld darf nicht leer sein"

        RValErrMustBeEmpty ->
            "das Feld muss leer sein"

        RValErrMustBeEqualTo ->
            "es dürfen nur folgende Werte im Feld stehen:"

        RValErrLengthDifferent ->
            "das Feld muss genau folgende Länge haben:"

        RValErrLengthExceeded ->
            "das Feld ist zu lang, die maximale zulässige Länge beträgt"

        RValErrLengthNotReached ->
            "das Feld ist zu kurz, die minimale zulässige Länge beträgt"

        RValErrMustBeDifferentThan ->
            "folgende Werte dürfen im Feld nicht enthalten sein:"

        RValErrDoesNotStartWith ->
            "das Feld muss mit folgender Zeichenkette beginnen:"

        RValErrInvalid ->
            "das Feld ist inkorrekt"

        RValErrFormatIsDifferentThan ->
            "das Feld muss folgendes Format respektieren:"

        RValErrInvalidEmail -> 
            "**l'adresse email n'est pas valable"

        RValErrQrReferenceInvalid ->
            "die QR Referenznummer (QRR) ist nicht korrekt"

        RValErrCreditorReferenceInvalid ->
            "die Creditor Referenz (SCOR) ist nicht korrekt"

        RValErrNonReferenceInvalid ->
            "für den Typ NON darf keine Referenz existieren"

        RValErrNonReferenceWithQrIban ->
            "der Typ NON kann nicht für mit einem QR-Iban verwendet werden"

        RValErrCreditorReferenceWithQrIban ->
            "der Typ SCOR kann nicht für mit einem QR-Iban verwendet werden"

        RValErrQrrReferenceWithStandardIban ->
            "der Typ QRR kann nicht für mit einem Iban verwendet werden"

        RValErrValueExceeded ->
            "der Wert darf nicht grösser sein als"

        RValErrValueNotReached ->
            "der Wert darf nicht kleiner sein als"

        RValErrInvalidTags ->
            "das Format des Swico Feldes ist inkorrekt"

        RValErrUnknownTag ->
            "folgender Swico Tag ist inkorrekt:"

        RValErrTagNotOrdered ->
            "der Swico Tag muss grösser als die vorhergehende sein (die Tags müssen in aufsteigender Reihenfolge erscheinen):"

        RValErrTagAlreadyExists ->
            "der Swico Tag existiert schon (ein Tag darf nur einmal erscheinen):"

        RValErrTagIsEmpty ->
            "der obligatorische Swico Tag darf nicht leer sein"

        RValErrSwiftFormat ->
            "das Feld respektiert nicht die Swift Kodierung"

        RValErrVatAmountMissmatch ->
            "var amount missmatch"

        RValErrZeroConditionMissing ->
            "eine Skontokondition mit 0% muss existieren, damit eine Zahlungsfrist angegeben werden kann"

        RValErrMissingEmailOrBillRecipient -> 
            "**la ligne eBill doit contenir soit l'adresse email, soit le BillRecipientId"