FROM alpine:3.6
RUN apk -U add ca-certificates nginx git openssl tar \
        php7-fpm php7-json php7-zlib php7-openssl php7-pdo php7-pdo_mysql php7-gd \
        php7-iconv php7-mcrypt php7-curl php7-opcache php7-intl php7-phar php7-xml php7-dom php7-ctype && \
        rm -rf /var/cache/apk/*
ADD https://s3.amazonaws.com/gitlist/gitlist-master.tar.gz /var/www/
ADD config.ini /var/www/gitlist/
RUN cd /var/www; tar -zxvf gitlist-master.tar.gz && \
        chmod -R 777 /var/www/gitlist && \
        cd /var/www/gitlist/; mkdir cache; chmod 777 cache
ADD nginx.conf /etc/
#ADD php7-fpm.conf /etc/php7/
RUN mkdir -p /repos/sentinel && chown -R 1001:0 /repos/sentinel && \
        cd /repos/sentinel; git --bare init . && \
        chmod -R 775 /var/log && \
        chmod -R 775 /var/tmp && \
        chmod -R 775 /var/lib/nginx && \
        chown -R 1001:0 /var/log && \
        chown -R 1001:0 /var/tmp && \
        chown -R 1001:0 /var/lib/nginx

WORKDIR /var/www/gitlist/
USER 1001
#CMD service php75-fpm restart; nginx -c /etc/nginx.conf
EXPOSE 8080
CMD php-fpm7 --fpm-config /etc/php7/php-fpm.conf; nginx -c /etc/nginx.conf


