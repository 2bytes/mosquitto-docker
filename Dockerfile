FROM debian:jessie

RUN adduser --system --disabled-password --disabled-login --group mosquitto

ENV GOSU_VERSION 1.7
RUN apt-get update && apt-get install -y wget \
	&& echo "deb http://repo.mosquitto.org/debian jessie main" > /etc/apt/sources.list.d/mosquitto.list \
	&& wget -q -S -O - http://repo.mosquitto.org/debian/mosquitto-repo.gpg.key | apt-key add - \
	&& apt-get update && apt-get install -y mosquitto mosquitto-clients \
	&& mkdir -p /mqtt/config /mqtt/data /mqtt/log \
	&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
	&& wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
	&& gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
	&& rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu \
	&& gosu nobody true \
	&& apt-get purge -y --auto-remove ca-certificates wget


ADD mosquitto.conf /mqtt/config/mosquitto.conf
ADD conf.d /mqtt/config/conf.d
ADD certs /mqtt/config/certs
COPY scripts/* /usr/local/bin/

VOLUME /var/lib/mosquitto/

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 1883 2883 3883
CMD ["/usr/sbin/mosquitto", "-c", "/mqtt/config/mosquitto.conf"]
