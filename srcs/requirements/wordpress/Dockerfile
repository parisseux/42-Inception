FROM alpine:3.20


RUN apk update && apk add --no-cache \
#PHP itself
    php83 \ 
#process manager
    php83-fpm \
# allow to connect to MariaDB
    php83-mysqli \
#pour wp-cli
    php83-phar \
#text encoding
    php83-iconv \
# pour telécharger wp-cli
    mariadb-client \
    wget

RUN echo "memory_limit=256M" >> /etc/php83/php.ini

# sans ça Nginx pouvait pas reach PHP-FPM (502 error)
RUN sed -i 's/listen = 127.0.0.1:9000/listen = 9000/' /etc/php83/php-fpm.d/www.conf


COPY tools/setup.sh /setup.sh
RUN chmod +x /setup.sh

#PHP-FPM listen on port 9000 and its where Nginx will send PHP request to
EXPOSE 9000

CMD ["sh", "/setup.sh"]