module Components.QrCode exposing (..)
import Components.QrHelpers exposing (..)
import Components.QrImage exposing (..)
import Components.QrValidation exposing (..)
import Components.QrSwicoLine exposing (..)
import Components.QrAlternativeProcedures exposing (..)
import Ports exposing (..)
import Backend.WebService exposing (..)
import Backend.Errors exposing (..)
import Translations.Languages exposing (t, Language)
import Translations.Resources exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import DropZone exposing (DropZoneMessage(Drop), dropZoneEventHandlers, isHovering)
import FileReader exposing (Error(..), FileRef, NativeFile, readAsArrayBuffer, readAsTextFile)
import Task
import Http
import Json.Encode
import Debug

type Tabs = Validation | Image | SwicoLine | AlternativeProcedures


type alias Model =
    {
      webService : Backend.WebService.Model
    , language : Language
    , showLineNumbers : Bool
    , qrValidation : Components.QrValidation.Model
    , dropZone : DropZone.Model
    , tabs : Tabs
    , files : List NativeFile
    }


init : Model
init =
    {
    webService = Backend.WebService.init
    , language = Translations.Languages.SwissFrench
    , showLineNumbers = True
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
    | SwicoExtracted (Result Http.Error String)
    | AlternativeProcedure1Extracted (Result Http.Error String)
    | AlternativeProcedure2Extracted (Result Http.Error String)
    | InvoiceGenerated (Result Http.Error String)
    | TabsChanged Tabs
    | QrValidationMessage Components.QrValidation.Message
    | LanguageChanged Language
    | LineNumbersShowed Bool
    | Back


update : Message -> Model -> ( Model, Cmd Message )
update message model =
    case message of
        TabsChanged tabs -> 
          let
            ( updatedQrValidationModel, qrValidationCmd ) =
              Components.QrValidation.update ResetCliboardCopy model.qrValidation
          in
            ( { model | tabs = tabs, qrValidation = updatedQrValidationModel }, Cmd.map QrValidationMessage qrValidationCmd )

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
            else if List.length files > 1 then
              ( { model | webService = Backend.WebService.setNewError model.webService Backend.Errors.MultipleFilesDropped }
              , Cmd.none )
            else
              ( model, Cmd.none )

        DnD a ->
            -- these are opaque DropZone messages, just hand them to DropZone to deal with them
            ( { model | dropZone = DropZone.update a model.dropZone }, Cmd.none)

        FileReadSucceeded file ->
          let
            ( updatedQrValidationModel, qrValidationCmd ) =
              Components.QrValidation.update ResetCliboardCopy model.qrValidation
          in
            ( { model | qrValidation = updatedQrValidationModel }, 
            Cmd.batch <| [
                  Cmd.map QrValidationMessage qrValidationCmd,
                  binaryFileRead file
                ]
             )

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
          case Backend.WebService.decodeError str of
            Ok wsErr ->
              ( { model | webService = Backend.WebService.setDecodingError model.webService wsErr }, Backend.WebService.debug (wsErr))
            Err msg -> -- It is not a webservice error, so it must be the expected result
              ( { model | webService = Backend.WebService.setRaw model.webService str },
                Cmd.batch <| [
                  Http.send InvoiceValidated (put "validate" (Http.stringBody "text/plain" str)),
                  Http.send SwicoExtracted (put "extractSwico" (Http.stringBody "text/plain" str)),
                  Http.send AlternativeProcedure1Extracted (put "extractAlternativeProcedure/1" (Http.stringBody "text/plain" str)),
                  Http.send AlternativeProcedure2Extracted (put "extractAlternativeProcedure/2" (Http.stringBody "text/plain" str)),
                  sendGenerate (Just str) model.language
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

        SwicoExtracted (Ok str) ->
          case  Backend.WebService.decodeError str of
            Ok wsErr ->
              ( { model | webService = Backend.WebService.setSwicoLineError model.webService wsErr }, Backend.WebService.debug (wsErr))
            Err msg -> -- It is not a webservice error, so it must be the expected result
              case Backend.WebService.decodeSwicoPayload str of
                Ok payload ->
                  ( { model | webService = Backend.WebService.setSwicoPayload model.webService payload }, Cmd.none)
                Err err ->
                  Debug.log (err)
                  ({ model | webService = Backend.WebService.setNewError model.webService Backend.Errors.NetworkError }, Cmd.none)


        SwicoExtracted (Err err) ->
          Debug.log (httpErrorString err)
          ({ model | webService = Backend.WebService.setNewError model.webService Backend.Errors.NetworkError }, Cmd.none)


        AlternativeProcedure1Extracted (Ok str) ->
          case  Backend.WebService.decodeError str of
            Ok wsErr ->
              ( { model | webService = Backend.WebService.setAlternativeProcedureError 1 model.webService wsErr }, Backend.WebService.debug (wsErr))
            Err msg -> -- It is not a webservice error, so it must be the expected result
              case Backend.WebService.decodeAlternativeProcedurePayload str of
                Ok payload ->
                  ( { model | webService = Backend.WebService.setAlternativeProcedurePayload 1 model.webService payload }, Cmd.none)
                Err err ->
                  Debug.log (err)
                  ({ model | webService = Backend.WebService.setNewError model.webService Backend.Errors.NetworkError }, Cmd.none)

        AlternativeProcedure1Extracted (Err err) ->
          Debug.log (httpErrorString err)
          ({ model | webService = Backend.WebService.setNewError model.webService Backend.Errors.NetworkError }, Cmd.none)


        AlternativeProcedure2Extracted (Ok str) ->
          case  Backend.WebService.decodeError str of
            Ok wsErr ->
              ( { model | webService = Backend.WebService.setAlternativeProcedureError 2 model.webService wsErr }, Backend.WebService.debug (wsErr))
            Err msg -> -- It is not a webservice error, so it must be the expected result
              case Backend.WebService.decodeAlternativeProcedurePayload str of
                Ok payload ->
                  ( { model | webService = Backend.WebService.setAlternativeProcedurePayload 2 model.webService payload }, Cmd.none)
                Err err ->
                  Debug.log (err)
                  ({ model | webService = Backend.WebService.setNewError model.webService Backend.Errors.NetworkError }, Cmd.none)

        AlternativeProcedure2Extracted (Err err) ->
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

        LanguageChanged language ->
          let
            ( updatedQrValidationModel, qrValidationCmd ) =
              Components.QrValidation.update ResetCliboardCopy model.qrValidation
          in
            ( { model | language = language, webService = Backend.WebService.setNoImage model.webService, qrValidation = updatedQrValidationModel }, 
               Cmd.batch <| [
                Cmd.map QrValidationMessage qrValidationCmd,
                sendGenerate model.webService.decoding.raw language
              ])

        LineNumbersShowed showLineNumbers -> 
          ({model | showLineNumbers = showLineNumbers},Cmd.none)

        Back -> ({ model | files = init.files }, Cmd.none)



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

sendGenerate : Maybe String -> Language -> Cmd Message
sendGenerate raw language =
  case raw of
    Nothing -> Cmd.none
    Just str ->
      Http.send InvoiceGenerated (
        put ("generate/" ++
          case language of
            Translations.Languages.SwissFrench -> "fr-ch"
            Translations.Languages.SwissGerman -> "de-ch"
        )
        (Http.stringBody "text/plain" str)
      )


put : String -> Http.Body -> Http.Request String
put route body =
  Http.request
    { method = "PUT"
    , headers = []
    , url = "https://partout.cresus.ch/swiss-qr-invoice/v2/" ++ route
    , body = body
    , expect = Http.expectString
    , timeout = Nothing
    , withCredentials = False
    }




-- qrCode component
view : Model -> Language -> Bool -> Html Message
view model language showLineNumbers =
    (div (renderZoneAttributes model.dropZone) [
      case model.webService.error of
        Nothing ->
          if List.length model.files > 0 then
            renderTabs model language showLineNumbers
          else
            renderEmptyDropZone language
        Just err ->
            renderError err language
    ])

renderTabs : Model -> Language -> Bool -> Html Message
renderTabs model language showLineNumbers =
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
      ("margin-left", "1.5em")
    ]]
    [
      renderTab model Validation (t language RTabValidation),
      renderTab model SwicoLine (t language RTabSwicoLine),
      renderTab model AlternativeProcedures (t language RTabAlternativeProcedures),
      renderTab model Image (t language RTabImage),
      renderBackButton model
    ],
    case model.tabs of
      Validation ->
        Html.map QrValidationMessage (Components.QrValidation.view model.qrValidation language showLineNumbers model.webService.decoding model.webService.validation)
      SwicoLine ->
        Components.QrSwicoLine.view language model.webService.decoding model.webService.swicoLine
      AlternativeProcedures ->
        Components.QrAlternativeProcedures.view language model.webService.decoding model.webService.alternativeProcedure1 model.webService.alternativeProcedure2
      Image ->
        Components.QrImage.view language model.webService.decoding model.webService.generation
  ]

