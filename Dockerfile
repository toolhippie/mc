FROM webhippie/golang:1.18 AS build

# renovate: datasource=github-tags depName=minio/mc
ENV MC_VERSION=RELEASE.2021-07-27T06-46-19Z

RUN git clone -b ${MC_VERSION} https://github.com/minio/mc.git /srv/app/src && \
  cd /srv/app/src && \
  GO111MODULE=on go install -ldflags "$(go run buildscripts/gen-ldflags.go)"

FROM webhippie/alpine:latest
ENTRYPOINT [""]

RUN apk update && \
  apk upgrade && \
  rm -rf /var/cache/apk/*

COPY --from=build /srv/app/bin/mc /usr/bin/
