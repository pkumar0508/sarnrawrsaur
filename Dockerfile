# gcloud container images describe mirror.gcr.io/library/golang:1.12
FROM mirror.gcr.io/library/golang@sha256:b9edf5a27f9991d798a733ab25bc6e13dd5c66828b4bf821be07ac326948e61a as builder

WORKDIR /workspace
COPY . .

RUN go mod download && go mod verify && go test ./...

# TODO: check if this line is the preferred build command for go 1.10+
RUN CGO_ENABLED=0 GOOS=linux go build -v -o server

# TODO: fetch this image by digest for security
FROM alpine
RUN apk add --no-cache ca-certificates
COPY --from=builder /workspace/server /server

ENTRYPOINT ["/server"]
