# Use the official PHP Apache image as the base
FROM php:8.4-apache

# Install system dependencies and PHP extensions in a single RUN layer to reduce image size
RUN apt-get update && apt-get install -y \
    # Needed for intl extension
    libicu-dev \
    # Needed for mbstring (usually already included but explicit is good)
    libonig-dev \
    # Needed for SSL functionality in various extensions
    libssl-dev \
    # Needed for PostgreSQL extensions (pdo_pgsql, pgsql)
    libpq-dev \
    # Needed for SQLite3 extensions (pdo_sqlite, sqlite3) - ADD THIS LINE
    libsqlite3-dev \
    # Needed for GD (PNG, JPEG, WebP, FreeType)
    libjpeg62-turbo-dev \
    libpng-dev \
    libwebp-dev \
    libfreetype6-dev \
    # Needed for git, Composer, and other common dev tools
    git \
    unzip \
    # Clean up the apt cache to reduce image size
    && rm -rf /var/lib/apt/lists/*

# Install and configure PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
 && docker-php-ext-install -j$(nproc) \
    intl \
    mbstring \
    mysqli \
    pdo_mysql \
    pdo_pgsql \
    pdo_sqlite \
    gd \
 && docker-php-ext-enable \
    intl \
    mbstring \
    mysqli \
    pdo_mysql \
    pdo_pgsql \
    pdo_sqlite \
    gd

# Install Xdebug from PECL
RUN pecl install xdebug && docker-php-ext-enable xdebug

# (Optional but recommended) Copy your custom php.ini into the image
# This ensures the base xdebug settings are always present, even without a volume.
#COPY php/php.ini /usr/local/etc/php/php.ini

RUN a2enmod rewrite

# (Optional) Set a custom document root if needed (e.g., /var/www/html/public)
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
