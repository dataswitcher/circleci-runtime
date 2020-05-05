# start from circleci base image
FROM circleci/php:7.2-apache-browsers

# run stuff as root
USER root

# install bash
RUN apt-get update && apt-get install bash vim

# remove xdebug (disabled it fully)
RUN rm /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# install coverage tool
RUN pecl install pcov && docker-php-ext-enable pcov

# enable it
RUN echo 'pcov.enabled = 1' >> /usr/local/etc/php/conf.d/docker-php-ext-pcov.ini

# install mongodb
RUN pecl install mongodb && docker-php-ext-enable mongodb

# needed for zip below
RUN apt-get install bzip2 libbz2-dev libxml2-dev libpng-dev

# enable other modules
RUN docker-php-ext-install pdo pcntl bcmath bz2 calendar iconv intl mbstring mysqli opcache pdo_mysql soap zip sockets gd

# in CircleCI:
# - [ ] rm /var/www/html && ln -s /var/app/web /var/www/html
# - [ ] Enable htaccess module - a2enmod rewrite
# - [ ] Enable headers module - a2enmod headers
# - [ ] Replace file /etc/apache2/sites-enabled/000-default.conf with… (below - see repo)
# - [ ] sudo service apache2 restart
# - [ ] In CircleCI you need to run this command too:
#    - [ ]   - run: echo 127.0.0.1 dataswitcher.test | sudo tee -a /etc/hosts
#    - [ ] That locks the host into the docker runtime so you can just use dataswitcher.test in your tests

# go and keep alive
CMD ["php", "-a"]
