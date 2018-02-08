module Components.QrValidation exposing (..)
import Backend.WebService exposing (..)
import Components.QrHelpers exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

type Message = ValidationHovered String

type alias LineBlock = {
  start : Int,
  end : Int,
  error : Bool,
  xmlField : Maybe String
}

type alias Line = {
  number : Int,
  raw : String,
  blocks : List LineBlock
}

type alias Model = {
  hoveredValidations : List String
}

init : Model
init = {
    hoveredValidations = []
  }



-- From each validation error, generate a chunk of correct text and another with error text
computeLineBlocks : List Backend.WebService.ValidationError -> Int -> Int -> List LineBlock
computeLineBlocks validations offset lineLength =
  case validations of
    [] -> [{
        start = offset,
        end = lineLength,
        error = False,
        xmlField = Nothing
      }]
    x::xs ->
      if offset <= x.column - 1 then
        List.append [{
          start = offset,
          end = x.column - 1,
          error = False,
          xmlField = Nothing
        }, {
          start = x.column - 1,
          end = x.column - 1 + x.length,
          error = True,
          xmlField = Just x.xmlField
        }] (computeLineBlocks xs (x.column - 1 + x.length) lineLength)
      else
        computeLineBlocks xs offset lineLength

cleanValidations : Int -> List Backend.WebService.ValidationError -> List Backend.WebService.ValidationError
cleanValidations index validations =
  List.sortWith (\a b -> compare a.column b.column) (
    List.filter (\validation -> validation.line == index) validations
  )

computeLines : String -> List Backend.WebService.ValidationError -> List Line
computeLines raw validations =
    List.indexedMap (\index line -> {
        number = index + 1,
        raw = line,
        blocks = computeLineBlocks (cleanValidations (index + 1) validations) 0 (String.length line)
      }
    ) (String.split "\n" raw)

{-

update : Message -> (Cmd Message)
update msg =
  case msg of
    InvoiceValidated validations ->

-}







renderValidationErrors: List Line -> List Backend.WebService.ValidationError -> Html a
renderValidationErrors lines validations =
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

renderLine : Line -> Html a
renderLine line =
  div [style [("display", "flex"), ("align-items", "flex-start")]] [
    span [style [("font-size", "8px"), ("padding-top", "2px")]] [text (parseIndexWithLeadingZero line.number)],
    span [style [("width", "10px"), ("height", "1px")]] [],

    span [] [
      if List.length line.blocks == 0 then
        text line.raw
      else
        renderLineBlocks line.raw line.blocks
    ],
    br [] []
  ]


renderRawInvoice : List Line -> Html a
renderRawInvoice lines =
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
        List.map (\line -> (renderLine line) ) lines
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
  (
    let
      lines = computeLines raw validations
    in ([
      renderRawInvoice lines,
      renderValidationErrors lines validations
    ])
  )

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
