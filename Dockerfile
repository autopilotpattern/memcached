FROM memcached:latest

USER root
# install python for entrypoint
RUN apt-get update \
    && apt-get install -y \
		netcat \
    curl

COPY containerbuddy/* /etc/

# Install Containerbuddy
# Releases at https://github.com/joyent/containerbuddy/releases
ENV CONTAINERBUDDY_VER 1.3.0
ENV CONTAINERBUDDY file:///etc/containerbuddy.json
RUN export CONTAINERBUDDY_CHECKSUM=c25d3af30a822f7178b671007dcd013998d9fae1 \
    && curl -Lso /tmp/containerbuddy.tar.gz \
         "https://github.com/joyent/containerbuddy/releases/download/${CONTAINERBUDDY_VER}/containerbuddy-${CONTAINERBUDDY_VER}.tar.gz" \
    && echo "${CONTAINERBUDDY_CHECKSUM}  /tmp/containerbuddy.tar.gz" | sha1sum -c \
    && tar zxf /tmp/containerbuddy.tar.gz -C /usr/local/bin \
    && rm /tmp/containerbuddy.tar.gz

USER memcache
CMD ["/opt/containerbuddy/containerbuddy", \
    "memcached", \
		"-l", \
		"0.0.0.0"]
