FROM php:8.0.2-apache

# Install System Dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \    
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    iputils-ping \
    vim

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer

# Set the Working directory
WORKDIR /var/www/html

# Copy the laravel project files into the working directory
COPY . /var/www/html/
COPY .env /var/www/html/
COPY composer.json /var/www/html/

# Remove dockerfiles Directory from the container
RUN rm -r /var/www/html/dockerfiles

RUN chmod +x /var/www/html/bootstrap/app.php

# Install Project Dependencies and generate autoload fiels
RUN composer install --optimize-autoloader --no-dev

# Set the ownership and permissions of the storage and bootstrap/cashe directories
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
RUN chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Enable Apache rewrite Module
RUN a2enmod rewrite 

# Set the Document Root
ENV APACHE_DOCUMENT_ROOT /var/www/html/public/
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!s${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Allow Permession on the apache2.conf file
RUN sed -ri 's/AllowOverride none/AllowOverride all/g' /etc/apache2/apache2.conf
RUN sed -ri 's/Require all denied/Require all granted/g' /etc/apache2/apache2.conf

CMD ["apache2-foreground"]



