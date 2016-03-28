FROM memcached:latest

USER root
# install python for entrypoint
RUN apt-get update \
    && apt-get install -y \
		netcat \
    curl

COPY containerbuddy/* /opt/containerbuddy/

# Install Containerbuddy
# Releases at https://github.com/joyent/containerbuddy/releases
ENV CONTAINERBUDDY_VERSION 0.1.1
ENV CONTAINERBUDDY_SHA1 3163e89d4c95b464b174ba31733946ca247e068e
RUN curl --retry 7 -Lso /tmp/containerbuddy.tar.gz "https://github.com/joyent/containerbuddy/releases/download/${CONTAINERBUDDY_VERSION}/containerbuddy-${CONTAINERBUDDY_VERSION}.tar.gz" \
    && echo "${CONTAINERBUDDY_SHA1}  /tmp/containerbuddy.tar.gz" | sha1sum -c \
    && tar zxf /tmp/containerbuddy.tar.gz -C /opt/containerbuddy \
    && rm /tmp/containerbuddy.tar.gz



COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
USER memcache
CMD ["/opt/containerbuddy/containerbuddy", \
    "memcached", \
		"-l", \
		"0.0.0.0"]
