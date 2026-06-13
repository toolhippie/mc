FROM ghcr.io/dockhippie/golang:1.26@sha256:00047f016ca50b0947703a645e116d36e6f02c3ab79125cb1b45f06240b39cba AS build

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
