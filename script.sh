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
    #nano /etc/apache2/apache2.conf
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

# Page de dialog serveur web
OPTION=$(whiptail --title "Menu" --menu "Choix du serveur web" 15 60 4 \
        "1" "Apache2" \
        "2" "Nginx" 3>&1 1>&2 2>&3)

exitstatus=$?
if [ $exitstatus = 0 ]; then
    if [ "$OPTION" = 1 ] ; then
        apache2
    elif [ "$OPTION" = 2 ] ; then
        nginx
    fi
else
    echo "vous avez annulé"
fi

#show_menu(){
#    NORMAL=`echo "\033[m"`
#    MENU=`echo "\033[36m"` #Blue
#    NUMBER=`echo "\033[33m"` #yellow
#    FGRED=`echo "\033[41m"`
#    RED_TEXT=`echo "\033[31m"`
#    ENTER_LINE=`echo "\033[33m"`
#    echo -e "${MENU}*********************************************${NORMAL}"
#    echo -e "${MENU}**${NUMBER} 1)${MENU} Installation Apache2 ${NORMAL}"
#    echo -e "${MENU}**${NUMBER} 2)${MENU} Installation Nginx ${NORMAL}"
#    echo -e "${MENU}*********************************************${NORMAL}"
#    echo -e "${ENTER_LINE}Please enter a menu option and enter or ${RED_TEXT}enter to exit. ${NORMAL}"
#    read opt
#}
#option_picked() {
#    COLOR='\033[01;31m' # bold red
#    RESET='\033[00;00m' # normal white
#    MESSAGE=${@:-"${RESET}Error: No message passed"}
#    echo -e "${COLOR}${MESSAGE}${RESET}"
#}
#
#clear
#show_menu
#while [ opt != '' ]
#    do
#    if [[ $opt = "" ]]; then
#            exit;
#    else
#        case $opt in
#        1) clear;
#            option_picked "Apache2";
#            apache2
#        menu;
#        ;;
#
#        2) clear;
#            option_picked "Nginx";
#            nginx
#        menu;
#            ;;
#
#        x)exit;
#        ;;
#
#        \n)exit;
#        ;;
#
#        *)clear;
#        option_picked "Pick an option from the menu";
#        show_menu;
#        ;;
#    esac
#fi
#done

#Installation PHP

# Apache2
php7_apache(){
    echo -e "\033[1;32mInstallation de PHP 7.0\e[0m"
    sudo apt-get update
    sudo apt-get install php-fpm php php-json php-mysql php-mbstring php-mcrypt php-xml php-xmlrpc php-curl php-gd curl git
    sudo apt-get install php7.0-mysql php7.0-curl php7.0-json php7.0-cgi  php7.0 libapache2-mod-php7.0
    sudo apt-get install php7.0
}

php71_apache(){
    echo -e "\033[1;32mInstallation de PHP 7.1\e[0m"
    sudo apt-get update
    sudo apt-get install php-fpm php php-json php-mysql php-mbstring php-mcrypt php-xml php-xmlrpc php-curl php-gd curl git
    sudo apt-get install php7.1-mysql php7.1-curl php7.1-json php7.0-cgi php7.1 libapache2-mod-php7.1
    sudo apt-get install php7.1
}

php72_apache(){
    echo -e "\033[1;32mInstallation de PHP 7.2\e[0m"
    sudo apt-get update
    sudo apt-get install php-fpm php php-json php-mysql php-mbstring php-mcrypt php-xml php-xmlrpc php-curl php-gd curl git
    sudo apt-get install php7.2-mysql php7.2-curl php7.2-json php7.2-cgi php7.2 libapache2-mod-php7.2
    sudo apt-get install php7.2
}

# Nginx
php7_nginx(){
    echo -e "\033[1;32mInstallation de PHP 7.0\e[0m"
    sudo apt-get update
    sudo apt-get --no-install-recommends php7.0 php7.0-fpm php7.0-mysql php7.0-curl php7.0-json php7.0-gd php7.0-mcrypt php7.0-msgpack php7.0-memcached php7.0-intl php7.0-sqlite3 php7.0-gmp php7.0-geoip php7.0-mbstring php7.0-redis php7.0-xml php7.0-zip
    sudo apt-get install php7.0-mysql php7.0-curl php7.0-json php7.0-cgi php7.0 libapache2-mod-php7.0
    sudo apt-get install php7.0
}

php71_nginx(){
    echo -e "\033[1;32mInstallation de PHP 7.1\e[0m"
    sudo apt-get update
    sudo apt-get install --no-install-recommends php7.1 php7.1-fpm php7.1-mysql php7.1-curl php7.1-json php7.1-gd php7.1-mcrypt php7.1-msgpack php7.1-memcached php7.1-intl php7.1-sqlite3 php7.1-gmp php7.1-geoip php7.1-mbstring php7.1-redis php7.1-xml php7.1-zip
    sudo apt-get install php7.1-mysql php7.1-curl php7.1-json php7.1-cgi php7.1 libapache2-mod-php7.1
    sudo apt-get install php7.1
}

php72_nginx(){
    echo -e "\033[1;32mInstallation de PHP 7.2\e[0m"
    sudo apt-get update
    sudo apt-get --no-install-recommends php7.2 php7.2-fpm php7.2-mysql php7.2-curl php7.2-json php7.2-gd php7.2-mcrypt php7.2-msgpack php7.2-memcached php7.2-intl php7.2-sqlite3 php7.2-gmp php7.2-geoip php7.2-mbstring php7.2-redis php7.2-xml php7.2-zip
    sudo apt-get install php7.2-mysql php7.2-curl php7.2-json php7.2-cgi php7.2 libapache2-mod-php7.2
    sudo apt-get install php7.2
}

OPTION=$(whiptail --title "Menu" --radiolist \ "Choix des versions de PHP" 15 60 4 \
        "1" "PHP 7.0" ON \
        "2" "PHP 7.1"  OFF \
        "3" "PHP 7.2" OFF 3>&1 1>&2 2>&3)

SERVICE_A='apache2'
SERVICE_N='nginx'

exitstatus=$?
if [ $exitstatus = 0 ]; then
    if [ "$OPTION" = 1 ] ; then
        if ps ax | grep -v grep | grep $SERVICE_A > /dev/null
        then
            php7_apache
        elif ps ax | grep -v grep | grep $SERVICE_N > /dev/null
        then
            php7_nginx
        fi
    elif [ "$OPTION" = 2 ] ; then
        if ps ax | grep -v grep | grep $SERVICE_A > /dev/null
        then
            php71_apache
        elif ps ax | grep -v grep | grep $SERVICE_N > /dev/null
        then
            php71_nginx
        fi
    elif [ "$OPTION" = 3 ] ; then
        if ps ax | grep -v grep | grep $SERVICE_A > /dev/null
        then
            php72_apache
        elif ps ax | grep -v grep | grep $SERVICE_N > /dev/null
        then
            php72_nginx
        fi
    fi
else
    echo "vous avez annulé"
fi



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
