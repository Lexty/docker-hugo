FROM lexty/debian:jessie
MAINTAINER Alexandr Medvedev <alexandr.mdr@gmail.com>

ENV HUGO_VERSION 0.15

COPY ./docker-entrypoint.sh /

RUN chmod +x /docker-entrypoint.sh && \

    apt-get update && apt-get install -y \
        git \
        wget \
        python3-pygments && \

    wget https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_amd64.deb && \
    dpkg -i hugo_${HUGO_VERSION}_amd64.deb && \
    rm hugo_${HUGO_VERSION}_amd64.deb && \

    apt-get remove --purge -y wget $(apt-mark showauto) && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER user
VOLUME /data
WORKDIR /data
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD [""]
