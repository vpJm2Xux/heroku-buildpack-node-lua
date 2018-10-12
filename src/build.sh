#!/bin/sh

set -e

DIR=$(realpath $(dirname $0))
FN=$(basename $0)

echo running $FN in $DIR on `uname -a`

if [ $DIR != "/app" ]; then
	echo entering Docker
	docker run --rm -it -v $DIR:/app heroku/heroku:16-build sh /app/$FN
	exit
fi

cd /tmp
wget http://luajit.org/download/LuaJIT-2.0.5.tar.gz
tar xvf LuaJIT-2.0.5.tar.gz
cd LuaJIT-2.0.5
make PREFIX=/app/.heroku/node-lua install

cd /tmp
wget https://luarocks.org/releases/luarocks-3.0.3.tar.gz
tar zxpf luarocks-3.0.3.tar.gz
cd luarocks-3.0.3

./configure --prefix=/app/.heroku/node-lua --with-lua=/app/.heroku/node-lua
make install

cd /app/.heroku/node-lua

./bin/luarocks install lua-zlib
./bin/luarocks install luaossl
./bin/luarocks install lua-cjson2
./bin/luarocks install basexx
./bin/luarocks install lua-yaml
./bin/luarocks install lpeg
./bin/luarocks install moonscript

tar cvJf ../node-lua-moon-heroku.tar.xz *
