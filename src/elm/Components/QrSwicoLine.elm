module Components.QrSwicoLine exposing (..)
import Backend.WebService exposing (..)
import Backend.Prettify exposing (..)
import Components.QrHelpers exposing (..)
import Translations.Languages exposing (t, Language)
import Translations.Resources exposing (..)

import Html exposing (..)
--import Date exposing (..)
--import Date.Format exposing (..)
import Html.Attributes exposing (..)

cellStyle : String -> String -> List (String, String)
cellStyle flexGrow fontWeight =
  [
    ("flex-grow", flexGrow),
    ("flex-basis", "0"),
    ("flex-shrink", "0"),
    ("min-width", "0"),
    ("word-wrap", "break-word"),
    ("font-weight", fontWeight),
    ("padding", "0 0.1em")
  ]

prettifyImportTax : String -> Language -> String -> Html a
prettifyImportTax currency language value =
  if String.contains ":" value then
    div[style [("display", "flex"), ("flex-direction", "column")]]
    (
      List.map (\detail ->
        let (details) = String.split ":" detail
        in (
          case details of
            x::xs -> case xs of
              y::ys -> case String.toFloat x of
                Err msg -> text ""
                Ok val -> case String.toFloat y of
                  Err msg -> text ""
                  Ok val -> div[] [text (y++" "++currency++" "++(t language RAtTax)++" "++x++"%")]
              [] -> text ""
            [] -> text ""
        )
      ) (String.split ";" value)
    )
  else
    case String.toFloat value of
      Err msg -> text ""
      Ok val -> text (value++"% "++(t language RImport))

prettifyDates : Language -> String -> Html a
prettifyDates language value =
  if String.length value == 6 then
    prettifyDate language value
  else if String.length value == 12 then
    div[][
      text ((t language RFrom)++" "),
      prettifyDate language (String.slice 0 6 value),
      text (" "++(t language RTo)++" "),
      prettifyDate language (String.slice 6 12 value)
    ]
  else
    text ""

prettifyDetails : String -> Language -> String -> Html a
prettifyDetails currency language value =
  if String.contains ":" value then
    div[style [("display", "flex"), ("flex-direction", "column")]]
    (
      List.map (\detail ->
        let (details) = String.split ":" detail
        in (
          case details of
            x::xs -> case xs of
              y::ys -> case String.toFloat x of
                Err msg -> text ""
                Ok val -> case String.toFloat y of
                  Err msg -> text ""
                  Ok val -> div[] [text (x++"% "++(t language ROn)++" "++y++" "++currency)]
              [] -> text ""
            [] -> text ""
        )
      ) (String.split ";" value)
    )
  else
    case String.toFloat value of
      Err msg -> text ""
      Ok val -> text (value++"% "++(t language RTotalBill))


prettifyConditions : Language -> String -> Html a
prettifyConditions language value =
  div[style [("display", "flex"), ("flex-direction", "column")]]
  (
    List.map (\detail ->
      let (details) = String.split ":" detail
      in (
        case details of
          x::xs -> case xs of
            y::ys -> case String.toFloat x of
              Err msg -> text ""
              Ok val -> case String.toInt y of
                Err msg -> text ""
                Ok val -> div[] [text (x++"% "++(t language RDiscount)++" "++y++" "++(t language RDays))]
            [] -> text ""
          [] -> text ""
      )
    ) (String.split ";" value)
  )


renderTableLine : Language -> String -> Resource -> String -> Bool -> (Language -> String -> Html a) -> Html a
renderTableLine language tag title value dark prettifyFunc =
  div [style (
    List.append [
    ("display", "flex"),
    ("padding", "0.2em")
    ]
    (if dark == True then
      [("background-color", "#EEE")]
    else
      []
    )
  )]
  [
    div [
      style (
        List.append
          (cellStyle "0.4" "normal")
          [
            ("display", "flex"),
            ("justify-content", "center")
          ]
      )
    ]
    [
      text (tag)
    ],
    div [style (cellStyle "2" "bold")]
    [
      text (t language title)
    ],
    div [style (cellStyle "1" "normal")]
    [
      text (value)
    ],
    div [style (cellStyle "2" "bold")]
    [
      prettifyFunc language value
    ]
  ]

renderRawLine : Language -> SwicoPayload -> Html a
renderRawLine language payload =
  div [style [
    ("display", "flex"),
    ("padding", "0.2em 0.2em 1.0em 0.2em")
    ]]
    [
      div [style (cellStyle "0.6" "bold")]
      [
        text (t language RRaw)
      ],
      div [style (cellStyle "4.8" "normal")]
      [
        text (payload.raw)
      ]
    ]



renderTable : Language -> SwicoPayload -> Html a
renderTable language payload =
  div [style [
    ("display", "flex"),
    ("flex-direction", "column"),
    ("flex-grow", "1"),
    ("flex-basis", "0"),
    ("flex-shrink", "0"),
    ("background-color", "white"),
    ("border-radius", "15px"),
    ("color", "black"),
    ("padding", "2.5em 1.5em 1.5em 1.5em"),
    ("font-size", "12px")
    ]]
  [
    renderRawLine language payload,
    renderTableLine language "S1" RPrefix payload.prefix False prettifyDefault,
    renderTableLine language "/10/" RDocumentReference payload.documentReference True prettifyDefault,
    renderTableLine language "/11/" RDocumentDate payload.documentDate False prettifyDate,
    renderTableLine language "/20/" RCustomerReference payload.customerReference True prettifyDefault,
    renderTableLine language "/30/" RVatNumber payload.vatNumber False prettifyUid,
    renderTableLine language "/31/" RVatDates payload.vatDates True prettifyDates,
    renderTableLine language "/32/" RVatDetails payload.vatDetails False (prettifyDetails payload.currency),
    renderTableLine language "/33/" RVatImportTax payload.vatImportTaxes True (prettifyImportTax payload.currency),
    renderTableLine language "/40/" RConditions payload.conditions False prettifyConditions
  ]


renderContent : Language -> SwicoPayload -> Html a
renderContent language payload =
  div [style [
    ("display", "flex"),
    ("flex-grow", "1"),
    ("flex-basis", "0"),
    ("align-items", "stretch"),
    ("padding", "1.5em")]
  ] [
    renderTable language payload
  ]

view : Language -> Backend.WebService.Decoding -> Backend.WebService.SwicoLine -> Html a
view language decoding swicoLine =
  case decoding.error of
    Nothing ->
      case swicoLine.error of
        Nothing ->
          case swicoLine.payload of
            Nothing -> renderSpinner language
            Just payload -> renderContent language payload
        Just err ->
            renderError err language
    Just err ->
        renderError err language
