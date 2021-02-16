port module Main exposing (main)

import Browser exposing (Document)
import Html exposing (Html, footer, h1, text)
import Ladder
import PairWho


type alias Model =
    { pair : PairWho.Model }


view : Model -> Document Msg
view model =
    { title = "Mob Randomizer"
    , body =
        [ viewHeader
        , content model
        , viewFooter
        ]
    }


viewHeader : Html Msg
viewHeader =
    h1 [] [ text "Mob Randomizer" ]


content : Model -> Html Msg
content model =
    PairWho.view model.pair
        |> Html.map GotPairWhoMessage


viewFooter : Html Msg
viewFooter =
    footer [] [ text "One is never alone with a rubber duck. -Douglas Adams" ]


type Msg
    = GotPairWhoMessage PairWho.Msg
    | Load String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotPairWhoMessage pairMsg ->
            fromPair model (PairWho.update pairMsg model.pair)

        Load value ->
            fromPair model (PairWho.update (PairWho.Load value) model.pair)


fromPair : Model -> ( PairWho.Model, Cmd PairWho.Msg ) -> ( Model, Cmd Msg )
fromPair model ( pairModel, cmd ) =
    ( { model | pair = pairModel }, Cmd.map GotPairWhoMessage cmd )


subscriptions : Model -> Sub Msg
subscriptions model =
    load Load


port save : String -> Cmd msg


port load : (String -> msg) -> Sub msg


port doload : () -> Cmd msg


init : () -> ( Model, Cmd Msg )
init _ =
    PairWho.init () |> fromPair { pair = PairWho.empty }


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }