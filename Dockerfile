ARG RUBY_VERSION=3.4.5
FROM ruby:$RUBY_VERSION-slim-trixie@sha256:0d2adfa1930d67ee79e5d16c3610f4fbed43c98e98dbda14c2811b8197211c74 AS base
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -qq \
  && apt-get install -yq --no-install-recommends \
    libpq-dev \
    libjemalloc2 \
    libyaml-dev \
  && apt-get clean \
  && ln -s /usr/lib/$(uname -m)-linux-gnu/libjemalloc.so.2 /usr/local/lib/libjemalloc.so \
  && rm -rf /var/cache/apt/archives /var/lib/apt/lists /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

ENV BUNDLE_PATH="/usr/local/bundle" \
  BUNDLE_RETRY=3 \
  LANG=C.UTF-8 \
  LD_PRELOAD=/usr/local/lib/libjemalloc.so

RUN groupadd --gid 1001 deploy \
  && useradd --uid 1001 --gid deploy --shell /bin/bash --create-home deploy

RUN mkdir /app && chown -R deploy:deploy /app

WORKDIR /app

FROM base AS builder
RUN apt-get update -qq \
  && apt-get install -yq --no-install-recommends \
    build-essential \
    git \
    curl \
    unzip \
  && apt-get clean \
  && rm -rf /var/cache/apt/archives /var/lib/apt/lists /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

RUN curl https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip -o /tmp/awscliv2.zip \
  && unzip /tmp/awscliv2.zip -d /tmp \
  && /tmp/aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update \
  && rm -rf /tmp/aws /tmp/awscliv2.zip

FROM builder AS ci
COPY --chown=deploy:deploy infra/bundle/config.ci ${BUNDLE_PATH}/config
COPY --chown=deploy:deploy Gemfile* /app/
RUN bundle install && \
    rm -rf ~/.bundle/ ${BUNDLE_PATH}/ruby/*/cache ${BUNDLE_PATH}/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile
COPY --chown=deploy:deploy . /app
