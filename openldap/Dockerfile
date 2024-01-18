FROM kalilinux/kali-rolling

RUN apt-get update && \
  echo 'slapd/root_password password 1111' | debconf-set-selections &&\
  echo 'slapd/root_password_again password 1111' | debconf-set-selections && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y slapd ldap-utils openssl 

RUN echo "slapd slapd/root_password password 1111" | debconf-set-selections && \
  echo "slapd slapd/root_password_again password 1111" | debconf-set-selections && \
  echo "slapd slapd/domain string security.tn" | debconf-set-selections && \
  echo "slapd shared/organization string security.tn" | debconf-set-selections && \
  echo "slapd slapd/no_configuration boolean false" | debconf-set-selections && \
  echo "slapd slapd/domain string security.tn" | debconf-set-selections && \
  echo "slapd shared/organization string security.tn" | debconf-set-selections && \
  echo "slapd slapd/password1 password 1111" | debconf-set-selections && \
  echo "slapd slapd/password2 password 1111" | debconf-set-selections && \
  echo "jslapd slapd/backend select HDB" | debconf-set-selections && \
  echo "slapd slapd/purge_database boolean true" | debconf-set-selections && \
  echo "slapd slapd/allow_ldap_v2 boolean false" | debconf-set-selections && \
  echo "slapd slapd/move_old_database boolean true" | debconf-set-selections && \
  echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
  dpkg-reconfigure -f noninteractive slapd

RUN mkdir -p /etc/openldap/certs

RUN openssl req -x509 -newkey rsa:4096 -outform DER -keyout /etc/openldap/certs/aziz.key -out /etc/openldap/certs/aziz.der -sha256 -days 3650 -nodes -subj "/C=TN/ST=Tunis/L=Tunis/O=Security/OU=IT/CN=AzizDoe" && \
  openssl req -x509 -newkey rsa:4096 -outform DER -keyout /etc/openldap/certs/sofien.key -out /etc/openldap/certs/sofien.der -sha256 -days 3650 -nodes -subj "/C=TN/ST=Tunis/L=Tunis/O=Security/OU=IT/CN=SofienDa"

COPY add_content.ldif /tmp/add_content.ldif

RUN slapadd -v -l /tmp/add_content.ldif && \
  rm /tmp/add_content.ldif

EXPOSE 389 636

CMD slapd -d 256 -u openldap -g openldap
