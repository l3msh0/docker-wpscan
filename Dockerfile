FROM ruby:2.3-alpine
LABEL maintainer "L3msh0@gmail.com"

ARG WPSCAN_VERSION=2.9.2

RUN \
  apk add --no-cache curl ca-certificates openssl libxml2 libxslt procps && \
  apk add --no-cache --virtual .dev git curl-dev libxml2-dev libxslt-dev alpine-sdk && \
  wget https://github.com/wpscanteam/wpscan/archive/${WPSCAN_VERSION}.tar.gz && \
  adduser -h /wpscan -D wpscan && \
  echo "install: --no-document" >> /etc/gemrc && \
  echo "update: --no-document" >> /etc/gemrc && \
  cd /wpscan && \
  sudo -u wpscan tar --strip-components=1 -zxf /${WPSCAN_VERSION}.tar.gz && \
  rm /2.9.2.tar.gz

USER wpscan
WORKDIR /wpscan

RUN \
  bundle install --without test --path vendor/bundle && \
  /wpscan/wpscan.rb --update --verbose --no-color

USER root
RUN apk del --purge .build-tools

USER wpscan
ENTRYPOINT ["/wpscan/wpscan.rb"]
CMD ["--help"]
