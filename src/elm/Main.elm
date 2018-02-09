module Main exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)

-- component import example
import Components.QrCode
import Translations.Languages exposing (t, Language)
import Translations.Resources exposing (..)


-- APP
main : Program Never Model Msg
main =
    Html.program
        { init = ( init, Cmd.none )
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


-- MODEL
type alias Model = {
  qrCode: Components.QrCode.Model,
  language: Language
}

init : Model
init =
    {
      qrCode = Components.QrCode.init,
      language = Translations.Languages.SwissFrench
    }


-- UPDATE
type Msg = QrCodeMessage Components.QrCode.Message
           | LanguageChanged Language

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
      ({ model | language = language }, Cmd.none)


-- VIEW
-- Html is defined as: elem [ attribs ][ children ]
-- CSS can be applied via class names or inline style attrib
view : Model -> Html Msg
view model =
  div [id "container",
    style [
        ("background", "#fafafa"),
        ("max-width", "960px"),
        ("padding", "20px 40px 20px 40px"),
        ("border", "1px solid #eee"),
        ("box-shadow", "0px 0px 10px rgba(0, 0, 0, 0.10)"),
        ("border-radius", "3px")]
    ][
    renderHeader model,
    renderContent model,
    renderFooter model
  ]




renderHeader: Model -> Html a
renderHeader model =
  header [style [("display", "flex"), ("border-bottom", "1px solid #eee"), ("align-items", "center")]] [
    div [style [("flex-grow", "10")]] [
      h1 [] [text (t model.language RTitle)]
    ],
    div [style [("flex-grow", "1"), ("text-align", "right")]] [
      img [style [("width", "120px")], src ("./static/img/swiss-cow.svg")] []
    ]
  ]

renderContent: Model -> Html Msg
renderContent model =
  div [style [("margin-top", "20px")]] [
    Html.map QrCodeMessage (Components.QrCode.view model.qrCode model.language)
  ]



renderFooter: Model -> Html Msg
renderFooter model =
  footer [style [
      ("margin-top", "40px"),
      ("border-top", "1px solid #eee"),
      ("font-size", ".75em"),
      ("padding", "20px 20px")]
    ] [
    div [class "row"] [
      div [class "colonne w50"] [
        p [] [text "Copyright © 2017 – Pierre Arnaud, Epsitec SA, Yverdon-les-Bains"]
      ],
      div [class "colonne w50 txt-right"] [
        languageButton model Translations.Languages.SwissFrench "FR",
        languageButton model Translations.Languages.SwissGerman "DE"
      ],
      div [class "clearfix"] []
    ]
  ]


languageButton: Model -> Translations.Languages.Language -> String -> Html Msg
languageButton model language str =
  a [style (
    List.append
      ([
        ("background", "#0d4c80"),
        ("padding", "0.5em"),
        ("color", "#fff"),
        ("border-radius", "2px"),
        ("cursor", "pointer"),
        ("margin", "2px")
      ])
      (
        if model.language == language then
          [("opacity", ".5")]
        else []
      )
    ),
    onClick (LanguageChanged language)]
    [text str]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map QrCodeMessage (Components.QrCode.subscriptions model.qrCode) ]
