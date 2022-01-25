FROM alpine:3.15
WORKDIR /tmp

ADD https://github.com/moriyoshi/cyrus-sasl-xoauth2/archive/v0.2.tar.gz /tmp/
RUN apk update && \
    apk add ca-certificates python3 postfix py3-pip cyrus-sasl-dev libc-dev gcc make autoconf automake libtool tini && \
    tar xf v0.2.tar.gz && \
    cd cyrus-sasl-xoauth2-0.2 && \
    ./autogen.sh && \
    ./configure --with-cyrus-sasl=/usr && \
    make install && \
    apk del cyrus-sasl-dev libc-dev gcc make autoconf automake libtool && \
    rm -rf cyrus-sasl-xoauth2-0.2 v0.2.tar.gz && \
	pip3 install jinja2 && \
	mkdir -p /scripts/state
	
WORKDIR /
COPY ./provision /scripts/provision
COPY ./oauth2.py ./entrypoint.sh ./keepalive.sh ./provision.sh /scripts/
VOLUME ["/var/spool/postfix", "/scripts/state"]
ENTRYPOINT ["/sbin/tini", "--", "/scripts/entrypoint.sh"]
CMD [""]