renderTab : Model -> Tabs -> String -> Html Message
renderTab model tab str =
  div [
    class "button",
    style (
      if (model.tabs == tab) then
        List.append baseTabStyle
        [
          ("background-color", "#eee"),
          ("color", "#0d4c80"),
          ("cursor", "inherit")
        ]
      else
        baseTabStyle
    ),
    onClick (TabsChanged tab)
    ]
    [
      text str
    ]

renderBackButton : Model -> Html Message
renderBackButton model =
  div [
    class "button",
    style [
      ("display", "flex"),
      ("justify-content", "center"),
      ("align-items", "center"),
      ("cursor", "pointer"),
      ("padding", "0.5em 1em 0.5em 1em"),
      ("color", "#fff"),
      ("border-bottom-left-radius", "10px"),
      ("border-bottom-right-radius", "10px"),
      ("margin-right", "8px"),
      ("margin-top", "-5px")
    ],
    onClick Back
  ]
  [
    img [src "./static/img/icon-parachute.svg", style [("width", "14.5px")]] []
  ]


renderEmptyDropZone : Language -> Html a
renderEmptyDropZone language =
  div [style [
    ("display", "flex"),
    ("flex-grow", "1"),
    ("flex-direction", "column"),
    ("align-items", "center"),
    ("justify-content", "flex-start"),
    ("padding-top", "3em")
    ]]
    [div [style [("font-size", "24px")]] [text (t language RDropYourCode)],
     img [src "./static/img/parachute.svg", style [("width", "18%"), ("margin-top", "2.5em")]] []
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
    style []


dropZoneHover : Html.Attribute a
dropZoneHover =
    style [( "box-shadow", "0px 0px 20px #77aad4" )]

baseDropStyle : Html.Attribute a
baseDropStyle =
    style
        [ ("display", "flex")
        , ("flex-grow", "1")
        , ("height", "600px")
        , ("background", "url('./static/img/bg-cloudy.png') no-repeat")
        , ("color", "#fff")
        , ( "border-radius", "10px" )]

baseTabStyle : List (String, String)
baseTabStyle = [
    ("cursor", "pointer"),
    ("padding", "0.5em 1em 0.5em 1em"),
    ("color", "#fff"),
    ("border-bottom-left-radius", "10px"),
    ("border-bottom-right-radius", "10px"),
    ("margin-right", "8px"),
    ("margin-top", "-5px")
  ]


subscriptions : Model -> Sub Message
subscriptions model =
  fileBase64Encoded FileBase64Encoded
