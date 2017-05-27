FROM ubuntu:16.04

RUN apt-get update && apt-get install -y \
        ruby2.3-dev \
        git \
        libpq-dev \
        build-essential \
        zlib1g-dev
RUN gem update --system
RUN mkdir /opt/gitrob
RUN git clone https://github.com/michenriksen/gitrob /opt/gitrob
RUN gem install gitrob

COPY rootfs /rootfs
