.PHONY = test

dist/app.js: src/Main.elm src/PairWho.elm src/Ladder.elm test
	elm make --output=dist/app.js src/Main.elm

test: tests/LadderTest.elm src/PairWho.elm
	elm-test
