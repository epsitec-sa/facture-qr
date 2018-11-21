module Translations.Resources exposing (..)


type Resource =
  RTitle | RDropYourCode | RTabValidation | RTabSwicoLine | RTabImage | RWaiting | RLine | RField |

  RErrMultipleFilesDropped | RErrNetworkError | RErrUnknownError |
  RErrInvalidEncoding | RErrInvalidInvoiceImage | RErrGenerationError | RErrValidationError |

  RPrefix | RDocumentReference | RDocumentDate | RCustomerReference | RVatNumber | RVatDates |
  RVatDetails | RVatImportTax | RConditions | RDiscount | RTotalBill | RImport | RDays | ROn | RFrom | RTo |

  RValErrDoesExist | RValErrDoesNotExist | RValErrIsEmpty | RValErrMustBeEmpty | RValErrMustBeEqualTo |
  RValErrLengthDifferent | RValErrLengthExceeded | RValErrLengthNotReached | RValErrMustBeDifferentThan |
  RValErrDoesNotStartWith | RValErrInvalid | RValErrFormatIsDifferentThan | RValErrQrReferenceInvalid |
  RValErrCreditorReferenceInvalid | RValErrNoReferenceInvalid | RValErrNoReferenceWithQrIban | RValErrValueExceeded | RValErrValueNotReached |
  RValErrInvalidTags | RValErrUnknownTag | RValErrTagNotOrdered | RValErrTagAlreadyExists | RValErrTagIsEmpty | RValErrSwiftFormat |
  RValErrZeroConditionMissing
