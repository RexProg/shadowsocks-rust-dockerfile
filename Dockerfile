FROM alpine:3.6

LABEL maintainer="RexProg <RexProg.Programmer@gmail.com>"

ENV SS_DOWNLOAD_URL https://github.com/shadowsocks/shadowsocks-rust/releases/download/v1.7.2/shadowsocks-v1.7.2-stable.x86_64-unknown-linux-musl.tar.xz
ENV OBFS_DOWNLOAD_URL https://github.com/shadowsocks/simple-obfs.git

RUN apk upgrade --update \
    && apk add bash tzdata libsodium \
    && apk add --virtual .build-deps \
        autoconf \
        automake \
        asciidoc \
        xmlto \
        build-base \
        curl \
        c-ares-dev \
        libev-dev \
        libtool \
        linux-headers \
        udns-dev \
        libsodium-dev \
        mbedtls-dev \
        pcre-dev \
        udns-dev \
        tar \
        xz \
        git \
    && curl -sSLO ${SS_DOWNLOAD_URL} \
    && tar -xf ${SS_DOWNLOAD_URL##*/} -C /usr/bin \
    && git clone --recursive ${OBFS_DOWNLOAD_URL} \
    && (cd simple-obfs \
    && ./autogen.sh && ./configure \
    && make && make install) \
    && runDeps="$( \
        scanelf --needed --nobanner /usr/bin/ss* /usr/local/bin/obfs-* \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | xargs -r apk info --installed \
           | sort -u \
        )" \
    && apk add --virtual .run-deps $runDeps \
    && apk del .build-deps \
    && rm -rf ${SS_DOWNLOAD_URL##*/} \
        simple-obfs \
        /var/cache/apk/*
CMD [ "ssserver", "-c","/server.json","-u"]
