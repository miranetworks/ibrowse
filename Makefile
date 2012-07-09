
.PHONY: all app clean test deps

export APP_VERSION = $(shell cat src/ibrowse.app.src | grep vsn | grep -Eo '["].+["]' | sed 's|"||g')

./ebin/ibrowse.app: src/*.erl include/*.hrl
	./rebar compile

deps:
	./rebar get-deps

app: deps ./ebin/ibrowse.app

./apps/ibrowse/ebin:
	mkdir -p ./apps/ibrowse/
	cd ./apps/ibrowse/; rm -f ebin; ln -s ../../ebin

clean:
	rm -fr log
	rm -fr .eunit
	rm -fr erl_crash.dump
	./rebar clean

test: app
	mkdir -p .eunit
	./rebar skip_deps=true eunit

all: clean app test
	@echo "Done."
