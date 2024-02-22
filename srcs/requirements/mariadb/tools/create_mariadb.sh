#checks if run/mysqld exists, if not makes it and changes ownership to mysql user and group
if [ ! -d "/run/mysqld" ]; then
    mkdir -p /run/mysqld
    chown -R mysql:mysql /run/mysqld
fi

#checks if mariadb database directory  exists in the local host if not then it creates it
#and initializes it using mysql command line commands
if [ ! -d /var/lib/mysql/$MDB_NAME ]; then
    chown -R mysql:mysql /var/lib/mysql
    mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --user=mysql --rpm > /dev/null

#creates a tmp file to store SQL commands for bootstrap install of mariadb
#sets up database and users and passwords specified by .env
tfile=$(mktemp)
if [ ! -f "$tfile" ]; then
    return 1
fi
cat << EOF > $tfile
USE mysql;
FLUSH PRIVILEGES;
DELETE FROM	mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MDB_ROOT_PASSWORD';
CREATE DATABASE $MDB_NAME CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER '$MDB_USER'@'%' IDENTIFIED by '$MDB_USER_PASSWORD';
GRANT ALL PRIVILEGES ON $MDB_NAME.* TO '$MDB_USER'@'%';
FLUSH PRIVILEGES;
EOF

#initializes MariaDB in bootstrap mode that uses a database user to login into the database
#and also allows admin related commands
/usr/sbin/mysqld --user=mysql --bootstrap < $tfile
rm -f $tfile

#updates mariadb config file to allow remote connections through 0.0.0.0 
sed -i "s|.*bind-address\s*=.*|bind-address=0.0.0.0|g" /etc/mysql/mariadb.conf.d/50-server.cnf

#starts the mariadbd server in console mode using mysql as user
exec /usr/sbin/mysqld --user=mysql --console
