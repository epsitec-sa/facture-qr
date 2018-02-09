module Components.QrValidation exposing (..)
import Backend.WebService exposing (..)
import Components.QrHelpers exposing (..)
import Translations.Languages exposing (Language)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

type Message = ValidationIn String | ValidationOut String

type alias LineBlock = {
  start : Int,
  end : Int,
  error : Bool,
  xmlField : String
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
        xmlField = ""
      }]
    x::xs ->
      if offset <= x.column - 1 then
        List.append [{
          start = offset,
          end = x.column - 1,
          error = False,
          xmlField = ""
        }, {
          start = x.column - 1,
          end = x.column - 1 + x.length,
          error = True,
          xmlField = x.xmlField
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


parseIndexWithLeadingZero : Int -> String
parseIndexWithLeadingZero index =
  if index < 10 then
    "0" ++ toString index
  else
    toString index


update : Message -> Model -> (Model, Cmd Message)
update msg model =
  case msg of
    ValidationIn xmlField -> (
      {model | hoveredValidations =
        if not (List.member xmlField model.hoveredValidations) then
          xmlField :: model.hoveredValidations
        else model.hoveredValidations
      },
      Cmd.none)
    ValidationOut xmlField -> (
      {model | hoveredValidations = List.filter (\field -> not (field == xmlField)) model.hoveredValidations},
      Cmd.none)





renderValidationErrors: Model -> Language -> List Line -> List Backend.WebService.ValidationError -> Html Message
renderValidationErrors model language lines validations =
  div [style [
    ("display", "flex"),
    ("flex-direction", "column"),
    ("flex-grow", "1"),
    ("flex-shrink", "0"),
    ("flex-basis", "0"),
    ("padding", "0em 0.5em 0em 0.5em"),
    ("overflow-y", "auto"),
    ("font-size", "10px")
  ]]
  (
    List.concatMap (\validation ->
      List.concatMap (\line ->
        List.map (\block ->
          div [style [
            ("border", "1px solid white"),
            ("padding", "1em"),
            ("margin", "1em 0em 1em 0em"),
            ("background-color", if (List.member block.xmlField model.hoveredValidations) then "#666" else "#333" )
          ],
          onMouseEnter (ValidationIn block.xmlField),
          onMouseLeave (ValidationOut block.xmlField)
          ] [
            text ("Line " ++ parseIndexWithLeadingZero (line.number)),
            br [] [],
            text (block.xmlField ++ ": " ++ (String.slice block.start block.end line.raw)),
            br [] [],
            text (Backend.WebService.prettifyValidationError validation language)
          ]
        ) (List.filter (\block -> block.xmlField == validation.xmlField) line.blocks)
      ) (List.filter (\line -> line.number == validation.line) lines)
    ) validations
  )



renderLineBlocks : Model -> String -> List LineBlock -> Html Message
renderLineBlocks model line blocks =
  div [style [("display", "inline")]] (
    List.map (\block ->
      div (
        case block.error of
          True -> [
            class "lineError",
            style [
              ("display", "inline"),
              ("background-color", if (List.member block.xmlField model.hoveredValidations) then "red" else "white" )
            ],
            onMouseEnter (ValidationIn block.xmlField),
            onMouseLeave (ValidationOut block.xmlField)
          ]
          False -> [style [("display", "inline")]]
      ) [
        if block.error == True && block.start == block.end then
          text "???"
        else
          text (String.slice block.start block.end line)
      ]
    ) blocks
  )

renderLine : Model -> Line -> Html Message
renderLine model line =
  div [style [("display", "flex"), ("align-items", "flex-start")]] [
    span [
      style [
        ("font-size", "8px"),
        ("padding-top", "2px"),
        ("font-weight", if List.length (line.blocks) > 1 then "bold" else "regular")
      ]]
      [text (parseIndexWithLeadingZero line.number)],

    span [style [("width", "10px"), ("height", "1px")]] [],

    span [] [renderLineBlocks model line.raw line.blocks],
    br [] []
  ]


renderRawInvoice : Model -> List Line -> Html Message
renderRawInvoice model lines =
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
        List.map (\line -> (renderLine model line) ) lines
      )
    ]
  ]

renderContent : Model -> Language -> String -> List Backend.WebService.ValidationError -> Html Message
renderContent model language raw validations =
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
      renderRawInvoice model lines,
      renderValidationErrors model language lines validations
    ])
  )

view : Model -> Language -> Backend.WebService.Decoding -> Backend.WebService.Validation -> Html Message
view model language decoding validation =
  case decoding.error of
    Nothing ->
      case validation.error of
        Nothing ->
          case validation.validations of
            Nothing -> renderSpinner language
            Just validations ->
              case decoding.raw of
                Nothing -> div [] []
                Just raw -> renderContent model language raw validations
        Just err ->
            renderError err language
    Just err ->
        renderError err language
