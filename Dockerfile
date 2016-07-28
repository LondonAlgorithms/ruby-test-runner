FROM ruby:latest

WORKDIR /usr/ruby-test-runner
COPY Gemfile /usr/ruby-test-runner
COPY Gemfile.lock /usr/ruby-test-runner
RUN bundle install

COPY app /usr/ruby-test-runner/app
RUN mkdir /usr/ruby-test-runner/builds
