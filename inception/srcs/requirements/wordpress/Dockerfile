FROM 	debian:buster


RUN		apt-get update;			\
		apt-get install  curl	\
		php7.3					\
		php7.3-fpm				\
		php7.3-cli				\
		php-mysql				\
		mariadb-client -y

RUN		mkdir -p /run/php/;	\
		chmod 777 /run/php;	\
		curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar; \
		mv wp-cli.phar /usr/local/bin/wp; \
		chmod +x /usr/local/bin/wp; \
		mkdir -p /var/www/;

COPY 	./www.conf /etc/php/7.3/fpm/php-fpm.conf

RUN		chmod -R 777 /etc/php/7.3/fpm/php-fpm.conf; \
		chown -R www-data:www-data /etc/php/7.3/fpm/php-fpm.conf

COPY 	./wp-create.sh /wp-create.sh

CMD 	["sh", "./wp-create.sh"]
