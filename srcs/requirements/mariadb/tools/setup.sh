#!/bin/sh

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

#sans ca MariaDB refusait tous les connextions d'autre containers
sed -i 's/skip-networking//' /etc/my.cnf.d/mariadb-server.cnf

# Configure port and bind address
echo "[mysqld]" >> /etc/my.cnf.d/mariadb-server.cnf
echo "port = 3306" >> /etc/my.cnf.d/mariadb-server.cnf
echo "bind-address = 0.0.0.0" >> /etc/my.cnf.d/mariadb-server.cnf

#on commence MariaBd de manière temporaire dans le background
#on bloque toute network connexion pour le setun 
#& = run in background so the script peut continuer
mysqld --user=mysql --skip-networking &
sleep 3

#on se connecte en root pour lancer les SQL commands
#on a un utilisateur pour les connexions via socket (meme machine @localhost) et
#un user pour les connexions via netowrk (autre container @%)
mysql -u root << EOF
CREATE DATABASE IF NOT EXISTS wordpress;
CREATE USER 'parissa'@'%' IDENTIFIED BY 'petiteGazelle123';
CREATE USER 'parissa'@'localhost' IDENTIFIED BY 'petiteGazelle123';
GRANT ALL PRIVILEGES ON wordpress.* TO 'parissa'@'%';
GRANT ALL PRIVILEGES ON wordpress.* TO 'parissa'@'localhost';
FLUSH PRIVILEGES;
EOF

#stop le MariaDb temporaire
mysqladmin -u root shutdown

#lance MAriaDB en "foreground" 
# exec replace the shell process et donc MariaDb devient PID1
exec mysqld --user=mysql