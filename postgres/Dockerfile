FROM roro_base:1.0.0
MAINTAINER ash@the-rebellion.net

RUN apk add --update-cache postgresql

ADD ./config/start /start
RUN chmod 755 /start

CMD [ "/start" ]
