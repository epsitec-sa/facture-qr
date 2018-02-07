module Components.QrValidation exposing (..)
import Backend.WebService exposing (..)
import Components.QrHelpers exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


renderValidationErrors: List Backend.WebService.ValidationError -> Html a
renderValidationErrors validations =
  div [] (
    List.map (\validation -> p [] [text (Backend.WebService.prettifyValidationError validation)]) validations
  )

renderRawInvoice: Backend.WebService.Decoding -> Html a
renderRawInvoice decoding =
  div [style [("flex-grow", "1"), ("background-color", "#ccc")]] [
    case decoding.raw of
      Nothing -> div [] []
      Just raw ->
        div [] (List.map (\line -> div [] [text line, br [] []]) (String.split "\n" raw))
  ]


render : Backend.WebService.Decoding -> Backend.WebService.Validation -> Html a
render decoding validation =
  div [style [
    ("display", "flex"),
    ("flex-grow", "1"),
    ("justify-content", "center"),
    ("align-items", "center")]
  ] [{-
    case validation.error of
      Nothing ->
        case validation.validations of
          Nothing -> renderSpinner
          Just img -> renderImage img
      Just err ->
          renderError err-}
  ]
