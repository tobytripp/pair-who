module Ladder exposing (Ladder, Msg, get, getRow, increment, init, map, mob, view)

import Dict exposing (Dict)
import Html exposing (Html, h2, section, table, tbody, td, text, th, thead, tr)


type alias Row =
    Dict String Int


type alias Ladder =
    Dict String Row


type Msg
    = None


view : Ladder -> Html msg
view model =
    section []
        [ h2 [] [ text "Ladder" ]
        , table []
            [ tableHead model
            , tableBody model
            ]
        ]


tableHead : Ladder -> Html msg
tableHead model =
    let
        cell v =
            th [] [ text v ]
    in
    thead [] [ tr [] <| List.map cell ("" :: Dict.keys model) ]


tableBody : Ladder -> Html msg
tableBody model =
    tbody [] (map tableRow model)


tableRow : String -> Row -> Html msg
tableRow n row =
    let
        cell v =
            td [] [ text (String.fromInt v) ]

        cells r =
            List.map cell (Dict.values r)
    in
    tr [] (th [] [ text n ] :: cells row)


init : List String -> Ladder
init names =
    let
        l1 =
            List.map (\n -> ( n, 0 )) names

        l2 =
            List.map (\n -> ( n, Dict.fromList l1 )) names
    in
    Dict.fromList l2


get : String -> String -> Ladder -> Int
get n1 n2 l =
    case Dict.get n1 l of
        Just r ->
            getRow n2 r

        Nothing ->
            0


getRow : String -> Row -> Int
getRow n r =
    case Dict.get n r of
        Just v ->
            v

        Nothing ->
            0


increment : String -> String -> Ladder -> Ladder
increment n1 n2 l =
    let
        value =
            get n1 n2 l
    in
    insert n1 n2 (value + 1) l


insert : String -> String -> Int -> Ladder -> Ladder
insert n1 n2 v l =
    let
        values =
            case Dict.get n1 l of
                Just d ->
                    d

                Nothing ->
                    Dict.empty
    in
    Dict.insert n1 (Dict.insert n2 v values) l


mob : List String -> Ladder -> Ladder
mob names l =
    case names of
        [] ->
            l

        [ n ] ->
            insert n n 0 l

        n :: ns ->
            List.foldl (increment n) l ns
                |> mob ns


map : (String -> Row -> a) -> Ladder -> List a
map f l =
    let
        ns =
            Dict.toList l
    in
    List.map (\( n, r ) -> f n r) ns
