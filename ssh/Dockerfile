FROM ubuntu:latest

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y openssh-server nscd nslcd libpam-ldap libnss-ldap \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/sshd

COPY ./nslcd.conf /etc/nslcd.conf
COPY ./nscd.conf /etc/nscd.conf
COPY ./nsswitch.conf /etc/nsswitch.conf
COPY ./access.conf /etc/security/access.conf
COPY ./sshd /etc/pam.d/sshd
COPY ./sshd_config /etc/ssh/sshd_config
COPY ./common-session /etc/pam.d/common-session
COPY ./common-password /etc/pam.d/common-password

EXPOSE 22

CMD /usr/sbin/sshd & /usr/sbin/nslcd