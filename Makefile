.PHONY = test

dist/app.js: src/Main.elm src/People.elm src/Ladder.elm test
	elm make --output=dist/app.js src/Main.elm

test: tests/LadderTest.elm src/People.elm
	elm-test
