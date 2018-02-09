module Translations.Languages exposing (..)
import Translations.Resources exposing (..)
import Translations.FrCh exposing (..)
import Translations.DeCh exposing (..)

type Language = SwissFrench | SwissGerman


t : Language -> Resource -> String
t language resource =
  case language of
    SwissFrench ->
      Translations.FrCh.t resource
    SwissGerman ->
      Translations.DeCh.t resource
