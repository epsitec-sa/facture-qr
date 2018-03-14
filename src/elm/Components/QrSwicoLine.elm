module Components.QrSwicoLine exposing (..)
import Backend.WebService exposing (..)
import Components.QrHelpers exposing (..)
import Translations.Languages exposing (t, Language)
import Translations.Resources exposing (..)

import Html exposing (..)
import Date exposing (..)
import Date.Format exposing (..)
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

--prettifyDate : String -> Html a
--prettifyDate date =
--  case Date.fromString date of
--    Ok value -> text (Date.Format.format "%d.%m.%Y" value)
--    Err err -> text ""
prettifyDate : String -> Html a
prettifyDate date =
  text ((String.slice 4 6 date)++"."++(String.slice 2 4 date)++"."++(String.slice 0 2 date))


prettifyUid : String -> Html a
prettifyUid date =
  text ("UID CHE-"++(String.slice 0 3 date)++"."++(String.slice 3 6 date)++"."++(String.slice 6 9 date))

prettifyDefault : String -> Html a
prettifyDefault value =
  text value

prettifyDetails : String -> Html a
prettifyDetails value =
  div[style [("display", "flex"), ("flex-direction", "column")]]
  (
    List.map (\detail ->
      let (details) = String.split ":" detail
      in (
        case details of
          x::xs -> case xs of
            y::ys -> div[] [text (x++"% sur "++y++" CHF")]
            [] -> text ""
          [] -> text ""
      )
    ) (String.split ";" value)
  )

prettifyConditions : String -> Html a
prettifyConditions value =
  div[style [("display", "flex"), ("flex-direction", "column")]]
  (
    List.map (\detail ->
      let (details) = String.split ":" detail
      in (
        case details of
          x::xs -> case xs of
            y::ys -> div[] [text (x++"% d'escompte à "++y++" jours")]
            [] -> text ""
          [] -> text ""
      )
    ) (String.split ";" value)
  )


renderTableLine : Language -> String -> Resource -> String -> Bool -> (String -> Html a) -> Html a
renderTableLine language tag title value dark prettifyFunc =
  div [style (
    List.append [
    ("display", "flex"),
    ("padding", "0.2em")
    ]
    (if dark == True then
      [("background-color", "#CCC")]
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
      prettifyFunc value
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
    renderTableLine language "S1" RPrefix payload.prefix False prettifyDefault,
    renderTableLine language "/10/" RDocumentReference payload.documentReference True prettifyDefault,
    renderTableLine language "/11/" RDocumentDate payload.documentDate False prettifyDate,
    renderTableLine language "/20/" RCustomerReference payload.customerReference True prettifyDefault,
    renderTableLine language "/30/" RVatNumber payload.vatNumber False prettifyUid,
    renderTableLine language "/31/" RVatDates payload.vatDates True prettifyDate,
    renderTableLine language "/32/" RVatDetails payload.vatDetails False prettifyDetails,
    renderTableLine language "/33/" RVatImportTax payload.vatImportTax True prettifyDefault,
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
