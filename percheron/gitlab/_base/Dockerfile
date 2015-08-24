FROM common_base:1.0.0
MAINTAINER ash@the-rebellion.net

RUN apk add --update-cache build-base git libxml2-dev libxslt-dev sqlite-dev readline-dev \
postgresql-dev icu-dev cmake linux-headers libffi-dev ruby ruby-dev nodejs openssh

RUN echo 'gem: --no-document' > /etc/gemrc
RUN gem install bundler foreman

RUN adduser -s /bin/bash -h /home/git -D -S git && passwd -u git
RUN su - git -c "git config --global core.autocrlf input"

ENV APP_HOME {{ userdata.gitlab.app_home }}
ENV DATA_HOME {{ userdata.gitlab.data_home }}
ENV REDIS_URL "redis://{{ userdata.redis.host }}:{{ userdata.redis.port }}"
ENV LIBGIT_TWO_VERSION {{ userdata.libgit_two_version }}
ENV GITLAB_VERSION {{ userdata.gitlab.version }}

RUN cd /tmp && wget "https://github.com/libgit2/libgit2/archive/v${LIBGIT_TWO_VERSION}.tar.gz"
RUN cd /tmp && tar xzf v${LIBGIT_TWO_VERSION}.tar.gz
RUN cd /tmp/libgit2-${LIBGIT_TWO_VERSION} && mkdir build && cd build && CFLAGS="-D__gnu_hurd__" cmake .. && \
CFLAGS="-D__gnu_hurd__" cmake --build . --target install && rm -f /tmp/v${LIBGIT_TWO_VERSION}.tar.gz

RUN mkdir -p ${APP_HOME} ${DATA_HOME}
RUN chown git ${APP_HOME}
WORKDIR ${APP_HOME}

RUN bundle config build.nokogiri "--use-system-libraries"
RUN bundle config build.rugged "--use-system-libraries"
# ADD gitlab/Gemfile* ${APP_HOME}/
# RUN CFLAGS="-L/usr/local/lib -I/usr/local/include" bundle install -j4 --without="mysql kerberos"

# ADD gitlab/ ${APP_HOME}/
# RUN rm -rf Gemfile* .bundle public && su git -c "git clone https://gitlab.com/gitlab-org/gitlab-ce.git -b ${GITLAB_VERSION} ."
# RUN su git -c "git clone https://gitlab.com/gitlab-org/gitlab-ce.git -b ${GITLAB_VERSION} ."
RUN curl -L https://gitlab.com/gitlab-org/gitlab-ce/repository/archive.tar.gz?ref=v${GITLAB_VERSION} | tar --strip-components 1 -xzf -
RUN mkdir -p public/assets
# RUN mkdir -p log tmp/assets public/assets && chown -R git ${APP_HOME}/
RUN chmod -R u+rwX,go-w log && chmod -R u+rwX tmp tmp/pids tmp/sockets public/uploads
RUN CFLAGS="-L/usr/local/lib -I/usr/local/include" bundle install -j4 --without="mysql kerberos"

ADD ./config/sshd_config /etc/ssh/sshd_config
RUN /usr/bin/ssh-keygen -A

ADD ./config/gitlab/secrets.yml ${APP_HOME}/config/secrets.yml
ADD ./config/gitlab/database.yml ${APP_HOME}/config/database.yml
ADD ./config/gitlab/gitlab.yml ${APP_HOME}/config/gitlab.yml
ADD ./config/gitlab/resque.yml ${APP_HOME}/config/resque.yml
ADD ./config/gitlab/unicorn.rb ${APP_HOME}/config/unicorn.rb
ADD ./config/gitlab/rack_attack.rb ${APP_HOME}/config/initializers/rack_attack.rb
RUN echo '{{ secrets.gitlab.shell_secret }}' > ${APP_HOME}/.gitlab_shell_secret

RUN sed -i 's%<REDIS_HOST>%{{ userdata.redis.host }}%' ${APP_HOME}/config/resque.yml
RUN sed -i 's%<REDIS_PORT>%{{ userdata.redis.port }}%' ${APP_HOME}/config/resque.yml

RUN rm -f .foreman
