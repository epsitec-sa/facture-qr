port module Ports exposing (..)
import FileReader exposing (..)

type alias BinaryFile = {
  fileName: String,
  content: FileReader.FileContentArrayBuffer
}

type alias EncodedFile =
  { content : String
  , fileName : String
  }

type alias UrlParam = {
  name: String,
  value: Maybe String
}

port binaryFileRead : BinaryFile -> Cmd msg

port fileBase64Encoded : (EncodedFile -> msg) -> Sub msg

port title : String -> Cmd msg

port scrollTo : (String, String) -> Cmd msg

port getUrlParams : List String -> Cmd msg

port urlParamReceived : (UrlParam -> msg) -> Sub msg

port downloadFile : (String, String, String) -> Cmd msg