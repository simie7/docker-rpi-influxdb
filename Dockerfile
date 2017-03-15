#FROM resin/armv7hf-debian:jessie
FROM resin/rpi-raspbian:jessie

ARG DEBIAN_FRONTEND=noninteractive
#RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN set -x && \
    sudo apt-get update && \
    sudo apt-get install -y --no-install-recommends apt-transport-https curl ca-certificates && \
    sudo curl -o /usr/sbin/gosu -fsSL "https://github.com/tianon/gosu/releases/download/1.10/gosu-$(dpkg --print-architecture)" && \
    sudo chmod +x /usr/sbin/gosu && \
    curl https://bintray.com/user/downloadSubjectPublicKey?username=bintray | sudo apt-key add - && \
    echo "deb https://dl.bintray.com/fg2it/deb jessie main" | sudo tee -a /etc/apt/sources.list.d/grafana.list && \
    sudo apt-get update && \
    sudo apt-get install -y --no-install-recommends grafana && \
    sudo apt-get remove -y apt-transport-https curl ca-certificates && \
    sudo apt-get autoremove -y && \
    sudo apt-get clean && \
    sudo rm -rf /var/lib/apt/lists/* && \
    sudo rm -rf /etc/apt/sources.list.d/grafana.list

VOLUME ["/var/lib/grafana", "/var/log/grafana", "/etc/grafana"]

EXPOSE 3000

COPY ./run.sh /run.sh

ENTRYPOINT ["/run.sh"]
