FROM webhippie/golang:1.19 AS build

# renovate: datasource=github-tags depName=minio/mc
ENV MC_VERSION=RELEASE.2022-06-26T18-51-48Z

RUN git clone -b ${MC_VERSION} https://github.com/minio/mc.git /srv/app/src && \
  cd /srv/app/src && \
  GO111MODULE=on go install -ldflags "$(go run buildscripts/gen-ldflags.go)"

FROM webhippie/alpine:3.16
ENTRYPOINT [""]

RUN apk update && \
  apk upgrade && \
  rm -rf /var/cache/apk/*

COPY --from=build /srv/app/bin/mc /usr/bin/
