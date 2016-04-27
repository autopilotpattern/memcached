FROM memcached:latest

USER root
RUN apt-get update \
    && apt-get install -y \
        netcat \
        curl

# Install ContainerPilot
# Releases at https://github.com/joyent/containerpilot/releases
ENV CONTAINERPILOT_VER 2.0.1
RUN export CONTAINERPILOT_CHECKSUM=a4dd6bc001c82210b5c33ec2aa82d7ce83245154 \
    && curl -Lso /tmp/containerpilot.tar.gz \
        "https://github.com/joyent/containerpilot/releases/download/${CONTAINERPILOT_VER}/containerpilot-${CONTAINERPILOT_VER}.tar.gz" \
    && echo "${CONTAINERPILOT_CHECKSUM}  /tmp/containerpilot.tar.gz" | sha1sum -c \
    && tar zxf /tmp/containerpilot.tar.gz -C /usr/local/bin \
    && rm /tmp/containerpilot.tar.gz

# Add ContainerPilot configuration
COPY etc/containerpilot.json /etc/containerpilot.json
ENV CONTAINERPILOT file:///etc/containerpilot.json

# reset entrypoint from base image
ENTRYPOINT []
USER memcache
CMD ["/usr/local/bin/containerpilot", \
    "memcached", \
        "-l", \
        "0.0.0.0"]
