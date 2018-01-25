{-module Components.QrCode exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import DropZone exposing (DropZoneMessage(Drop), dropZoneEventHandlers, isHovering)
import FileReader exposing (Error(..), FileRef, NativeFile, readAsTextFile)
import Task
import Debug

type alias Model =
    { message : String
    , dropZone :
        DropZone.Model

    -- store the DropZone model in your apps Model
    , files : List NativeFile
    , contents : List String
    }


init : Model
init =
    { message = "Waiting..."
    , dropZone =
        DropZone.init

    -- call DropZone.init to initialize
    , files = []
    , contents = []
    }

type Message
    = DnD (DropZone.DropZoneMessage (List NativeFile))
      -- add an Message that takes care of hovering, dropping etc
    | FileReadSucceeded String
    | FileReadFailed FileReader.Error


update : Message -> Model -> ( Model, Cmd Message )
update message model =
    case message of
        DnD (Drop files) ->
            Debug.log "dfdfdfdfdf"
            -- this happens when the user dropped something into the dropzone
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
                List.map (readTextFile << .blob) files
            )

        DnD a ->
            Debug.log "aaaaaaaa"
            -- these are opaque DropZone messages, just hand them to DropZone to deal with them
            ( { model | dropZone = DropZone.update a model.dropZone }
            , Cmd.none
            )

        FileReadSucceeded str ->
            Debug.log "wwwwwwwwwwwwwww"
            -- this happens when an effect has finished and the file has successfully been loaded
            ( { model
                | contents = str :: model.contents
                , message = "Successfully loaded at least one file"
              }
            , Cmd.none
            )

        FileReadFailed err ->
            Debug.log "xxxxxxxxxxxxxxxxxx"
            -- this happens when an effect has finished and there was an error loading hte file
            ( { model | message = FileReader.prettyPrint err }
            , Cmd.none
            )



readTextFile : FileRef -> Cmd Message
readTextFile fileValue =
    readAsTextFile fileValue
        |> Task.attempt
            (\res ->
                case res of
                    Ok val ->
                        FileReadSucceeded val

                    Err error ->
                        FileReadFailed error
            )




-- qrCode component
qrCode : () -> Html Message
qrCode () =
  div [style [("width", "200px")
  , ("height", "200px")
  , ("background-color", "gray")
  , ("display", "flex")
  , ( "align-items", "center" )
  , ("justify-content", "center")]
  ] [
      text ( "Please drop your QR Code here" ),
      renderDropZone ()
  ]


renderDropZone : () -> Html Message
renderDropZone () =
    Html.map DnD
        (div (dropZoneEventHandlers FileReader.parseDroppedFiles) [])
-}
