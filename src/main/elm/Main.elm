port module Main exposing (Model, Msg(..), init, main, subscriptions, update, view)

import Browser
import Html exposing (..)
import Json.Decode
import Json.Encode


port receiveStuff : (Json.Encode.Value -> msg) -> Sub msg



-- MAIN


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { name : String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { name = "noname"
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = NoOp
    | Received (Result Json.Decode.Error Int)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Received result ->
            case result of
                Ok value ->
                    ( model, Cmd.none )

                Err error ->
                    ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    receiveStuff (Json.Decode.decodeValue valueDecoder >> Received)


valueDecoder : Json.Decode.Decoder Int
valueDecoder =
    Json.Decode.field "value" Json.Decode.int



-- VIEW


view : Model -> Html Msg
view model =
    h1 [] [ text model.name ]
