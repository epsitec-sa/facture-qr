module Components.QrValidation exposing (..)
import Backend.WebService exposing (..)
import Components.QrHelpers exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


renderValidationErrors: List Backend.WebService.ValidationError -> Html a
renderValidationErrors validations =
  div [style [
    ("display", "flex"),
    ("flex-grow", "1"),
    ("flex-shrink", "0"),
    ("flex-basis", "0")
  ]]
  [
    --List.map (\validation -> p [] [text (Backend.WebService.prettifyValidationError validation)]) validations
  ]

computeLineSubstr : String -> Backend.WebService.ValidationError -> (Int, Int)
computeLineSubstr line validation =
  (0, String.length line)

renderLineWithValidation : String -> (Int, Int) -> Html a
renderLineWithValidation line substr =
  div [] []


renderLine : Int -> String -> List Backend.WebService.ValidationError -> Html a
renderLine index line validations =
  div [style [("display", "flex"), ("align-items", "flex-start")]] [
    span [style [("font-size", "8px"), ("padding-top", "2px")]] [text (toString (index + 1))],
    span [style [("width", "10px"), ("height", "1px")]] [],

    if List.length validations == 0 then
      span [] [text line]
    else
      span [] (
        List.map (\validation ->
          renderLineWithValidation line (computeLineSubstr line validation)
        ) validations
      )
    ,
    br [] []
  ]


renderRawInvoice : String -> List Backend.WebService.ValidationError -> Html a
renderRawInvoice raw validations =
  div [style [
    ("display", "flex"),
    ("flex-grow", "1"),
    ("flex-shrink", "0"),
    ("flex-basis", "0")
  ]]
  [
    div [style [
      ("display", "flex"),
      ("background-color", "#fff"),
      ("overflow-y", "auto"),
      ("font-size", "10px"),
      ("width", "400px"),
      ("padding", "0.5em"),
      ("color", "black")
    ]]
    [
      div [] (
        List.indexedMap (\index line ->
          renderLine index line (List.filter (\validation -> validation.line == (index + 1)) validations)
        ) (String.split "\n" raw)
      )
    ]
  ]

renderContent : String -> List Backend.WebService.ValidationError -> Html a
renderContent raw validations =
  div [style [
    ("display", "flex"),
    ("flex-grow", "1"),
    ("flex-basis", "0"),
    ("padding", "0.5em")]
  ]
  [
    renderRawInvoice raw validations,
    renderValidationErrors validations
  ]

render : Backend.WebService.Decoding -> Backend.WebService.Validation -> Html a
render decoding validation =
  case decoding.error of
    Nothing ->
      case validation.error of
        Nothing ->
          case validation.validations of
            Nothing -> renderSpinner
            Just validations ->
              case decoding.raw of
                Nothing -> div [] []
                Just raw -> renderContent raw validations
        Just err ->
            renderError err
    Just err ->
        renderError err
