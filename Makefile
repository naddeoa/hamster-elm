
default: elm run

elm:
	elm make src/elm/* --output build/elm/bundle.js

run:
	./node_modules/.bin/electron ./main.js
