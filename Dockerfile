# HTTPD 2.4
ARG VERSION=2.4
FROM httpd:$VERSION-alpine

LABEL authors="Florentin Munsch <flo.m68@gmailc.om>"
LABEL company="KMSF"
LABEL website="www.munschflorentin.fr"
LABEL version="1.0"

ENV PORT=80

# Apache modules
RUN apk update && apk add apache-mod-fcgid

# Create directories and update permissions
RUN mkdir -p /var/www \
    && chown -R www-data:www-data /var/www

VOLUME /usr/local/apache2/conf/httpd.conf
VOLUME /usr/local/apache2/conf/extra/httpd-vhosts.conf
VOLUME /var/www
VOLUME /var/log/apache2

WORKDIR /var/www

EXPOSE $PORT

USER www-data:www-data

# Start Apache
CMD ["httpd-foreground"]