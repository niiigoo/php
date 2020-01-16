ARG PHP_TAG=latest

FROM php:$PHP_TAG

ARG LOCALE=en_US
ARG ENV=production

# install dependencies
RUN apt update && apt upgrade -y && apt install -y locales libicu-dev unzip && \
	docker-php-ext-configure intl && \
	docker-php-ext-install intl && \
	docker-php-ext-install mysqli && \
	docker-php-ext-install pdo_mysql && \
# generate locale
	sed -i 's/^# *\($LOCALE.UTF-8\)/\1/' /etc/locale.gen && \
	locale-gen && \
	mv "$PHP_INI_DIR/php.ini-$ENV" "$PHP_INI_DIR/php.ini" && \
# clean up
	apt purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false $BUILD_LIBS && \
	apt -y autoremove && \
    apt clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/* && \
# enable debug options
	if [ $ENV = "development" ] ; then \
		pecl install xdebug; \
		docker-php-ext-enable xdebug; \
		echo "error_reporting = E_ALL" >> $PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini; \
		echo "display_startup_errors = On" >> $PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini; \
		echo "display_errors = On" >> $PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini; \
		echo "xdebug.remote_enable=1" >> $PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini; \
	fi ;
