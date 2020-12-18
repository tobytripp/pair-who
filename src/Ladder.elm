module Ladder exposing (get, increment, init)

import Dict exposing (Dict)


type alias Ladder =
    Dict String (Dict String Int)


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
        Just d2 ->
            case Dict.get n2 d2 of
                Just i ->
                    i

                Nothing ->
                    0

        Nothing ->
            0


increment : String -> String -> Ladder -> Ladder
increment n1 n2 l =
    let
        values =
            case Dict.get n1 l of
                Just d ->
                    d

                Nothing ->
                    Dict.fromList [ ( n2, 0 ) ]

        value =
            get n1 n2 l
    in
    Dict.insert n1 (Dict.insert n2 (value + 1) values) l
