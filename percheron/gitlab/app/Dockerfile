FROM gitlab_base:1.0.0
MAINTAINER ash@the-rebellion.net

ADD ./config/Procfile ${APP_HOME}/Procfile
RUN su git -c 'bundle exec rake gitlab:shell:install[{{ userdata.gitlab.shell_version }}]'

ADD ./config/start /start
RUN chmod 755 /start

EXPOSE 22 5000

CMD [ "/start" ]
