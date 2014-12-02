#!/bin/bash

if [ "${0:0:1}" = "/" ]
then
  cd $(dirname $0)/..
else
  cd $(pwd)/$(dirname $0)/..
fi

cat fastcgi_ssl_variables.conf | sed 's/fastcgi_/scgi_/g' > scgi_ssl_variables.conf
cat fastcgi_ssl_variables.conf | sed 's/fastcgi_/uwsgi_/g' > uwsgi_ssl_variables.conf

cat fastcgi_ssl_variables_lua.conf | sed 's/fastcgi_/scgi_/g' > scgi_ssl_variables_lua.conf
cat fastcgi_ssl_variables_lua.conf | sed 's/fastcgi_/uwsgi_/g' > uwsgi_ssl_variables_lua.conf
