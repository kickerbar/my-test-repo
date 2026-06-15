#!/bin/bash
dnf install -y java-17-openjdk git maven httpd

# Clone and build
git clone https://github.com/kickerbar/my-test-repo.git /opt/myapp
cd /opt/myapp
mvn clean package -DskipTests

# Run app
nohup java -jar target/*.jar > /opt/app.log 2>&1 &

# Setup Apache
echo "ProxyRequests Off" > /etc/httpd/conf.d/proxy.conf
echo "ProxyPreserveHost On" >> /etc/httpd/conf.d/proxy.conf
echo "<VirtualHost *:80>" >> /etc/httpd/conf.d/proxy.conf
echo "    ProxyPass / http://127.0.0.1:8080/" >> /etc/httpd/conf.d/proxy.conf
echo "    ProxyPassReverse / http://127.0.0.1:8080/" >> /etc/httpd/conf.d/proxy.conf
echo "</VirtualHost>" >> /etc/httpd/conf.d/proxy.conf

# Start service
systemctl enable --now httpd
