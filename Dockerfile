FROM debian:stretch
MAINTAINER yohan <783b8c87@scimetis.net>
ENV DEBIAN_FRONTEND noninteractive
RUN echo "deb http://http.debian.net/debian stretch-backports main" >> /etc/apt/sources.list
RUN apt-get update && apt-get -y install openvpn procps iptables
ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN mkdir -p /etc/openvpn/server/ccd
RUN mkdir -p /etc/openvpn/server/keys
RUN touch /etc/openvpn/server/server.conf
EXPOSE 1194/udp
ENTRYPOINT ["/usr/sbin/openvpn", "--mode", "server", "--topology", "subnet", "--proto", "udp", "--port", "1194", "--dev", "tun", "--server", "192.168.102.0", "255.255.255.0", "--ifconfig-pool", "192.168.102.50", "192.168.102.254", "--push", "route 192.168.102.0 255.255.255.0", "--client-to-client", "--keepalive", "10", "120", "--persist-tun", "--persist-key", "--comp-lzo", "yes", "--remote-cert-tls", "client", "--cipher", "AES-256-CBC", "--ca", "/etc/openvpn/server/keys/ca.crt", "--cert", "/etc/openvpn/server/keys/server.crt", "--dh", "/etc/openvpn/server/keys/dh1024.pem", "--key", "/etc/openvpn/server/keys/server.key", "--client-config-dir", "/etc/openvpn/server/ccd", "--config", "/etc/openvpn/server/server.conf"]
