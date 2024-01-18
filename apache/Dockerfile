FROM ubuntu:latest

RUN apt-get update \
  && apt-get install -y apache2 libapache2-mod-ldap-userdir

RUN a2enmod ldap && a2enmod authnz_ldap
COPY ./000-default.conf /etc/apache2/sites-available/000-default.conf

EXPOSE 80

CMD service apache2 restart && tail -f /dev/null
