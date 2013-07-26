.PHONY: build
build:
	mkdir -p lib
	node_modules/.bin/lsc -o lib source
clean:
	rm -rf lib
