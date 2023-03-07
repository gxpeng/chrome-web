#!/bin/sh
docker pull tekfik/chrome
docker run -d --name chrome -e VNC_USER=app -e VNC_PASSWORD=password -e VNC_WIDTH=1300 -e VNC_HIGHT=780 -e BROSWER_WIDTH=1280 -e BROSWER_HIGHT=760 -e VNC_TimeZone=America/Los_Angeles --privileged -p 3000:3000 tekfik/chrome
docker exec -it chrome /bin/bash
  yum -y install google-chrome-stable
  yum -y install sudo unzip
  wget https://codeload.github.com/gxpeng/chrome-web-docker/zip/refs/heads/master
  unzip master
  /bin/cp -f chrome-web-docker-master/system/* /etc/systemd/system/
  [ "z""${VNC_USER}" = "z" ]      && VNC_USER=app
  [ "z""${VNC_PASSWORD}" = "z" ]  && VNC_PASSWORD=password
  [ "z""${VNC_WIDTH}" = "z" ]     && VNC_WIDTH=1300
  [ "z""${VNC_HIGHT}" = "z" ]     && VNC_HIGHT=780
  [ "z""${BROSWER_WIDTH}" = "z" ] && BROSWER_WIDTH=1280
  [ "z""${BROSWER_HIGHT}" = "z" ] && BROSWER_HIGHT=760
  [ "z""${VNC_TimeZone}" = "z" ]  && VNC_TimeZone=America/Los_Angeles
  [ "z""${VNC_PORT}" = "z" ]      && VNC_PORT=3000
  sed -i "s/_USER_/${VNC_USER}/g" `grep -rl "_USER_" /etc/systemd/system/tgvnc.service`
  sed -i "s/_WIDTH_/${VNC_WIDTH}/g" `grep -rl "_WIDTH_" /etc/systemd/system/tgvnc.service`
  sed -i "s/_HIGHT_/${VNC_HIGHT}/g" `grep -rl "_HIGHT_" /etc/systemd/system/tgvnc.service`
  sed -i "s/_USER_/${VNC_USER}/g" `grep -rl "_USER_" /etc/systemd/system/novnc.service`
  sed -i "s/_PORT_/${VNC_PORT}/g" `grep -rl "_PORT_" /etc/systemd/system/novnc.service`
  sed -i "s/_USER_/${VNC_USER}/g" `grep -rl "_USER_" /etc/systemd/system/chrome.service`
  sed -i "s/_WIDTH_/${BROSWER_WIDTH}/g" `grep -rl "_WIDTH_" /etc/systemd/system/chrome.service`
  sed -i "s/_HIGHT_/${BROSWER_HIGHT}/g" `grep -rl "_HIGHT_" /etc/systemd/system/chrome.service`
  echo -e "${VNC_PASSWORD}\n${VNC_PASSWORD}\n\n" | sudo -Hu ${VNC_USER} vncpasswd
  /bin/cp -f chrome-web-docker-master/fonts/* /usr/share/fonts/ 
  ln -sf /usr/share/zoneinfo/${VNC_TimeZone} /etc/localtime
  rm -rf chrome-web-docker-master
  rm -f master 
  exit
docker restart chrome_web
