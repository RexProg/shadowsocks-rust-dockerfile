FROM alpine:latest

LABEL maintainer="RexProg <RexProg.Programmer@gmail.com>"

ENV SS_REPOSITORY_URL https://github.com/shadowsocks/shadowsocks-rust.git
ENV V2RAY_DOWNLOAD_URL https://github.com/shadowsocks/v2ray-plugin/releases/download/v1.2.0/v2ray-plugin-linux-amd64-v1.2.0.tar.gz

RUN apk upgrade --update \
	&& apk update \
	&& set -ex \
	&& apk add --no-cache \
		cargo \
		git \
		pkgconfig \
		openssl-dev \
		libsodium-dev \
		wget \
	&& wget ${V2RAY_DOWNLOAD_URL} \
	&& tar -xvf v2ray-plugin-linux-amd64-v1.2.0.tar.gz \
	&& mv v2ray-plugin_linux_amd64 /usr/bin/v2ray-plugin \
	&& git clone --recursive ${SS_REPOSITORY_URL} \
	&& cd /shadowsocks-rust \
	&& SODIUM_USE_PKG_CONFIG=1 cargo build --release

CMD [ "/shadowsocks-rust/target/release/ssserver", "-c","/server.json"]