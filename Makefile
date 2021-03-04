tag := $(shell git describe --tags --abbrev=0 2> /dev/null)

# This target (taken from: https://gist.github.com/prwhite/8168133) is an easy way to print out a usage/ help of all make targets.
# For all make targets the text after \#\# will be printed.
help: ## Prints the help
	@echo "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\1\:\2/' | column -c2 -t -s :)"

build.golang-alpine: sep ## Builds the golang-alpine image with wkhtmltopdf (with patched qt) in version 0.12.6
	@echo "--> Build thobe/wkhtmltopdf:$(tag) Docker image"
	@docker build -f golang_alpine.Dockerfile -t thobe/wkhtmltopdf .
	@docker tag thobe/wkhtmltopdf:latest thobe/wkhtmltopdf:$(tag)

build.base: sep ## Build the base image that contains the compiled wkhtmltopdf with patched qt in version 0.12.6
	@echo "--> Build thobe/wkhtmltopdf-base Docker image"
	@docker build -f base_image.Dockerfile -t thobe/wkhtmltopdf-base .
	@docker tag thobe/wkhtmltopdf-base:latest thobe/wkhtmltopdf-base:$(tag)

push.golang-alpine: sep ## Pushes the golang-alpine image with wkhtmltopdf (with patched qt)
	@echo "--> Push thobe/wkhtmltopdf:$(tag) Docker image"
	@docker push thobe/wkhtmltopdf:$(tag)
	@echo "--> Push thobe/wkhtmltopdf:latest Docker image"
	@docker push thobe/wkhtmltopdf:latest

push.base: sep ## Pushes the base image with wkhtmltopdf (with patched qt)
	@echo "--> Push thobe/wkhtmltopdf-base:$(tag) Docker image"
	@docker push thobe/wkhtmltopdf-base:$(tag)
	@echo "--> Push thobe/wkhtmltopdf-base:latest Docker image"
	@docker push thobe/wkhtmltopdf-base:latest

dobuild: sep ## Build the base image that contains the compiled wkhtmltopdf with patched qt in version 0.12.6
	@echo "--> Build golang build image"
	@docker build -f golang_build.Dockerfile -t thobe/golang-build .
	@docker tag thobe/golang-build:latest thobe/golang-build:v0.0.1

dopush: sep ## Pushes the base image with wkhtmltopdf (with patched qt)
	@echo "--> Push thobe/golang-build:v0.0.1 Docker image"
	@docker push thobe/golang-build:v0.0.1

sep:
	@echo "----------------------------------------------------------------------------------"

finish:
	@echo "=================================================================================="
