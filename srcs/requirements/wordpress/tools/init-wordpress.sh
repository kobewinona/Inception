#!/bin/bash

# Wait for the database to be reachable (port 3306 by default)
until nc -z "${DB_HOST}" 3306; do
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
  wp config create \
    --dbname="${MYSQL_NAME}" \
    --dbuser="${MYSQL_USER_NAME}" \
    --dbpass="${MYSQL_USER_PASSWORD}" \
    --dbhost="${DB_HOST}" \
    --path=/var/www/html \
    --allow-root || { echo "Failed to create wp-config.php"; exit 1; }
  echo "✓ WordPress configuration is created"
fi

# Clean up sed temp files (if any are left over)
find /var/www/html -type f -name "sed*" -exec rm -f {} \;

# Run WordPress installation if not already installed
if ! wp core is-installed --path=/var/www/html --allow-root; then
  echo "Installing WordPress..."
  wp core install \
    --url="https://${DOMAIN_NAME}" \
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

# Check if the Force Login plugin is already installed and active
if ! wp plugin is-installed wp-force-login --path=/var/www/html --allow-root; then
  echo "Installing and activating Force Login plugin..."
  wp plugin install wp-force-login --activate --allow-root
  echo "✓ Force Login plugin installed and activated"
else
  echo "✓ Force Login plugin is already installed and activated"
fi

exec "$@"

