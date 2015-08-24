FROM gitlab_base:1.0.0
MAINTAINER ash@the-rebellion.net

ENV APP_HOME {{ userdata.gitlab.app_home }}

ADD ./config/Procfile ${APP_HOME}/Procfile
RUN mkdir -p log tmp/assets public/assets && chown -R git ${APP_HOME}/
RUN su git -c 'bundle exec rake gitlab:shell:install[{{ userdata.gitlab.shell_version }}]'

ADD ./config/start /start
RUN chmod 755 /start

CMD [ "/start" ]
