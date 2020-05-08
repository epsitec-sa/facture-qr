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
    RTabAlternativeProcedures -> "Procédures alternatives"
    RWaiting -> "En attente..."
    RLine -> "Ligne"
    RField -> "champ"

    RRaw -> "Ligne brute :"
    RPrefix -> "Préfixe"
    RDocumentReference -> "Numéro de facture"
    RDocumentDate -> "Date de la facture"
    RCustomerReference -> "Référence du donneur d'ordre"
    RVatNumber -> "Numéro UID"
    RVatDates -> "Date(s) de la prestation"
    RVatDetails -> "Taux de la facture"
    RVatImportTax -> "TVA pure lors de l'importation"
    RConditions -> "Condition(s)"
    RDiscount -> "d'escompte à"
    RTotalBill -> "sur l'entier du montant"
    RImport -> "de TVA lors de l'importation de marchandises"
    RDays -> "jours"
    ROn -> "sur"
    RAtTax -> "au taux de"
    RFrom -> "du"
    RTo -> "au"

    RAlternativeProcedure -> "Procédure alternative"
    RTransactionType -> "Type de transaction"
    RBusinessCaseDate -> "Date de l'opération bancaire ou date de la facture"
    RDueDate -> "Date d'échéance"
    RReferenceNumber -> "Référence de facturation ou numéro de facture"
    RPayableAmountCanBeModified -> "Montant modifiable"
    RBillerID -> "Identification de l'émetteur de la facture"
    REmailAddress -> "Adresse e-mail du destinataire de la facture"
    RBillRecipientID -> "Identification alternative du destinataire de la facture"
    RReferencedBill -> "Identification de la facture originale"
    RYes -> "Oui"
    RNo -> "Non"
    RBills -> "Facture ou facture rectificative"
    RReminders -> "Rappel"

    RErrMultipleFilesDropped -> "Un seul fichier peut être traité à la fois"
    RErrNetworkError -> "La requête a échoué (voir log js pour plus de détails)"
    RErrUnknownError -> "Erreur inconnue (voir log js pour plus de détails)"
    RErrInvalidEncoding -> "Le QR-code doit être encodé en UTF-8 mais l'encodage suivant a été détecté :"
    RErrInvalidInvoiceImage -> "Impossible de decoder l'image (voir log js pour plus de détails)"
    RErrGenerationError -> "Impossible de générer l'image de la facture (voir log js pour plus de détails)"
    RErrValidationError -> "Impossible de valider la facture QR (voir log js pour plus de détails)"

    RValErrDoesExist -> "la ligne ne doit pas exister"
    RValErrDoesNotExist -> "le champ peut être vide mais doit exister"
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
    RValErrInvalidEmail -> "l'adresse email n'est pas valable"
    RValErrQrReferenceInvalid -> "la référence QR (QRR) n'est pas valable"
    RValErrCreditorReferenceInvalid -> "la réference du créditeur (SCOR) n'est pas valable"
    RValErrNonReferenceInvalid -> "aucune réference ne doit être saisie pour le type NON"
    RValErrNonReferenceWithQrIban -> "le type NON n'est pas valable avec un QR-Iban"
    RValErrCreditorReferenceWithQrIban -> "le type SCOR n'est pas valable avec un QR-Iban"
    RValErrQrrReferenceWithStandardIban -> "le type QRR n'est pas valable avec un Iban normal"
    RValErrValueExceeded -> "la valeur ne peut pas être plus grande que"
    RValErrValueNotReached -> "la valeur ne peut pas être plus petite que"
    RValErrInvalidTags -> "le champ Swico n'est pas formatté correctement"
    RValErrUnknownTag -> "la balise Swico n'est pas reconnue :"
    RValErrTagNotOrdered -> "la balise Swico doit être plus grande que la précedente (les balises doivent être ordrées de façon croissante) :"
    RValErrTagAlreadyExists -> "la balise Swico existe déjà (une balise ne peut apparaître qu'une seule fois) :"
    RValErrTagIsEmpty -> "la balise Swico est obligatoire et ne peut pas être vide"
    RValErrSwiftFormat -> "le champ ne respecte pas l'encodage Swift"
    RValErrVatAmountMissmatch -> "la somme des montants TVA n'est pas en accord avec le montant total de la facture ((VatDtlsPrcntg1*VatDtlsAmt1 + VatDtlsAmt1) + (VatDtlsPrcntg2*VatDtlsAmt2 + VatDtlsAmt2) +.... + VatTaxAmt1 + VatTaxAmt2 + ...). Le total calculé est"
    RValErrZeroConditionMissing -> "une condition d'escompte à 0% doit exister afin d'indiquer le delai de paiement"
    RValErrMissingEmailOrBillRecipient -> "la ligne eBill doit contenir soit l'adresse email, soit le BillRecipientId"
