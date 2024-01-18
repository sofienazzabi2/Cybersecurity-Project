FROM ubuntu:latest

RUN apt-get update \
  && apt-get install -y openvpn easy-rsa openvpn-auth-ldap

COPY ./server.conf /etc/openvpn/server.conf
COPY ./auth-ldap.conf /etc/openvpn/auth/auth-ldap.conf
COPY ./ta.key /etc/openvpn/ta.key
COPY ./dh.pem /etc/openvpn/dh.pem
COPY ./SERVER.crt /etc/openvpn/SERVER.crt
COPY ./SERVER.key /etc/openvpn/SERVER.key
COPY ./ca.crt /etc/openvpn/ca.crt

RUN sed -i 's/^#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf && \
  sysctl -p /etc/sysctl.conf

EXPOSE 1194

CMD openvpn --config /etc/openvpn/server.conf || tail -f /dev/null

