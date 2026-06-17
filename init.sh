#!/bin/bash
# init.sh (이 내용을 GitHub에 저장하세요)
set -ex

# 1. 패키지 설치
dnf makecache
dnf install -y java-17-openjdk-devel httpd

# 2. Java 17 설정
JAVA_BIN=$(ls /usr/lib/jvm/java-17-openjdk-*/bin/java | head -n 1)
ln -sf $JAVA_BIN /usr/bin/java

# 3. Systemd 서비스 등록
tee /etc/systemd/system/myapp.service <<EOF
[Unit]
Description=My Spring Boot App
After=network.target
[Service]
ExecStart=$JAVA_BIN -jar /opt/app.jar
Restart=always
User=root
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now myapp

# 4. Apache 프록시 설정
tee /etc/httpd/conf.d/proxy.conf <<EOF
ProxyRequests Off
ProxyPreserveHost On
<VirtualHost *:80>
    ProxyPass / http://127.0.0.1:8080/
    ProxyPassReverse / http://127.0.0.1:8080/
</VirtualHost>
EOF

systemctl enable --now httpd
systemctl restart httpd
