module Ladder exposing (get, init)

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
