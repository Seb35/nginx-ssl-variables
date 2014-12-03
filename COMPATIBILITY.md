Compatibility of SSL environment variables between Apache and nginx

## Compatibility status

### Natively compatible variables

* SSL_PROTOCOL: $ssl_protocol
* SSL_CIPHER: $ssl_cipher
* SSL_CLIENT_SERIAL: $ssl_client_serial
* SSL_CLIENT_S_DN: $ssl_client_s_dn
* SSL_CLIENT_I_DN: $ssl_client_i_dn
* SSL_CLIENT_CERT: $ssl_client_raw_cert
* SSL_TLS_SNI: $ssl_server_name (introduced in nginx 1.7)

### Almost natively compatible variables

* SSL_SESSION_ID: $ssl_session_id (uppercase hex in Apache, lowercase hex in nginx)

### Computable variables, with nginx Lua or application logic

Pure Lua:
* SSL_SESSION_ID: uppercased $ssl_session_id
* SSL_SESSION_RESUMED: small Lua if/else from $ssl_session_reused (introduced in nginx 1.5.11)

Lua with a gateway to OpenSSL, using $ssl_client_raw_cert:
* SSL_CIPHER_EXPORT: computed from SSL_CIPHER_USEKEYSIZE
* SSL_CIPHER_USEKEYSIZE: (TODO) can be computed from $ssl_cipher
* SSL_CIPHER_ALGKEYSIZE: (TODO) can be computed from $ssl_cipher
* SSL_VERSION_LIBRARY: outputs OpenSSL version
* SSL_CLIENT_M_VERSION: computed from $ssl_client_raw_cert with Lua-OpenSSL gateway
* SSL_CLIENT_S_DN_*x509*: (TODO) can be computed from $ssl_client_raw_cert with Lua-OpenSSL gateway
* SSL_CLIENT_I_DN_*x509*: (TODO) can be computed from $ssl_client_raw_cert with Lua-OpenSSL gateway
* SSL_CLIENT_V_START: computed from $ssl_client_raw_cert with Lua-OpenSSL gateway
* SSL_CLIENT_V_END: computed from $ssl_client_raw_cert with Lua-OpenSSL gateway
* SSL_CLIENT_V_REMAIN: (TODO) can be computed from $ssl_client_raw_cert with Lua-OpenSSL gateway
* SSL_CLIENT_A_SIG: (TODO) can be computed from $ssl_client_raw_cert with Lua-OpenSSL gateway
* SSL_CLIENT_A_KEY: (TODO) can be computed from $ssl_client_raw_cert with Lua-OpenSSL gateway

### Unaccessible variables

These variables cannot be accessed until an update of the SSL nginx module. An access to the currect SSL connection and server certificate is needed to compute these variables.

* SSL_SECURE_RENEG
* SSL_COMPRESS_METHOD
* SSL_VERSION_INTERFACE
* SSL_CLIENT_CERT_CHAIN_*n*
* SSL_SERVER_M_VERSION
* SSL_SERVER_M_SERIAL
* SSL_SERVER_S_DN
* SSL_SERVER_S_DN_*x509*
* SSL_SERVER_I_DN
* SSL_SERVER_I_DN_*x509*
* SSL_SERVER_V_START
* SSL_SERVER_V_END
* SSL_SERVER_A_SIG
* SSL_SERVER_A_KEY
* SSL_SERVER_CERT
* SSL_SRP_USER
* SSL_SRP_USERINFO

### Variables accessible with nginx but not with Apache

* SSL_CLIENT_FINGERPRINT: $ssl_client_fingerprint (introduced in nginx 1.7.1)


## All Apache variables

### SSL_PROTOCOL

* Apache values: "SSLv2", "SSLv3", "TLSv1", "TLSv1.1", "TLSv1.2"
* nginx variable: $ssl_protocol
* nginx values: same as Apache


### SSL_SESSION_ID

