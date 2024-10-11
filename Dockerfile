FROM ghcr.io/ietf-tools/xml2rfc-base:latest

ARG MMARK_VERSION=2.2.31

WORKDIR /opt

RUN cd /usr/local/bin && \
    wget https://github.com/mmarkdown/mmark/releases/download/v${MMARK_VERSION}/mmark_${MMARK_VERSION}_linux_amd64.tgz -O/tmp/mmark.tgz && \
    tar xzf /tmp/mmark.tgz

RUN apt-get update &&\
    apt-get install -y git

RUN cd /usr/local/src && \
    git clone https://github.com/wolfcw/libfaketime.git && \
    cd libfaketime/src && \
    make install

ENV LD_PRELOAD=/usr/local/lib/faketime/libfaketime.so.1