# Dockerfile MariaDB
ARG BASE_IMAGE=debian:11-slim
FROM $BASE_IMAGE

ENV DEBIAN_FRONTEND=noninteractive

# Installer MariaDB
RUN apt-get update && \
    apt-get install -y mariadb-server && \
    rm -rf /var/lib/apt/lists/*

# Créer les dossiers nécessaires et régler les permissions
RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

# Configurer MariaDB pour écouter sur toutes les interfaces
RUN sed -i "s/^bind-address\s*=.*$/bind-address = 0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf

# Copier le script d'initialisation de la base
COPY ./init_db.sh /usr/local/bin/init_db.sh
RUN chmod +x /usr/local/bin/init_db.sh

# Exposer le port 3306
EXPOSE 3306

# Lancer MariaDB

ENTRYPOINT ["/usr/local/bin/init_db.sh"]
