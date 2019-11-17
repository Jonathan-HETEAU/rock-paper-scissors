module RockPaperScissor.Update exposing (..)

import Random
import RockPaperScissor.Model as Model exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.mode ) of
        ( OnStartGame game, Menu _ ) ->
            ( { model | mode = Play initPart game }, Cmd.batch <| generateRandomCmds game )

        ( OnReturnMenu, Play part game ) ->
            ( { model | mode = Menu (Just ( part, game )) }, Cmd.none )

        ( OnNextRound, Play part game ) ->
            ( { model | mode = Play { part | status = InProgress Nothing Nothing } game }, Cmd.batch <| generateRandomCmds game )

        ( OnPlayerChoose player symbol, Play part game ) ->
            let
                status =
                    case ( part.status, player ) of
                        ( InProgress _ mSymbole2, Player1 ) ->
                            InProgress (Just symbol) mSymbole2

                        ( InProgress mSymbole1 _, Player2 ) ->
                            InProgress mSymbole1 (Just symbol)

                        ( currentStatus, _ ) ->
                            currentStatus
            in
            update TestResult { model | mode = Play { part | status = status } game }

        ( TestResult, Play part game ) ->
            case part.status of
                InProgress (Just s1) (Just s2) ->
                    let
                        result =
                            toResult s1 s2

                        ( score1, score2 ) =
                            part.score

                        newScore =
                            case result of
                                WIN Player1 ->
                                    ( score1 + 1, score2 )

                                WIN Player2 ->
                                    ( score1, score2 + 1 )

                                NULL ->
                                    ( score1, score2 )

                        newPart =
                            { part | status = Finish s1 s2 result, history = ( s1, s2 ) :: part.history, score = newScore, rounds = part.rounds + 1 }
                    in
                    ( { model | mode = Play newPart game }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        ( _, _ ) ->
            ( model, Cmd.none )


generateRandomCmds : Game -> List (Cmd Msg)
generateRandomCmds game =
    case game of
        PlayerVsComputer ->
            [ Random.generate (OnPlayerChoose Player2) randomSymbol ]

        ComputerVsComputer ->
            List.map (\player -> Random.generate (OnPlayerChoose player) randomSymbol) [ Player1, Player2 ]


randomSymbol : Random.Generator Symbol
randomSymbol =
    Random.weighted ( 34, ROCK ) [ ( 33, PAPER ), ( 33, SCISSORS ) ]


toResult : Symbol -> Symbol -> Model.Result
toResult s1 s2 =
    if s1 == s2 then
        NULL

    else
        case ( s1, s2 ) of
            ( ROCK, SCISSORS ) ->
                WIN Player1

            ( PAPER, ROCK ) ->
                WIN Player1

            ( SCISSORS, PAPER ) ->
                WIN Player1

            ( _, _ ) ->
                WIN Player2
