FROM roro_base:1.0.0
MAINTAINER ash@the-rebellion.net

RUN apk add --update-cache libxml2-dev libxslt-dev sqlite-dev libffi-dev ruby ruby-dev nodejs
RUN apk add --update-cache readline-dev postgresql-dev icu-dev

RUN echo 'gem: --no-document' > /etc/gemrc
RUN gem install bundler foreman

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

RUN bundle config build.nokogiri "--use-system-libraries"
ADD gitlab/Gemfile* $APP_HOME/
RUN bundle install -j4 --without="mysql kerberos"

ADD ./config/start /start
RUN chmod 755 /start

EXPOSE 5000

CMD [ "/start" ]
