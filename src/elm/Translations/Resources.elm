module Translations.Resources exposing (..)


type Resource =
  RTitle | RDropYourCode | RTabValidation | RTabImage | RWaiting | RLine | RField |

  RErrMultipleFilesDropped | RErrNetworkError | RErrUnknownError |
  RErrInvalidEncoding | RErrInvalidInvoiceImage | RErrGenerationError | RErrValidationError |

  RValErrDoesNotExist | RValErrIsEmpty | RValErrMustBeEmpty | RValErrMustBeEqualTo |
  RValErrLengthDifferent | RValErrLengthExceeded | RValErrLengthNotReached | RValErrMustBeDifferentThan |
  RValErrDoesNotStartWith | RValErrInvalid | RValErrFormatIsDifferentThan | RValErrQrReferenceInvalid |
  RValErrCreditorReferenceInvalid | RValErrNoReferenceInvalid | RValErrNoReferenceWithQrIban | RValErrValueExceeded | RValErrValueNotReached |
  RValErrInvalidTags | RValErrUnknownTag | RValErrTagNotOrdered | RValErrTagAlreadyExists | RValErrTagIsEmpty | RValErrSwiftFormat
