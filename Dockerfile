# gcloud container images describe mirror.gcr.io/library/golang:1.12
FROM mirror.gcr.io/library/golang@sha256:b9edf5a27f9991d798a733ab25bc6e13dd5c66828b4bf821be07ac326948e61a as builder

WORKDIR /workspace
COPY . .

RUN go mod download && go mod verify && go test ./...
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -v -o server

# gcloud container images describe mirror.gcr.io/library/alpine:latest
FROM mirror.gcr.io/library/alpine@sha256:57334c50959f26ce1ee025d08f136c2292c128f84e7b229d1b0da5dac89e9866
RUN apk add --no-cache ca-certificates
COPY --from=builder /workspace/server /server

ENTRYPOINT ["/server"]
