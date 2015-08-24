FROM roro_base:1.0.0
MAINTAINER ash@the-rebellion.net

RUN apk add --update-cache build-base git libxml2-dev libxslt-dev sqlite-dev readline-dev \
postgresql-dev icu-dev cmake linux-headers libffi-dev ruby ruby-dev nodejs

RUN echo 'gem: --no-document' > /etc/gemrc
RUN gem install bundler foreman

RUN adduser -s /bin/bash -S -D git
RUN su - git -c "git config --global core.autocrlf input"

# ENV APP_HOME {{ userdata.gitlab.app_home }}
# ENV DATA_HOME {{ userdata.gitlab.app_home }}
# ENV LIBGIT_TWO_VERSION {{ userdata.libgit_two_version }}

RUN cd /tmp && wget "https://github.com/libgit2/libgit2/archive/v{{ userdata.libgit_two_version }}.tar.gz"
RUN cd /tmp && tar xzvf v{{ userdata.libgit_two_version }}.tar.gz
RUN cd /tmp/libgit2-{{ userdata.libgit_two_version }} && mkdir build && cd build && CFLAGS="-D__gnu_hurd__" cmake .. && \
CFLAGS="-D__gnu_hurd__" cmake --build . --target install

RUN mkdir {{ userdata.gitlab.app_home }} {{ userdata.gitlab.data_home }}
WORKDIR {{ userdata.gitlab.app_home }}

RUN bundle config build.nokogiri "--use-system-libraries"
RUN bundle config build.rugged "--use-system-libraries"
ADD gitlab/Gemfile* {{ userdata.gitlab.app_home }}/
RUN CFLAGS="-L/usr/local/lib -I/usr/local/include" bundle install -j4 --without="mysql kerberos"

ENV APP_HOME {{ userdata.gitlab.app_home }}
ENV REDIS_URL "redis://{{ userdata.redis.host }}:{{ userdata.redis.port }}"

ADD gitlab/ ${APP_HOME}/
ADD ./config/gitlab/database.yml ${APP_HOME}/config/database.yml
ADD ./config/gitlab/gitlab.yml ${APP_HOME}/config/gitlab.yml
ADD ./config/gitlab/resque.yml ${APP_HOME}/config/resque.yml
ADD ./config/gitlab/rack_attack.rb ${APP_HOME}/config/initializers/rack_attack.rb

RUN sed -i 's%<POSTGRES_HOST>%{{ userdata.postgres.host }}%' ${APP_HOME}/config/database.yml
RUN sed -i 's%<POSTGRES_PORT>%{{ userdata.postgres.port }}%' ${APP_HOME}/config/database.yml
RUN sed -i 's%<POSTGRES_NAME>%{{ userdata.postgres.name }}%' ${APP_HOME}/config/database.yml
RUN sed -i 's%<POSTGRES_USERNAME>%{{ userdata.postgres.username }}%' ${APP_HOME}/config/database.yml
RUN sed -i 's%<POSTGRES_PASSWORD>%{{ secrets.postgres.password }}%' ${APP_HOME}/config/database.yml

RUN sed -i 's%<REDIS_HOST>%{{ userdata.redis.host }}%' ${APP_HOME}/config/resque.yml
RUN sed -i 's%<REDIS_PORT>%{{ userdata.redis.port }}%' ${APP_HOME}/config/resque.yml

RUN sed -i 's%<GITLAB_EMAIL_FROM>%{{ userdata.gitlab.email_from }}%' ${APP_HOME}/config/gitlab.yml
RUN sed -i 's%<GITLAB_EMAIL_DISPLAY_NAME>%{{ userdata.gitlab.email_display_name }}%' ${APP_HOME}/config/gitlab.yml
RUN sed -i 's%<GITLAB_EMAIL_REPLY_TO>%{{ userdata.gitlab.email_reply_to }}%' ${APP_HOME}/config/gitlab.yml

RUN chown -R git tmp log && chmod -R u+rwX,go-w log && chmod -R u+rwX tmp tmp/pids tmp/sockets public/uploads

RUN touch ${APP_HOME}/.secret ${APP_HOME}/.gitlab_shell_secret && \
chown git ${APP_HOME}/.secret ${APP_HOME}/.gitlab_shell_secret
RUN su git -c 'bundle exec rake gitlab:shell:install[{{ userdata.gitlab.shell_version }}]'

ADD ./config/start /start
RUN chmod 755 /start

EXPOSE 5000

CMD [ "/start" ]
