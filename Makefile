
source = $(shell find ./src/elm -name "*.elm")
bundle = build/elm/bundle.js

default: webpack-dev-server

$(bundle): $(source)
	elm make $(source) --output build/elm/bundle.js

electron:
	./node_modules/.bin/electron ./main.js

webpack-dev-server:
	./node_modules/.bin/webpack-dev-server --content-base /build/

elm-reactor:
	elm-reactor
