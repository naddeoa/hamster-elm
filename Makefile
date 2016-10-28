
source = $(shell find ./src/elm -name "*.elm")
bundle = build/elm/bundle.js

default: $(bundle) run

$(bundle): $(source)
	elm make $(source) --output build/elm/bundle.js

run:
	./node_modules/.bin/electron ./main.js
