PROJECT_NAME = CSSEncapsulator
FILES = $(PROJECT_NAME).coffee

make:
	cat $(FILES) | coffee --compile --stdio > $(PROJECT_NAME).js

test:
	cat $(FILES) Test.coffee | coffee --compile --stdio > $(PROJECT_NAME).js

production: make
	uglifyjs $(PROJECT_NAME).js -o $(PROJECT_NAME).min.js -c -m drop_console=true -d DEBUG=false
