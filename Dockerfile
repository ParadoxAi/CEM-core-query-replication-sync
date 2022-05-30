# to run dv dev local
# docker pull mysql:5.7.12
# docker run -e MYSQL_ROOT_PASSWORD=root -p 3306:3306 2fd136002c22
# docker run -e MYSQL_ROOT_PASSWORD=root -p 3306:3306 mysql:5.7.12

FROM golang:latest AS builder

# not sure if golang:latest already sets these
ENV CGO_ENABLED=0
ENV GOOS=linux
ENV GOARCH=amd64

WORKDIR /app
COPY . .

RUN go mod download
RUN go build -o main .

FROM alpine:latest

# app-specific
ENV ENV=prod

WORKDIR /home

COPY --from=builder /app .
CMD ["./main"]