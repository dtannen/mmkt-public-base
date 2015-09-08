FROM ubuntu:14.04

# http://askubuntu.com/a/601498/154707
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get update
RUN apt-get install -y \
  git \
  libpq-dev \
  wget \
  nodejs \
  npm \
  imagemagick \
  nodejs-legacy \
  postgresql-client \
  awscli

# Fix cron permission issue
# https://github.com/aptible/docker-ubuntu/issues/5
RUN apt-get -y build-dep pam
RUN export CONFIGURE_OPTS=--disable-audit && \
  cd /root && apt-get -b source pam && \
  dpkg -i libpam-doc*.deb libpam-modules*.deb libpam-runtime*.deb libpam0g*.deb

RUN wget -O ruby-install-0.5.0.tar.gz https://github.com/postmodern/ruby-install/archive/v0.5.0.tar.gz
RUN tar -xzvf ruby-install-0.5.0.tar.gz
RUN cd ruby-install-0.5.0 && make install

ENV RUBY_VERSION=2.2.2
ENV APP /home/mmkt

RUN ruby-install ruby $RUBY_VERSION

ENV PATH ./node_modules/.bin:/opt/rubies/ruby-$RUBY_VERSION/bin:$PATH

RUN mkdir $APP

RUN gem install bundler
