nginx SSL variables
===================

In Apache, standard SSL variables (activated with SSLOptions +StdEnvVars) are used to give access the underlying application details of the current SSL connection. When nginx is used, these variables are not passed to the underlying application (through FastCGI, SCGI, or uWSGI), except the variable HTTPS.

The following config files can be added in nginx configuration to keep application working correctly with SSL. nginx has (much) less available SSL variables than Apache and some are a bit different, so you can see the COMPATIBILITY.md file to check the status of each variable. It is tried to fill some missing variables by using Lua in nginx, with the Lua-OpenSSL gateway. Obviously there will be performance issues, so you should see if you really need these supplementary variables for your applications.

Installing
----------

You have to copy the file `*.conf` of this directory in your nginx configuration directory (probably `/etc/nginx`). If you want to use enhanced variables provided by Lua, you have to install the Lua package of nginx (package nginx-extras on Debian/Ubuntu), as well as the Lua-OpenSSL gateway available on https://github.com/zhaozg/lua-openssl.

Depending of your nginx version, you can uncomment some lines where minimal nginx version is indicated in the various `*.conf` files.

Then you have to include this file after the inclusion of the standard fastcgi/scgi/uwsgi parameters, e.g.
    include fastcgi.conf;
    include fastcgi_ssl_variables.conf;

Contributing
------------

Please submit pull requests if you see some improvements. You can update fastcgi_ssl_variables.conf, then use the Bash script utils/sync_scgi-uwsgi_from_fastcgi.sh to update the two other files, scgi_ssl_variables.conf and uwsgi_ssl_variables.

I’m not (yet) part of nginx community, and I don’t know if such a patch could/should be added to nginx, neither know the SSL module development policy and roadmap; if you have some advices about that, you can reach me to discuss.

License
-------

WTFPL 2.0

