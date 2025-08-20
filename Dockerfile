# Use PHP + Apache as base image
FROM php:8.3-apache

# Install required PHP extensions + unzip, git, composer deps
RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev libzip-dev unzip git curl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql mysqli opcache zip

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Enable Apache rewrite
RUN a2enmod rewrite

# Copy Drupal source code
COPY . /var/www/html/

# Set working directory
WORKDIR /var/www/html

# Run composer install inside container to generate vendor/ folder
RUN composer install --no-interaction --optimize-autoloader

# Fix permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

EXPOSE 80

