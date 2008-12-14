apt-get update
apt-get install apache2
apt-get install libapache2-mod-jk
a2enmod jk
sudo apt-get install openjdk-6-jdk

cd /usr/share
wget http://ftp.carnet.hr/misc/apache/tomcat/tomcat-6/v6.0.18/bin/apache-tomcat-6.0.18.tar.gz
tar zxvf apache-tomcat-6.0.18.tar.gz
mv apache-tomcat-6.0.18 tomcat-6.0.18

adduser tomcat && addgroup tomcat
cd tomcat-6.0.18

chown -R tomcat:tomcat webapps; chmod -R 775 webapps
usermod -aG tomcat www-data
cd bin && chmod 755 shutdown.sh startup.sh && cd ..

cp sources/etc/apache2/workers.properties /etc/apache2
chown tomcat.tomcat /etc/apache2/workers.properties

cp sources/etc/apache2/sites-available/java_example /etc/apache2/sites-available

cat sources/etc/apache2/apache2.conf.append /etc/apache2/apache2.conf

/etc/init.d/apache2 stop

cp sources/etc/init.d/tomcat /etc/init.d
chmod +x /etc/init.d/tomcat
invoke-rc.d tomcat start
cp sources/etc/environment /etc/environment
/etc.init.d/tomcat start
/etc/init.d/apache2 start


wget http://dist.codehaus.org/grails/grails-bin-1.0.4.tar.gz

mkdir /usr/lib/grails
cd /usr/lib/grails/
mv ~/grails-bin-1.0.4.tar.gz .
tar -zxvf grails-bin-1.0.4.tar.gz
