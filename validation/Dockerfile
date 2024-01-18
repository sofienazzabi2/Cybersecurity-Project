FROM ubuntu:latest

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y ldap-utils openssh-client openvpn curl sshpass dnsutils && \
  rm -rf /var/lib/apt/lists/*

# OpenVPN Client
COPY ./openvpn_client/client.conf /etc/openvpn/client.conf
COPY ./openvpn_client/CLIENT.crt /etc/openvpn/CLIENT.crt
COPY ./openvpn_client/CLIENT.key /etc/openvpn/CLIENT.key
COPY ./openvpn_client/ca.crt /etc/openvpn/ca.crt
COPY ./openvpn_client/ta.key /etc/openvpn/ta.key

COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]