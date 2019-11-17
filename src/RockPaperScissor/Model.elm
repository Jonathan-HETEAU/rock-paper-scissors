module RockPaperScissor.Model exposing (..)


type Msg
    = OnStartGame Game
    | OnReturnMenu
    | OnPlayerChoose Player Symbol
    | OnNextRound
    | TestResult


type Player
    = Player1
    | Player2


type Symbol
    = ROCK
    | PAPER
    | SCISSORS


type Result
    = WIN Player
    | NULL


type PartStatus
    = InProgress (Maybe Symbol) (Maybe Symbol)
    | Finish Symbol Symbol Result


type alias Part =
    { status : PartStatus
    , history : List ( Symbol, Symbol )
    , score : ( Int, Int )
    , rounds : Int
    }


type Game
    = PlayerVsComputer
    | ComputerVsComputer


type Mode
    = Menu (Maybe ( Part, Game ))
    | Play Part Game


type alias Model =
    { mode : Mode
    }


init : String -> ( Model, Cmd Msg )
init _ =
    ( Model (Menu Nothing), Cmd.none )


initPart : Part
initPart =
    { status = InProgress Nothing Nothing
    , history = []
    , score = ( 0, 0 )
    , rounds = 1
    }
