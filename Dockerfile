FROM ghcr.io/ietf-tools/xml2rfc-base:latest

ARG MMARK_VERSION=2.2.31

WORKDIR /opt

RUN cd /usr/local/bin && \
    wget https://github.com/mmarkdown/mmark/releases/download/v${MMARK_VERSION}/mmark_${MMARK_VERSION}_linux_amd64.tgz -O/tmp/mmark.tgz && \
    tar xzf /tmp/mmark.tgz
