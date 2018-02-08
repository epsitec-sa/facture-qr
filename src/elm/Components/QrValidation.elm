module Components.QrValidation exposing (..)
import Backend.WebService exposing (..)
import Components.QrHelpers exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

type alias LineBlock = {
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


parseIndexWithLeadingZero : Int -> String
parseIndexWithLeadingZero index =
  if index < 10 then
    "0" ++ toString index
  else
    toString index


renderLineBlocks : String -> List LineBlock -> Html a
renderLineBlocks line blocks =
  div [style [("display", "inline")]] (
    List.map (\block ->
      div (
        case block.error of
          True -> [class "lineError", style [("display", "inline")]]
          False -> [style [("display", "inline")]]
      ) [
        if block.error == True && block.start == block.end then
          text "???"
        else
          text (String.slice block.start block.end line)
      ]
    ) blocks
  )

-- From each validation error, generate a chunk of correct text and another with error text
computeLineBlocks : List Backend.WebService.ValidationError -> Int -> Int -> List LineBlock
computeLineBlocks validations offset lineLength =
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
        }] (computeLineBlocks xs (x.column - 1 + x.length) lineLength)
      else
        computeLineBlocks xs offset lineLength

sortValidations : List Backend.WebService.ValidationError -> List Backend.WebService.ValidationError
sortValidations validations =
  List.sortWith (\a b -> compare a.column b.column) validations

renderLine : Int -> String -> List Backend.WebService.ValidationError -> Html a
renderLine index line validations =
  div [style [("display", "flex"), ("align-items", "flex-start")]] [
    span [style [("font-size", "8px"), ("padding-top", "2px")]] [text (parseIndexWithLeadingZero (index + 1))],
    span [style [("width", "10px"), ("height", "1px")]] [],

    span [] [
      if List.length validations == 0 then
        text line
      else
        renderLineBlocks line (
          computeLineBlocks (sortValidations validations) 0 (String.length line)
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
