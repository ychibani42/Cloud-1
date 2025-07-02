#!/bin/sh

if [ ! -f /conf ]
then
	rm -rf /var/www/wp-config.php
	sleep 10

	wp core download	--allow-root --path="/var/www/"

	wp config create	--allow-root\
						--dbname="$DB_NAME"\
						--dbuser="$DB_USER"\
						--dbpass="$DB_PASS"\
						--dbhost=mariadb:3306\
						--path="/var/www/"

	wp core install		--allow-root\
						--admin_user="$ADMIN_USER"\
						--admin_password="$ADMIN_PASS"\
						--admin_email="$ADMIN_USER@example.com"\
						--url="$DOMAIN_NAME"\
						--title="Inception"\
						--skip-email\
						--path="/var/www/"

	wp user create		--allow-root\
						"$WP_USER"\
						"$WP_USER"example.com\
						--role=author\
						--user_pass="$WP_PASS"\
						--path="/var/www/"

	touch /conf
else
	echo "wordpress is already installed an parametrized"
fi
exec php-fpm7.3 -F
