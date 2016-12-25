FROM openresty/openresty:alpine-fat

MAINTAINER Adam Grandquist <grandquista@gmail.com>

RUN apk update
RUN apk add --no-cache build-base curl git openssl-dev perl-dev unzip

RUN luarocks install Lua-ReQL
RUN luarocks install lua-testmore

RUN cpan Test::Nginx::Socket::Lua

COPY t t

RUN ln /usr/local/openresty/nginx/sbin/nginx /usr/local/bin/

ENTRYPOINT ["prove", "-r", "t"]
