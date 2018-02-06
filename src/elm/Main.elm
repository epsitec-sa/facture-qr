
module Main exposing (..)
import Html exposing (..)

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
  div [][    -- inline CSS (literal)
    Html.map QrCodeMessage (Components.QrCode.view model.qrCode)
    , p [] [ text model.qrCode.raw ]
    , p [] [ text (Components.WebService.prettifyError model.qrCode.error) ]
    , renderValidationErrors model.qrCode.validations
  ]

renderValidationErrors: List Components.WebService.ValidationError -> Html msg
renderValidationErrors validations =
  div [] (List.map (\validation -> p [] [text (Components.WebService.prettifyValidationError validation)]) validations)



subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map QrCodeMessage (Components.QrCode.subscriptions model.qrCode) ]
