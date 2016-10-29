
source = $(shell find ./src/elm -name "*.elm")
elm-bundle = build/bundle.js
webpack-bundle = build/bundle.js

.PHONY: elm-reactor default electron server

default: webpack-dev-server

$(elm-bundle): $(source)
	elm make $(source) --output $(elm-bundle)

$(webpack-bundle): $(source)
	./node_modules/.bin/webpack

electron:HOST=localhost
electron:WEBPACK_PORT=8080
electron:
	./node_modules/.bin/webpack-dev-server --host $(HOST) --port $(WEBPACK_PORT) --content-base /build/ &
	./node_modules/.bin/electron ./src/static/electron.js

server:PORT=8000
server:HOST=0.0.0.0
server:WEBPACK_PORT=8122
server:
	./node_modules/.bin/webpack-dev-server --host $(HOST) --port $(WEBPACK_PORT) --content-base /build/ &
	@echo "http://$(HOST):$(PORT)/src/static/index.html"
	python -mSimpleHTTPServer $(PORT)

elm-reactor:
	elm-reactor
