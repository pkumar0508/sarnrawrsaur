# FROM gcr.io/cloud-builders/go:latest
FROM gcr.io/cloud-builders/go@sha256:101d584e440f2a7d0d2c96d2d9f64375cfb1e43916dcf9cd65dc12454cb8d3a9 as builder
RUN apk update && apk add --no-cache git ca-certificates tzdata && update-ca-certificates
RUN adduser -D -g '' appuser

WORKDIR $GOPATH/src/pkumar0508/sarnrawrsaur/
COPY . .
RUN go mod download && go mod verify && go test ./...
RUN GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o /go/bin/sarnrawrsaur

FROM scratch
COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /go/bin/sarnrawrsaur /go/bin/sarnrawrsaur

USER appuser
EXPOSE 8080
ENTRYPOINT ["/go/bin/sarnrawrsaur"]
