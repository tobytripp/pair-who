module LadderTest exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Ladder
import Test exposing (..)


suite : Test
suite =
    test "one plus one equals two" (\_ -> Expect.equal 2 (1 + 1))


initTest : Test
initTest =
    test "Initializing a Ladder gives all zeroes" <|
        \_ ->
            let
                l =
                    Ladder.init [ "Person1", "Person2" ]
            in
            Expect.equal 0 (Ladder.get "Person1" "Person2" l)
