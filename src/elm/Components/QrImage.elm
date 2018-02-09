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
    ("justify-content", "flex-end"),
    ("margin-right", "3em"),
    ("align-items", "center")
    ]]
  [
    img [src ("data:image/png;base64," ++ image), style [("width", "60%")]] []
  ]


view : Language -> Backend.WebService.Generation -> Html a
view language generation =
  div [style [
    ("display", "flex"),
    ("flex-grow", "1"),
    ("justify-content", "center"),
    ("align-items", "stretch")]
  ] [
    case generation.error of
      Nothing ->
        case generation.image of
          Nothing -> renderSpinner language
          Just img -> renderImage img
      Just err ->
          renderError err language
  ]
