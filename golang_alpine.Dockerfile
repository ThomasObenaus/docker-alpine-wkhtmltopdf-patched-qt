
FROM thobe/wkhtmltopdf-base:latest as wkhtmltopdf
FROM golang:1.15.8-alpine3.13

ARG git_revision

RUN apk add --update --no-cache \
    libgcc libstdc++ libx11 libxrender libxext libintl \
    ttf-dejavu ttf-droid ttf-freefont ttf-liberation ttf-ubuntu-font-family

# Adds support for chinese fonts (taken from https://stackoverflow.com/questions/49067625/how-can-i-use-chinese-in-alpine-headless-chrome)
# Adds https://pkgs.alpinelinux.org/package/edge/testing/x86/wqy-zenhei
RUN apk add wqy-zenhei --update-cache --repository http://nl.alpinelinux.org/alpine/edge/testing --allow-untrusted

# Add wkhtmltopdf taken from thobe/wkhtml_apline
COPY --from=wkhtmltopdf /bin/wkhtmltopdf /bin/wkhtmltopdf