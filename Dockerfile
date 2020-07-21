FROM memcached:1.6.6-alpine

# Reset to root user to do some installs
USER root

# Install packages
RUN apk update && apk add \
    bash \
    curl \
    netcat-openbsd \
    && rm -rf /var/cache/apk/*

# Add ContainerPilot and its configuration
# Releases at https://github.com/joyent/containerpilot/releases
ENV CONTAINERPILOT_VER 3.8.0
ENV CONTAINERPILOT /etc/containerpilot.json5
RUN export CONTAINERPILOT_CHECKSUM=84642c13683ddae6ccb63386e6160e8cb2439c26 \
    && curl -Lso /tmp/containerpilot.tar.gz \
    "https://github.com/joyent/containerpilot/releases/download/${CONTAINERPILOT_VER}/containerpilot-${CONTAINERPILOT_VER}.tar.gz" \
    && echo "${CONTAINERPILOT_CHECKSUM} /tmp/containerpilot.tar.gz" | sha1sum -c \
    && tar zxf /tmp/containerpilot.tar.gz -C /usr/local/bin \
    && rm /tmp/containerpilot.tar.gz

# The our helper/glue scripts and configuration for this specific app
COPY bin /usr/local/bin
COPY etc /etc

# Reset entrypoint from base image
ENTRYPOINT []

# Reset to memcache user to, um, run memcache
USER memcache
CMD ["/usr/local/bin/containerpilot"]
