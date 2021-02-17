port module Main exposing (main)

import Browser exposing (Document)
import Html exposing (Html, footer, h1, text)
import Ladder
import People


type alias Model =
    { pair : People.Model
    , ladder : Ladder.Ladder
    }


view : Model -> Document Msg
view model =
    { title = "Mob Randomizer"
    , body =
        [ viewHeader
        , selection model
        , ladder model
        , viewFooter
        ]
    }


viewHeader : Html Msg
viewHeader =
    h1 [] [ text "Mob Randomizer" ]


selection : Model -> Html Msg
selection model =
    People.view model.pair
        |> Html.map GotPeopleMessage


ladder : Model -> Html Msg
ladder model =
    Ladder.view model.ladder
        |> Html.map GotLadderMessage


viewFooter : Html Msg
viewFooter =
    footer [] [ text "One is never alone with a rubber duck. -Douglas Adams" ]


type Msg
    = GotPeopleMessage People.Msg
    | GotLadderMessage Ladder.Msg
    | Load String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotPeopleMessage pairMsg ->
            fromPair model (People.update pairMsg model.pair)

        GotLadderMessage ladderMsg ->
            ( model, Cmd.none )

        Load value ->
            fromPair model (People.update (People.Load value) model.pair)


fromPair : Model -> ( People.Model, Cmd People.Msg ) -> ( Model, Cmd Msg )
fromPair model ( pairModel, cmd ) =
    ( { model | pair = pairModel }, Cmd.map GotPeopleMessage cmd )


subscriptions : Model -> Sub Msg
subscriptions model =
    load Load


port save : String -> Cmd msg


port load : (String -> msg) -> Sub msg


port doload : () -> Cmd msg


init : () -> ( Model, Cmd Msg )
init _ =
    People.init ()
        |> fromPair
            { pair = People.empty
            , ladder = Ladder.init [ "Foo", "Bar", "Baz" ]
            }


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }
