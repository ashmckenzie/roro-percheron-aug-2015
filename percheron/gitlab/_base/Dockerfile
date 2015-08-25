FROM common_base:1.0.0
MAINTAINER ash@the-rebellion.net

RUN apk add --update-cache build-base git libxml2-dev libxslt-dev sqlite-dev readline-dev \
postgresql-dev icu-dev cmake linux-headers libffi-dev ruby ruby-dev nodejs openssh

RUN echo 'gem: --no-document' > /etc/gemrc
RUN gem install bundler foreman

RUN adduser -s /bin/bash -h /home/git -D -S git && passwd -u git
RUN su - git -c "git config --global core.autocrlf input"

ADD ./config/sshd_config /etc/ssh/sshd_config
RUN /usr/bin/ssh-keygen -A

ENV LIBGIT_TWO_VERSION {{ userdata.libgit_two_version }}

RUN cd /tmp && curl -sL "https://github.com/libgit2/libgit2/archive/v${LIBGIT_TWO_VERSION}.tar.gz" | tar xzf -
RUN cd /tmp/libgit2-${LIBGIT_TWO_VERSION} && mkdir build && cd build && CFLAGS="-D__gnu_hurd__" cmake .. && \
CFLAGS="-D__gnu_hurd__" cmake --build . --target install && rm -f /tmp/v${LIBGIT_TWO_VERSION}.tar.gz
