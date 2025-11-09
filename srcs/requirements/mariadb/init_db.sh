#!/bin/bash
set -e

echo "🔧 Initialisation de la base de données MariaDB..."

# Démarrer MariaDB en arrière-plan
mysqld_safe --skip-networking=0 &
pid="$!"

# Attendre que le socket soit dispo
until mysqladmin ping --silent; do
    echo "⏳ En attente que MariaDB démarre..."
    sleep 2
done

# Vérifier si la base existe déjà
DB_EXISTS=$(mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "SHOW DATABASES LIKE '${MYSQL_DATABASE}';" | grep "${MYSQL_DATABASE}" || true)

if [ -z "$DB_EXISTS" ]; then
    echo "🗄️ Base '${MYSQL_DATABASE}' absente, création..."
    mysql -u root -p"${MYSQL_ROOT_PASSWORD}" <<-EOSQL
        CREATE DATABASE ${MYSQL_DATABASE} CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
        CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
        GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
        FLUSH PRIVILEGES;
EOSQL
else
    echo "✅ Base '${MYSQL_DATABASE}' déjà existante."
fi

echo "✅ Initialisation terminée, arrêt du processus temporaire..."
mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown

# Relancer MariaDB en avant-plan
exec mysqld_safe
