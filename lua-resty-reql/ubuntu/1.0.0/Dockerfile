FROM openresty/openresty:xenial

MAINTAINER Adam Grandquist <grandquista@gmail.com>

RUN apt-get update
RUN apt-get install -y cpanminus git libcurl4-openssl-dev libprotobuf-dev libssl-dev wget

RUN /usr/local/openresty/luajit/bin/luarocks install luasec
RUN /usr/local/openresty/luajit/bin/luarocks install luacrypto
RUN /usr/local/openresty/luajit/bin/luarocks install Lua-ReQL

RUN cpanm -v --notest Test::Nginx::Socket

RUN ln /usr/local/openresty/nginx/sbin/nginx /usr/local/sbin/

RUN wget https://download.rethinkdb.com/apt/pool/xenial/main/r/rethinkdb/rethinkdb_2.3.5~0xenial_amd64.deb
RUN ar x rethinkdb_2.3.5~0xenial_amd64.deb
RUN tar xvf data.tar.xz
