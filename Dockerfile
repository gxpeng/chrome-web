# Pull base image.
FROM tekfik/os:centos7-systemd
MAINTAINER <TekFik - www.tekfik.com> tekfik.rd@gmail.com 

COPY system /etc/systemd/system/
COPY yum/google-chrome.repo /etc/yum.repos.d/

# Define parameters
ARG VNC_USER=app
ARG VNC_PASSWD=password
ARG VNC_WIDTH=1300
ARG VNC_HIGHT=780
ARG VNC_PORT=3000
ARG VNC_TimeZone=America/Los_Angeles
ARG BROSWER_WIDTH=1280
ARG BROSWER_HIGHT=760


RUN sed -i "s/_USER_/${VNC_USER}/g" `grep -rl "_USER_" /etc/systemd/system/tgvnc.service`; \
    sed -i "s/_WIDTH_/${VNC_WIDTH}/g" `grep -rl "_WIDTH_" /etc/systemd/system/tgvnc.service`; \
    sed -i "s/_HIGHT_/${VNC_HIGHT}/g" `grep -rl "_HIGHT_" /etc/systemd/system/tgvnc.service`; \
    sed -i "s/_USER_/${VNC_USER}/g" `grep -rl "_USER_" /etc/systemd/system/novnc.service`; \
    sed -i "s/_PORT_/${VNC_PORT}/g" `grep -rl "_PORT_" /etc/systemd/system/novnc.service`; \
    sed -i "s/_USER_/${VNC_USER}/g" `grep -rl "_USER_" /etc/systemd/system/chrome.service`; \
    sed -i "s/_WIDTH_/${BROSWER_WIDTH}/g" `grep -rl "_WIDTH_" /etc/systemd/system/chrome.service`; \
    sed -i "s/_HIGHT_/${BROSWER_HIGHT}/g" `grep -rl "_HIGHT_" /etc/systemd/system/chrome.service`

RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm; yum -y update all; \
    yum -y install sudo tigervnc-server-minimal novnc google-chrome-stable alsa-firmware alsa-lib alsa-tools-firmware; \
    yum -y clean all; rm -rf /var/tmp/* /tmp/* /var/cache/yum/*

RUN sbin/useradd ${VNC_USER}; \
    echo -e "${VNC_PASSWD}\n${VNC_PASSWD}\n\n" | sudo -Hu ${VNC_USER} vncpasswd; \
    cd /etc/systemd/system/multi-user.target.wants; \
    ln -sf /etc/systemd/system/tgvnc.service tgvnc.service; \    
    ln -sf /etc/systemd/system/chrome.service chrome.service; \
    ln -sf /etc/systemd/system/novnc.service novnc.service;\
    cd /usr/share/novnc; rm -rf index.html

COPY index.html /usr/share/novnc

# Fonts
COPY fonts /usr/share/fonts/ 

# Set Timezone
RUN ln -sf /usr/share/zoneinfo/${VNC_TimeZone} /etc/localtime

# Define working directory.
WORKDIR /tmp

# Metadata.
LABEL \
      org.label-schema.name="chrome" \
      org.label-schema.description="Docker container for Google-Chrome" \
      org.label-schema.version="Centos7"

# EXPOSE ${VNC_PORT}

CMD ["/usr/sbin/init"]
