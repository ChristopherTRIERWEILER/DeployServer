#!/bin/bash
#Installation des packets
echo 'Mise à jour du système'
sudo apt-get update && apt-get install

#Installation nano
sudo apt-get install nano

#Modification passwd root
echo 'Mise à jour du mot de passe Root'
sudo passwd root

#Repository
echo 'Ajouts des repository'
sudo apt-get install software-properties-common

#Modification du port SSH
echo 'Modification du port SSH par defaut'
echo 'Entrez un port'
read port
sed -i "s/Port 22/Port"port"/" /etc/ssh/sshd_config
echo 'Redemarrage des services'
sudo service ssh restart

#Installation de GLANCE
echo 'Installation de glance (monitoring)'
sudo apt-get install glances

#Installation MySQL
echo 'Installation du serveur MySQL'
sudo apt-get install mysql-server
cp -rp /var/lib/mysql /home/mysql_data
nano /etc/mysql/mysql.conf.d/mysqld.cnf
sed -i "sl/var/lib/mysqli/home/mysql_data/l*" /etc/mysql/mysql.conf.d/mysqld.cnf
echo 'Redemarrage des services'
sudo service apparmor reload
sudo service mysql restart

#Installation apache/nginx
function apache2 {
    echo 'Installation apache2'
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
function nginx {
    echo 'Installation nginx'
    sudo apt-get install nginx
}
echo 'Entrez votre choix de serveur (Apache2/Nginx): '
select item in "- Apache2 -" "- Nginx -"
do
    for var in $REPLY; do
        echo "Installation $var : $item"
        case $REPLY in
            1) #Appel de la fonction apache2
                apache2
                ;;
            2) #Appel de la fonction nginx
                nginx
                ;;
            *) echo "Choix incorrect"
                ;;
        esac
    done
done

#Installation PHP7
echo 'Installation de PHP 7'
sudo apt-get update
sudo apt-get install php-fpm php php-json php-mysql php-mbstring php-mcrypt php-xml php-xmlrpc php-curl php-gd curl git
sudo apt-get install php7.0-mysql php7.0-curl php7.0-json php7.0-cgi  php7.0 libapache2-mod-php7.0
sudo apt-get install php7.0

#Installation webmin
echo 'Installation WEBMIN'
cd /root
sudo wget http://www.webmin.com/jcameron-key.asc
sudo apt-key add jcameron-key.asc
sed -i "s|#|deb http://download.webmin.com/download/repository sarge contrib\n#|" /etc/apt/sources.list
sudo apt-get update
sudo apt-get install webmin

#Installation postfix
echo 'Installation POSTFIX'
sudo apt-get install postfix
service postfix restart

#Installation Serveur NTP
echo 'Installation serveur NTP'
sudo apt-get install ntp
sed -i "s|# more information.|# more information.\nserver ntp.ubuntu.com prefer\n server ntp2.jussieu.fr\n server 0.fr.pool.ntp.org\n server 0.europe.pool.ntp.org|" /etc/ntp.conf
service ntp restart
