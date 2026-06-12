FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    apache2 php php-mysqli php-gd libapache2-mod-php \
    mariadb-server mariadb-client \
    && rm -rf /var/lib/apt/lists/*

COPY . /var/www/html/DVWA/
RUN chown -R www-data:www-data /var/www/html/DVWA

RUN sed -i 's/allow_url_fopen = Off/allow_url_fopen = On/' /etc/php/*/apache2/php.ini \
    && sed -i 's/allow_url_include = Off/allow_url_include = On/' /etc/php/*/apache2/php.ini

RUN sed -i 's|/var/www/html|/var/www/html/DVWA|g' /etc/apache2/sites-available/000-default.conf \
    && sed -i 's|/var/www/html|/var/www/html/DVWA|g' /etc/apache2/sites-available/default-ssl.conf

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE $PORT

CMD ["/start.sh"]
