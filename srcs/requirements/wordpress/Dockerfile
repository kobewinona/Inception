FROM debian:buster

RUN apt-get update && apt-get install -y php php-cgi php-mysql php-fpm php-pdo php-gd php-cli php-mbstring wget curl

# Download and setup WordPress during build
RUN mkdir -p /run/php /var/www/html && \
    curl -O https://wordpress.org/latest.tar.gz && \
    tar -xzvf latest.tar.gz -C /var/www/html --strip-components=1 && \
    rm latest.tar.gz && \
    chown -R www-data:www-data /var/www/html

COPY ./conf/www.conf /etc/php/7.3/fpm/pool.d/www.conf
COPY ./tools/init-wordpress.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/init-wordpress.sh

WORKDIR /var/www/html

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/init-wordpress.sh"]

CMD ["php-fpm7.3", "-F"]