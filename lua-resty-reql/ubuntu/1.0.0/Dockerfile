FROM openresty/openresty:xenial

MAINTAINER Adam Grandquist <grandquista@gmail.com>

RUN apt-get update
RUN apt-get install -y cpanminus git libssl-dev

RUN /usr/local/openresty/luajit/bin/luarocks install Lua-ReQL

RUN cpan Test::Nginx::Socket::Lua

RUN ln /usr/local/openresty/nginx/sbin/nginx /usr/local/sbin/

ENTRYPOINT ["prove", "-r", "t"]
