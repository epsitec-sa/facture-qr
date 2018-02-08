module Components.QrValidation exposing (..)
import Backend.WebService exposing (..)
import Components.QrHelpers exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

type alias LineSubstr = {
  start : Int,
  end : Int,
  error : Bool
}


renderValidationErrors: List Backend.WebService.ValidationError -> Html a
renderValidationErrors validations =
  div [style [
    ("display", "flex"),
    ("flex-direction", "column"),
    ("flex-grow", "1"),
    ("flex-shrink", "0"),
    ("flex-basis", "0"),
    ("overflow-y", "auto"),
    ("font-size", "10px"),
    ("width", "300px")
  ]]
  (
    List.map (\validation -> p [] [text (Backend.WebService.prettifyValidationError validation)]) validations
  )


renderLineWithSubstrs : String -> List LineSubstr -> Html a
renderLineWithSubstrs line substrs =
  div [style [("display", "inline")]] (
    List.map (\substr ->
      div (
        case substr.error of
          True -> [class "lineError", style [("display", "inline")]]
          False -> [style [("display", "inline")]]
      ) [
        if substr.error == True && substr.start == substr.end then
          text "???"
        else
          text (String.slice substr.start substr.end line)
      ]
    ) substrs
  )

-- From each validation error, generate a chunk of correct text and another with error text
computeLineSubstrs : List Backend.WebService.ValidationError -> Int -> Int -> List LineSubstr
computeLineSubstrs validations offset lineLength =
  case validations of
    [] -> [{
        start = offset,
        end = lineLength,
        error = False
      }]
    x::xs ->
      if offset <= x.column - 1 then
        List.append [{
          start = offset,
          end = x.column - 1,
          error = False
        }, {
          start = x.column - 1,
          end = x.column - 1 + x.length,
          error = True
        }] (computeLineSubstrs xs (x.column - 1 + x.length) lineLength)
      else
        computeLineSubstrs xs offset lineLength


renderLine : Int -> String -> List Backend.WebService.ValidationError -> Html a
renderLine index line validations =
  div [style [("display", "flex"), ("align-items", "flex-start")]] [
    span [style [("font-size", "8px"), ("padding-top", "2px")]] [text (toString (index + 1))],
    span [style [("width", "10px"), ("height", "1px")]] [],

    span [] [
      if List.length validations == 0 then
        text line
      else
        renderLineWithSubstrs line (
          computeLineSubstrs validations 0 (String.length line)
        )
    ],
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
