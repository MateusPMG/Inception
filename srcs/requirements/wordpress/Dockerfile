# Use Debian Bullseye as base image
FROM debian:bullseye

# Install PHP 7.4 and necessary extensions
RUN apt-get update && apt-get install -y \
    php7.4 \
    php7.4-fpm \
    php7.4-mysql \
    php7.4-gd \
    php7.4-curl \
    php7.4-xml \
    php7.4-mbstring \
    && rm -rf /var/lib/apt/lists/*

# Install wordpress cli in the local host, the script will then set it up
RUN apt-get update && apt-get install -y curl \
    && curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp \
# Clean up after installation, removes package lists from apt-get
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /run/php/ && chmod 755 /run/php

# copy configurations
COPY ./tools/create_wordpress.sh /tmp/create_wordpress.sh

#make php7.4 listen to the socket 9000 
RUN sed -i 's+listen = /run/php/php7.4-fpm.sock+listen = 9000+g' /etc/php/7.4/fpm/pool.d/www.conf

# give exec permission
RUN chmod +x /tmp/create_wordpress.sh


# Expose port 9000 for PHP-FPM
EXPOSE 9000

# Set working directory
WORKDIR /var/www/html


#Configuration must run when container starts
ENTRYPOINT ["/tmp/create_wordpress.sh"]