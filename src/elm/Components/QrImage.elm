module Components.QrImage exposing (..)
import Backend.WebService exposing (..)
import Components.QrHelpers exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


renderImage : String -> Html a
renderImage image =
  img [src ("data:image/png;base64," ++ image), style [("width", "70%")]] []


render : Backend.WebService.Generation -> Html a
render generation =
  div [style [
    ("display", "flex"),
    ("flex-grow", "1"),
    ("justify-content", "center"),
    ("align-items", "center")]
  ] [
    case generation.error of
      Nothing ->
        case generation.image of
          Nothing -> renderSpinner
          Just img -> renderImage img
      Just err ->
          renderError err
  ]
