# syntax=docker/dockerfile:1

FROM ruby:3.0 AS build
ARG RAILS_PARAMS
ARG RAILS_PROJECT_NAME

RUN gem install rails
RUN rails new $RAILS_PROJECT_NAME $RAILS_PARAMS

FROM scratch
COPY --from=build /blog .