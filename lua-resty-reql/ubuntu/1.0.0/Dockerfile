FROM openresty/openresty:xenial

MAINTAINER Adam Grandquist <grandquista@gmail.com>

RUN apt-get update
RUN apt-get install -y cpanminus git libssl-dev wget

RUN /usr/local/openresty/luajit/bin/luarocks install luasec
RUN /usr/local/openresty/luajit/bin/luarocks install luacrypto
RUN /usr/local/openresty/luajit/bin/luarocks install Lua-ReQL

RUN cpanm -v --notest Test::Nginx::Socket

RUN ln /usr/local/openresty/nginx/sbin/nginx /usr/local/sbin/
