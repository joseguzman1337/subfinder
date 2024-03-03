# Build
FROM golang:1.20.6-alpine@sha256:7839c9f01b5502d7cb5198b2c032857023424470b3e31ae46a8261ffca72912a AS build-env
RUN apk add build-base
WORKDIR /app
COPY . /app
WORKDIR /app/v2
RUN go mod download
RUN go build ./cmd/subfinder

# Release
FROM alpine:3.18.2@sha256:82d1e9d7ed48a7523bdebc18cf6290bdb97b82302a8a9c27d4fe885949ea94d1
RUN apk upgrade --no-cache \
    && apk add --no-cache bind-tools ca-certificates
COPY --from=build-env /app/v2/subfinder /usr/local/bin/

ENTRYPOINT ["subfinder"]