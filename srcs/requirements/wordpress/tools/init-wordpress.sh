#!/bin/bash

# Download and set up WordPress if not already installed
if [ ! -f /var/www/html/wp-config.php ]; then
  echo "Downloading WordPress..."
  wget -q https://wordpress.org/latest.tar.gz -O /tmp/latest.tar.gz
  tar -xzf /tmp/latest.tar.gz -C /var/www/html --strip-components=1
  rm /tmp/latest.tar.gz

  echo "Configuring WordPress..."
  cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

  # Ensure the environment variables are available and print them for debugging
  echo "WORDPRESS_DB_NAME: $WORDPRESS_DB_NAME"
  echo "WORDPRESS_DB_USER: $WORDPRESS_DB_USER"
  echo "WORDPRESS_DB_PASSWORD: $WORDPRESS_DB_PASSWORD"
  echo "WORDPRESS_DB_HOST: $WORDPRESS_DB_HOST"

  # Configure wp-config.php with environment variables
  sed -i "s/database_name_here/${WORDPRESS_DB_NAME}/" /var/www/html/wp-config.php
  sed -i "s/username_here/${WORDPRESS_DB_USER}/" /var/www/html/wp-config.php
  sed -i "s/password_here/${WORDPRESS_DB_PASSWORD}/" /var/www/html/wp-config.php
  sed -i "s/localhost/${WORDPRESS_DB_HOST}/" /var/www/html/wp-config.php
fi

# Clean up sed temp files (if any are left over)
find /var/www/html -type f -name "sed*" -exec rm -f {} \;

# Ensure proper permissions
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# Start PHP-FPM
exec "$@"