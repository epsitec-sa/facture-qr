module Backend.Prettify exposing (..)
import Translations.Languages exposing (t, Language)
import Translations.Resources exposing (..)

import Html exposing (..)

--prettifyDate : String -> Html a
--prettifyDate date =
--  case Date.fromString date of
--    Ok value -> text (Date.Format.format "%d.%m.%Y" value)
--    Err err -> text ""
prettifyDate : Language -> String -> Html a
prettifyDate language date =
  if String.length date == 6 then
    case String.toInt date of
      Err msg -> text ""
      Ok val -> text ((String.slice 4 6 date)++"."++(String.slice 2 4 date)++"."++(String.slice 0 2 date))
  else
    text ""


prettifyBool : Language -> String -> Html a
prettifyBool language value =
  case String.toLower value of
    "true" -> text (t language RYes)
    "false" -> text (t language RNo)
    _ -> text ""


prettifyUid : Language -> String -> Html a
prettifyUid language uid =
  if String.length uid == 9 then
    case String.toInt uid of
      Err msg -> text ""
      Ok val -> text ("UID CHE-"++(String.slice 0 3 uid)++"."++(String.slice 3 6 uid)++"."++(String.slice 6 9 uid))
  else
    text ""


prettifyDefault : Language -> String -> Html a
prettifyDefault language value =
  text value
