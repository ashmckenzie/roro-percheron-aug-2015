FROM gliderlabs/alpine:latest
MAINTAINER ash@the-rebellion.net

ADD ./config/repositories /etc/apk/repositories

RUN apk add --update-cache bash openssl-dev ca-certificates tzdata wget ack vim tar
