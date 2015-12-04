FROM elyase/pyrun:2.7
MAINTAINER Alexandr Medvedev <alexandr.mdr@gmail.com>

ENV HUGO_VERSION 0.15

COPY ./build/hugo_v0.15 /
COPY ./docker-entrypoint.sh /
COPY ./build/pygments_v2.0.2 /opt/pygments

RUN mkdir /data && \
    mv "/hugo_v${HUGO_VERSION}" "/bin/hugo" && \
    chmod +x /bin/hugo && \
    chmod +x /docker-entrypoint.sh && \
    ln -s /bin/python /bin/python2 && \
    cd /opt/pygments && \
    python setup.py install

ENV PATH $PATH:/opt/pygments
VOLUME /data
WORKDIR /data
EXPOSE 1313

ENTRYPOINT ["/bin/sh", "/docker-entrypoint.sh"]
