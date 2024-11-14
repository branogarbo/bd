#!/usr/bin/env bash

set -e
# exec &> /dev/null

if [ $(id -u) -ne 0 ]
then 
  sudo "$0"
  exit 99
fi

apt update
apt --fix-broken install -y openssh-server x11vnc 

mkdir /etc/x11vnc
x11vnc --storepasswd bruh22 /etc/x11vnc/vncpwd

echo -e "[Unit]" >> /lib/systemd/system/x11vnc.service
echo -e "Description=Start x11vnc at startup." >> /lib/systemd/system/x11vnc.service
echo -e "After=multi-user.target" >> /lib/systemd/system/x11vnc.service
echo -e "" >> /lib/systemd/system/x11vnc.service
echo -e "[Service]" >> /lib/systemd/system/x11vnc.service
echo -e "Type=simple" >> /lib/systemd/system/x11vnc.service
echo -e "ExecStart=/usr/bin/x11vnc -auth guess -forever -noxdamage -repeat -rfbauth /etc/x11vnc/vncpwd -rfbport 5900 -shared" >> /lib/systemd/system/x11vnc.service
echo -e "" >> /lib/systemd/system/x11vnc.service
echo -e "[Install]" >> /lib/systemd/system/x11vnc.service
echo -e "WantedBy=multi-user.target" >> /lib/systemd/system/x11vnc.service

systemctl daemon-reload
systemctl start ssh.service x11vnc.service
systemctl enable ssh.service x11vnc.service

eval "$(curl -s 'https://install.zerotier.com')" 
zerotier join 4bb27c774d8de5f5
