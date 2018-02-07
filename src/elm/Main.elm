
module Main exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)

-- component import example
import Components.QrCode
import Components.WebService

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
  qrCode: Components.QrCode.Model
}

init : Model
init =
    {
      qrCode = Components.QrCode.init
    }


-- UPDATE
type Msg = QrCodeMessage Components.QrCode.Message

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    QrCodeMessage qrCodeMsg ->
      let
        ( updatedQrCodeModel, qrCodeCmd ) =
          Components.QrCode.update qrCodeMsg model.qrCode
      in
        ( { model | qrCode = updatedQrCodeModel }, Cmd.map QrCodeMessage qrCodeCmd )


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
    renderHeader,
    renderContent model,
    renderFooter
  ]




renderHeader: Html a
renderHeader =
  header [style [("display", "flex"), ("border-bottom", "1px solid #eee"), ("align-items", "center")]] [
    div [style [("flex-grow", "10")]] [
      h1 [] [text "Validateur de QR code"]
    ],
    div [style [("flex-grow", "1"), ("text-align", "right")]] [
      img [style [("width", "120px")],
           src ("./static/img/swiss-cow.svg"),
           alt ("Kuh-Air-Bill"),
           title ("Schweizer Kuh mit QR-Code")] []
    ]
  ]

renderContent: Model -> Html Msg
renderContent model =
  div [style [("margin-top", "20px")]] [
    Html.map QrCodeMessage (Components.QrCode.view model.qrCode),
    div [style [("display", "flex")]] [
      renderRawInvoice model
      --renderErrors model-}
    ]
  ]


renderRawInvoice: Model -> Html Msg
renderRawInvoice model =
  div [style [("flex-grow", "1"), ("background-color", "#ccc")]] [
    case model.qrCode.webService.decoding.raw of
      Nothing -> div [] []
      Just raw ->
        div [] (List.map (\line -> div [] [text line, br [] []]) (String.split "\n" raw))
  ]

renderErrors: Model -> Html Msg
renderErrors model =
  div [style [("flex-grow", "1")]] []


renderFooter: Html a
renderFooter =
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
        a [href "#", buttonStyle] [text "FR"],
        a [href "#", buttonStyle] [text "DE"]
      ],
      div [class "clearfix"] []
    ]
  ]



renderValidationErrors: List Components.WebService.ValidationError -> Html a
renderValidationErrors validations =
  div [] (
    List.map (\validation -> p [] [text (Components.WebService.prettifyValidationError validation)]) validations
  )


buttonStyle: Html.Attribute a
buttonStyle =
  style [
    ("background", "#0d4c80"),
    ("padding", "0.5em"),
    ("color", "#fff"),
    ("border-radius", "2px"),
    ("margin", "2px")
  ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map QrCodeMessage (Components.QrCode.subscriptions model.qrCode) ]
