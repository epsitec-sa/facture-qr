module Components.QrSwicoLine exposing (..)
import Backend.WebService exposing (..)
import Components.QrHelpers exposing (..)
import Translations.Languages exposing (Language)

import Html exposing (..)
import Html.Attributes exposing (..)


renderPayload : Language -> SwicoPayload -> Html a
renderPayload language payload =
  div [style [
    ("display", "flex"),
    ("flex-grow", "2"),
    ("flex-basis", "0"),
    ("flex-shrink", "0")
    ]]
  [
    div [style [
      ("display", "flex"),
      ("align-items", "center")
      ]]
    [
    ]
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
    renderPayload language payload
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
