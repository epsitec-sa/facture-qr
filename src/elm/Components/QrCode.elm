module Components.QrCode exposing (..)
import Components.QrHelpers exposing (..)
import Components.QrImage exposing (..)
import Components.QrValidation exposing (..)
import Backend.Ports exposing (..)
import Backend.WebService exposing (..)
import Backend.Errors exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import DropZone exposing (DropZoneMessage(Drop), dropZoneEventHandlers, isHovering)
import FileReader exposing (Error(..), FileRef, NativeFile, readAsArrayBuffer, readAsTextFile)
import Task
import Http
import Json.Encode
import Debug

type Tabs = Validation | Image


type alias Model =
    {
      webService : Backend.WebService.Model
    , qrValidation : Components.QrValidation.Model
    , dropZone : DropZone.Model
    , tabs : Tabs
    , files : List NativeFile
    }


init : Model
init =
    {
    webService = Backend.WebService.init
    , qrValidation =  Components.QrValidation.init
    , dropZone = DropZone.init
    , tabs = Validation
    , files = []
    }




type Message
    = DnD (DropZone.DropZoneMessage (List NativeFile))
      -- add an Message that takes care of hovering, dropping etc
    | FileReadSucceeded BinaryFile
    | FileReadFailed FileReader.Error
    | FileBase64Encoded EncodedFile

    | FileDecoded (Result Http.Error String)
    | InvoiceValidated (Result Http.Error String)
    | InvoiceGenerated (Result Http.Error String)
    | TabsChanged Tabs
    | QrValidationMessage Components.QrValidation.Message


update : Message -> Model -> ( Model, Cmd Message )
update message model =
    case message of
        TabsChanged tabs -> ( { model | tabs = tabs }, Cmd.none)

        DnD (Drop files) ->
            -- this happens when the user dropped something into the dropzone
            if List.length files == 1 then
              ( { model
                  | dropZone =
                      DropZone.update (Drop files) model.dropZone

                  -- update the DropZone model
                  , files = files
                  , webService = Backend.WebService.init
                  -- and store the dropped files
                }
              , Cmd.batch <|
                  -- also create a bunch of effects to read the files as text, one effect for each file
                  List.map (readBinaryFile) files
              )
            else
              ( { model | webService = Backend.WebService.setNewError model.webService Backend.Errors.MultipleFilesDropped }
              , Cmd.none )

        DnD a ->
            -- these are opaque DropZone messages, just hand them to DropZone to deal with them
            ( { model | dropZone = DropZone.update a model.dropZone }, Cmd.none)

        FileReadSucceeded file ->
          ( model, binaryFileRead file)

        FileReadFailed err ->
            Debug.log (FileReader.prettyPrint err)
            -- this happens when an effect has finished and there was an error loading hte file
            ( model, Cmd.none)

        FileBase64Encoded file ->
            -- this happens when an effect has finished and the file has successfully been loaded
            ( model ,
              Http.send FileDecoded (put "decode" (Http.jsonBody <| (Json.Encode.object [
                  ("fileName", Json.Encode.string file.fileName),
                  ("content", Json.Encode.string file.content)
                ])))
            )

        FileDecoded (Ok str) ->
          case  Backend.WebService.decodeError str of
            Ok wsErr ->
              ( { model | webService = Backend.WebService.setDecodingError model.webService wsErr }, Backend.WebService.debug (wsErr))
            Err msg -> -- It is not a webservice error, so it must be the expected result
              ( { model | webService = Backend.WebService.setRaw model.webService str },
                Cmd.batch <| [
                  Http.send InvoiceValidated (put "validate" (Http.stringBody "text/plain" str)),
                  Http.send InvoiceGenerated (put "generate/fr-ch" (Http.stringBody "text/plain" str))
                ]
              )

        FileDecoded (Err err) ->
          Debug.log (httpErrorString err)
          ({ model | webService = Backend.WebService.setNewError model.webService Backend.Errors.NetworkError }, Cmd.none)


        InvoiceValidated (Ok str) ->
          case  Backend.WebService.decodeError str of
            Ok wsErr ->
              ( { model | webService = Backend.WebService.setValidationsError model.webService wsErr }, Backend.WebService.debug (wsErr))
            Err msg -> -- It is not a webservice error, so it must be the expected result
              case Backend.WebService.decodeValidationErrors str of
                Ok validations ->
                  ( { model | webService = Backend.WebService.setValidations model.webService validations }, Cmd.none)
                Err err ->
                  Debug.log (err)
                  ({ model | webService = Backend.WebService.setNewError model.webService Backend.Errors.NetworkError }, Cmd.none)


        InvoiceValidated (Err err) ->
          Debug.log (httpErrorString err)
          ({ model | webService = Backend.WebService.setNewError model.webService Backend.Errors.NetworkError }, Cmd.none)


        InvoiceGenerated (Ok str) ->
          case  Backend.WebService.decodeError str of
            Ok wsErr ->
              ( { model | webService = Backend.WebService.setGenerationError model.webService wsErr }, Backend.WebService.debug (wsErr))
            Err msg -> -- It is not a webservice error, so it must be the expected result
              ( { model | webService = Backend.WebService.setImage model.webService str }, Cmd.none)


        InvoiceGenerated (Err err) ->
          Debug.log (httpErrorString err)
          ({ model | webService = Backend.WebService.setNewError model.webService Backend.Errors.NetworkError }, Cmd.none)

        QrValidationMessage qrValidationMsg ->
          let
            ( updatedQrValidationModel, qrValidationCmd ) =
              Components.QrValidation.update qrValidationMsg model.qrValidation
          in
            ( { model | qrValidation = updatedQrValidationModel }, Cmd.map QrValidationMessage qrValidationCmd )



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




