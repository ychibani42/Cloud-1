FROM    debian:buster

ARG     DB_NAME \
        DB_USER \
        DB_PASS

RUN     apt-get update; \
        apt-get install mariadb-server -y \
                        mariadb-client -y;

COPY	./mariadb.conf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY 	./script.sh .

CMD     ["sh", "/script.sh"]
