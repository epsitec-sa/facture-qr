module Components.QrValidation exposing (..)
import Backend.WebService exposing (..)
import Components.QrHelpers exposing (..)
import Translations.Languages exposing (t, Language)
import Translations.Resources exposing (..)
import Ports exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String.Extra exposing (..)

type Message = LineBlockIn (String, Int) | ValidationIn (String, Int) | FieldOut String | RawInvoiceDownloaded String | RawInvoiceToCliboardCopied String | ResetCliboardCopy

type Rendering = Error | Warning | Default

type alias LineBlock = {
  start : Int,
  end : Int,
  rendering : Rendering,
  xmlField : String
}

type alias Line = {
  number : Int,
  raw : String,
  blocks : List LineBlock
}

type alias Model = 
  {
    hoveredValidations : List String
  , copiedToClipboard : Bool
  }

init : Model
init = {
    hoveredValidations = []
  , copiedToClipboard = False
  }


-- From each validation error, generate a chunk of correct text and another with error text
computeLineBlocks : List Backend.WebService.ValidationError -> Int -> Int -> List LineBlock
computeLineBlocks validations offset lineLength =
  case validations of
    [] -> [{
        start = offset,
        end = lineLength,
        rendering = Default,
        xmlField = ""
      }]
    x::xs ->
      if offset <= x.column - 1 then
        List.append [{
          start = offset,
          end = x.column - 1,
          rendering = Default,
          xmlField = ""
        }, {
          start = x.column - 1,
          end = x.column - 1 + x.length,
          rendering = if x.warning == True then Warning else Error,
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
  ) (List.filter (\line ->
      not (String.startsWith "[encoding:" line)
    ) (String.split "\n" raw))

-- Computes lines that are not in the raw text, but for which errors have been generated
-- (usually end of text errors)
computeExtraLines : List Line -> List Backend.WebService.ValidationError -> List Line
computeExtraLines lines validations =
  List.map (\validation -> {
      number = validation.line,
      raw = "",
      blocks = [{
        start = 0,
        end = 0,
        rendering = if validation.warning == True then Warning else Error,
        xmlField = validation.xmlField
      }]
    }
  ) (List.filter (\validation ->
      List.isEmpty (
        List.filter (\line ->
          validation.line <= line.number
        ) lines
      )
    ) validations)


parseIndexWithLeadingZero : Int -> String
parseIndexWithLeadingZero index =
  if index < 10 then
    "0" ++ toString index
  else
    toString index

normalizeValidationId : String -> Int -> String
normalizeValidationId xmlField lineNumber =
  "v_" ++ (replace "]" "_" (replace "[" "_" xmlField)) ++ "_" ++ (toString lineNumber)

update : Message -> Model -> (Model, Cmd Message)
update msg model =
  case msg of
    LineBlockIn (xmlField, lineNumber) -> (
      {model | hoveredValidations =
        if not (List.member xmlField model.hoveredValidations) then
          xmlField :: model.hoveredValidations
        else model.hoveredValidations
      },
      scrollTo ("validations", normalizeValidationId xmlField lineNumber))
    ValidationIn (xmlField, lineNumber) -> (
      {model | hoveredValidations =
          if not (List.member xmlField model.hoveredValidations) then
            xmlField :: model.hoveredValidations
          else model.hoveredValidations
      },
      scrollTo ("lines", "l_" ++ (toString lineNumber)))
    FieldOut xmlField -> (
      {model | hoveredValidations = List.filter (\field -> not (field == xmlField)) model.hoveredValidations},
      Cmd.none)
    RawInvoiceDownloaded rawInvoice -> (
      model, 
      downloadFile (rawInvoice, "text/plain;charset=utf-8;", "qr-bill.txt"))
    RawInvoiceToCliboardCopied rawInvoice -> (
      {model | copiedToClipboard = True},
      copyToClipboard rawInvoice)
    ResetCliboardCopy -> (
      {model | copiedToClipboard = False},
      Cmd.none
    )



renderValidationErrors: Model -> Language -> List Line -> List Backend.WebService.ValidationError -> Html Message
renderValidationErrors model language lines validations =
  div [
    id "validations",
    style [
      ("position", "relative"),
      ("display", "flex"),
      ("flex-direction", "column"),
      ("flex-grow", "1"),
      ("flex-basis", "0"),
      ("flex-shrink", "0"),
      ("overflow-y", "auto"),
      ("font-size", "10px")
    ]
  ]
  (
    List.concatMap (\validation ->
      List.concatMap (\line ->
        List.map (\block ->
          div [
            id (normalizeValidationId block.xmlField line.number),
            style [
              ("display", "flex"),
              ("flex-shrink", "0"),
              ("border-radius", "0px 10px 10px 0px"),
              ("padding", "1em 0em 1em 0em"),
              ("margin-bottom", "1.5em"),
              ("background-color", if (List.member block.xmlField model.hoveredValidations) then "#cce8ff" else "#0d4c80" ),
              ("color", if (List.member block.xmlField model.hoveredValidations) then "#0d4c80" else "white" )
            ],
          onMouseEnter (ValidationIn (block.xmlField, line.number)),
          onMouseLeave (FieldOut block.xmlField)
          ] [
            div [style [
              ("display", "flex"),
              ("flex-shrink", "0"),
              ("padding", "0em 0.5em"),
              ("justify-content", "center"),
              ("align-items", "center"),
              ("font-size", "32px")
            ]] [
              text (parseIndexWithLeadingZero (line.number))
            ],
            div [style [
              ("display", "flex"),
              ("flex-direction", "column"),
              ("flex-grow", "1"),
              ("flex-basis", "0"),
              ("flex-shrink", "0"),
              ("align-items", "stretch"),
              ("justify-content", "center")
            ]] [
              div [style [
                ("display", "flex"),
                ("flex-shrink", "0"),
                ("align-items", "center")
              ]] [
                text ((t language RLine)),
                b [style [("margin-left", "3px")]] [text (toString line.number)],
                text (", " ++ (t language RField)),
                b [style [("margin-left", "3px")]] [text (Backend.WebService.prettifyXmlField block.xmlField)]
              ],
              div [style [
                ("display", "block"),
                ("align-items", "center"),
                ("font-size", "16px"),

                ("width", "300px"),
                ("whiteSpace", "nowrap"),
                ("overflow", "hidden"),
                ("textOverflow", "ellipsis")
              ]] [
                if block.start == block.end then
                  text "*"
                else
                  text (String.slice block.start block.end line.raw)
              ],
              div [style [
                ("display", "flex"),
                ("flex-shrink", "0"),
                ("align-items", "center")
              ]] [
                text (Backend.WebService.prettifyValidationError validation language)
              ]
            ]
          ]
        ) (List.filter (\block -> block.xmlField == validation.xmlField) line.blocks)
      ) (List.filter (\line -> line.number == validation.line) lines)
    ) validations
  )


renderLineBlocks : Model -> Line -> Html Message
renderLineBlocks model line =
  span [] (
    List.map (\block ->
      span (
        case block.rendering of
          Error -> [
            class "lineError",
            style [
              ("display", "inline-block"),
              ("word-break", "break-all"),
              ("background-color", if (List.member block.xmlField model.hoveredValidations) then "red" else "rgba(255, 0, 0, 0.2)" )
            ],
            onMouseEnter (LineBlockIn (block.xmlField, line.number)),
            onMouseLeave (FieldOut block.xmlField)
          ]
          Warning -> [
            class "lineError",
            style [
              ("display", "inline-block"),
              ("word-break", "break-all"),
              ("background-color", if (List.member block.xmlField model.hoveredValidations) then "orange" else "rgba(255, 165, 0, 0.2)" )
            ],
            onMouseEnter (LineBlockIn (block.xmlField, line.number)),
            onMouseLeave (FieldOut block.xmlField)
          ]
          Default -> [style [("display", "inline-block"), ("word-break", "break-all")]]
      ) [
        if block.rendering /= Default && block.start == block.end then
          i [class "far fa-exclamation-triangle", style [("font-size", "10px")]] []
        else
          text (String.slice block.start block.end line.raw)
      ]
    ) line.blocks
  )

computeLineBackground: List LineBlock -> String
computeLineBackground blocks =
  if List.length (blocks) > 1
    then
      if List.isEmpty (List.filter (\block -> block.rendering == Error) blocks)
        then "rgba(255, 165, 0, 0.2)"
        else "rgba(255, 0, 0, 0.2)"
    else "white"

renderLine : Model -> Line -> Bool -> Html Message
renderLine model line showLineNumbers =
  div [
    id ("l_" ++ (toString line.number)),
    style [
      ("display", "flex"),
      ("align-items", "flex-start"),
      ("flex-shrink", "0"),
      ("background-color", computeLineBackground line.blocks)
    ]
  ]
  [
    span [
      style [
        ("font-size", "8px"),
        ("padding-top", "2px")
      ]]
      [
        if showLineNumbers == True
          then text (parseIndexWithLeadingZero line.number)
          else text ""
      ],

    span [
      style [
        ("width", "10px"),
        ("height", "1px"),
        ("flex-shrink", "0")
      ]] [],

    renderLineBlocks model line
  ]


renderRawInvoice : Model -> Language -> Bool -> List Line -> String -> Html Message
renderRawInvoice model language showLineNumbers lines raw  =
  div [style [
    ("display", "flex"),
    ("flex-direction", "column"),
    ("flex-grow", "1"),
    ("flex-shrink", "0"),
    ("flex-basis", "0"),
    ("align-items", "stretch")
  ]]
  [
    div [
      id "lines",
      style [
        ("display", "flex"),
        ("position", "relative"),
        ("flex-direction", "column"),
        ("flex-grow", "1"),
        ("flex-basis", "0"),
        ("flex-shrink", "0"),
        ("align-items", "stretch"),
        ("background-color", "#fff"),
        ("border-radius", "10px 0px 0px 10px"),
        ("overflow-y", "auto"),
        ("font-size", "10px"),
        ("padding", "0.5em"),
        ("color", "black")
      ]
    ]
    (
      List.map (\line -> (renderLine model line showLineNumbers) ) lines
    ),
    div [
      style [
        ("display", "flex"),
        ("justify-content", "flex-end"),
        ("margin-top", "5px"),
        ("gap", "10px")
      ]
    ]
    [
      div [
        class "button",
        style [
          ("display", "flex"),
          ("justify-content", "center"),
          ("align-items", "center"),
          ("cursor", "pointer"),
          ("padding", "0.5em 1em 0.5em 1em"),
          ("color", "#fff"),
          ("border-radius", "10px")
        ],
        onClick (RawInvoiceToCliboardCopied raw)
      ]
      [
        if (model.copiedToClipboard) 
        then img [src "./static/img/light-green-check.svg", style [("width", "14.5px")]] []
        else text (t language RCopyClipboard)
      ],
      div [
        class "button",
        style [
          ("display", "flex"),
          ("justify-content", "center"),
          ("align-items", "center"),
          ("cursor", "pointer"),
          ("padding", "0.5em 1em 0.5em 1em"),
          ("color", "#fff"),
          ("border-radius", "10px")
        ],
        onClick (RawInvoiceDownloaded raw)
      ]
      [
        text (t language RDownloadRaw)
      ]
    ]
  ]

renderContent : Model -> Language -> Bool -> String -> List Backend.WebService.ValidationError -> Html Message
renderContent model language showLineNumbers raw validations =
  div [
    id "validation"
  ]
  (
    let
      lines = computeLines raw validations
    in (
      let allLines = List.append lines (computeExtraLines lines validations)
      in ([
        renderRawInvoice model language showLineNumbers allLines (String.join "\n" (List.map (\line -> line.raw ) lines)),
        renderValidationErrors model language allLines validations
      ])
    )
  )

view : Model -> Language -> Bool -> Backend.WebService.Decoding -> Backend.WebService.Validation -> Html Message
view model language showLineNumbers decoding validation =
  case decoding.error of
    Nothing ->
      case validation.error of
        Nothing ->
          case validation.validations of
            Nothing -> renderSpinner language
            Just validations ->
              case decoding.raw of
                Nothing -> div [] []
                Just raw -> renderContent model language showLineNumbers raw validations
        Just err ->
            renderError err language
    Just err ->
        renderError err language
