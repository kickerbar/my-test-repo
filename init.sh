#!/bin/bash
dnf install -y java-17-openjdk git maven httpd

git clone https://github.com/kickerbar/my-test-repo.git /opt/myapp
cd /opt/myapp

mvn clean package -DskipTests

nohup java -jar target/*.jar > /opt/app.log 2>&1 &

cat << 'EOF_CONF' > /etc/httpd/conf.d/proxy.conf
ProxyRequests Off
ProxyPreserveHost On
<VirtualHost *:80>
    ProxyPass / http://127.0.0.1:8080/
    ProxyPassReverse / http://127.0.0.1:8080/
</VirtualHost>
EOF_CONF

systemctl enable --now httpd
