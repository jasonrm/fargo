#!/bin/sh
DEPS="libarchive git curl openssh-client"
BUILD_DEPS="asciidoc build-base libarchive-dev autoconf automake"
apk add --update ${DEPS} ${BUILD_DEPS}

# Build pixz
git clone https://github.com/vasi/pixz.git \
    && cd pixz \
    && ./autogen.sh \
    && ./configure \
    && make \
    && make install \
    && cd .. \
    && rm -Rf pixz

# Build pv
curl -L -O http://www.ivarch.com/programs/sources/pv-1.6.0.tar.gz \
    && tar -xf pv-1.6.0.tar.gz \
    && cd pv-1.6.0 \
    && ./configure \
    && make \
    && make install \
    && cd .. \
    && rm -Rf pv-1.6.0

# Install gof3r
curl -L https://github.com/rlmcpherson/s3gof3r/releases/download/v0.5.0/gof3r_0.5.0_linux_amd64.tar.gz \
    | gzip -d \
    | tar --extract
mv gof3r_0.5.0_linux_amd64/gof3r /usr/local/bin/gof3r
rmdir gof3r_0.5.0_linux_amd64

# Cleanup
apk del ${BUILD_DEPS}
rm -rf /var/cache/apk/*

rm $0
