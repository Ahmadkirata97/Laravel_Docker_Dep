#! /bin/bash

composer install --no-interaction --no-plugins --no-scripts --prefer-dist

php artisan cache:clear
php artisan config:clear
php artisan migrate:rollback
php artisan migrate


