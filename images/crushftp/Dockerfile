FROM openjdk:18-slim

RUN apt-get update && apt-get install -y \
  bash \
  bash-completion \
  bash-doc \
  ca-certificates \
  curl \
  wget \
  unzip \
  procps \
	&& update-ca-certificates

RUN wget -O /tmp/CrushFTP10.zip https://www.crushftp.com/early10/CrushFTP10.zip
VOLUME [ "/var/opt/CrushFTP10" ]
RUN unzip -o -q /tmp/CrushFTP10.zip -d /var/opt/
RUN rm -f /tmp/CrushFTP10.zip
RUN chmod +x /var/opt/CrushFTP10/crushftp_init.sh

ADD ./startup.sh /var/opt/startup.sh
ENTRYPOINT [ "/bin/bash", "/var/opt/startup.sh" ]
CMD ["-c"]

HEALTHCHECK --interval=1m --timeout=3s \
  CMD curl -f ${CRUSH_ADMIN_PROTOCOL}://localhost:${CRUSH_ADMIN_PORT}/favivon.ico -H 'Connection: close' || exit 1

ENV CRUSH_ADMIN_PROTOCOL http
ENV CRUSH_ADMIN_PORT 8080

EXPOSE 21 443 2000-2100 2222 8080 9090