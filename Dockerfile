# Build
FROM golang:1.22.0-alpine@sha256:8e96e6cff6a388c2f70f5f662b64120941fcd7d4b89d62fec87520323a316bd9 AS build-env
RUN apk add build-base
WORKDIR /app
COPY . /app
WORKDIR /app/v2
RUN go mod download
RUN go build ./cmd/subfinder

# Release
FROM alpine:3.19.1@sha256:c5b1261d6d3e43071626931fc004f70149baeba2c8ec672bd4f27761f8e1ad6b
RUN apk upgrade --no-cache \
    && apk add --no-cache bind-tools ca-certificates
COPY --from=build-env /app/v2/subfinder /usr/local/bin/

ENTRYPOINT ["subfinder"]