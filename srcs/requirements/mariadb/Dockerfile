FROM debian:buster

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y mariadb-server
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/
COPY ./tools /var/www/

EXPOSE 3306

RUN service mysql start && mysql < /var/www/createdb.sql && rm -f /var/www/createdb.sql

CMD ["mysqld_safe"]