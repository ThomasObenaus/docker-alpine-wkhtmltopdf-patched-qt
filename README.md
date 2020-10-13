# Alpine Linux 3.12 with golang 1.14 and wkhtmltopdf 0.12.6 (with patched qt)

Based on [madnight/docker-alpine-wkhtmltopdf](https://github.com/madnight/docker-alpine-wkhtmltopdf)

Alpine has wkhtmltopdf package but with unpatched qt, therefor not all wkhtmltopdf features can be used.
This container builds wkhtmltopdf and patched qt.

## Build the images

```sh
# build the base image
make build.base

# build the golang-alpine image
build.golang-alpine
```

## Use the golang-alpine image

```Dockerfile
FROM thobe/wkhtmltopdf:golang1.14-alpine_0.12.6

# stuff of your custom docker image
# ...
# ...
```
