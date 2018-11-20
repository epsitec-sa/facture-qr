module Components.QrImage exposing (..)
import Backend.WebService exposing (..)
import Components.QrHelpers exposing (..)
import Translations.Languages exposing (Language)

import Html exposing (..)
import Html.Attributes exposing (..)


renderImage : String -> Html a
renderImage image =
  div [style [
    ("display", "flex"),
    ("flex-grow", "3"),
    ("flex-basis", "0"),
    ("flex-shrink", "0")
    ]]
  [
    div [style [
      ("display", "flex"),
      ("align-items", "center")
      ]]
    [
      img [src ("data:image/png;base64," ++ image), style [("width", "100%")]] []
    ]
  ]

renderActions : Html a
renderActions =
  div [style [
    ("display", "flex"),
    ("flex-grow", "1"),
    ("flex-basis", "0"),
    ("flex-shrink", "0")
    ]]
  []

renderContent : Language -> String -> Html a
renderContent language img =
  div [style [
    ("display", "flex"),
    ("flex-grow", "1"),
    ("flex-basis", "0"),
    ("align-items", "stretch"),
    ("padding", "1.5em")]
  ] [
    renderImage img,
    renderActions
  ]

view : Language -> Backend.WebService.Decoding -> Backend.WebService.Generation -> Html a
view language decoding generation =
  case decoding.error of
    Nothing ->
      case generation.error of
        Nothing ->
          case generation.image of
            Nothing -> renderSpinner language
            Just img -> renderContent language img
        Just err ->
            renderError err language
    Just err ->
        renderError err language
