FROM nginx:alpine

LABEL org.opencontainers.image.authors="Alexandre Jardin <info@ajardin.fr>"
LABEL org.opencontainers.image.title="Nginx image with HTTPS support."
LABEL org.opencontainers.image.description="https://www.nginx.com/"
LABEL org.opencontainers.image.source="https://github.com/origamiphp/docker-images/tree/main/common/nginx"

# Install Nginx requirements
RUN \
    apk update && \
    apk add --no-cache bash openssl shadow && \
    mkdir -p /etc/nginx/ssl

# Assign a new UID/GID to avoid using a generated value
RUN \
    usermod -u 1000 nginx && \
    groupmod -g 1000 nginx

EXPOSE 443
WORKDIR /var/www/html/

# Install custom entrypoint
COPY entrypoint.sh /usr/local/bin/docker-custom-entrypoint
RUN chmod 777 /usr/local/bin/docker-custom-entrypoint
CMD ["nginx", "-g", "daemon off;"]
ENTRYPOINT ["docker-custom-entrypoint"]
