#!/bin/bash
dnf install -y java-17-openjdk git maven httpd

# 1. 소스코드 복제 및 빌드
git clone https://github.com/kickerbar/my-test-repo.git /opt/myapp
cd /opt/myapp
mvn clean package -DskipTests

# 2. 애플리케이션 실행
nohup java -jar target/*.jar > /opt/app.log 2>&1 &

# 3. Apache 설정 (간단한 echo 방식 사용)
echo "ProxyRequests Off" > /etc/httpd/conf.d/proxy.conf
echo "ProxyPreserveHost On" >> /etc/httpd/conf.d/proxy.conf
echo "<VirtualHost *:80>" >> /etc/httpd/conf.d/proxy.conf
echo "    ProxyPass / http://127.0.0.1:8080/" >> /etc/httpd/conf.d/proxy.conf
echo "    ProxyPassReverse / http://127.0.0.1:8080/" >> /etc/httpd/conf.d/proxy.conf
echo "</VirtualHost>" >> /etc/httpd/conf.d/proxy.conf

# 4. 서비스 시작
systemctl enable --now httpd
