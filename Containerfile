# See https://github.com/apache/cloudstack/blob/4.22.0.0/tools/docker/Dockerfile
FROM docker.io/apache/cloudstack-simulator:4.22.0.0

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update && apt-get upgrade -y && apt-get install -y --no-install-recommends \
    wget \
    nginx \
    jq \
    netcat \
    && apt-get clean all && rm -rf /var/lib/apt/lists/*;

COPY zones.cfg /opt/zones.cfg

COPY nginx_default.conf /etc/nginx/sites-available/default

RUN pip install cs tzdata

COPY run.sh /opt/run.sh
COPY deploy.sh /opt/deploy.sh
COPY supervisord_nginx.conf /etc/supervisor/conf.d/nginx.conf

RUN /opt/deploy.sh

EXPOSE 8888 8080 8096

CMD ["/usr/bin/supervisord"]
