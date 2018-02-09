module Translations.FrCh exposing (..)
import Translations.Resources exposing (..)


t : Resource -> String
t resource =
  case resource of
    Title -> "Validateur de QR-code"
