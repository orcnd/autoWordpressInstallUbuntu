export PS1="\[\e[30;42m\]basladi\[\e[m\] "

echo "paketler kuruluyor \n"
apt-get update -y -qq

apt-get upgrade -y -qq

apt-get -q q-y install apache2 

export DEBIAN_FRONTEND=noninteractive

apt-get -qq -y install mysql-server php php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip php-mysql git 

echo "paketler kuruldu \n\n"

rm -rf /wpin

mkdir /wpin

cd /wpin

rm -rf /var/www/html/*

echo "klasorler hazirlandi \n\n"

echo "wordpress indiriliyor\n"

wget -q https://tr.wordpress.org/latest-tr_TR.tar.gz

tar -xzf latest-tr_TR.tar.gz

mv wordpress/* /var/www/html

echo "wordpress indirildi ve acildi \n"

dbpass=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)

salt=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 4 | head -n 1)

hash=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

echo $dbpass > /wpindbpass.txt

mysql -e "create database wpdb_$salt;"

mysql -e "create user 'wpuser_$salt'@'localhost' identified by '$dbpass';"

mysql -e "SET PASSWORD FOR 'wpuser_$salt'@'localhost'=password('$dbpass');"

mysql -e "grant all privileges on wpdb_$salt.* to wpuser_$salt@localhost;"

mysql -e "FLUSH PRIVILEGES;"

echo "veritabani olusturuldu izinler ayarlandi  \n"

cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

sed -i "s/veritabaniismi/wpdb_$salt/g" /var/www/html/wp-config.php

sed -i "s/kullaniciadi/wpuser_$salt/g" /var/www/html/wp-config.php

sed -i "s/parola/$dbpass/g" /var/www/html/wp-config.php

sed -i "s/eşsiz karakter kümenizi buraya yerleştirin/$hash/g" /var/www/html/wp-config.php

echo "wordpress config duzenlendi \n\n"

export PS1="\[\e[30;42m\]tamamlandi\[\e[m\] "
