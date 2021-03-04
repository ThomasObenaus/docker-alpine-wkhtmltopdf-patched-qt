
FROM golang:1.14.13-alpine

RUN apk add --update --no-cache make git build-base curl bash wget \
    && wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
    && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.29-r0/glibc-2.29-r0.apk \
    && apk add glibc-2.29-r0.apk


WORKDIR /opt
RUN curl -fsSL https://raw.githubusercontent.com/pact-foundation/pact-ruby-standalone/master/install.sh | bash
ENV PATH="/opt/pact/bin:${PATH}"

WORKDIR /go

CMD ["/bin/sh","-c","(#nop) WORKDIR /go"]
#CMD ["/bin/sh"]