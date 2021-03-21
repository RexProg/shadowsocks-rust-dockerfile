FROM rust:latest AS build-env

LABEL maintainer="RexProg <RexProg.Programmer@gmail.com>"

ENV V2RAY_DOWNLOAD_URL https://github.com/shadowsocks/v2ray-plugin/releases/download/v1.3.1/v2ray-plugin-linux-amd64-v1.3.1.tar.gz
ENV SHADOWSOCKS_RUST_GIT_URL https://github.com/shadowsocks/shadowsocks-rust.git

RUN apt update \
	&& apt upgrade -y \
	&& apt install git \
	&& git clone ${SHADOWSOCKS_RUST_GIT_URL} \
	&& export RUSTFLAGS="-C target-cpu=native" \
	&& cd shadowsocks-rust \
	&& rustup override set nightly \
	&& cargo build --release \
	&& wget ${V2RAY_DOWNLOAD_URL} \
	&& tar -xvf v2ray-plugin-linux-amd64-v1.3.1.tar.gz \
	&& mv v2ray-plugin_linux_amd64 ./target/release/v2ray-plugin

FROM ubuntu:latest

COPY --from=build-env /shadowsocks-rust/target/release /usr/bin

CMD [ "ssserver", "-c", "/server.json"]

