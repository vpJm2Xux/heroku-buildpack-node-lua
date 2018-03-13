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
wget https://www.lua.org/ftp/lua-5.2.4.tar.gz
tar xvf lua-5.2.4.tar.gz
cd lua-5.2.4
make linux INSTALL_TOP=/app/.heroku/node-lua install

cd /tmp
wget https://luarocks.org/releases/luarocks-2.4.3.tar.gz
tar zxpf luarocks-2.4.3.tar.gz
cd luarocks-2.4.3
./configure --prefix=/app/.heroku/node-lua --with-lua=/app/.heroku/node-lua
make bootstrap
/app/.heroku/node-lua/bin/luarocks install luasocket

/app/.heroku/node-lua/bin/luarocks install moonscript

cd /app/.heroku/node-lua && tar cvJf node-lua-moon-heroku.tar.xz *
