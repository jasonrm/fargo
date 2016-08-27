#!/bin/sh
DEPS="libarchive git curl openssh-client ca-certificates"
BUILD_DEPS="go asciidoc build-base libarchive-dev autoconf automake"
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
    && rm -Rf /pv-1.6.0 /pv-1.6.0.tar.gz

# I wouldn't know where to start describing how much I dislike the golang build process
## Go build env
mkdir -p /go/src /go/bin
chmod -R 777 /go
export GOPATH=/go
export PATH=/go/bin:$PATH

# Install gof3r
go get github.com/rlmcpherson/s3gof3r
cd /go/src/github.com/rlmcpherson/s3gof3r
git remote add jasonrm https://github.com/jasonrm/s3gof3r
cd gof3r
git fetch --all
git checkout jasonrm/expose-pathstyle
CGO_ENABLED=0 GOOS=linux go build -a .
cp gof3r /usr/local/bin/

# Cleanup
apk del ${BUILD_DEPS}
rm -rf /var/cache/apk/*
rm -rf /go

rm /$0
