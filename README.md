# Shadowsocks Rust Dockerfile
[Shadowsocks-rust](https://github.com/shadowsocks/shadowsocks-rust) + simple-obfs Dockerfile and Docker Compose

# Usage
- to run shadowsocks server, review server.json then
```
docker-compose up -d server
```
- to run shadowsocks client, review client.json then
```
docker-compose up -d local
```
- to run shadowsocks dns local server, review dns.json then
```
docker-compose up -d dns
```

# Default Values
- Port: 443
- Method: rc4-md5
- Password: ZA2722
- Plugin: simple-obfs(tls)