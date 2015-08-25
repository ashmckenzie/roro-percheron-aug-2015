FROM gliderlabs/alpine:latest
MAINTAINER ash@the-rebellion.net

RUN apk add --update-cache redis

CMD [ "/usr/bin/redis-server", "--port", "{{ userdata.redis.port }}" ]
