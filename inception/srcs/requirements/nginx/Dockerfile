FROM debian:buster

RUN apt-get update -y; \
	apt-get upgrade -y; \ 
	apt-get install -y nginx; \
	apt install vim -y; \ 
	apt install curl -y; \
	mkdir -p /etc/nginx/ssl; \
	apt install openssl -y; \
	openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=${EIP}/UID=ychibani"; \
	mkdir -p /var/run/nginx; \
	mkdir -p /var/www/; \
	chmod 777 /var/www/; \
	chown -R www-data:www-data /var/www/;

COPY ./conf/nginx.conf /etc/nginx/nginx.conf 

ADD  ./conf/default.conf /etc/nginx/conf.d/

EXPOSE 443

CMD [ "nginx", "-g", "daemon off;" ]
