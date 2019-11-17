module RockPaperScissor exposing (main)

import Browser
import RockPaperScissor.Model exposing (Model, Msg, init)
import RockPaperScissor.Update exposing (update)
import RockPaperScissor.View exposing (view)


main : Program String Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
