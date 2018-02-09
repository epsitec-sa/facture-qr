module Translations.Resources exposing (..)


type Resource =
  RTitle | RDropYourCode | RWeWillValidateIt | RTabValidation | RTabImage |

  RErrMultipleFilesDropped | RErrNetworkError | RErrUnknownError |
  RErrInvalidEncoding | RErrInvalidInvoiceImage | RErrGenerationError | RErrValidationError |

  RValErrDoesNotExist | RValErrIsEmpty | RValErrMustBeEmpty | RValErrMustBeEqualTo |
  RValErrLengthDifferent | RValErrLengthExceeded | RValErrLengthNotReached | RValErrMustBeDifferentThan |
  RValErrDoesNotStartWith | RValErrInvalid | RValErrFormatIsDifferentThan | RValErrQrReferenceInvalid |
  RValErrCreditorReferenceInvalid | RValErrNoReferenceInvalid | RValErrValueExceeded | RValErrValueNotReached |
  RValErrInvalidTags | RValErrUnknownTag | RValErrTagNotOrdered | RValErrTagAlreadyExists | RValErrSwiftFormat
