<?php 
$wpdbpass=substr(md5(microtime()),12);
$c = new PDO('mysql:host=localhost;', 'root', '');
$c->query("create database wpdb");

$c->query("create user wpuser@localhost identified by '" . $wpdbpass . "'");
$c->query("grant all privileges on wpdb.* to wpuser@localhost");
$c->query("FLUSH PRIVILEGES");



shell_exec("wget https://tr.wordpress.org/latest-tr_TR.tar.gz");
shell_exec("tar -xzf latest-tr_TR.tar.gz");
shell_exec("rm -rf /var/www/html/*");
shell_exec("mv wordpress/* /var/www/html");



$cf=file_get_contents('/var/www/html/wp-config-sample.php');
$cf=str_replace("veritabaniismi","wpdb",$cf);
$cf=str_replace("kullaniciadi","wpuser",$cf);
$cf=str_replace("parola",$wpdbpass,$cf);
$cf=str_replace('eşsiz karakter kümenizi buraya yerleştirin',md5('salttt'.microtime()),$cf);

file_put_contents('/var/www/html/wp-config.php',$cf);

shell_exec("chmod 755 /var/www/html");
shell_exec("systemctl restart apache2");
