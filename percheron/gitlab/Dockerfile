FROM roro_base:1.0.0
MAINTAINER ash@the-rebellion.net

RUN apk add --update-cache build-base git libxml2-dev libxslt-dev sqlite-dev readline-dev \
postgresql-dev icu-dev cmake linux-headers libffi-dev ruby ruby-dev nodejs openssh

RUN echo 'gem: --no-document' > /etc/gemrc
RUN gem install bundler foreman

RUN adduser -s /bin/bash -h /home/git -D -S git
RUN su - git -c "git config --global core.autocrlf input"

ENV APP_HOME {{ userdata.gitlab.app_home }}
ENV DATA_HOME {{ userdata.gitlab.data_home }}
ENV REDIS_URL "redis://{{ userdata.redis.host }}:{{ userdata.redis.port }}"
ENV LIBGIT_TWO_VERSION {{ userdata.libgit_two_version }}

RUN cd /tmp && wget "https://github.com/libgit2/libgit2/archive/v${LIBGIT_TWO_VERSION}.tar.gz"
RUN cd /tmp && tar xzf v${LIBGIT_TWO_VERSION}.tar.gz
RUN cd /tmp/libgit2-${LIBGIT_TWO_VERSION} && mkdir build && cd build && CFLAGS="-D__gnu_hurd__" cmake .. && \
CFLAGS="-D__gnu_hurd__" cmake --build . --target install

RUN mkdir -p ${APP_HOME} ${APP_HOME}/public/assets ${DATA_HOME}
WORKDIR ${APP_HOME}

RUN bundle config build.nokogiri "--use-system-libraries"
RUN bundle config build.rugged "--use-system-libraries"
ADD gitlab/Gemfile* ${APP_HOME}/
RUN CFLAGS="-L/usr/local/lib -I/usr/local/include" bundle install -j4 --without="mysql kerberos"

ADD gitlab/ ${APP_HOME}/
RUN chown -R git tmp log public/assets && chmod -R u+rwX,go-w log && chmod -R u+rwX tmp tmp/pids tmp/sockets public/uploads

ADD ./config/sshd_config /etc/ssh/sshd_config
RUN /usr/bin/ssh-keygen -A

ADD ./config/gitlab/secrets.yml ${APP_HOME}/config/secrets.yml
ADD ./config/gitlab/database.yml ${APP_HOME}/config/database.yml
ADD ./config/gitlab/gitlab.yml ${APP_HOME}/config/gitlab.yml
ADD ./config/gitlab/resque.yml ${APP_HOME}/config/resque.yml
ADD ./config/gitlab/unicorn.rb ${APP_HOME}/config/unicorn.rb
ADD ./config/gitlab/rack_attack.rb ${APP_HOME}/config/initializers/rack_attack.rb
ADD ./config/gitlab/Procfile ${APP_HOME}/Procfile

RUN sed -i 's%<REDIS_HOST>%{{ userdata.redis.host }}%' ${APP_HOME}/config/resque.yml
RUN sed -i 's%<REDIS_PORT>%{{ userdata.redis.port }}%' ${APP_HOME}/config/resque.yml

RUN rm -f .foreman
RUN touch .secret .gitlab_shell_secret && chown git .secret .gitlab_shell_secret
RUN su git -c 'bundle exec rake gitlab:shell:install[{{ userdata.gitlab.shell_version }}]'

ADD ./config/start /start
RUN chmod 755 /start

EXPOSE 22 5000

CMD [ "/start" ]
