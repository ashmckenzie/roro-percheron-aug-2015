FROM roro_base:1.0.0
MAINTAINER ash@the-rebellion.net

RUN apk add --update-cache build-base git libxml2-dev libxslt-dev sqlite-dev readline-dev \
postgresql-dev icu-dev cmake linux-headers libffi-dev ruby ruby-dev nodejs

RUN echo 'gem: --no-document' > /etc/gemrc
RUN gem install bundler foreman

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

RUN adduser -s /bin/bash -S -D git

RUN cd /tmp && https://github.com/libgit2/libgit2/archive/v0.23.1.tar.gz && \
tar xzvf v0.23.1.tar.gz && cd libgit2-0.23.1 && cmake .. && \
CFLAGS="-D__gnu_hurd__" cmake .. && CFLAGS="-D__gnu_hurd__" cmake --build . --target install

RUN bundle config build.nokogiri "--use-system-libraries"
RUN bundle config build.rugged "--use-system-libraries"
ADD gitlab/Gemfile* $APP_HOME/
RUN CFLAGS="-L/usr/local/lib -I/usr/local/include" bundle install -j2 --without="mysql kerberos"

ADD gitlab/ /app/
ADD ./config/gitlab/database.yml /app/config/database.yml
ADD ./config/gitlab/gitlab.yml /app/config/gitlab.yml

RUN chown -R git tmp log && chmod -R u+rwX,go-w log && chmod -R u+rwX tmp tmp/pids tmp/sockets public/uploads

RUN su git -c "bundle exec rake gitlab:shell:install[${GITLAB_SHELL_VERSION}] REDIS_URL=redis://${REDIS_SERVER}"

ADD ./config/start /start
RUN chmod 755 /start

RUN mkdir /data

EXPOSE 5000

CMD [ "/start" ]
