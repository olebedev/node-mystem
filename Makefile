.PHONY: build clean

clean:
	@rm -rf lib
	@echo "\033[1;33m\n\tDone.\n\033[m"

build: download
	@./node_modules/.bin/coffee -bco lib/ src/

watch: 
	@./node_modules/.bin/coffee -bwo lib/ src/

download:
	@curl http://download.yandex.ru/mystem/mystem-2.0-macosx10.5.tar.gz > mystem.tar.gz
	@tar -xvf mystem.tar.gz 
	@mkdir -p vendor/darwin/x64
	@mv mystem vendor/darwin/x64
	@rm mystem.tar.gz
