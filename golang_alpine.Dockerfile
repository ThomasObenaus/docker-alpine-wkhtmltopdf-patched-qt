
FROM thobe/wkhtmltopdf-base:latest as wkhtmltopdf
FROM golang:1.14-alpine

ARG git_revision

RUN apk add --update --no-cache \
    libgcc libstdc++ libx11 glib libxrender libxext libintl \
    ttf-dejavu ttf-droid ttf-freefont ttf-liberation ttf-ubuntu-font-family

# Add wkhtmltopdf taken from thobe/wkhtml_apline
COPY --from=wkhtmltopdf /bin/wkhtmltopdf /bin/wkhtmltopdf


