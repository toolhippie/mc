FROM ghcr.io/dockhippie/golang:1.23@sha256:c216fc815d94e3ca49a7db76b45742d1ded5237eb870bfa2441c3642835ac107 AS build

# renovate: datasource=github-tags depName=minio/mc
ENV MC_VERSION=RELEASE.2025-04-16T18-13-26Z

RUN git clone -b ${MC_VERSION} https://github.com/minio/mc.git /srv/app/src && \
  cd /srv/app/src && \
  GO111MODULE=on go install -ldflags "$(go run buildscripts/gen-ldflags.go)"

FROM ghcr.io/dockhippie/alpine:3.23@sha256:95760a33908b66020311e4d50c71ae7ac3132aee8971e037d99a858cdc5b074e
ENTRYPOINT [""]

RUN apk update && \
  apk upgrade && \
  rm -rf /var/cache/apk/*

COPY --from=build /srv/app/bin/mc /usr/bin/