-- qrCode component
view : Model -> Html Message
view model =
    (div (renderZoneAttributes model.dropZone) [
      if List.length model.files > 0 then
        case model.webService.error of
          Nothing ->
              renderTabs model
          Just err ->
              renderError err
      else
        renderEmptyDropZone
    ])

renderTabs : Model -> Html Message
renderTabs model =
  div [style [
    ("display", "flex"),
    ("flex-grow", "1"),
    ("flex-direction", "column"),
    ("align-items", "stretch"),
    ("justify-content", "flex-start")
  ]]
  [
    div [style [ -- tabs
      ("display", "flex"),
      ("height", "50px"),
      ("align-items", "flex-start"),
      ("justify-content", "flex-start"),
      ("margin-left", "2em")
    ]]
    [
      renderTab model Validation "Validation",
      renderTab model Image "Qr Invoice"
    ],
    case model.tabs of
      Validation ->
        Html.map QrValidationMessage (Components.QrValidation.view model.qrValidation model.webService.decoding model.webService.validation)
      Image ->
        Components.QrImage.render model.webService.generation
  ]

renderTab : Model -> Tabs -> String -> Html Message
renderTab model tab str =
  div [
    class "qrTab",
    style (
      if (model.tabs == tab) then
        ("background-color", "#ccc") :: baseTabStyle
      else
        baseTabStyle
    ),
    onClick (TabsChanged tab)
    ]
    [
      text str
    ]


renderEmptyDropZone : Html a
renderEmptyDropZone =
  div [style [
    ("display", "flex"),
    ("flex-grow", "1"),
    ("flex-direction", "column"),
    ("align-items", "center"),
    ("justify-content", "flex-start"),
    ("padding-top", "3em")
    ]]
    [div [] [text "Drop your code or your QR code here without fear."],
     div [] [text "We will validate it very carefully ;-)"],
     img [src "./static/img/parachute.svg", style [("width", "30%"), ("margin-top", "2em")]] []
    ]


renderZoneAttributes : DropZone.Model -> List (Html.Attribute (Message))
renderZoneAttributes dropZoneModel =
    baseDropStyle ::
    (if DropZone.isHovering dropZoneModel then
        dropZoneHover
        -- style the dropzone differently depending on whether the user is hovering
     else
        dropZoneDefault
    )
        :: -- add the necessary DropZone event wiring
            (List.map (\msg -> Html.Attributes.map DnD msg) <| dropZoneEventHandlers FileReader.parseDroppedFiles)


dropZoneDefault : Html.Attribute a
dropZoneDefault =
    style [( "border", "2px dashed #333" )]


dropZoneHover : Html.Attribute a
dropZoneHover =
    style [( "border", "2px dashed red" )]

baseDropStyle : Html.Attribute a
baseDropStyle =
    style
        [ ("display", "flex")
        , ("flex-grow", "1")
        , ("height", "calc(60vh)")
        , ("background-size", "25%")
        , ("background", "#333")
        , ("color", "#fff")
        , ( "border-radius", "10px" )]

baseTabStyle : List (String, String)
baseTabStyle = [
    ("cursor", "pointer"),
    ("padding", "0.5em 1em 0.5em 1em"),
    ("color", "#fff"),
    ("border-bottom-left-radius", "10px"),
    ("border-bottom-right-radius", "10px"),
    ("margin-right", "4px"),
    ("margin-left", "4px"),
    ("margin-top", "-2px")
  ]


subscriptions : Model -> Sub Message
subscriptions model =
  fileBase64Encoded FileBase64Encoded
