FROM gliderlabs/alpine:latest
MAINTAINER ash@the-rebellion.net

RUN apk add --update-cache bash postfix

ADD ./config/start /start
RUN chmod 755 /start

CMD [ "/start" ]
