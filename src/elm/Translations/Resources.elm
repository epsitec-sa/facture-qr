module Translations.Resources exposing (..)


type Resource =
  RTitle | RDropYourCode | RTabValidation | RTabSwicoLine | RTabImage | RTabAlternativeProcedures | RWaiting | RLine | RField |

  RErrMultipleFilesDropped | RErrNetworkError | RErrUnknownError |
  RErrInvalidEncoding | RErrInvalidInvoiceImage | RErrGenerationError | RErrValidationError |

  RRaw | RPrefix | RDocumentReference | RDocumentDate | RCustomerReference | RVatNumber | RVatDates |
  RVatDetails | RVatImportTax | RConditions | RDiscount | RTotalBill | RImport | RDays | ROn | RAtTax | RFrom | RTo |

  RAlternativeProcedure | RTransactionType | RBusinessCaseDate | RDueDate | RReferenceNumber | RPayableAmountCanBeModified | RBillerID |
  REmailAddress | RBillRecipientID | RReferencedBill | RYes | RNo | RBills  | RReminders |

  RValErrDoesExist | RValErrDoesNotExist | RValErrIsEmpty | RValErrMustBeEmpty | RValErrMustBeEqualTo |
  RValErrLengthDifferent | RValErrLengthExceeded | RValErrLengthNotReached | RValErrMustBeDifferentThan |
  RValErrDoesNotStartWith | RValErrInvalid | RValErrFormatIsDifferentThan | RValErrInvalidEmail | RValErrQrReferenceInvalid | RValErrDateNotSequential |
  RValErrCreditorReferenceInvalid | RValErrNonReferenceInvalid |
  RValErrNonReferenceWithQrIban | RValErrCreditorReferenceWithQrIban | RValErrQrrReferenceWithStandardIban |
  RValErrValueExceeded | RValErrValueNotReached |
  RValErrInvalidTags | RValErrUnknownTag | RValErrTagNotOrdered | RValErrTagAlreadyExists | RValErrTagIsEmpty | RValErrSwiftFormat | RValErrInvalidEscapeSequence |
  RValErrVatAmountMissmatch | RValErrZeroConditionMissing |
  RValErrMissingEmailOrBillRecipient
