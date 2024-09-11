module Main exposing (Model, Msg(..), init, languageButton, localStorageErrorString, main, renderContent, renderFooter, renderHeader, send, subscriptions, update, view)

-- component import example

import Components.QrCode
import Debug
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import LocalStorage exposing (..)
import Ports exposing (..)
import Task
import Translations.Languages exposing (Language, t)
import Translations.Resources exposing (..)



-- APP


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { qrCode : Components.QrCode.Model
    , language : Language
    , showLineNumbers : Bool
    }


init : ( Model, Cmd Msg )
init =
    ( { qrCode = Components.QrCode.init
      , language = Translations.Languages.SwissFrench
      , showLineNumbers = True
      }
    , Ports.getUrlParams ["lang", "linenumbers"]
    )



-- UPDATE


type Msg
    = QrCodeMessage Components.QrCode.Message
    | LanguageChanged Language
    | LineNumbersShowed Bool
    | OnLocalStorageLanguage LocalStorage.Key (Result LocalStorage.Error (Maybe LocalStorage.Value))
    | OnVoidOp (Result LocalStorage.Error ())
    | UrlParamReceived UrlParam


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        QrCodeMessage qrCodeMsg ->
            let
                ( updatedQrCodeModel, qrCodeCmd ) =
                    Components.QrCode.update qrCodeMsg model.qrCode
            in
            ( { model | qrCode = updatedQrCodeModel }, Cmd.map QrCodeMessage qrCodeCmd )

        LanguageChanged language ->
            let
                ( updatedQrCodeModel, qrCodeCmd ) =
                    Components.QrCode.update (Components.QrCode.LanguageChanged language) model.qrCode
            in
            ( { model | language = language, qrCode = updatedQrCodeModel }
            , Cmd.batch <|
                [ Cmd.map QrCodeMessage qrCodeCmd
                , Ports.title (t language RTitle)
                , Task.attempt OnVoidOp
                    (LocalStorage.set "epsitec-qr-validator-language"
                        (case language of
                            Translations.Languages.SwissFrench ->
                                "SwissFrench"

                            Translations.Languages.SwissGerman ->
                                "SwissGerman"
                        )
                    )
                ]
            )

        LineNumbersShowed showLineNumbers ->
            let
                ( updatedQrCodeModel, qrCodeCmd ) =
                    Components.QrCode.update (Components.QrCode.LineNumbersShowed showLineNumbers) model.qrCode
            in
            ( { model | showLineNumbers = showLineNumbers, qrCode = updatedQrCodeModel }, Cmd.none )

        OnLocalStorageLanguage key result ->
            case result of
                Ok maybeValue ->
                    case maybeValue of
                        Nothing ->
                            ( model, Task.attempt OnVoidOp (LocalStorage.set "epsitec-qr-validator-language" "SwissFrench") )

                        -- Create key with SwissFrench as default
                        Just language ->
                            case language of
                                "SwissFrench" ->
                                    ( model, send (LanguageChanged Translations.Languages.SwissFrench) )

                                "SwissGerman" ->
                                    ( model, send (LanguageChanged Translations.Languages.SwissGerman) )

                                a ->
                                    ( model, Cmd.none )

                Err err ->
                    Debug.log (localStorageErrorString err)
                        ( model, Cmd.none )

        OnVoidOp result ->
            case result of
                Ok _ ->
                    ( model, Cmd.none )

                Err err ->
                    Debug.log (localStorageErrorString err)
                        ( model, Cmd.none )

        UrlParamReceived result ->
            case result.name of
                "lang" ->
                    case result.value of
                        Nothing ->
                            ( model, Task.attempt (OnLocalStorageLanguage "epsitec-qr-validator-language") (LocalStorage.get "epsitec-qr-validator-language") )

                        Just language ->
                            case language of
                                "fr" ->
                                    ( model, send (LanguageChanged Translations.Languages.SwissFrench) )

                                "de" ->
                                    ( model, send (LanguageChanged Translations.Languages.SwissGerman) )

                                a ->
                                    ( model, Task.attempt (OnLocalStorageLanguage "epsitec-qr-validator-language") (LocalStorage.get "epsitec-qr-validator-language") )

                "linenumbers" ->
                    case result.value of
                        Nothing ->
                            ( model, Cmd.none )

                        Just showLineNumbers ->
                            case showLineNumbers of
                                "false" ->
                                    ( model, send (LineNumbersShowed False) )

                                a ->
                                    ( model, Cmd.none )

                a ->
                    ( model, Cmd.none )


