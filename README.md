nginx SSL variables
===================

This creates backward-compatible SSL variables in nginx, compared to Apache mod_ssl module. A few variables are given by nginx, and some others have to be computed through nginx-Lua with a Lua-OpenSSL interface.

All available SSL variables are given in the [COMPATIBILITY.md](COMPATIBILITY.md) file with its specifications and current implementation status.

Installing
----------

1. Copy the files `*.conf` in your nginx directory `/etc/nginx` (or another non-standard location).

__Soft install:__

2. Include the file `*_ssl_variables.conf` in your web server config corresponding to your gateway (fastcgi, scgi, uwsgi). For instance:
   ```nginx
   location ~ \.php {
       include fastcgi.conf;
       include fastcgi_ssl_variables.conf;
   }
   ```
3. Depending of your nginx version, uncomment lines where a nginx version is indicated. You can also comment some variables you don’t need.
4. Reload nginx. It’s ready!

__Complete install:__

2. Be sure you have installed the [nginx Lua package](http://wiki.nginx.org/HttpLuaModule) (available in the Debian/Ubuntu package nginx-extras).
3. Install the [Lua-OpenSSL interface written by zhaozg](https://github.com/zhaozg/lua-openssl) and be sure it works in the Lua command line.
4. Include the file `*_ssl_variables_lua.conf` in your web server config corresponding to your gateway (fastcgi, scgi, uwsgi). For instance:
   ```nginx
   location ~ \.php {
       include fastcgi.conf;
       include fastcgi_ssl_variables_lua.conf;
   }
   ```
5. Depending of your nginx version, uncomment lines where a nginx version is indicated. You can also comment some variables you don’t need.
6. Reload nginx. It’s ready!

Contributing
------------

Don’t hesit to submit pull requests or open [issues](https://github.com/Seb35/nginx-ssl-variables/issues). When you change files, you only need to change the two files `fastcgi_*.conf`, then use the Bash `script utils/sync_scgi-uwsgi_from_fastcgi.sh` to update the four other files, `scgi_*.conf` and `uwsgi_*.conf`.

I’m not (yet) part of nginx community, and I don’t know if such a patch could/should be added to nginx, neither know the SSL module development policy and roadmap; if you have some advices about that, you can reach me to discuss.

Licence
-------

Original author: [Seb35](https://github.com/Seb35)

Licence: [WTFPL 2](http://www.wtfpl.net)

