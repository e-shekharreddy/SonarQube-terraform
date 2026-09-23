#!/bin/bash

SONAR_VERSION="26.8.0.126808"

apt-get update -y
apt-get upgrade -y
apt-get install -y openjdk-21-jdk unzip wget curl

cat <<EOF > /etc/sysctl.d/99-sonarqube.conf
vm.max_map_count=524288
fs.file-max=131072
EOF

sysctl --system

cat <<EOF > /etc/security/limits.d/sonarqube.conf
sonar   -   nofile   131072
sonar   -   nproc    8192
EOF

groupadd --system sonar
useradd --system --home-dir /opt/sonarqube --gid sonar sonar

cd /opt

wget -q "https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-${SONAR_VERSION}.zip"

unzip -q "sonarqube-${SONAR_VERSION}.zip"

mv "sonarqube-${SONAR_VERSION}" sonarqube

rm -f "sonarqube-${SONAR_VERSION}.zip"

mkdir -p /opt/sonarqube/logs
mkdir -p /opt/sonarqube/data
mkdir -p /opt/sonarqube/temp

chown -R sonar:sonar /opt/sonarqube

sed -i 's/^#sonar.web.host=.*/sonar.web.host=0.0.0.0/' /opt/sonarqube/conf/sonar.properties

sed -i 's/^#sonar.web.port=.*/sonar.web.port=9000/' /opt/sonarqube/conf/sonar.properties

cat <<EOF > /etc/systemd/system/sonarqube.service
[Unit]
Description=SonarQube service
After=network.target

[Service]
Type=forking
ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
User=sonar
Group=sonar
Restart=always
LimitNOFILE=131072
LimitNPROC=8192

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload

systemctl enable sonarqube

systemctl start sonarqube

systemctl status sonarqube --no-pager