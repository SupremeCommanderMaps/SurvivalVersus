FROM debian:latest

RUN apt-get install -y lua5.1 luarocks

RUN luarocks install busted

WORKDIR /app