# syntax=docker/dockerfile:1

FROM ruby:3.0

RUN apt update && apt upgrade -y && \
    sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt bullseye-pgdg main" > /etc/apt/sources.list.d/pgdg.list' && \
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    apt update && \
    apt -y install postgresql-client && \
    apt clean && \
    rm -rf /var/cache/apt/archives/* && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    truncate -s 0 /var/log/*log

COPY ./blog /blog

WORKDIR /blog
RUN bundle install

CMD ["bin/rails", "s", "-b", "0.0.0.0"]