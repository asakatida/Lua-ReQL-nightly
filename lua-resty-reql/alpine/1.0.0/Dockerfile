FROM openresty/openresty:latest

MAINTAINER Adam Grandquist <grandquista@gmail.com>

RUN apk update
RUN apk add --no-cache build-base curl git openssl-dev perl-dev unzip

RUN curl http://keplerproject.github.io/luarocks/releases/luarocks-2.3.0.tar.gz \
    | tar -xzf -
RUN cd luarocks-2.3.0 && ./configure \
    --with-lua="/usr/local/openresty/luajit/" \
    --lua-suffix="jit" \
    --with-lua-include="/usr/local/openresty/luajit/include/luajit-2.1"
RUN cd luarocks-2.3.0 && make bootstrap

RUN luarocks install Lua-ReQL

RUN cpan Test::Nginx::Socket::Lua
