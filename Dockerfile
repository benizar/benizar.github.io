FROM ruby
MAINTAINER benizar@gmail.com

# Set the locale
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN apt-get update
RUN apt-get install -y node python-pygments

RUN gem install jekyll bundler

# Install Gems
RUN gem install \
  github-pages \
  jekyll-scholar

VOLUME /srv/jekyll
EXPOSE 4000

WORKDIR /srv/jekyll

## These commands are executed from docker-compose
#ENTRYPOINT bundle install && jekyll serve --host 0.0.0.0 --watch --incremental
