FROM ghcr.io/dockhippie/golang:1.26@sha256:573c3b82a8e452a2aaf0eea23e4f5b5f562c1252d1bae56c32a18223e79d9595 AS build

# renovate: datasource=github-tags depName=minio/mc
ENV MC_VERSION=RELEASE.2025-04-16T18-13-26Z

RUN git clone -b ${MC_VERSION} https://github.com/minio/mc.git /srv/app/src && \
  cd /srv/app/src && \
  GO111MODULE=on go install -ldflags "$(go run buildscripts/gen-ldflags.go)"

FROM ghcr.io/dockhippie/alpine:3.23@sha256:4f1d25154fbfd737924257bb63e372a6ce9689c0d202d7397d15aa316a7b644d
ENTRYPOINT [""]

RUN apk update && \
  apk upgrade && \
  rm -rf /var/cache/apk/*

COPY --from=build /srv/app/bin/mc /usr/bin/
