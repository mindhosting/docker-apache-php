FROM ubuntu:18.04
LABEL Maintainer="Sakly Ayoub"
ENV DEBIAN_FRONTEND noninteractive
#
# Install Apache & PHP7.4
RUN apt-get update -yq && apt-get upgrade -yq && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:ondrej/php
RUN apt-get update -yq && \
    apt-get install -y \
    apt-utils \
    curl \
    apache2 \
    libapache2-mod-php7.4 \
    php7.4 \
    php7.4-common \
    php7.4-cli \
    php7.4-json \
    php7.4-curl \
    php7.4-fpm \
    php7.4-gd \
    php7.4-ldap \
    php7.4-mbstring \
    php7.4-mysql \
    php7.4-soap \
    php7.4-sqlite3 \
    php7.4-xml \
    php7.4-zip \
    php7.4-bz2 \
    php7.4-intl \
    php7.4-imap \
    php7.4-tidy \
    php7.4-xmlrpc \
    php-imagick \
    nano \
    graphicsmagick \
    imagemagick \
    ghostscript \
    iputils-ping \
    nodejs \
    npm \
    locales \
    wget \
    git \
    zip \
    mysql-client \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
#
# Generate locales
RUN locale-gen en_US.UTF-8 en_GB.UTF-8 de_DE.UTF-8 es_ES.UTF-8 fr_FR.UTF-8 it_IT.UTF-8 km_KH sv_SE.UTF-8 fi_FI.UTF-8 && \
    a2enmod rewrite expires
#
# Install IonCube Loader
RUN wget https://www.ioncube.com/php-7.4.0-beta-loaders/ioncube_loaders_lin_x86-64_7.4_BETA2.tar.gz && \
    tar xvf ioncube_loaders_lin_x86-64_7.4_BETA2.tar.gz && \
    cp ioncube_loader_lin_7.4_10.4.0_beta2.so /usr/lib/php/20190902 && \
    echo zend_extension = /usr/lib/php/20190902/ioncube_loader_lin_7.4_10.4.0_beta2.so > /etc/php/7.4/cli/php.ini && \
    echo zend_extension = /usr/lib/php/20190902/ioncube_loader_lin_7.4_10.4.0_beta2.so > /etc/php/7.4/apache2/conf.d/00-ioncube.ini
#
# Make php.ini editibale from ENV VARS
RUN echo 'memory_limit = "${PHP_MEMORY_LIMIT}"' >> /etc/php/7.4/apache2/conf.d/php.ini && \
    echo 'upload_max_filesize = "${PHP_MAX_FILESIZE}"' >> /etc/php/7.4/apache2/conf.d/php.ini && \
    echo 'upload_max_filesize = "${PHP_MAX_FILESIZE}"' >> /etc/php/7.4/apache2/conf.d/php.ini && \
    echo 'post_max_size = "${PHP_POST_MAX_SIZE}"' >> /etc/php/7.4/apache2/conf.d/php.ini && \
    echo 'max_input_vars = "${PHP_INPUT_VARS}"' >> /etc/php/7.4/apache2/conf.d/php.ini && \
    echo 'date.timezone = "${TZ}"' >> /etc/php/7.4/apache2/conf.d/php.ini
#
# ADD PhpMyAdmin
RUN wget -O /tmp/phpmyadmin.tar.gz https://files.phpmyadmin.net/phpMyAdmin/4.8.2/phpMyAdmin-4.8.2-all-languages.tar.gz && \
    tar xfvz /tmp/phpmyadmin.tar.gz -C /var/www && \
    mv /var/www/phpMyAdmin-4.8.2-all-languages /var/www/phpmyadmin && \
    echo "<?php" >> /var/www/phpmyadmin/config.inc.php && \
    echo "\$i++;">> /var/www/phpmyadmin/config.inc.php && \
    echo "\$cfg['Servers'][\$i]['auth_type'] = 'cookie';">> /var/www/phpmyadmin/config.inc.php && \
    echo "\$cfg['Servers'][\$i]['host'] = 'db';">> /var/www/phpmyadmin/config.inc.php && \
    echo "\$cfg['Servers'][\$i]['connect_type'] = 'tcp';">> /var/www/phpmyadmin/config.inc.php && \
    echo "\$cfg['Servers'][\$i]['compress'] = false;">> /var/www/phpmyadmin/config.inc.php && \
    echo "\$cfg['Servers'][\$i]['extension'] = 'mysql';">> /var/www/phpmyadmin/config.inc.php && \
    echo "\$cfg['Servers'][\$i]['controluser'] = '';">> /var/www/phpmyadmin/config.inc.php && \
    echo "\$cfg['Servers'][\$i]['controlpass'] = '';">> /var/www/phpmyadmin/config.inc.php && \
    echo "\$cfg['Servers'][\$i]['hide_db'] = 'information_schema';">> /var/www/phpmyadmin/config.inc.php && \
    chmod 544 /var/www/phpmyadmin/config.inc.php
#
# Create defautl site in apache
ADD default.conf /etc/apache2/sites-enabled/000-default.conf
#
# Add Custom Tiny File Manager
RUN git clone https://github.com/mindhosting/filemanager.git /var/www/filemanager && \
    rm -r /var/www/filemanager/.git && \
    chown -R www-data:www-data /var/www/filemanager
#
# Finxing permerssion and printing logs as output
RUN chown -R www-data:www-data /var/www/html && \
    ln -sf /dev/stdout /var/log/apache2/access.log && \
    ln -sf /dev/stderr /var/log/apache2/error.log
#
# Declaring volumes
WORKDIR /var/www/html
RUN rm /var/www/html/index.html
VOLUME /var/www/html
#
# Exposing ports
EXPOSE 80
#
# Declaring entrypoint
COPY entrypoint.sh /usr/local/bin/
ENTRYPOINT ["entrypoint.sh"]
#
# ADD HEATHCHECK TETS
HEALTHCHECK CMD curl --fail http://localhost:80 || exit 1
CMD ["apache2ctl", "-D", "FOREGROUND"]
