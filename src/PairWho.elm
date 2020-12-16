port module PairWho exposing (main)

import Browser
import Html exposing (Html, button, input, li, section, text, ul)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput, onSubmit)
import Json.Decode as Decode exposing (Decoder, field, int, list, string)
import Json.Encode as Encode
import Random
import Random.List
import Task


type alias Model =
    { newPerson : String
    , mobs : List (List String)
    , people : List String
    }


type Msg
    = DoLoad
    | Load String
    | NewPerson String
    | AddPerson
    | RemovePerson String
    | Shuffle
    | NewMobs (List String)


view : Model -> Html Msg
view model =
    section []
        [ ul [] (List.map viewPerson model.people)
        , Html.form [ onSubmit AddPerson ]
            [ viewInput "text" "Name" model.newPerson NewPerson
            , button [ onClick AddPerson ] [ text "Add" ]
            ]
        , button [ onClick Shuffle ] [ text "2 Mobs" ]
        , Html.div [] (List.map viewMob model.mobs)
        ]


viewMob : List String -> Html Msg
viewMob mobs =
    let
        viewMember name =
            li [] [ text name ]
    in
    ul [] (List.map viewMember mobs)


viewPerson : String -> Html Msg
viewPerson name =
    li []
        [ text name
        , button [ onClick (RemovePerson name) ] [ text "-" ]
        ]


viewInput : String -> String -> String -> (String -> msg) -> Html msg
viewInput t p v toMsg =
    input [ type_ t, placeholder p, value v, onInput toMsg ] []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DoLoad ->
            ( model, doload () )

        Load value ->
            ( fromJson value, Cmd.none )

        NewPerson value ->
            ( { model | newPerson = value }, Cmd.none )

        AddPerson ->
            let
                m =
                    { model
                        | people =
                            List.sort
                                (model.people
                                    ++ [ model.newPerson ]
                                )
                        , newPerson = ""
                    }
            in
            ( m, save (toJson m) )

        RemovePerson p ->
            let
                m =
                    { model | people = List.filter (\x -> x /= p) model.people }
            in
            ( m, save (toJson m) )

        Shuffle ->
            ( model
            , Random.generate NewMobs (Random.List.shuffle model.people)
            )

        NewMobs l ->
            let
                len =
                    List.length l // 2

                a =
                    List.take len l

                b =
                    List.drop len l
            in
            ( { model | mobs = [ a, b ] }, Cmd.none )


toJson : Model -> String
toJson model =
    [ ( "people", Encode.list Encode.string model.people )
    ]
        |> Encode.object
        |> Encode.encode 2


modelDecoder : Decoder Model
modelDecoder =
    Decode.map (Model "" [ [] ])
        (field "people" (Decode.list string))


fromJson string =
    case Decode.decodeString modelDecoder string of
        Err _ ->
            initialModel

        Ok val ->
            val


subscriptions : Model -> Sub Msg
subscriptions model =
    load Load


port save : String -> Cmd msg


port load : (String -> msg) -> Sub msg


port doload : () -> Cmd msg


initialModel =
    Model "" [] []


initialCmd =
    Task.succeed DoLoad |> Task.perform identity


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> ( initialModel, initialCmd )
        , view = view
        , update = update
        , subscriptions = subscriptions
        }