localStorageErrorString : LocalStorage.Error -> String
localStorageErrorString err =
    case err of
        NoStorage ->
            "local storage is not available"

        UnexpectedPayload payload ->
            "unexpected payload from local storage: " ++ payload

        Overflow ->
            "local storage overflow error"


send : msg -> Cmd msg
send msg =
    Task.succeed msg
        |> Task.perform identity



-- VIEW
-- Html is defined as: elem [ attribs ][ children ]
-- CSS can be applied via class names or inline style attrib


view : Model -> Html Msg
view model =
    div
        [ id "container"
        , style
            [ ( "background", "#fafafa" )
            , ( "max-width", "960px" )
            , ( "padding", "20px 40px 20px 40px" )
            , ( "border", "1px solid #eee" )
            , ( "box-shadow", "0px 0px 10px rgba(0, 0, 0, 0.10)" )
            , ( "border-radius", "3px" )
            ]
        ]
        [ renderHeader model
        , renderContent model
        , renderFooter model
        ]


renderHeader : Model -> Html a
renderHeader model =
    header [ style [ ( "display", "flex" ), ( "border-bottom", "1px solid #eee" ), ( "align-items", "center" ) ] ]
        [ div [ style [ ( "flex-grow", "10" ), ( "max-width", "640px" ) ] ]
            [ h1 [] [ text (t model.language RTitle) ]
            ]
        , div [ style [ ( "flex-grow", "1" ), ( "text-align", "right" ) ] ]
            [ img [ style [ ( "width", "120px" ) ], src "./static/img/swiss-cow.svg" ] []
            ]
        ]


renderContent : Model -> Html Msg
renderContent model =
    div [ style [ ( "margin-top", "20px" ) ] ]
        [ Html.map QrCodeMessage (Components.QrCode.view model.qrCode model.language model.showLineNumbers)
        ]


renderFooter : Model -> Html Msg
renderFooter model =
    footer
        [ style
            [ ( "margin-top", "40px" )
            , ( "border-top", "1px solid #eee" )
            , ( "font-size", ".75em" )
            , ( "padding", "20px 20px" )
            ]
        ]
        [ div [ class "row" ]
            [ div [ class "colonne w50" ]
                [ p [] [ text "Copyright © 2018-2023 – Epsitec SA, Yverdon-les-Bains – Developed for Swico by Jonny Quarta" ]
                ]
            , div [ class "colonne w50 txt-right" ]
                [ languageButton model Translations.Languages.SwissFrench "FR"
                , languageButton model Translations.Languages.SwissGerman "DE"
                ]
            , div [ class "clearfix" ] []
            ]
        ]


languageButton : Model -> Translations.Languages.Language -> String -> Html Msg
languageButton model language str =
    a
        [ style
            (List.append
                [ ( "background", "#0d4c80" )
                , ( "padding", "0.5em" )
                , ( "color", "#fff" )
                , ( "border-radius", "2px" )
                , ( "cursor", "pointer" )
                , ( "margin", "2px" )
                ]
                (if model.language == language then
                    [ ( "background", "#ccc" ) ]

                 else
                    []
                )
            )
        , onClick (LanguageChanged language)
        ]
        [ text str ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map QrCodeMessage (Components.QrCode.subscriptions model.qrCode)
        , urlParamReceived UrlParamReceived
        ]
