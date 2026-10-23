FROM ghcr.io/dockhippie/golang:1.27@sha256:9fd44dfcdb09d8113e64940398b3356ca2bbe0d7a60c55c5ab8536b7939729de AS build

# renovate: datasource=github-tags depName=minio/mc
ENV MC_VERSION=RELEASE.2025-04-16T18-13-26Z

RUN git clone -b ${MC_VERSION} https://github.com/minio/mc.git /srv/app/src && \
  cd /srv/app/src && \
  GO111MODULE=on go install -ldflags "$(go run buildscripts/gen-ldflags.go)"

FROM ghcr.io/dockhippie/alpine:3.23@sha256:0518a97b1c6406d9777d435432dcb525b4f47a84562e13a6472f55ac6623f9f6
ENTRYPOINT [""]

RUN apk update && \
  apk upgrade && \
  rm -rf /var/cache/apk/*

COPY --from=build /srv/app/bin/mc /usr/bin/
