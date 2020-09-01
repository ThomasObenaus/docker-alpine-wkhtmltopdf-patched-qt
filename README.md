# Alpine Linux 3.12 with golang 1.14 and wkhtmltopdf 0.12.5 (with patched qt)

Based on [RoseRocket/docker-alpine-wkhtmltopdf-patched-qt](https://github.com/RoseRocket/docker-alpine-wkhtmltopdf-patched-qt)

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
FROM thobe/wkhtmltopdf:golang1.14-alpine

# stuff of your custom docker image
# ...
# ...
```
