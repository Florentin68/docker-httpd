# HTTPD 2.4
ARG VERSION=2.4
FROM httpd:$VERSION-alpine

LABEL authors="Florentin Munsch <flo.m68@gmailc.om>"
LABEL company="KMSF"
LABEL website="www.munschflorentin.fr"
LABEL version="1.0"

ENV UID=33 \
    GID=33 \
    TZ=Europe/Paris \
    PORT=80

# Apache modules
RUN apk update && apk add apache-mod-fcgid

# Set timezone
RUN echo $TZ > /etc/timezone && dpkg-reconfigure --frontend $DEBIAN_FRONTEND tzdata

# Enable proxy and fcgi modules
RUN sed -i \
    -e 's/^#\(LoadModule proxy_module modules\/mod_proxy.so\)/\1/' \
    -e 's/^#\(LoadModule proxy_fcgi_module modules\/mod_proxy_fcgi.so\)/\1/' \
    /usr/local/apache2/conf/httpd.conf

# Create user, directories and update permissions
RUN addgroup -g $GID www-data \
    && adduser -D -H -h /var/www -s /sbin/nologin -G www-data -u $UID www-data \
    && mkdir -p /var/www /usr/local/apache2/logs \
    && chown -R app:app /var/www /usr/local/apache2/logs

VOLUME /usr/local/apache2/conf/httpd.conf
VOLUME /var/www

WORKDIR /var/www

EXPOSE $PORT

USER www-data:www-data

# Start Apache
CMD ["httpd-foreground"]