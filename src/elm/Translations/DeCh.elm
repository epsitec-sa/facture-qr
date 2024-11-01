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
            "Alternative Verfahren"

        RWaiting ->
            "Einen Augenblick..."

        RLine ->
            "Zeile"

        RField ->
            "Feld"

        RDownloadRaw -> 
            "Herunterladen"

        RCopyClipboard -> 
            "Kopieren"

        RCopyClipboardTooltip -> "Die Rechnung in die Zwischenablage kopieren"

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
            "Liste der Konditionen"

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

        RAtTax ->
            "mit der Rate von"

        RFrom ->
            "von"

        RTo ->
            "bis zum"

        RAlternativeProcedure ->
            "Alternatives Verfahren"

        RTransactionType ->
            "Transaktionstyp"

        RBusinessCaseDate ->
            "Geschäftsfalldatum bzw. Rechnungsdatum"

        RDueDate ->
            "Fälligkeitsdatum"

        RReferenceNumber ->
            "Rechnungsreferenz bzw. Rechnungsnummer"

        RPayableAmountCanBeModified ->
            "Betrag darf verändert werden"

        RBillerID ->
            "Identifikation des Rechnungsstellers"

        REmailAddress ->
            "E-Mail-Adresse des Rechnungsempfängers"

        RBillRecipientID ->
            "Alternative Identifikation des Rechnungsempfängers"

        RReferencedBill ->
            "Identifikation der Originalrechnung"

        RYes ->
            "Ja"

        RNo ->
            "Nein"

        RBills ->
            "Rechnung oder überrollende Rechnung"

        RReminders ->
            "Mahnung"

        RErrMultipleFilesDropped ->
            "Es kann nur eine Datei auf einmal verarbeitet werden"

        RErrNetworkError ->
            "Die Anfrage ist fehlgeschlagen (siehe js logs für mehr Details)"

        RErrUnknownError ->
            "Ein unbekannter Fehler ist aufgetreten (siehe js logs für mehr Details)"

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
            "das E-Mail ist nicht korrekt"

        RValErrDateNotSequential ->
            "Enddatum sollte nach dem Startdatum sein"

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

        RValErrInvalidEscapeSequence ->
            "es werden nur '\\\\' und '\\/' als Escapesequenzen angenommen"

        RValErrInvalidEncoding ->
            "Der QR-Code muss mit dem UTF-8 Zeichensatz kodiert sein aber es wurde folgender Zeichensatz entdeckt:"

        RValErrVatAmountMissmatch ->
            "die Summe der Mehrwertsteuerbeträge entspricht nicht dem Gesamtbetrag der Rechnung  ((VatDtlsPrcntg1*VatDtlsAmt1 + VatDtlsAmt1) + (VatDtlsPrcntg2*VatDtlsAmt2 + VatDtlsAmt2) +.... + VatTaxAmt1 + VatTaxAmt2 + ...). Die berechnete Summe beträgt"

        RValErrZeroConditionMissing ->
            "eine Skontokondition mit 0% muss existieren, damit eine Zahlungsfrist angegeben werden kann"

        RValErrMissingEmailOrBillRecipient ->
            "die Zeile eBill muss entweder ein E-Mail oder ein BillRecipientId enthalten"
