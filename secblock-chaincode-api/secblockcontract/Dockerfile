FROM golang:1.13.8-alpine AS build
COPY ./ /go/src/github.com/secblock
WORKDIR /go/src/github.com/secblock
RUN go build -o chaincode -v .

FROM alpine:3.11 as prod
COPY --from=build /go/src/github.com/secblock/chaincode /app/chaincode
ENV ISEXTERNAL=true
USER 1000
WORKDIR /app
CMD ./chaincode
