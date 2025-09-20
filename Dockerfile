FROM debian:trixie-slim
ENV GNUPGHOME=/data/.gnupg
RUN apt update && apt install -y aptly
ADD /etc/aptly.yml /etc/aptly.conf
VOLUME [ "/data" ]
ADD entrypoint.sh /entrypoint.sh
WORKDIR /data
CMD ["/entrypoint.sh"]
