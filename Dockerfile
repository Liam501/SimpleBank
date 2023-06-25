# # Build stage
# FROM golang:1.20-alpine AS builder
# WORKDIR /app
# COPY . .
# RUN go build -o main main.go

# # Run stage
# FROM alpine
# WORKDIR /app
# COPY --from=builder /app/main .
# COPY app.env .
# COPY start.sh .
# COPY wait-for.sh .
# COPY db/migration ./db/migration

# Build stage
FROM golang:1.20-alpine AS builder
WORKDIR /app
COPY . .
RUN go build -o main main.go
RUN apk add crul
RUN curl -L https://github.com/golang-migrate/migrate/releases/download/v4.15.2/migrate.linux-amd64.tar.gz | tar xvz

# Run stage
FROM alpine
WORKDIR /app
COPY --from=builder /app/main .
COPY --from=builder /app/migrate.linux-amd64 ./migrate
COPY app.env .
COPY start.sh .
COPY wait-for.sh .
COPY db/migration ./migration

EXPOSE 8080
CMD [ "/app/main" ]
ENTRYPOINT [ "/app/start.sh" ]