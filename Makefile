
syntax-error:
	@echo "visit http://localhost:8000/src/elm/Main.elm and open the Javascript console."
	elm-make src/elm/Main.elm
	elm-reactor

elm:
	elm make src/elm/* --output build/elm/bundle.js

run:
	./node_modules/.bin/electron ./main.js
