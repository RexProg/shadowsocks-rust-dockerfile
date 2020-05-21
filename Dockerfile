FROM alpine:latest

LABEL maintainer="RexProg <RexProg.Programmer@gmail.com>"

ENV SS_REPOSITORY_URL https://github.com/shadowsocks/shadowsocks-rust.git
ENV V2RAY_DOWNLOAD_URL https://github.com/shadowsocks/v2ray-plugin/releases/download/v1.3.0/v2ray-plugin-linux-amd64-v1.3.0.tar.gz

RUN apk upgrade --update \
	&& apk update \
	&& set -ex \
	&& apk add --no-cache \
		git \
		pkgconfig \
		openssl-dev \
		libsodium-dev \
		curl \
		wget \
	&& curl "https://sh.rustup.rs" -o "rust-init.sh"
	&& chmod +x "rust-init.sh"
	&& ./rust-init.sh -y --default-toolchain stable --no-modify-path --profile minimal
	&& export PATH="$HOME/.cargo/bin:$PATH"
	&& echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> $BASH_ENV
	&& rustup --version
	&& cargo --version
	&& rustc --version
	&& cargo install cross
	&& wget ${V2RAY_DOWNLOAD_URL} \
	&& tar -xvf v2ray-plugin-linux-amd64-v1.3.0.tar.gz \
	&& mv v2ray-plugin_linux_amd64 /usr/bin/v2ray-plugin \
	&& git clone --recursive ${SS_REPOSITORY_URL} \
	&& cd /shadowsocks-rust/build \
	&& ./build-release 

CMD [ "/shadowsocks-rust/target/release/ssserver", "-c","/server.json"]
