module LadderTest exposing (..)

import Dict exposing (..)
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Ladder
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector exposing (tag, text)


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


mobTest : Test
mobTest =
    describe "mob"
        [ test "increments the first pair in the given List" <|
            \_ ->
                let
                    l =
                        Ladder.init []

                    l2 =
                        Ladder.mob [ "p1", "p2", "p3", "p4" ] l
                in
                Expect.equal 1 (Ladder.get "p1" "p2" l2)
        , test "increments the next pair in the given List" <|
            \_ ->
                let
                    l =
                        Ladder.init []

                    l2 =
                        Ladder.mob [ "p1", "p2", "p3", "p4" ] l
                in
                Expect.equal 1 (Ladder.get "p1" "p3" l2)
        , test "increments the inner pairs in the given List" <|
            \_ ->
                let
                    l =
                        Ladder.init []

                    l2 =
                        Ladder.mob [ "p1", "p2", "p3", "p4" ] l
                in
                Expect.equal 1 (Ladder.get "p2" "p3" l2)
        , test "increments the final pair in the given List" <|
            \_ ->
                let
                    l =
                        Ladder.init []

                    l2 =
                        Ladder.mob [ "p1", "p2", "p3", "p4" ] l
                in
                Expect.equal 1 (Ladder.get "p3" "p4" l2)
        ]


mapTest : Test
mapTest =
    describe "map"
        [ test "passes Rows to the callback" <|
            \_ ->
                Ladder.init []
                    |> Ladder.mob [ "p1", "p2", "p3" ]
                    |> Ladder.map (\n r -> ( n, Ladder.getRow n r ))
                    |> Expect.equal [ ( "p1", 0 ), ( "p2", 0 ), ( "p3", 0 ) ]
        ]


viewTest : Test
viewTest =
    describe "view"
        [ test "creates a table with a row for each participant" <|
            \_ ->
                Ladder.init []
                    |> Ladder.mob [ "p1", "p2", "p3" ]
                    |> Ladder.view
                    |> Query.fromHtml
                    |> Query.findAll [ tag "tr" ]
                    |> Query.count (Expect.equal 4)
        , test "puts the participant's name in a th tag" <|
            \_ ->
                Ladder.init []
                    |> Ladder.mob [ "p1", "p2", "p3" ]
                    |> Ladder.view
                    |> Query.fromHtml
                    |> Query.has [ text "p1" ]
        , test "puts the count in a td" <|
            \_ ->
                Ladder.init []
                    |> Ladder.mob [ "p1", "p2" ]
                    |> Ladder.view
                    |> Query.fromHtml
                    |> Query.findAll [ tag "td" ]
                    |> Query.first
                    |> Query.has [ text "1" ]
        ]
