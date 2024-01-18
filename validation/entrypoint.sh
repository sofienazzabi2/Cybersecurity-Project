#!/bin/bash

sleep 5

##############################################################################################################

echo "DNS Validation"

# grep the right address (no loopback)
echo "openldap.security.tn: $(nslookup openldap.security.tn | awk '/^Address: / { print $2 }')"
echo "ssh.security.tn: $(nslookup ssh.security.tn | awk '/^Address: / { print $2 }')"
echo "openvpn.security.tn: $(nslookup openvpn.security.tn | awk '/^Address: / { print $2 }')"
echo "apache.security.tn: $(nslookup apache.security.tn | awk '/^Address: / { print $2 }')"

echo "DNS Validation done"

##############################################################################################################

echo "LDAP Validation"

LDAP_SERVER_IP="openldap.security.tn"
LDAP_SERVER_PORT="389"
LDAP_USER_DN_AZIZ="uid=aziz,ou=users,dc=security,dc=tn"
LDAP_PASSWORD_AZIZ="aziz"
LDAP_USER_DN_SOFIEN="uid=sofien,ou=users,dc=security,dc=tn"
LDAP_PASSWORD_SOFIEN="aziz"

echo "Aziz certificate:"
ldapsearch -x -H ldap://$LDAP_SERVER_IP:$LDAP_SERVER_PORT -LLL -b uid=aziz,ou=users,dc=security,dc=tn userCertificate
echo "Sofien certificate:"
ldapsearch -x -H ldap://$LDAP_SERVER_IP:$LDAP_SERVER_PORT -LLL -b uid=sofien,ou=users,dc=security,dc=tn userCertificate

echo "Authenticating aziz..."
ldapwhoami -x -H ldap://$LDAP_SERVER_IP:$LDAP_SERVER_PORT -D "$LDAP_USER_DN_AZIZ" -w "$LDAP_PASSWORD_AZIZ" \
&& echo "Aziz authenticated successfully" \
|| echo "Aziz authentication failed"

echo "Authenticating sofien..."
ldapwhoami -x -H ldap://$LDAP_SERVER_IP:$LDAP_SERVER_PORT -D "$LDAP_USER_DN_SOFIEN" -w "$LDAP_PASSWORD_SOFIEN" \
&& echo "Sofien authenticated successfully" \
|| echo "Sofien authentication failed"

echo "LDAP Validation done"

##############################################################################################################

echo "Apache Validation"

APACHE_SERVER_IP="apache.security.tn"
APACHE_SERVER_PORT="80"
APACHE_CORRECT_USERNAME="sofien"
APACHE_CORRECT_PASSWORD="aziz"
APACHE_INCORRECT_USERNAME="aziz"
APACHE_INCORRECT_PASSWORD="aziz"

echo "Authenticating "$APACHE_INCORRECT_USERNAME"..."
curl -s -o /dev/null -w "Status: %{http_code}\n" -u $APACHE_INCORRECT_USERNAME:$APACHE_INCORRECT_PASSWORD http://$APACHE_SERVER_IP:$APACHE_SERVER_PORT

echo "Authenticating "$APACHE_CORRECT_USERNAME"..."
curl -s -o /dev/null -w "Status: %{http_code}\n" -u $APACHE_CORRECT_USERNAME:$APACHE_CORRECT_PASSWORD http://$APACHE_SERVER_IP:$APACHE_SERVER_PORT

echo "Apache Validation done"

##############################################################################################################

echo "SSH Validation"

SSH_SERVER_HOST="ssh.security.tn"
SSH_AZIZ_USERNAME="aziz"
SSH_AZIZ_PASSWORD="aziz"
SSH_SOFIEN_USERNAME="sofien"
SSH_SOFIEN_PASSWORD="aziz"

sshpass -p ${SSH_AZIZ_PASSWORD} -v ssh -o StrictHostKeyChecking=no ${SSH_AZIZ_USERNAME}@${SSH_SERVER_HOST}

sshpass -p ${SSH_SOFIEN_PASSWORD} -v ssh -o StrictHostKeyChecking=no ${SSH_SOFIEN_USERNAME}@${SSH_SERVER_HOST}

echo "SSH Validation done"

##############################################################################################################

echo "OpenVPN Validation"

OPENVPN_CORRECT_USERNAME="firas"
OPENVPN_CORRECT_PASSWORD="aziz"

OPENVPN_INCORRECT_USERNAME="aziz"
OPENVPN_INCORRECT_PASSWORD="aziz"

echo "Authenticating "$OPENVPN_INCORRECT_USERNAME"..."

echo $OPENVPN_INCORRECT_USERNAME > /etc/openvpn/auth.txt
echo $OPENVPN_INCORRECT_PASSWORD >> /etc/openvpn/auth.txt

openvpn --config /etc/openvpn/client.conf --auth-user-pass /etc/openvpn/auth.txt --inactive 9 --ping 10 --ping-exit 20 \
| grep -e "Initialization Sequence Completed" -e "AUTH_FAILED" -e "TLS Error" -e "Connection refused"

echo "Authenticating "$OPENVPN_CORRECT_USERNAME"..."

echo $OPENVPN_CORRECT_USERNAME > /etc/openvpn/auth.txt
echo $OPENVPN_CORRECT_PASSWORD >> /etc/openvpn/auth.txt

openvpn --config /etc/openvpn/client.conf --auth-user-pass /etc/openvpn/auth.txt --inactive 9 --ping 10 --ping-exit 20 \
| grep -e "Initialization Sequence Completed" -e "AUTH_FAILED" -e "TLS Error" -e "Connection refused"

rm /etc/openvpn/auth.txt

echo "OpenVPN Validation done"

##############################################################################################################

tail -f /dev/null
