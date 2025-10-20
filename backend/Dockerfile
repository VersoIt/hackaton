FROM golang:1.25-alpine AS builder

WORKDIR /app

RUN apk add --no-cache ca-certificates git

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED = 0 GOOS = linux go build -o main ./cmd

FROM alpine:latest
WORKDIR /app

RUN apk --no-cache add ca-certificate

COPY --from=builder /app/main .
COPY --from=builder /app/config ./config

EXPOSE 8080

USER 65532:65532

ENTRYPOINT ["./main"]