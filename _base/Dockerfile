FROM gliderlabs/alpine:latest
MAINTAINER ash@the-rebellion.net

ENV HOME /root
ENV TERM ansi
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ADD ./config/repositories /etc/apk/repositories
ADD ./config/supervisord.conf /etc/supervisord.conf

RUN apk add --update-cache build-base supervisor git bash openssl-dev ca-certificates libxml2-dev \
libxslt-dev sqlite-dev tzdata postgresql-client cmake linux-headers
