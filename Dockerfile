FROM memcached:1.4-alpine

# Build-time metadata as defined at http://label-schema.org
# with added usage described in https://microbadger.com/#/labels
ARG BUILD_DATE
ARG VCS_REF
LABEL org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.docker.dockerfile="/Dockerfile" \
    org.label-schema.name="Autopilot Pattern Memcached" \
    org.label-schema.url="https://github.com/autopilotpattern/memcached" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-type="Git" \
    org.label-schema.vcs-url="https://github.com/autopilotpattern/memcached"

# Reset to root user to do some installs
USER root

# Install packages
RUN apk update && apk add \
    bash \
    curl \
    netcat-openbsd \
    && rm -rf /var/cache/apk/*

# Add Containerpilot and its configuration
# Releases at https://github.com/joyent/containerpilot/releases
ENV CONTAINERPILOT_VER 2.3.0
COPY etc/containerpilot.json /etc/containerpilot.json
ENV CONTAINERPILOT file:///etc/containerpilot.json

RUN export CONTAINERPILOT_CHECKSUM=ec9dbedaca9f4a7a50762f50768cbc42879c7208 \
    && curl --retry 7 --fail -Lso /tmp/containerpilot.tar.gz \
         "https://github.com/joyent/containerpilot/releases/download/${CONTAINERPILOT_VER}/containerpilot-${CONTAINERPILOT_VER}.tar.gz" \
    && echo "${CONTAINERPILOT_CHECKSUM}  /tmp/containerpilot.tar.gz" | sha1sum -c \
    && tar zxf /tmp/containerpilot.tar.gz -C /usr/local/bin \
    && rm /tmp/containerpilot.tar.gz

# Install Consul
# Releases at https://releases.hashicorp.com/consul
RUN export CONSUL_VERSION=0.6.4 \
    && export CONSUL_CHECKSUM=abdf0e1856292468e2c9971420d73b805e93888e006c76324ae39416edcf0627 \
    && curl --retry 7 --fail -vo /tmp/consul.zip "https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip" \
    && echo "${CONSUL_CHECKSUM}  /tmp/consul.zip" | sha256sum -c \
    && unzip /tmp/consul -d /usr/local/bin \
    && rm /tmp/consul.zip \
    && mkdir /config

# Reset entrypoint from base image
ENTRYPOINT []

# Reset to memcache user to, um, run memcache
USER memcache
CMD ["/usr/local/bin/containerpilot", \
    "memcached", \
        "-l", \
        "0.0.0.0"]
