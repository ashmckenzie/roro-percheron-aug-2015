FROM roro_base:1.0.0
MAINTAINER ash@the-rebellion.net

RUN apk add --update-cache postgresql

ENV PGBASE "/var/lib/postgresql"
ENV PGDATA "${PGBASE}/data"

RUN mkdir -p ${PGDATA}

ADD ./config/start /start
RUN chmod 755 /start

VOLUME [ "/var/lib/postgresql/data" ]

CMD [ "/start" ]
