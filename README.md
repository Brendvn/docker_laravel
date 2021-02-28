# Docker for laravel and Mariadb

<div align="center">

  <img width="250px" src="https://uploads.sitepoint.com/wp-content/uploads/2015/04/1429543497dockerimg.png">

</div>

<br>

<div align="center">
    <a href="https://www.php.net"><img src="https://img.shields.io/badge/language-php-8892BF.svg?style=flat-square" alt="PHP"></a>
    <a href="https://laravel.com"><img src="https://img.shields.io/badge/framework-laravel-f46460.svg?style=flat-square" alt="Laravel"></a>
    <a href="https://laravel.com"><img src="https://img.shields.io/badge/docker-version-v3.8-blue?style=flat-square" alt="Docker"></a>
    <a href="https://www.conventionalcommits.org/"><img src="https://img.shields.io/badge/changelog-conventional-FA6477.svg?style=flat-square" alt="Conventional Changelog"></a>
    <a href="https://github.com/conventional-changelog/standard-version"><img src="https://img.shields.io/badge/release-standard%20version-brightgreen.svg?style=flat-square" alt="Standard Version Release"></a>
    <a href="https://getcomposer.org/doc/04-schema.md#license"><img src="https://img.shields.io/badge/license-proprietary-red.svg?style=flat-square" alt="License"></a>
</div>


# Docker-compose Setup

## Nginx

Config file is in /nginx/nginx.conf
php_container references container name in docker-compose.yaml
fastcgi_pass php_container:3000; php docker file listens to port 9000 in github changed to 9000
https://github.com/docker-library/php/blob/1ad18817e5de82df1a8855fe711de0b3c0c320b9/7.4/alpine3.12/fpm/Dockerfile

ro is for read only nginx can write to the file

## Php

Container name php_container
Created a custom file for php setup..
In dockerfiles/php.dockerfile
docker-php-ext-install php install tool help to install additional php features

delegated option to volumes
Is for performance
when local source writes to src folder it should reflect instantly
when container writes it can take its time

## MYSQL

Environment variable created in env/mysql.env
Used in docker-compose file for setup

## Composer

Created a utility container
in dockerfile/composer.dockerfile
--ignore-platform-reqs this wont output errors or warnings

### Running composer utility container
docker-compose run --rm composer create-project laravel/laravel .

NB composer is the container
we dont use composer create-project
since composer is used as an entrypoint

### Running the compose file

docker-compose up -d --build server

We only run the server container due to the depends_on option
which tells compose to start the php and mysql container

The --build force docker to re-evaluate the dockerfiles 
and build them every time