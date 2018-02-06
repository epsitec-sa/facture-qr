port module Components.Ports exposing (..)
import FileReader exposing (..)

type alias BinaryFile = {
  fileName: String,
  content: FileReader.FileContentArrayBuffer
}

type alias EncodedFile =
  { content : String
  , fileName : String
  }

port binaryFileRead : BinaryFile -> Cmd msg

port fileBase64Encoded : (EncodedFile -> msg) -> Sub msg