* Apache values: SSL session id in hexadecimal uppercase
* nginx variable: $ssl_session_id
* nginx values: same as Apache but in lowercase
* nginx Lua:
```lua
set_by_lua $ssl_session_id_compat '
        if ngx.var.https == "on" then
            return string.upper(ngx.var.ssl_session_id)
        end
        return nil';
```


### SSL_SESSION_RESUMED

* Apache values: "Initial" or "Resumed"
* nginx variable: $ssl_session_reused introduced in nginx 1.5.11
* nginx values: "r" or "."
* nginx Lua:
```lua
set_by_lua $ssl_session_resumed_compat '
        if ngx.var.ssl_session_reused == "." then
            return "Initial"
        elseif ngx.var.ssl_session_reused == "r" then
            return "Resumed"
        end
        return nil';
```


### SSL_SECURE_RENEG

* Apache values: "true", "false"
* nginx variable: none
* nginx values: none
* nginx Lua: not possible


### SSL_CIPHER

* Apache values: given the SSL engine or NULL
* nginx variable: $ssl_cipher
* nginx values: same as Apache


### SSL_CIPHER_EXPORT

* Apache values: "true", "false"
* nginx variable: none
* nginx values: none
* nginx Lua:
```lua
set_by_lua $ssl_cipher_export_compat '
        if ngx.var.https == "on" then
            if ngx.var.ssl_cipher_usekeysize < 56 then
                return "true"
            else
                return "false"
            end
        end
        return nil';
```


### SSL_CIPHER_USEKEYSIZE

* Apache values: int
* nginx variable: none
* nginx values: none
* nginx Lua: TODO from SSL_CIPHER


### SSL_CIPHER_ALGKEYSIZE

* Apache values: int
* nginx variable: none
* nginx values: none
* nginx Lua: TODO from SSL_CIPHER


### SSL_COMPRESS_METHOD

* Apache values: "NULL", "DEFLATE", "LZS", "UNKNOWN"
* nginx variable: none
* nginx values: none
* nginx Lua: not possible


### SSL_VERSION_INTERFACE

* Apache values: string
* nginx variable: none
* nginx values: none
* nginx Lua: not possible


### SSL_VERSION_LIBRARY

* Apache values: string
* nginx variable: none
* nginx values: none
* nginx Lua:
```lua
set_by_lua $ssl_version_library_compat '
        if ngx.var.https == "on" then
            lua_openssl_version, lua_version, openssl_version = require("openssl").version()
            return openssl_version
        end
        return nil';
```


### SSL_CLIENT_M_VERSION

* Apache values: int
* nginx variable: none
* nginx values: none
* nginx Lua:
```lua
set_by_lua $ssl_client_m_version_compat '
        if ngx.var.https == "on" then
            return require("openssl").x509.read(ngx.var.ssl_client_raw_cert):version()+1
        end
        return nil';
```


### SSL_CLIENT_M_SERIAL

* Apache values: hexadecimal uppercase int
* nginx variable: $ssl_client_serial
* nginx values: same as Apache


### SSL_CLIENT_S_DN

* Apache values: string
* nginx variable: $ssl_client_s_dn
* nginx values: same as Apache


### SSL_CLIENT_S_DN_*x509*

* Apache values: string
* nginx variable: none
* nginx values: none
* nginx Lua: TODO


### SSL_CLIENT_I_DN

* Apache values: string
* nginx variable: $ssl_client_i_dn
* nginx values: same as Apache


### SSL_CLIENT_I_DN_*x509*

* Apache values: string
* nginx variable: none
* nginx values: none
* nginx Lua: TODO


### SSL_CLIENT_V_START

* Apache values: string, date with format "%s %2d %02d:%02d:%02d %d%s" (3-letter month like "Jan", day of month, hour, minute, second, 4-figure year, " GMT" or "")
* nginx variable: none
* nginx values: none
* nginx Lua:
```lua
set_by_lua $ssl_client_v_start_compat '
        if ngx.var.https == "on" then
            return require("openssl").x509.read(ngx.var.ssl_client_raw_cert):notbefore()
        end
        return nil';
```


