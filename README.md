### Source
- https://github.com/chenhw2/Dockers/tree/SS2-KCP-SERVER-lite
  
### Thanks to
- [https://github.com/shadowsocks/go-shadowsocks2][ss2ver]
- https://github.com/xtaci/kcptun
  
### Usage
```
$ docker pull chenhw2/ss2-kcp-server-lite

$ docker run -d \
    -e "SS=[ss://cipher:pass]" \
    -e "KCP=[kcp://mode:crypt:key]" \
    -p 8488:8488/tcp -p 8488:8488/udp -p 18488:18488/udp \
    chenhw2/ss2-kcp-server-lite
```

### ENV
```
# ss://cipher:pass
ENV SS=ss://AEAD_AES_128_GCM:12345678

# kcp://mode:crypt:key
ENV KCP=cp://fast2:aes:
ENV KCP_EXTRA_ARGS=''

```

 [ss2ver]: https://github.com/shadowsocks/go-shadowsocks2/commit/9baef5e148d885b8040f7df13596f2c87d526a07
