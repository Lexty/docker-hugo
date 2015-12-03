FROM busybox
MAINTAINER Alexandr Medvedev <alexandr.mdr@gmail.com>

ENV HUGO_VERSION {{ VERSION }}

COPY ./hugo_v{{ VERSION }} /
COPY ./docker-entrypoint.sh /

RUN mkdir /data && \
    mv "/hugo_v${HUGO_VERSION}" "/bin/hugo" && \
    chmod +x /bin/hugo && \
    chmod +x /docker-entrypoint.sh

VOLUME /data
WORKDIR /data