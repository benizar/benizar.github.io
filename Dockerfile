FROM ruby:2.4

# Basic build-time metadata as defined at http://label-schema.org
LABEL org.label-schema.vendor="benito-zaragozi.com" \
      org.label-schema.url="https://github.com/benizar/docker-jekyll" \
      org.label-schema.name=" Docker container and utilities for Jekyll" \
      org.label-schema.version="0.1.0" \
      org.label-schema.vcs-url="https://github.com/benizar/docker-jekyll" \
      org.label-schema.vcs-ref="master" \
      org.label-schema.schema-version="1.0"

# Set the locale
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# Install basics
RUN apt-get update && apt-get install -y \
    node \
    python-pygments \
 && rm -rf /var/lib/apt/lists/*

# Install Gems
RUN gem install \
  jekyll \
  bundler \
  github-pages \
  jekyll-scholar

VOLUME /home
EXPOSE 4000
WORKDIR /home
