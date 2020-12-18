module LadderTest exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Ladder
import Test exposing (..)


initTest : Test
initTest =
    test "Initializing a Ladder gives all zeroes" <|
        \_ ->
            let
                l =
                    Ladder.init [ "Person1", "Person2" ]
            in
            Expect.equal 0 (Ladder.get "Person1" "Person2" l)


incrementTest : Test
incrementTest =
    test "increment adds one to an empty cell" <|
        \_ ->
            let
                l =
                    Ladder.init [ "p1", "p2" ]

                l2 =
                    Ladder.increment "p1" "p2" l
            in
            Expect.equal 1 (Ladder.get "p1" "p2" l2)
