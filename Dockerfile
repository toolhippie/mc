FROM ghcr.io/dockhippie/golang:1.27@sha256:a1141a722e4dc549b8965740c0d818be8bd17ade52a565687b7e449871bc2353 AS build

# renovate: datasource=github-tags depName=minio/mc
ENV MC_VERSION=RELEASE.2025-04-16T18-13-26Z

RUN git clone -b ${MC_VERSION} https://github.com/minio/mc.git /srv/app/src && \
  cd /srv/app/src && \
  GO111MODULE=on go install -ldflags "$(go run buildscripts/gen-ldflags.go)"

FROM ghcr.io/dockhippie/alpine:3.23@sha256:a95a9a4236d9d8ea9250ac367ab8d83b161493788c5e05394c74ac5c95320875
ENTRYPOINT [""]

RUN apk update && \
  apk upgrade && \
  rm -rf /var/cache/apk/*

COPY --from=build /srv/app/bin/mc /usr/bin/
