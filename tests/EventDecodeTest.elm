module EventDecodeTest exposing (all)

import Expect
import Json.Decode exposing (decodeString)
import Main exposing (Event, eventDecoder)
import Test exposing (..)


all : Test
all =
    describe "Test of event Json decoding."
        [ test "Event message" <|
            \_ ->
                decodeString eventDecoder eventExample
                    |> Expect.equal expectedEvent
        ]


eventExample : String
eventExample =
    """
        {
            "eventId":"0154416d-5117-4e67-9adc-0121f7e8af22",
            "eventDt":"2019-12-17T07:25:45.120315"
        }
    """


expectedEvent : Result Json.Decode.Error Event
expectedEvent =
    Ok (Event "0154416d-5117-4e67-9adc-0121f7e8af22" "2019-12-17T07:25:45.120315")
