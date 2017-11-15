FROM ruby:2.4-alpine
LABEL maintainer "L3msh0@gmail.com"

ARG WPSCAN_VERSION=2.9.3

RUN \
  apk add --upgrade --no-cache curl ca-certificates openssl libxml2 libxslt procps && \
  update-ca-certificates && \
  apk add --upgrade --no-cache --virtual .builddeps git curl-dev libxml2-dev libxslt-dev alpine-sdk && \
  wget https://github.com/wpscanteam/wpscan/archive/${WPSCAN_VERSION}.tar.gz -O /tmp/wpscan.tar.gz && \
  adduser -h /wpscan -D wpscan && \
  echo "install: --no-document" >> /etc/gemrc && \
  echo "update: --no-document" >> /etc/gemrc && \
  sudo -u wpscan tar --strip-components=1 -zxf /tmp/wpscan.tar.gz -C /wpscan && \
  su -c 'cd /wpscan; bundle install --without test --path vendor/bundle' wpscan && \
  rm /tmp/wpscan.tar.gz && \
  apk del --purge .builddeps

USER wpscan
WORKDIR /wpscan
VOLUME /wpscan/data
ENTRYPOINT ["./wpscan.rb"]
CMD ["--help"]
