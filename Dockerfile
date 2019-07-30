# gcloud container images describe mirror.gcr.io/library/golang:1.12
FROM mirror.gcr.io/library/golang@sha256:b9edf5a27f9991d798a733ab25bc6e13dd5c66828b4bf821be07ac326948e61a as builder

WORKDIR /workspace
COPY . .
RUN go mod download && go mod verify && go test ./...
RUN GOOS=linux GOARCH=amd64 go build -o /sarnrawrsaur

# gcloud container images describe mirror.gcr.io/alpine/git:latest
FROM mirror.gcr.io/alpine/git@sha256:8f5659025d83a60e9d140123bb1b27f3c334578aef10d002da4e5848580f1a6c
RUN apk add --no-cache ca-certificates
COPY --from=builder /sarnrawrsaur /sarnrawrsaur

RUN adduser -D -g '' appuser
USER appuser

# EXPOSE 8080
ENTRYPOINT ["/sarnrawrsaur"]
