module Components.QrHelpers exposing (..)
import Backend.WebService exposing (..)
import Translations.Languages exposing (t, Language)
import Translations.Resources exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


renderSpinner : Language -> Html a
renderSpinner language =
  div [style [
    ("display", "flex"),
    ("flex-grow", "1"),
    ("flex-direction", "column"),
    ("align-items", "center"),
    ("justify-content", "center")
    ]]
  [
    div [style [("margin-bottom", "4em")]]
    [
      text (t language RWaiting)
    ],
    div [style [
     ("display", "flex"),
     ("flex-direction", "column"),
     ("align-items", "center"),
     ("justify-content", "center")
     ]]
    [
      i [class "fas fa-spinner fa-spin", style [("font-size", "40px")]] []
    ]
  ]



renderError : Backend.WebService.Error -> Language -> Html a
renderError err language =
  div [style [
    ("display", "flex"),
    ("flex-grow", "1"),
    ("justify-content", "center"),
    ("align-items", "center")]
  ] [
    div [style [
    ("color", "#0d4c80"),
    ("background-color", "rgba(255, 255, 255, 0.5)"),
    ("padding", "1em 2em"),
    ("border-radius", "5px")]
    ] [
      text (Backend.WebService.prettifyError err language)
    ]
  ]
