FROM gliderlabs/alpine:latest
MAINTAINER ash@the-rebellion.net

ENV TERM ansi

ENV PGBASE "/var/lib/postgresql"
ENV PGDATA "${PGBASE}/data"

RUN apk add --update-cache bash postgresql
RUN mkdir -p ${PGDATA}

ADD ./config/start /start
RUN chmod 755 /start

VOLUME [ "/var/lib/postgresql/data" ]

CMD [ "/start" ]
