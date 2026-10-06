#!/bin/sh
set -e

# Create required Laravel directories if they do not exist
mkdir -p /var/www/html/storage/framework/cache/data
mkdir -p /var/www/html/storage/framework/sessions
mkdir -p /var/www/html/storage/framework/views
mkdir -p /var/www/html/storage/logs
mkdir -p /var/www/html/bootstrap/cache

# Adjust storage and bootstrap cache permissions
chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache 2>/dev/null || true
chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache 2>/dev/null || true

# Remove stale host cached packages and config files if mounted
rm -f /var/www/html/bootstrap/cache/config.php 2>/dev/null || true

# If SQLite is configured or no DB_CONNECTION is set, prepare the sqlite file
if [ "$DB_CONNECTION" = "sqlite" ] || [ -z "$DB_CONNECTION" ]; then
    mkdir -p /var/www/html/database
    if [ ! -f /var/www/html/database/database.sqlite ]; then
        touch /var/www/html/database/database.sqlite
    fi
    chown -R www-data:www-data /var/www/html/database 2>/dev/null || true
    chmod -R 775 /var/www/html/database 2>/dev/null || true
    chmod 664 /var/www/html/database/database.sqlite 2>/dev/null || true
fi

# Generate APP_KEY if missing in .env
if [ -f /var/www/html/.env ]; then
    if ! grep -q "^APP_KEY=base64:" /var/www/html/.env; then
        echo "Generating Application Key..."
        php artisan key:generate --no-interaction --force
    fi
fi

exec "$@"

