FROM openresty/openresty:latest

MAINTAINER Adam Grandquist <grandquista@gmail.com>

RUN apk update
RUN apk add --no-cache build-base curl git openssl-dev perl wget unzip
RUN apk add --update --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ tini docker

RUN wget http://keplerproject.github.io/luarocks/releases/luarocks-2.3.0.tar.gz
RUN tar -xf luarocks-2.3.0.tar.gz
RUN cd luarocks-2.3.0 && ./configure \
    --with-lua="/usr/local/openresty/luajit/" \
    --lua-suffix="jit" \
    --with-lua-include="/usr/local/openresty/luajit/include/luajit-2.1"
RUN cd luarocks-2.3.0 && make bootstrap

RUN luarocks install luasec
RUN luarocks install luacrypto
RUN luarocks install Lua-ReQL

RUN cpan CPAN
RUN cpan App::cpanminus
RUN cpanm -v --notest Test::Nginx
RUN cpanm -v --notest Test::Nginx::Socket

COPY t t

RUN docker run rethinkdb && prove -r t
