FROM ghcr.io/dockhippie/golang:1.26@sha256:573c3b82a8e452a2aaf0eea23e4f5b5f562c1252d1bae56c32a18223e79d9595 AS build

# renovate: datasource=github-tags depName=minio/mc
ENV MC_VERSION=RELEASE.2025-04-16T18-13-26Z

RUN git clone -b ${MC_VERSION} https://github.com/minio/mc.git /srv/app/src && \
  cd /srv/app/src && \
  GO111MODULE=on go install -ldflags "$(go run buildscripts/gen-ldflags.go)"

FROM ghcr.io/dockhippie/alpine:3.23@sha256:b96792d40b58aed3ca66b37fb7c44a860acef5324bee5bb3b48f817ae65de248
ENTRYPOINT [""]

RUN apk update && \
  apk upgrade && \
  rm -rf /var/cache/apk/*

COPY --from=build /srv/app/bin/mc /usr/bin/
