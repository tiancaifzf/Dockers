### Source
- https://github.com/chenhw2/Dockers/tree/SS2-KCP-SERVER-lite
  
### Thanks to
- [https://github.com/shadowsocks/go-shadowsocks2][ss2ver]
  
### Usage
```
$ docker pull chenhw2/ss2

$ docker run -d \
    -e "Args=[-s ss://AEAD_CHACHA20_POLY1305:your-password@:8488 -verbose]" \
    -p 8488:8488/tcp -p 8488:8488/udp \
    chenhw2/ss2
```

### ENV
```
ENV Args=''
```

 [ss2ver]: https://github.com/shadowsocks/go-shadowsocks2/commit/de996c889eae0ad0356d654eff7b2ff7aa489096
