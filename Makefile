# This target (taken from: https://gist.github.com/prwhite/8168133) is an easy way to print out a usage/ help of all make targets.
# For all make targets the text after \#\# will be printed.
help: ## Prints the help
	@echo "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\1\:\2/' | column -c2 -t -s :)"

build.golang-alpine: sep ## Builds the golang-alpine image with wkhtmltopdf (with patched qt) in version 0.12.6
	@echo "--> Build thobe/wkhtmltopdf:golang1.14-alpine_0.12.6 Docker image"
	@docker build -f golang_alpine.Dockerfile -t thobe/wkhtmltopdf:golang1.14-alpine_0.12.6 .

build.base: sep ## Build the base image that contains the compiled wkhtmltopdf with patched qt in version 0.12.6
	@echo "--> Build thobe/wkhtmltopdf-base Docker image"
	@docker build -f base_image.Dockerfile -t thobe/wkhtmltopdf-base .

push.golang-alpine: sep ## Pushes the golang-alpine image with wkhtmltopdf (with patched qt)
	@echo "--> Push thobe/wkhtmltopdf:golang1.14-alpine_0.12.6 Docker image"
	@docker push thobe/wkhtmltopdf:golang1.14-alpine_0.12.6

sep:
	@echo "----------------------------------------------------------------------------------"

finish:
	@echo "=================================================================================="
