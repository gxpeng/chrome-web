#!/bin/sh
docker pull tekfik/chrome
docker run --name chrome --privileged -p 5800:3000 -d tekfik/chrome
docker exec -it chrome /bin/bash
yum -y install sudo unzip google-chrome-stable
wget https://codeload.github.com/gxpeng/chrome-web-docker/zip/refs/heads/master
unzip master
/bin/cp -f chrome-web-docker-master/system/* /etc/systemd/system/
VNC_USER=app
VNC_PASSWD=password
VNC_WIDTH=1300
VNC_HIGHT=780
VNC_PORT=3000
VNC_TimeZone=America/Los_Angeles
BROSWER_WIDTH=1280
BROSWER_HIGHT=760
sed -i "s/_USER_/${VNC_USER}/g" `grep -rl "_USER_" /etc/systemd/system/tgvnc.service`
sed -i "s/_WIDTH_/${VNC_WIDTH}/g" `grep -rl "_WIDTH_" /etc/systemd/system/tgvnc.service`
sed -i "s/_HIGHT_/${VNC_HIGHT}/g" `grep -rl "_HIGHT_" /etc/systemd/system/tgvnc.service`
sed -i "s/_USER_/${VNC_USER}/g" `grep -rl "_USER_" /etc/systemd/system/novnc.service`
sed -i "s/_PORT_/${VNC_PORT}/g" `grep -rl "_PORT_" /etc/systemd/system/novnc.service`
sed -i "s/_USER_/${VNC_USER}/g" `grep -rl "_USER_" /etc/systemd/system/chrome.service`
sed -i "s/_WIDTH_/${BROSWER_WIDTH}/g" `grep -rl "_WIDTH_" /etc/systemd/system/chrome.service`
sed -i "s/_HIGHT_/${BROSWER_HIGHT}/g" `grep -rl "_HIGHT_" /etc/systemd/system/chrome.service`
echo -e "${VNC_PASSWD}\n${VNC_PASSWD}\n\n" | sudo -Hu ${VNC_USER} vncpasswd
/bin/cp -f chrome-web-docker-master/fonts/* /usr/share/fonts/ 
ln -sf /usr/share/zoneinfo/${VNC_TimeZone} /etc/localtime
rm -rf chrome-web-docker-master
rm -f master 
