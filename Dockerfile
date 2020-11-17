FROM rust:latest

LABEL maintainer="RexProg <RexProg.Programmer@gmail.com>"

ENV V2RAY_DOWNLOAD_URL https://github.com/shadowsocks/v2ray-plugin/releases/download/v1.3.1/v2ray-plugin-linux-amd64-v1.3.1.tar.gz
ENV SHADOWSOCKS_RUST_GIT_URL https://github.com/shadowsocks/shadowsocks-rust.git

RUN apt update \
	&& apt upgrade -y \
	&& apt install git \
	&& wget ${V2RAY_DOWNLOAD_URL} \
	&& tar -xvf v2ray-plugin-linux-amd64-v1.3.1.tar.gz \
	&& mv v2ray-plugin_linux_amd64 /usr/bin/v2ray-plugin \
	&& git clone ${SHADOWSOCKS_RUST_GIT_URL} \
	&& cd shadowsocks-rust \
	&& cargo build --release \
	&& make install TARGET=release

CMD [ "$CARGO_HOME/bin/ssserver", "-c","/server.json"]
