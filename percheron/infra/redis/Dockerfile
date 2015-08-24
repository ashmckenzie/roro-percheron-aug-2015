FROM gliderlabs/alpine:latest
MAINTAINER ash@the-rebellion.net

ENV TERM ansi

RUN apk add --update-cache redis

ADD ./config/start /start
RUN chmod 755 /start

CMD [ "/start" ]
