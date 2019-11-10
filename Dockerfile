  
FROM elixir:1.9.2
ENV LANG C.UTF-8

ENV WORKDIR /work
RUN mkdir $WORKDIR
WORKDIR $WORKDIR

RUN cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get update && \
    apt-get install -y \
    nodejs inotify-tools git && \
    mix local.hex --force && \
    mix local.rebar --force && \
    mix archive.install --force hex phx_new 1.4.10