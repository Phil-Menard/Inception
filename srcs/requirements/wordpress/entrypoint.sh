#!/bin/bash
# Entrypoint WordPress

# Attendre que MariaDB soit prêt
until mysql -h "$WORDPRESS_DB_HOST" -u"$WORDPRESS_DB_USER" -p"$WORDPRESS_DB_PASSWORD" "$WORDPRESS_DB_NAME" >/dev/null 2>&1; do
  echo "Waiting for database..."
  sleep 2
done

cd /var/www/html

# Si WordPress n'est pas encore configuré
if [ ! -f wp-config.php ]; then
    echo "⚙️ Generating wp-config.php..."
    wp config create \
        --dbname="$WORDPRESS_DB_NAME" \
        --dbuser="$WORDPRESS_DB_USER" \
        --dbpass="$WORDPRESS_DB_PASSWORD" \
        --dbhost="$WORDPRESS_DB_HOST" \
        --path=/var/www/html \
        --allow-root

    echo "🧱 Installing WordPress..."
    wp core install \
        --url="https://${DOMAIN_NAME}" \
        --title="Inception - $DOMAIN_NAME" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASS" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --skip-email \
        --path=/var/www/html \
        --allow-root

    echo "👤 Creating regular user..."
    wp user create "$WORDPRESS_USER" "$WORDPRESS_USER_EMAIL" \
        --user_pass="$WORDPRESS_USER_PASSWORD" \
        --role=author \
        --allow-root
else
    echo "✅ WordPress already configured."
fi

# Lancer PHP-FPM en premier plan
php-fpm7.4 -F
