ARG GO_VERSION=1
FROM golang:${GO_VERSION}-alpine as builder

WORKDIR /usr/src/app
COPY go.mod go.sum ./
RUN go mod download && go mod verify
COPY . .
RUN go build -v -o /run-app .


FROM alpine:3.17

RUN apk --no-cache add curl \
    && curl -fsSL -o /usr/bin/dbmate https://github.com/amacneil/dbmate/releases/download/v1.4.1/dbmate-linux-amd64 \
    && chmod +x /usr/bin/dbmate

COPY --from=builder /run-app /usr/local/bin/
CMD ["run-app"]
