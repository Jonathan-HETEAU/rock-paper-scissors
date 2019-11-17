module RockPaperScissor.View exposing (..)

import Browser
import Html exposing (Html, button, div, h1, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import RockPaperScissor.Model as Model exposing (..)


view : Model -> Browser.Document Msg
view model =
    let
        document =
            case model.mode of
                Menu _ ->
                    viewMenu model

                Play part game ->
                    viewGame part game

        body =
            [ div [ class "row titles" ]
                [ h1 [ class "rock" ] [ text "Rock" ]
                , h1 [ class "paper" ] [ text "Paper" ]
                , h1 [ class "scissors" ] [ text "Scissors" ]
                ]
            , div [ class "column"] document.body
            ]
    in
    { title = document.title, body = body }


viewMenu : Model -> Browser.Document Msg
viewMenu model =
    let
        body =
            [ div [ class "row buttons" ]
                [ button [ class "button", onClick (OnStartGame PlayerVsComputer) ] [ text "PlayerVsComputer" ]
                , button [ class "button", onClick (OnStartGame ComputerVsComputer) ] [ text "ComputerVsComputer" ]
                ]
            ]
    in
    { title = "Rock-Paper-Scissors", body = body }


viewGame : Part -> Game -> Browser.Document Msg
viewGame part game =
    let
        menu =
            div [ class "row" ] [ button [ onClick OnReturnMenu ] [ text "Menu" ] ]

        ( score1, score2 ) =
            part.score

        hud =
            div [ class "row"] [ h1 [] [ text <| "Player1 " ++ String.fromInt score1 ++ " : " ++ String.fromInt score2 ++ " Player2 " ] ]

        statusView =
            case part.status of
                InProgress ms1 ms2 ->
                    viewInProgress game part ms1 ms2

                Finish s1 s2 result ->
                    viewResult part s1 s2 result

        body =
            [ menu
            , hud
            , div [] statusView.body
            ]
    in
    { title = statusView.title, body = body }


viewInProgress : Game -> Part -> Maybe Symbol -> Maybe Symbol -> Browser.Document Msg
viewInProgress game part mSymbole1 mSymbole2 =
    let
        choose =
            case game of
                PlayerVsComputer ->
                    div [class "row"] [ viewPlayer Player1 mSymbole1, viewComputer mSymbole2 ]

                ComputerVsComputer ->
                    div [class "row"] [ viewComputer mSymbole1, viewComputer mSymbole2 ]

        body =
            [ choose
            ]
    in
    { title = "Play!!", body = body }


viewPlayer : Player -> Maybe Symbol -> Html Msg
viewPlayer player maybeSymbol =
    div [class "row column"]
        [ button [ class "button column rock rock-bg-c" , onClick (OnPlayerChoose player ROCK) ] [ text "Rock" ]
        , button [ class "button column paper paper-bg-c" , onClick (OnPlayerChoose player PAPER) ] [ text "Paper" ]
        , button [ class "button column scissors scissors-bg-c" , onClick (OnPlayerChoose player SCISSORS) ] [ text "Scissors" ]
        ]


viewComputer : Maybe Symbol -> Html Msg
viewComputer maybeSymbol =
    div [class "row column"] [ h1 [] [text "I am waiting for your answer"]]


viewResult : Part -> Symbol -> Symbol -> Model.Result -> Browser.Document Msg
viewResult part symbol1 symbol2 result =
    let
        (style1,style2,title) =
            case result of
                WIN player ->
                    case player of
                        Player1 ->
                            ("win","loose","Player1 win !!")

                        Player2 ->
                            ("loose","win","Player2 win !!")

                NULL ->
                    ("null","null"," Match Null !!")

        body =
            [ div [ class "row"]
                [ div[ class <|"column "++style1++" "++(toClass symbol1) ][ h1 [] [text <| toString symbol1 ] ]
                , div[ class <|"column "++style2++" "++(toClass symbol2) ][ h1 [] [text <| toString symbol2 ] ]                    
                ]
            ,div [ class "row"]
                [ h1 [] [ text title ]]
            ,div [ class "row"]
                [ button [ onClick OnNextRound ] [ text "Next >>>" ]
                ]
            ]
    in
    { title = "Rock-Paper-Scissors", body = body }



toString : Symbol -> String 
toString symbol = 
    case symbol of
        ROCK ->
            "Rock"  
        PAPER ->
            "Paper"
        SCISSORS ->
            "Scissors"
            
toClass : Symbol -> String
toClass symbol = 
    case symbol of
        ROCK ->
            "rock-bg-c"  
        PAPER ->
            "paper-bg-c"
        SCISSORS ->
            "scissors-bg-c"