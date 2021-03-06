# install required packages
apt -y update
apt -y upgrade
apt -y dist-upgrade



export MYSQLROOTPASSWORD="$1"
export GUACAPASSWORD="$2"
export GUACADMIN="$3"
export GUACADMINPASSWORD="$4"


debconf-set-selections <<< "mysql-server mysql-server/root_password password $MYSQLROOTPASSWORD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $MYSQLROOTPASSWORD"

apt -y install libcairo2-dev libjpeg-turbo8-dev libpng12-dev libossp-uuid-dev libfreerdp-dev libpango1.0-dev libssh2-1-dev libtelnet-dev \
libvncserver-dev libpulse-dev libssl-dev libvorbis-dev libwebp-dev git build-essential autoconf libtool tomcat8 \
tomcat8-admin tomcat8-common tomcat8-docs tomcat8-user maven mysql-server mysql-client mysql-common mysql-utilities libpulse-dev \
libvorbis-dev freerdp ghostscript wget

# create directories
mkdir -p /etc/guacamole
mkdir -p /etc/guacamole/lib
mkdir -p /etc/guacamole/extensions

# configure GUACAMOLE_HOME for tomcat
echo "" >> /etc/default/tomcat8
echo "# GUACAMOLE ENV VARIABLE" >> /etc/default/tomcat8
echo "GUACAMOLE_HOME=/etc/guacamole" >> /etc/default/tomcat8
cd /opt

# install guacamole server
git clone https://github.com/apache/incubator-guacamole-server.git

cd incubator-guacamole-server/
apt -y install autoconf
autoreconf -fi
./configure --with-init-dir=/etc/init.d
make
make install
ldconfig
systemctl enable guacd

apt-get -y install openjdk-8-jdk

# install guacamole client (web app)
cd /opt
git clone https://github.com/apache/incubator-guacamole-client.git
cd incubator-guacamole-client
mvn package -Drat.ignoreErrors=true 
cp ./guacamole/target/guacamole-*.war /var/lib/tomcat8/webapps/guacamole.war
cp ./extensions/guacamole-auth-jdbc/modules/guacamole-auth-jdbc-mysql/target/guacamole-auth-jdbc-mysql-*.jar /etc/guacamole/extensions/
# cp ./extensions/guacamole-auth-ldap/target/guacamole-auth-ldap-*.jar /etc/guacamole/extensions/

# install mysql connector
wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.40.tar.gz
tar xf mysql-conn*
cp mysql-connector-java-5.1.40/mysql-connector-java-5.1.40-bin.jar /etc/guacamole/lib/
ln -s /usr/local/lib/freerdp/* /usr/lib/x86_64-linux-gnu/freerdp/.

# configure mysql for guacamole
echo "mysql-hostname: localhost" > /etc/guacamole/guacamole.properties
echo "mysql-port: 3306" >> /etc/guacamole/guacamole.properties
echo "mysql-database: guacamole_db" >> /etc/guacamole/guacamole.properties
echo "mysql-username: guacamole_user" >> /etc/guacamole/guacamole.properties
echo "mysql-password: $GUACAPASSWORD" >> /etc/guacamole/guacamole.properties

# link guacamole dir to tomcat
rm -rf /usr/share/tomcat8/.guacamole
ln -s /etc/guacamole /usr/share/tomcat8/.guacamole


echo "
create database guacamole_db;
create user 'guacamole_user'@'localhost' identified by '$GUACAPASSWORD';
GRANT SELECT,INSERT,UPDATE,DELETE ON guacamole_db.* TO 'guacamole_user'@'localhost';
flush privileges;
quit
" | tee init_db.sql

# provision the guacamole database
mysql -u root --password="$MYSQLROOTPASSWORD" < init_db.sql

cat /opt/incubator-guacamole-client/extensions/guacamole-auth-jdbc/modules/guacamole-auth-jdbc-mysql/schema/*.sql | mysql -u root --password="$MYSQLROOTPASSWORD" guacamole_db

mysql -u root --password="$MYSQLROOTPASSWORD" guacamole_db -e "update guacamole_user set username='$GUACADMIN' ,password_hash=UNHEX(SHA2(CONCAT('$GUACADMINPASSWORD', HEX(password_salt)), 256))"

systemctl restart guacd
systemctl restart tomcat8

iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to 8080 