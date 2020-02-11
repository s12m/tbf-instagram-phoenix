  
FROM elixir:1.10.1-alpine

ENV LANG C.UTF-8
ENV TZ=Asia/Tokyo

ENV WORKDIR /work
RUN mkdir $WORKDIR
WORKDIR $WORKDIR

RUN apk update && \
    apk --no-cache --update add \
    git make g++ wget curl inotify-tools \
    nodejs nodejs-npm && \
    npm install npm -g --no-progress && \
    rm -rf /var/cache/apk/* && \
    mix local.hex --force && \
    mix local.rebar --force && \
    mix archive.install --force hex phx_new 1.4.12
