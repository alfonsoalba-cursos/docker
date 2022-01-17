# syntax=docker/dockerfile:1

FROM ruby:3.0

RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN --mount=type=cache,target=/var/cache/apt --mount=type=cache,target=/var/lib/apt \
  apt update && apt upgrade && apt install -yq --no-install-recommends build-essential less curl openjdk-11-jre

COPY ./blog /blog

WORKDIR /blog

# RUN --mount=type=cache,target=/usr/local/bundle bundle install
RUN bundle install

CMD ["bin/rails", "s", "-b", "0.0.0.0"]