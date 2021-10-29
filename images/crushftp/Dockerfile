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

# Setup CrushFTP
RUN wget -O /tmp/CrushFTP10.zip https://www.crushftp.com/early10/CrushFTP10.zip
RUN unzip -o -q /tmp/CrushFTP10.zip -d /var/opt
RUN rm -f /tmp/CrushFTP10.zip
RUN chmod +x /var/opt/CrushFTP10/crushftp_init.sh

# Set prefs.XML to persisted folder
RUN sed -i "s/-jar plugins\/lib\/CrushFTPJarProxy\.jar/-Dcrushftp.prefs=\/var\/opt\/CrushFTP10\/settings\/ -jar plugins\/lib\/CrushFTPJarProxy.jar/g" /var/opt/CrushFTP10/crushftp_init.sh

# Add SQLJBC for MSSQL
RUN wget -O /tmp/sqljdbc_9.4.0.0_enu.zip https://download.microsoft.com/download/b/c/5/bc5e407f-97ff-42ea-959d-12f2391063d7/sqljdbc_9.4.0.0_enu.zip
RUN unzip -o -q /tmp/sqljdbc_9.4.0.0_enu.zip -d /tmp/sqljdbc_9.4.0.0_enu
RUN cd /tmp/sqljdbc_9.4.0.0_enu && cp -RT 'sqljdbc_9.4\enu' /var/opt/CrushFTP10
RUN rm -f /tmp/sqljdbc_9.4.0.0_enu.zip
RUN rm -rf /tmp/sqljdbc_9.4.0.0_enu

ADD ./startup.sh /var/opt/startup.sh
ENTRYPOINT [ "/bin/bash", "/var/opt/startup.sh" ]
CMD ["-c"]

HEALTHCHECK --interval=1m --timeout=3s \
  CMD curl -f ${CRUSH_ADMIN_PROTOCOL}://localhost:${CRUSH_ADMIN_PORT}/favivon.ico -H 'Connection: close' || exit 1

ENV CRUSH_ADMIN_PROTOCOL http
ENV CRUSH_ADMIN_PORT 8080

EXPOSE 21 443 2000-2100 2222 8080 9090