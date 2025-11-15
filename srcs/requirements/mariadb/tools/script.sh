#!/bin/bash

# Lancer MariaDB en arrière-plan (mode maintenance)
mysqld_safe --skip-networking &
sleep 5

# Attente que MariaDB soit prêt
MAX_TRIES=20
COUNT=0

until mysqladmin ping &>/dev/null; do
    COUNT=$((COUNT+1))
    if [ $COUNT -ge $MAX_TRIES ]; then
        echo "❌ MariaDB ne démarre pas. Abort."
        exit 1
    fi
    sleep 1
done

echo "✅ MariaDB est prêt."

# Exécuter l'initialisation
mysql -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"
mysql -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';"
mysql -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%';"
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"
mysql -e "FLUSH PRIVILEGES;"

echo "✅ Initialisation terminée."

# Arrêter le serveur temporaire
mysqladmin -u root -p"${SQL_ROOT_PASSWORD}" shutdown

echo "▶️ Lancement de MariaDB final..."

# Lancer MariaDB en foreground (obligatoire)
exec mysqld_safe
