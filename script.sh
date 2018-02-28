#!/bin/bash
#Installation des packets
echo -e "\033[1;32mInstallation des mise à jour\e[0m"
sudo apt-get update && apt-get upgrade

#Installation nano
sudo apt-get install nano
sudo apt-get install vim

#Modification passwd root
echo -e "\033[1;32mMise à jour du mot de passe Root\e[0m"
sudo passwd root

#Repository
echo -e "\033[1;32mAjouts des repository\e[0m"
sudo apt-get install software-properties-common

#Modification du port SSH
echo -e "\033[1;32mModification du port SSH par defaut\e[0m"
echo -e "\033[1;31mEntrez un port\e[0m"
read port
sed -i "s/Port 22/Port"port"/" /etc/ssh/sshd_config
echo -e "\033[41mRedemarrage des services\e[0m"
sudo service ssh restart

#Installation de GLANCE
echo -e "\033[1;32mInstallation de glance (monitoring)\e[0m"
sudo apt-get install glances

#Installation MySQL
echo -e "\033[1;32mInstallation du serveur MySQL\e[0m"
sudo apt-get install mysql-server
cp -rp /var/lib/mysql /home/mysql_data
#nano /etc/mysql/mysql.conf.d/mysqld.cnf
sed -i "sl/var/lib/mysqli/home/mysql_data/l*" /etc/mysql/mysql.conf.d/mysqld.cnf
echo -e "\033[41mRedemarrage des services\e[0m"
sudo service apparmor reload
sudo service mysql restart

#Installation apache/nginx
apache2(){
    echo -e "\033[1;32mInstallation apache2\e[0m"
    sudo add-apt-repository ppa:ondrej/apache2
    sudo apt-get update
    sudo apt-get install apache2
    nano /etc/apache2/apache2.conf
    LogFormat "%h %l %u %t \"%r\" %>s %O %T sec \"%{Referer}i\" \"%{User-Agent}i\"" combinedspeed
    LogFormat "%a %l %u %t \"%r\" %>s %O %T sec \"%{Referer}i\" \"%{User-Agent}i\"" combinedspeedLB
    a2dismod -f mpm_event auth_basic
    a2enmod mpm_prefork proxy proxy_fcgi remoteip reqtimeout rewrite socache_shmcb ssl headers  expires
    systemctl restart apache2
}
nginx(){
    echo -e "\033[1;32mInstallation Nginx\e[0m"
    sudo apt-get install nginx
}

# Page de dialog
HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=4
BACKTITLE="Backtitle here"
TITLE="Title here"
MENU="Choose one of the following options:"

OPTIONS=(1 "Apache2"
         2 "Nginx")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            echo "You chose Option 1"
            ;;
        2)
            echo "You chose Option 2"
            ;;
        3)
            echo "You chose Option 3"
            ;;
esac

#Installation PHP7
echo -e "\033[1;32mInstallation de PHP 7\e[0m"
sudo apt-get update
sudo apt-get install php-fpm php php-json php-mysql php-mbstring php-mcrypt php-xml php-xmlrpc php-curl php-gd curl git
sudo apt-get install php7.0-mysql php7.0-curl php7.0-json php7.0-cgi  php7.0 libapache2-mod-php7.0
sudo apt-get install php7.0

#Installation webmin
echo -e "\033[1;32mInstallation WEBMIN\e[0m"
cd /root
sudo wget http://www.webmin.com/jcameron-key.asc
sudo apt-key add jcameron-key.asc
sed -i "s|#|deb http://download.webmin.com/download/repository sarge contrib\n#|" /etc/apt/sources.list
sudo apt-get update
sudo apt-get install webmin

#Installation postfix
echo -e "\033[1;32mInstallation POSTFIX\e[0m"
sudo apt-get install postfix
service postfix restart

#Installation Serveur NTP
echo -e "\033[1;32mInstallation serveur NTP\e[0m"
sudo apt-get install ntp
sed -i "s|# more information.|# more information.\nserver ntp.ubuntu.com prefer\n server ntp2.jussieu.fr\n server 0.fr.pool.ntp.org\n server 0.europe.pool.ntp.org|" /etc/ntp.conf
service ntp restart
