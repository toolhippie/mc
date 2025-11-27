FROM ghcr.io/dockhippie/golang:1.23@sha256:1ddfddfd3e2655f697c7d76652c98d1f6c1bb3c53face26d2b56c240a2ae974b AS build

# renovate: datasource=github-tags depName=minio/mc
ENV MC_VERSION=RELEASE.2025-04-16T18-13-26Z

RUN git clone -b ${MC_VERSION} https://github.com/minio/mc.git /srv/app/src && \
  cd /srv/app/src && \
  GO111MODULE=on go install -ldflags "$(go run buildscripts/gen-ldflags.go)"

FROM ghcr.io/dockhippie/alpine:3.22@sha256:5b36d6c9994b3dbde7ff8e6140558b673d4ceb4d794c586073b934585c064a37
ENTRYPOINT [""]

RUN apk update && \
  apk upgrade && \
  rm -rf /var/cache/apk/*

COPY --from=build /srv/app/bin/mc /usr/bin/
