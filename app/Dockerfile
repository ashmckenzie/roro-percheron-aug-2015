FROM roro_base:1.0.0
MAINTAINER ash@the-rebellion.net

RUN apk add --update-cache build-base git libxml2-dev libxslt-dev sqlite-dev readline-dev \
postgresql-dev icu-dev cmake linux-headers libffi-dev ruby ruby-dev nodejs

RUN echo 'gem: --no-document' > /etc/gemrc
RUN gem install bundler foreman

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

RUN bundle config build.nokogiri "--use-system-libraries"
ADD gitlab/Gemfile* $APP_HOME/
RUN bundle install -j2 --without="mysql kerberos"

ADD ./config/start /start
RUN chmod 755 /start

RUN mkdir /data

EXPOSE 5000

CMD [ "/start" ]
