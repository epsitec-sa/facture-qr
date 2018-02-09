module Translations.DeCh exposing (..)
import Translations.Resources exposing (..)


t : Resource -> String
t resource =
  case resource of
    Title -> "QR-Code Validator"
