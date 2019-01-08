module Components.QrAlternativeProcedures exposing (..)
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



renderTableLine : Language -> Resource -> String -> Bool -> (Language -> String -> Html a) -> Html a
renderTableLine language title value dark prettifyFunc =
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
    div [style (cellStyle "3" "bold")]
    [
      text (t language title)
    ],
    div [style (cellStyle "2" "bold")]
    [
      prettifyFunc language value
    ]
  ]

renderRawLine : Language -> String -> Html a
renderRawLine language raw =
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
        text (raw)
      ]
    ]



renderEBillTable : Language -> EBillProcedure -> Html a
renderEBillTable language payload =
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
    renderRawLine language payload.raw,
    renderTableLine language RBusinessCaseDate payload.businessCaseDate False prettifyDate,
    renderTableLine language RDueDate payload.dueDate True prettifyDate,
    renderTableLine language RReferenceNumber payload.referenceNumber False prettifyDefault,
    renderTableLine language RPayableAmountCanBeModified payload.payableAmountCanBeModified True prettifyBool,
    renderTableLine language RBillerID payload.billerID False prettifyDefault,
    renderTableLine language REmailAddress payload.emailAddress True prettifyDefault,
    renderTableLine language RBillRecipientID payload.billRecipientID False prettifyDefault,
    renderTableLine language RReferencedBill payload.referencedBill False prettifyDefault
  ]


renderContent : Language -> AlternativeProcedurePayload -> Html a
renderContent language payload =
  div [style [
    ("display", "flex"),
    ("flex-grow", "1"),
    ("flex-basis", "0"),
    ("align-items", "stretch"),
    ("padding", "1.5em")]
  ] [
    case payload of
      Default _ -> div [][]
      EBill eBill -> renderEBillTable language eBill
  ]

view : Language -> Backend.WebService.Decoding -> Backend.WebService.AlternativeProcedure -> Backend.WebService.AlternativeProcedure -> Html a
view language decoding procedure1 procedure2 =
  case decoding.error of
    Nothing ->
      case procedure1.error of
        Nothing ->
          case procedure1.payload of
            Nothing -> renderSpinner language
            Just payload -> renderContent language payload
        Just err ->
            renderError err language
    Just err ->
        renderError err language
