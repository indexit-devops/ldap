#!/bin/bash


yum install openldap-servers openldap-clients git -y &>/dev/null
 cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG 
 chown ldap. /var/lib/ldap/DB_CONFIG 
systemctl start slapd 
systemctl enable slapd 

cd /opt
git clone https://github.com/indexit-devops/ldap.git &>/dev/null
cd /opt/ldap
ldapadd -Y EXTERNAL -H ldapi:/// -f chrootpw.ldif 
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/cosine.ldif 
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/nis.ldif 
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/inetorgperson.ldif 
ldapmodify -Y EXTERNAL -H ldapi:/// -f chdomain.ldif 
ldapadd -x -D cn=Manager,dc=linuxautomations,dc=com -W -f basedomain.ldif 

yum install httpd php php-ldap -y &>/dev/null
cd /var/www/html
tar xf /opt/ldap/lam.tgz
systemctl restart httpd
systemctl enable httpd

