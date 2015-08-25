FROM gitlab_base:1.0.0
MAINTAINER ash@the-rebellion.net

RUN apk --update-cache add redis rsync

ENV APP_HOME {{ userdata.gitlab.app_home }}
ENV DATA_HOME {{ userdata.gitlab.data_home }}
ENV REDIS_URL "redis://{{ userdata.redis.host }}:{{ userdata.redis.port }}"
ENV GITLAB_VERSION {{ userdata.gitlab.version }}
ENV TMP_APP_HOME /tmp${APP_HOME}

RUN mkdir -p ${APP_HOME} ${TMP_APP_HOME} ${DATA_HOME}
WORKDIR ${TMP_APP_HOME}

RUN wget --quiet https://gitlab.com/gitlab-org/gitlab-ce/repository/archive.tar.gz?ref=v${GITLAB_VERSION} -O - | tar --strip-components 1 -xzf -
RUN rm -f .foreman
RUN mkdir -p log tmp/assets public/assets && chown -R git .
RUN chmod -R u+rwX,go-w log && chmod -R u+rwX tmp tmp/pids tmp/sockets public/uploads

ADD ./config/Procfile ./Procfile
ADD ./config/gitlab/secrets.yml ./config/secrets.yml
ADD ./config/gitlab/database.yml ./config/database.yml
ADD ./config/gitlab/gitlab.yml ./config/gitlab.yml
ADD ./config/gitlab/resque.yml ./config/resque.yml
ADD ./config/gitlab/unicorn.rb ./config/unicorn.rb
ADD ./config/gitlab/rack_attack.rb ./config/initializers/rack_attack.rb
RUN echo '{{ secrets.gitlab.shell_secret }}' > ./gitlab_shell_secret

RUN sed -i 's%<REDIS_HOST>%{{ userdata.redis.host }}%' ./config/resque.yml
RUN sed -i 's%<REDIS_PORT>%{{ userdata.redis.port }}%' ./config/resque.yml

RUN bundle config build.nokogiri "--use-system-libraries"
RUN bundle config build.rugged "--use-system-libraries"

RUN CFLAGS="-L/usr/local/lib -I/usr/local/include" bundle install -j4 --deployment --without="mysql kerberos"

ADD ./config/start /start
RUN chmod 755 /start

WORKDIR ${APP_HOME}

EXPOSE 22 5000

VOLUME [ "/app" ]

CMD [ "/start" ]
