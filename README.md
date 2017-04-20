### Source
- https://github.com/chenhw2/Dockers/tree/SSR-KCP-SERVER-latest
  
### Thanks to
- https://github.com/shadowsocksr/shadowsocksr
- https://github.com/xtaci/kcptun
  
### Usage
```
$ docker pull chenhw2/ssr-kcp-server

$ docker run -d -e "SSR_PASS=12345678" -e "KCP_PASS=87654321" \
    -p 8300:8300/tcp -p 8300:8300/udp -p 8311:8311/tcp -p 8311:8311/udp \
    -p 8322:8322/tcp -p 8322:8322/udp -p 8344:8344/tcp -p 8344:8344/udp \
    -p 8355:8355/tcp -p 8355:8355/udp \
    -p 18300:18300/udp -p 18311:18311/udp -p 18322:18322/udp \
    -p 18344:18344/udp -p 18355:18355/udp \
    chenhw2/ssr-kcp-server
```
=================================================================================
```
{
 "port_password":{
    "8300":{"protocol":"origin", "obfs": "plain"},
    "8322":{"protocol":"auth_sha1_v2"},
    "8344":{"protocol":"auth_sha1_v4"},
    "8355":{"protocol":"auth_aes128_md5"},
    "8311":{"protocol":"auth_aes128_sha1"}
  },
  "password": "SSRPassword",
  "method": "chacha20-ietf",
  "obfs": "tls1.2_ticket_auth",
  "obfs_param": "bing.com"
}
```
=================================================================================
```
{
  "key": "KCPPassword",
  "crypt": "salsa20",
  "mode": "fast2"
}
```
