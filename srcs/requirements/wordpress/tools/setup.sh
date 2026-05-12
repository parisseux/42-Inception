#!/bin/sh

mkdir -p /var/www/html

# on telecharge wp-cli - a comand line tool to manage WordPress
wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

#downlaod que si pas present
if [ ! -f /var/www/html/wp-config.php ]; then
    wp core download --path=/var/www/html --allow-root
fi

#temps d'attente car sinon WordPress essaiyant de se connecter avant que MariaDb etait pret
until mysqladmin ping -h mariadb -u $DB_USER -p$DB_PASSWORD --silent; do
    echo "Waiting for MariaDB..."
    sleep 2
done

#config file Tells WordPress how to connect to MariaDB
wp config create \
    --path=/var/www/html \
    --dbname=$DB_NAME \
    --dbuser=$DB_USER \
    --dbpass=$DB_PASSWORD \
    --dbhost=mariadb \
    --allow-root

#install WordPress & create all the tables in MariaDB
#setup admin 
wp core install \
    --path=/var/www/html \
    --url=$DOMAIN_NAME \
    --title=$WP_TITLE \
    --admin_user=$WP_ADMIN \
    --admin_password=$WP_ADMIN_PASSWORD \
    --admin_email=$WP_ADMIN_EMAIL \
    --allow-root

wp user create \
    $WP_USER \
    $WP_USER_EMAIL \
    --role=author \
    --user_pass=$WP_USER_PASSWORD \
    --path=/var/www/html \
    --allow-root

#on run en "foreground" so the docker know the container is alive
exec php-fpm83 -F