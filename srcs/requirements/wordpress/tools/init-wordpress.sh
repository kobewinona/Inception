#!/bin/bash

# Wait for the database to be ready
until wp db check --path=/var/www/html --allow-root; do
    echo "Waiting for database connection..."
    sleep 3
done

# Download and set up WordPress if not already installed
if [ ! -f /var/www/html/wp-config.php ]; then
  echo "Downloading WordPress..."
  wget -q https://wordpress.org/latest.tar.gz -O /tmp/latest.tar.gz
  tar -xzf /tmp/latest.tar.gz -C /var/www/html --strip-components=1
  rm /tmp/latest.tar.gz
  echo "✓ WordPress is downloaded"

  echo "Configuring WordPress..."
  # Configure wp-config.php with environment variables
  sed -i "s/database_name_here/${MYSQL_NAME}/" /var/www/html/wp-config.php
  sed -i "s/username_here/${MYSQL_USER_NAME}/" /var/www/html/wp-config.php
  sed -i "s/password_here/${MYSQL_USER_PASSWORD}/" /var/www/html/wp-config.php
  sed -i "s/localhost/${DB_HOST}/" /var/www/html/wp-config.php
  echo "✓ Wordpress is configures"
fi

# Clean up sed temp files (if any are left over)
find /var/www/html -type f -name "sed*" -exec rm -f {} \;

# Set ownership for WordPress files
echo "Setting ownership of WordPress files..."
# chown -R www-data /var/www/html
# chmod -R 775 /var/www/html
# echo "✓ Ownership of WordPress files is set"

# Run WordPress installation if not already installed
if ! wp core is-installed --path=/var/www/html --allow-root; then
    echo "Installing WordPress..."
    wp core install \
        --url="https://${DOMAIN_NAME}:8443" \
        --title="My WordPress Site" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --path=/var/www/html \
        --allow-root || echo "✓ WordPress installation is complete"
else
    echo "✓ Wordpress is already installed"
fi

# Create the 'editor' user if it doesn't exist
if ! wp user get "${WP_EDITOR_USER}" --path=/var/www/html --allow-root > /dev/null 2>&1; then
    echo "Creating ${WP_EDITOR_USER} user..."
    wp user create "${WP_EDITOR_USER}" "${WP_EDITOR_EMAIL}" --role=editor --user_pass="${WP_EDITOR_PASSWORD}" --path=/var/www/html --allow-root
    echo "✓ ${WP_EDITOR_USER} user is created"
else
    echo "✓ ${WP_EDITOR_USER} already exists, skipping creation"
fi

exec "$@"

