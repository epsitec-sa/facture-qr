module Components.QrCode exposing (..)
import Components.Ports exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import DropZone exposing (DropZoneMessage(Drop), dropZoneEventHandlers, isHovering)
import FileReader exposing (Error(..), FileRef, NativeFile, readAsArrayBuffer, readAsTextFile)
import Task
import Http
import Json.Encode

type alias Model =
    { message : String
    , dropZone :
        DropZone.Model

    -- store the DropZone model in your apps Model
    , files : List NativeFile
    }


init : Model
init =
    { message = "Waiting..."
    , dropZone =
        DropZone.init

    -- call DropZone.init to initialize
    , files = []
    }




type Message
    = DnD (DropZone.DropZoneMessage (List NativeFile))
      -- add an Message that takes care of hovering, dropping etc
    | FileReadSucceeded BinaryFile
    | FileReadFailed FileReader.Error
    | FileEncoded EncodedFile
    | FileValidated (Result Http.Error String)


update : Message -> Model -> ( Model, Cmd Message )
update message model =
    case message of
        DnD (Drop files) ->
            -- this happens when the user dropped something into the dropzone
            if List.length files == 1 then
              ( { model
                  | dropZone =
                      DropZone.update (Drop files) model.dropZone

                  -- update the DropZone model
                  , files =
                      files

                  -- and store the dropped files
                }
              , Cmd.batch <|
                  -- also create a bunch of effects to read the files as text, one effect for each file
                  List.map (readBinaryFile) files
              )
            else
              ( {model
              | message = "Please do not drop more than one file"}
              , Cmd.none )

        DnD a ->
            -- these are opaque DropZone messages, just hand them to DropZone to deal with them
            ( { model | dropZone = DropZone.update a model.dropZone }
            , Cmd.none
            )

        FileReadSucceeded file ->
          ( model
          , binaryFileRead file
          )

        FileReadFailed err ->
            -- this happens when an effect has finished and there was an error loading hte file
            ( { model | message = FileReader.prettyPrint err }
            , Cmd.none
            )
        FileEncoded file ->
            -- this happens when an effect has finished and the file has successfully been loaded
            ( model ,
              Http.send FileValidated (put file)
            )

        FileValidated (Ok str) ->
          ({ model | message = str }, Cmd.none)

        FileValidated (Err err) ->
          ({ model | message = httpErrorString err }, Cmd.none)



readBinaryFile : NativeFile -> Cmd Message
readBinaryFile file =
    readAsArrayBuffer file.blob
        |> Task.attempt
            (\res ->
                case res of
                    Ok val ->
                        FileReadSucceeded {
                          fileName = file.name,
                          content = val
                        }

                    Err error ->
                        FileReadFailed error
            )

put : String -> Http.Body -> Http.Request String
put route body =
  Http.request
    { method = "PUT"
    , headers = []
    , url = "http://127.0.0.1:6482/" ++ route
    , body = body
    , expect = Http.expectString
    , timeout = Nothing
    , withCredentials = False
    }


httpErrorString : Http.Error -> String
httpErrorString error =
    case error of
        Http.BadUrl text ->
            "Bad Url: " ++ text
        Http.Timeout ->
            "Http Timeout"
        Http.NetworkError ->
            "Network Error"
        Http.BadStatus response ->
            "Bad Http Status: " ++ toString response.status.code
        Http.BadPayload message response ->
            "Bad Http Payload: "
                ++ toString message
                ++ " ("
                ++ toString response.status.code
                ++ ")"








-- qrCode component
view : Model -> Html Message
view model =
  Html.map DnD
      (div (renderZoneAttributes model.dropZone) [
        text ( "Please drop your QR Code here" )
      ])


renderZoneAttributes :
    DropZone.Model
    -> List (Html.Attribute (DropZoneMessage (List NativeFile)))
renderZoneAttributes dropZoneModel =
    baseDropStyle ::
    (if DropZone.isHovering dropZoneModel then
        dropZoneHover
        -- style the dropzone differently depending on whether the user is hovering
     else
        dropZoneDefault
    )
        :: -- add the necessary DropZone event wiring
           dropZoneEventHandlers FileReader.parseDroppedFiles


dropZoneDefault : Html.Attribute a
dropZoneDefault =
    style [( "border", "3px dashed steelblue" )]


dropZoneHover : Html.Attribute a
dropZoneHover =
    style [( "border", "3px dashed red" )]

baseDropStyle : Html.Attribute a
baseDropStyle =
    style
        [("width", "200px")
        , ("height", "200px")
        , ("background-color", "gray")
        , ("display", "flex")
        , ( "align-items", "center" )
        , ("justify-content", "center")]


subscriptions : Model -> Sub Message
subscriptions model =
  fileBase64Encoded FileBase64Encoded
