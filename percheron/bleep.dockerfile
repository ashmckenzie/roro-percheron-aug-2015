FROM gliderlabs/alpine:latest
MAINTAINER ash@the-rebellion.net

RUN apk add --update-cache redis

EXPOSE 6379

CMD [ "/usr/bin/redis-server", "--port", "6379" ]

