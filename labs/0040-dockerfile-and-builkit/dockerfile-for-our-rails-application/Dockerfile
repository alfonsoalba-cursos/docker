# syntax=docker/dockerfile:1

FROM ruby:3.0

COPY ./blog /blog

WORKDIR /blog
RUN bundle install

CMD ["bin/rails", "s", "-b", "0.0.0.0"]