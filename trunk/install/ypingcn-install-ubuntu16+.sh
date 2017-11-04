#!/bin/bash
echo "请确认程序已用管理员权限运行"
apt update
apt install -y subversion
/usr/sbin/useradd -m -u 1536 judge
cd /home/judge/
svn co https://github.com/ypingcn/hustoj/trunk/trunk/  src
apt install -y make flex g++ clang libmysqlclient-dev libmysql++-dev php-fpm nginx mysql-server php-mysql php-gd php-zip fp-compiler openjdk-8-jdk mono-devel php-mbstring php-xml

USER=`cat /etc/mysql/debian.cnf |grep user|head -1|awk  '{print $3}'`
PASSWORD=`cat /etc/mysql/debian.cnf |grep password|head -1|awk  '{print $3}'`

mkdir etc data log

cp src/install/java0.policy  /home/judge/etc
cp src/install/judge.conf  /home/judge/etc

if grep "OJ_SHM_RUN=0" etc/judge.conf ; then
	mkdir run0 run1 run2 run3
	chown www-data run0 run1 run2 run3
fi


sed -i "s/OJ_USER_NAME=root/OJ_USER_NAME=$USER/g" etc/judge.conf
sed -i "s/OJ_PASSWORD=root/OJ_PASSWORD=$PASSWORD/g" etc/judge.conf
sed -i "s/OJ_COMPILE_CHROOT=1/OJ_COMPILE_CHROOT=0/g" etc/judge.conf
chmod 700 etc/judge.conf

sed -i "s/DB_USER=\"root\"/DB_USER=\"$USER\"/g" src/web/include/db_info.inc.php
sed -i "s/DB_PASS=\"root\"/DB_PASS=\"$PASSWORD\"/g" src/web/include/db_info.inc.php
chmod 700 src/web/include/db_info.inc.php
chown www-data src/web/include/db_info.inc.php
chown www-data src/web/upload data run0 run1 run2 run3

if grep client_max_body_size /etc/nginx/nginx.conf ; then
	echo "client_max_body_size already added" ;
else
	sed -i "s:include /etc/nginx/mime.types;:client_max_body_size    80m;\n\tinclude /etc/nginx/mime.types;:g" /etc/nginx/nginx.conf
fi

mysql -h localhost -u$USER -p$PASSWORD < src/install/db.sql
echo "insert into jol.privilege values('admin','administrator','N');"|mysql -h localhost -u$USER -p$PASSWORD

sed -i "s:root /var/www/html;:root /home/judge/src/web;\n\t# modified for hustoj(ypingcn's distribution):g" /etc/nginx/sites-enabled/default
sed -i "s:index index.html:index index.php:g" /etc/nginx/sites-enabled/default
sed -i "s:#location ~ \\\.php\\$:location ~ \\\.php\\$:g" /etc/nginx/sites-enabled/default
sed -i "s:#\tinclude snippets:\tinclude snippets:g" /etc/nginx/sites-enabled/default
sed -i "s:#\tfastcgi_pass unix\:/run/php/php7.0-fpm.sock;:\tfastcgi_pass unix\:/run/php/php7.0-fpm.sock;\n\t}\n\t# modified for hustoj(ypingcn's distribution):g" /etc/nginx/sites-enabled/default

sed -i "s/post_max_size = 8M/post_max_size = 80M/g" /etc/php/7.0/fpm/php.ini
sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 80M/g" /etc/php/7.0/fpm/php.ini

/etc/init.d/nginx restart
/etc/init.d/php7.0-fpm restart

service php7.0-fpm restart

cd src/core
./make.sh

if grep "/usr/bin/judged" /etc/rc.local ; then
	echo "auto start judged added!"
else
	sed -i "s/exit 0//g" /etc/rc.local
	echo "/usr/bin/judged" >> /etc/rc.local
	echo "exit 0" >> /etc/rc.local
fi

/usr/bin/judged
