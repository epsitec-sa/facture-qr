module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
{-import DropZone exposing (DropZoneMessage(Drop), dropZoneEventHandlers, isHovering)
import FileReader exposing (Error(..), FileRef, NativeFile, readAsArrayBuffer, readAsTextFile)
import Task-}

-- APP
main : Program Never Model Msg
main =
    Html.program
        { init = ( init, Cmd.none )
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }


-- MODEL
type alias Model =
    {
      message : String
    }
        {-, dropZone :
            DropZone.Model

        -- store the DropZone model in your apps Model
        , files : List NativeFile-}

init : Model
init =
    {
      message = "Waiting..."
    }
    {-, dropZone =
        DropZone.init

    -- call DropZone.init to initialize
    , files = []-}

-- UPDATE

type Msg
    = Clicked
      {-DnD (DropZone.DropZoneMessage (List NativeFile))
      -- add an Message that takes care of hovering, dropping etc
    | FileReadSucceeded TextFile
    | FileReadFailed FileReader.Error-}


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        Clicked ->
          ( {model | message = "clicked!!"}, Cmd.none )
        {-DnD (Drop files) ->
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
                  List.map (readTextFile) files
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
          ( { model | message = file.fileName }
          , Cmd.none
          )

        FileReadFailed err ->
            -- this happens when an effect has finished and there was an error loading hte file
            ( { model | message = FileReader.prettyPrint err }
            , Cmd.none
            )-}


{-
readTextFile : NativeFile -> Cmd Msg
readTextFile file =
    readAsTextFile file.blob
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
-}


-- VIEW
-- Html is defined as: elem [ attribs ][ children ]
-- CSS can be applied via class names or inline style attrib
view : Model -> Html Msg
view model =
  div [][    -- inline CSS (literal)
    renderQrCode model
    , p [] [ text model.message ]
  ]


renderQrCode : Model -> Html Msg
renderQrCode model =
  div [baseDropStyle, onClick Clicked] [
    text ( "Please drop your QR Code here" )
  ]
{-
renderQrCode : Model -> Html Msg
renderQrCode model =
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
-}
baseDropStyle : Html.Attribute a
baseDropStyle =
    style
        [("width", "200px")
        , ("height", "200px")
        , ("background-color", "gray")
        , ("display", "flex")
        , ( "align-items", "center" )
        , ("justify-content", "center")]

{-
subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map QrCodeMessage (Components.QrCode.subscriptions model.qrCode) ]
-}
