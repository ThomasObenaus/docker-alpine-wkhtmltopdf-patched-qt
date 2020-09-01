
FROM thobe/wkhtmltopdf-base:latest as wkhtmltopdf
FROM golang:1.14-alpine

ARG git_revision

# install patched qt
RUN apk --update --no-cache add \
    libgcc \
    libstdc++ \
    musl \
    qt5-qtbase \
    qt5-qtbase-x11 \
    qt5-qtsvg \
    qt5-qtwebkit \
    ttf-freefont \
    ttf-dejavu \
    ttf-droid \
    ttf-liberation \
    ttf-ubuntu-font-family \
    fontconfig

# Add openssl dependencies for wkhtmltopdf
RUN echo 'http://dl-cdn.alpinelinux.org/alpine/v3.8/main' >> /etc/apk/repositories && \
    apk add --no-cache libcrypto1.0 libssl1.0

# Add wkhtmltopdf taken from thobe/wkhtml_apline
COPY --from=wkhtmltopdf /bin/wkhtmltopdf /bin/wkhtmltopdf


