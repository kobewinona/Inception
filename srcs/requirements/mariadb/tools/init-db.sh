#!/bin/bash

# Replace placeholders in the SQL file with environment variables
envsubst < /var/www/createdb.sql > /var/www/createdb-final.sql

# Start MySQL in safe mode in the background, but don't skip networking
mysqld_safe &

# Wait until MySQL is ready to accept connections
until mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "status"; do
    echo "Waiting for MariaDB to start..."
    sleep 2
done

# Check if the database already exists, and create it if not
DB_EXISTS=$(mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "SHOW DATABASES LIKE '${MYSQL_DATABASE}';" | grep "${MYSQL_DATABASE}")

if [ -z "$DB_EXISTS" ]; then
    # Run the generated SQL file if the database doesn't exist
    mysql -u root -p"${MYSQL_ROOT_PASSWORD}" < /var/www/createdb-final.sql
    echo "Database ${MYSQL_DATABASE} and user ${MYSQL_USER} created."
else
    echo "Database ${MYSQL_DATABASE} already exists. Skipping creation."
fi

# Clean up the SQL file
rm -f /var/www/createdb-final.sql

# Stop the background mysqld_safe (we'll restart it in the foreground)
mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown

# Finally, start mysqld_safe in the foreground to keep the container running
exec mysqld_safe --bind-address=0.0.0.0