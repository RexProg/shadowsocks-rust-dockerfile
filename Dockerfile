FROM alpine:latest

LABEL maintainer="RexProg <RexProg.Programmer@gmail.com>"

ENV SS_REPOSITORY_URL https://github.com/shadowsocks/shadowsocks-rust.git
ENV V2RAY_DOWNLOAD_URL https://github.com/shadowsocks/v2ray-plugin/releases/download/v1.3.0/v2ray-plugin-linux-amd64-v1.3.0.tar.gz

RUN apk upgrade --update \
	&& apk update \
	&& set -ex \
	&& apk add --no-cache \
		bash \
		git \
		gcc \
		libgcc \
		pkgconfig \
		openssl-dev \
		libsodium-dev \
		curl \
		wget \
	&& curl "https://sh.rustup.rs" -o "rust-init.sh" \
	&& chmod +x "rust-init.sh" \
	&& bash ./rust-init.sh -y --default-toolchain stable --no-modify-path --profile minimal \
	&& export PATH="$HOME/.cargo/bin:$PATH" \
	&& cargo install cross \
	&& wget ${V2RAY_DOWNLOAD_URL} \
	&& tar -xvf v2ray-plugin-linux-amd64-v1.3.0.tar.gz \
	&& mv v2ray-plugin_linux_amd64 /usr/bin/v2ray-plugin \
	&& git clone --recursive ${SS_REPOSITORY_URL} \
	&& cd /shadowsocks-rust \
	&& bash ./build-release 

CMD [ "/shadowsocks-rust/target/release/ssserver", "-c","/server.json"]
