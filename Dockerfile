ARG GO_VERSION=1
FROM golang:${GO_VERSION}-alpine as builder

WORKDIR /usr/src/app
COPY go.mod go.sum ./
RUN go mod download && go mod verify
COPY . .
RUN go build -v -o /run-app .


FROM alpine:3.17

WORKDIR /opt

# Install dbmate in a way that works on Alpine Linux.
RUN apk --no-cache add npm \
    && npm install --save-dev dbmate

COPY ./bin bin
COPY ./db db

COPY --from=builder /run-app /usr/local/bin/
CMD ["run-app"]
