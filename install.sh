echo -e "\n\n islem basladi \n"
apt update -y -q
apt upgrade -y -q
apt -q -y install apache2 -q
export DEBIAN_FRONTEND=noninteractive
apt -q -y install mysql-server php php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip php-mysql git -q
echo -e "paketler kuruldu \n"
rm -rf /wpin
mkdir /wpin
cd /wpin
rm -rf /var/www/html/*
echo -e "klasorler hazirlandi \n"

wget -q https://tr.wordpress.org/latest-tr_TR.tar.gz
tar -xzf latest-tr_TR.tar.gz
mv wordpress/* /var/www/html
echo -e "wordpress indirildi ve acildi \n"

dbpass=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)
salt=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 4 | head -n 1)
hash=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

echo $dbpass > /wpindbpass.txt
mysql -e "create database wpdb_$salt;"
mysql -e "create user 'wpuser_$salt'@'localhost' identified by '$dbpass';"
mysql -e "SET PASSWORD FOR 'wpuser_$salt'@'localhost'=password('$dbpass');"
mysql -e "grant all privileges on wpdb_$salt.* to wpuser_$salt@localhost;"
mysql -e "FLUSH PRIVILEGES;"

echo -e "veritabani olusturuldu izinler ayarlandi  \n"

cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
sed -i "s/veritabaniismi/wpdb_$salt/g" /var/www/html/wp-config.php
sed -i "s/kullaniciadi/wpuser_$salt/g" /var/www/html/wp-config.php
sed -i "s/parola/$dbpass/g" /var/www/html/wp-config.php
sed -i "s/eşsiz karakter kümenizi buraya yerleştirin/$hash/g" /var/www/html/wp-config.php

echo -e "wordpress config duzenlendi \n"
echo -e "kurulum tamamlandi \n"