### SSL_CLIENT_V_END

* Apache values: string, date with format "%s %2d %02d:%02d:%02d %d%s" (3-letter month like "Jan", day of month, hour, minute, second, 4-figure year, " GMT" or "")
* nginx variable: none
* nginx values: none
* nginx Lua: TODO
```lua
set_by_lua $ssl_client_v_end_compat '
        if ngx.var.https == "on" then
            return require("openssl").x509.read(ngx.var.ssl_client_raw_cert):notafter()
        end
        return nil';
```

### SSL_CLIENT_V_REMAIN

* Apache values: int
* nginx variable: none
* nginx values: none
* nginx Lua: TODO


### SSL_CLIENT_A_SIG

* Apache values: string
* nginx variable: none
* nginx values: none
* nginx Lua: TODO


### SSL_CLIENT_A_KEY

* Apache values: string
* nginx variable: none
* nginx values: none
* nginx Lua: TODO


### SSL_CLIENT_CERT

* Apache values: string, PEM-encoded certificate
* nginx variable: $ssl_client_raw_cert
* nginx values: same as Apache


### SSL_CLIENT_CERT_CHAIN_*n*

* Apache values: string, PEM-encoded certificate
* nginx variable: none
* nginx values: none
* nginx Lua: not possible


### SSL_CLIENT_VERIFY

* Apache values: "NONE", "SUCCESS", "GENEROUS", "FAILED: %s"
* nginx variable: $ssl_client_verify
* nginx values: "NONE", "SUCCESS", "FAILED"
* nginx Lua: not possible to do better


### SSL_SERVER_M_VERSION

* Apache values: int
* nginx variable: none
* nginx values: none
* nginx Lua: not possible


### SSL_SERVER_M_SERIAL

* Apache values: hexadecimal uppercase int
* nginx variable: none
* nginx values: none
* nginx Lua: not possible


### SSL_SERVER_S_DN

* Apache values: string
* nginx variable: none
* nginx values: none
* nginx Lua: not possible


### SSL_SERVER_S_DN_*x509*

* Apache values: string
* nginx variable: none
* nginx values: none
* nginx Lua: not possible


### SSL_SERVER_I_DN

* Apache values: string
* nginx variable: none
* nginx values: none
* nginx Lua: not possible


### SSL_SERVER_I_DN_*x509*

* Apache values: string
* nginx variable: none
* nginx values: none
* nginx Lua: not possible


### SSL_SERVER_V_START

* Apache values: string, date with format "%s %2d %02d:%02d:%02d %d%s" (3-letter month like "Jan", day of month, hour, minute, second, 4-figure year, " GMT" or "")
* nginx variable: none
* nginx values: none
* nginx Lua: not possible


### SSL_SERVER_V_END

* Apache values: string, date with format "%s %2d %02d:%02d:%02d %d%s" (3-letter month like "Jan", day of month, hour, minute, second, 4-figure year, " GMT" or "")
* nginx variable: none
* nginx values: none
* nginx Lua: not possible


### SSL_SERVER_A_SIG

* Apache values: string
* nginx variable: none
* nginx values: none
* nginx Lua: not possible


### SSL_SERVER_A_KEY

* Apache values: string
* nginx variable: none
* nginx values: none
* nginx Lua: not possible


### SSL_SERVER_CERT

* Apache values: string, PEM-encoded certificate
* nginx variable: none
* nginx values: none
* nginx Lua: not possible


### SSL_SRP_USER

* Apache values: string
* nginx variable: none
* nginx values: none
* nginx Lua: not possible


### SSL_SRP_USERINFO

* Apache values: string
* nginx variable: none
* nginx values: none
* nginx Lua: not possible


### SSL_TLS_SNI

* Apache values: string
* nginx variable: $ssl_server_name introduced in nginx 1.7.0
* nginx values: same as Apache

