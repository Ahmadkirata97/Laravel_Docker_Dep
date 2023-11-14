FROM php:8.0.2-fpm

# Set the Working Directory
WORKDIR /var/www/

#  Install System Dependencies
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


# Install Php Extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install Composer Globally 
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy the application code into the container
COPY . .

# Set permessions for laravel directories
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache/
RUN chmod -R 755 /var/www/bootstrap/cache /var/www/storage 

# ENV variables
ENV DB_PASSWORD password

# Edit the .env file 
RUN sed -ri -e 's!/DB_PASSWORD=!${DB_PASSWORD}!g' /var/www/.env


# Expose the container Port 
EXPOSE 9000

CMD [ "php-fpm" ]

#ENTRYPOINT [ "nginx/composer.sh" ]