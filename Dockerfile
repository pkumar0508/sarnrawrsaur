FROM golang:1.13

WORKDIR /tmp/build
COPY . .

RUN go mod download && go mod verify && go test ./...
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -v -o server

FROM alpine:3
RUN apk add --no-cache ca-certificates
COPY --from=builder /tmp/build/server /usr/bin/server

ENTRYPOINT ["/usr/bin/server"]
