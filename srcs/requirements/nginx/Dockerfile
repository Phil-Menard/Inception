# Dockerfile Nginx
FROM debian:11-slim

ENV DEBIAN_FRONTEND=noninteractive

# Installer nginx et openssl
RUN apt-get update && \
    apt-get install -y nginx openssl && \
    rm -rf /var/lib/apt/lists/*

# Créer le dossier pour les certificats
RUN mkdir -p /etc/nginx/ssl

# Générer un certificat auto-signé
RUN openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=FR/ST=France/L=Paris/O=42/OU=Inception/CN=pmenard.42.fr" && \
    chmod 600 /etc/nginx/ssl/nginx.key /etc/nginx/ssl/nginx.crt

# Copier la configuration Nginx
COPY ./conf/default.conf /etc/nginx/conf.d/default.conf

# Exposer le port HTTPS
EXPOSE 443

# Lancer Nginx au premier plan
CMD ["nginx", "-g", "daemon off;"]
