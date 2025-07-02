
#!/bin/sh

if [ ! -f "$PROTECT_FILE" ]
then
	#setup launch of mysql
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld

	#launch mysql in back ground 
	mysqld &
	while !(mysqladmin ping > /dev/null)
	do
		echo "Waiting for database to be ready..." 
	    sleep 5
	done
	echo "Database is ready"


	# setup database in mysql
	#mysql -uroot --skip-password -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
	mysql -uroot --skip-password -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT';"
	mysql -uroot -p$DB_ROOT -e "CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASS';"
	mysql -uroot -p$DB_ROOT -e "GRANT ALL PRIVILEGES ON *.* TO '$DB_USER'@'%' IDENTIFIED BY '$DB_PASS';"
	mysql -uroot -p$DB_ROOT -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"
	mysql -uroot -p$DB_ROOT -e "FLUSH PRIVILEGES;"

	mysqladmin -uroot -p$DB_ROOT shutdown
	touch "$PROTECT_FILE"
else
	echo "Database already created"
fi

exec mysqld 
