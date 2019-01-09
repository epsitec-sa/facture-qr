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

prettifyTransactionType : Language -> String -> Html a
prettifyTransactionType language value =
  case value of
    "B" -> text (t language RBills)
    "R" -> text (t language RReminders)
    _ -> text ""

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

renderTitle : Language -> Int -> String -> Html a
renderTitle language index procType =
  div [style [
    ("display", "flex"),
    ("padding", "0.2em 0.2em 1.0em 0.2em")
    ]]
    [
      div [
        style [
          ("font-size", "14px"),
          ("font-weight", "bold"),
          ("padding", "0 0.1em")
        ]
      ]
      [
        text ((t language RAlternativeProcedure)++" "++ toString index++ " ("++procType++")")
      ]
    ]

renderRawLine : Language -> String -> Html a
renderRawLine language raw =
  div [style [
    ("display", "flex"),
    ("padding", "0.2em 0.2em 0.5em 0.2em")
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



renderEBillTable : Language -> EBillProcedure -> Int -> Html a
renderEBillTable language payload index =
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
    renderTitle language index "eBill",
    renderRawLine language payload.raw,
    renderTableLine language RTransactionType payload.transactionType True prettifyTransactionType,
    renderTableLine language RBusinessCaseDate payload.businessCaseDate False prettifyDate,
    renderTableLine language RDueDate payload.dueDate True prettifyDate,
    renderTableLine language RReferenceNumber payload.referenceNumber False prettifyDefault,
    renderTableLine language RPayableAmountCanBeModified payload.payableAmountCanBeModified True prettifyBool,
    renderTableLine language RBillerID payload.billerID False prettifyDefault,
    renderTableLine language REmailAddress payload.emailAddress True prettifyDefault,
    renderTableLine language RBillRecipientID payload.billRecipientID False prettifyDefault,
    renderTableLine language RReferencedBill payload.referencedBill True prettifyDefault
  ]


renderProcedure : Language -> AlternativeProcedure -> Int -> Html a
renderProcedure language procedure index =
  case procedure.error of
          Nothing ->
            case procedure.payload of
              Nothing -> renderSpinner language
              Just payload -> 
                div [style [
                  ("display", "flex"),
                  ("flex-shrink", "0"),
                  ("align-items", "stretch"),
                  ("padding", "1.5em 1.5em 0em 1.5em")]
                ] [
                  case payload of
                    Default _ -> div [][]
                    EBill eBill -> renderEBillTable language eBill index
                ]
          Just err ->
              renderError err language
  

view : Language -> Backend.WebService.Decoding -> Backend.WebService.AlternativeProcedure -> Backend.WebService.AlternativeProcedure -> Html a
view language decoding procedure1 procedure2 =
  case decoding.error of
    Nothing ->
      div [style [
        ("display", "flex"),
        ("flex-direction", "column"),
        ("flex-grow", "1"),
        ("flex-basis", "0"),
        ("align-items", "stretch"),
        ("overflow-y", "auto"),
        ("padding", "0em 0em 1.5em 0em")]
      ] [
        renderProcedure language procedure1 1,
        renderProcedure language procedure2 2
      ]
      
    Just err ->
        renderError err language
