module Components.QrHelpers exposing (..)
import Backend.WebService exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


renderSpinner : Html a
renderSpinner =
  div [style [
    ("display", "flex"),
    ("flex-grow", "1"),
    ("flex-direction", "column"),
    ("align-items", "center"),
    ("justify-content", "flex-start"),
    ("padding-top", "3em")
    ]]
  [
    div []
    [
      text "Waiting for generation..."],
      div [style [
       ("display", "flex"),
       ("flex-grow", "1"),
       ("flex-direction", "column"),
       ("align-items", "center"),
       ("justify-content", "center")
       ]]
    [
      i [class "fas fa-spinner fa-spin", style [("font-size", "40px")]] []
    ]
  ]



renderError : Backend.WebService.Error -> Html a
renderError err =
  div [style [("color", "red")]] [
    text (Backend.WebService.prettifyError err)
  ]
