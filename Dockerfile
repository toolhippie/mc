FROM ghcr.io/dockhippie/golang:1.23@sha256:ba9f30070709364682d6b6479e3aee1fb1717ccd65ecd09104aa0e1aac17a36d AS build

# renovate: datasource=github-tags depName=minio/mc
ENV MC_VERSION=RELEASE.2025-04-16T18-13-26Z

RUN git clone -b ${MC_VERSION} https://github.com/minio/mc.git /srv/app/src && \
  cd /srv/app/src && \
  GO111MODULE=on go install -ldflags "$(go run buildscripts/gen-ldflags.go)"

FROM ghcr.io/dockhippie/alpine:3.22@sha256:8c689fb24e65bb97d02d9224435dd07c6c94939a09b8bcae903e1bc5b87ae9ad
ENTRYPOINT [""]

RUN apk update && \
  apk upgrade && \
  rm -rf /var/cache/apk/*

COPY --from=build /srv/app/bin/mc /usr/bin/
