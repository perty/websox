port module Main exposing (Event, Model, Msg(..), eventDecoder, init, main, subscriptions, update, view)

import Browser
import Html exposing (..)
import Json.Decode
import Json.Decode.Pipeline exposing (required)
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


type alias Event =
    { eventId : String
    , eventDt : String
    }


type alias Model =
    { name : String
    , lastEvent : Event
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { name = "The App"
      , lastEvent = Event "no event" ""
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = NoOp
    | Received (Result Json.Decode.Error Event)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Received result ->
            case result of
                Ok value ->
                    ( { model | lastEvent = value }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 []
            [ text model.name
            ]
        , p []
            [ text model.lastEvent.eventDt
            ]
        , p []
            [ text model.lastEvent.eventId
            ]
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    receiveStuff (Json.Decode.decodeValue eventDecoder >> Received)


eventDecoder : Json.Decode.Decoder Event
eventDecoder =
    Json.Decode.succeed Event
        |> required "eventId" Json.Decode.string
        |> required "eventDt" Json.Decode.string
