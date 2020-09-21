#! /bin/bash

# Install VNC
apt_install_prerequisites() {
  echo "[$(date +%H:%M:%S)]: Running apt-get update..."
  apt update
  echo "[$(date +%H:%M:%S)]: Install TigerVNC..."
  apt install -y tigervnc-standalone-server
  echo "[$(date +%H:%M:%S)]: Get Script and Autostart..."
  mkdir ~/.vnc/ && wget https://gitlab.com/kalilinux/nethunter/build-scripts/kali-nethunter-project/-/raw/master/nethunter-fs/profiles/xstartup -O ~/.vnc/xstartup
  echo kali | vncpasswd -f > ~/.vnc/passwd
  chmod 600 ~/.vnc/passwd
  vncserver :1 -localhost no
# Autostart
echo "Generating autostart script for VNC session..."
cd /etc/init.d/
if [ -f vncautostart ]
then
rm vncautostart
update-rc.d vncautostart remove
fi
echo "#!/bin/sh
### BEGIN INIT INFO
# Provides: /usr/bin/vncserver
# Required-Start: \$local_fs \$remote_fs \$syslog
# Required-Stop: \$local_fc \$remote_fs \$syslog
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: auto setup vnc server
# Description: auto setup vncserver in kali linux
#
### END INIT INFO
# /etc/init.d/vncautostart
USER=root
HOME=/root
export USER HOME
case" '$1' "in
start)
/usr/bin/vncserver :1 -localhost no -geometry 1920x886
;;
stop)
pkill Xtigervnc
;;
*)
exit 1
;;
esac
exit 0
" > vncautostart
echo ""
echo "Setup autostart script"
echo "Wait..."; sleep 2;
chmod +x vncautostart
update-rc.d vncautostart defaults
echo "VNC auto start setup successfully completed"
}


main() {
  apt_install_prerequisites
}

main
exit 0
