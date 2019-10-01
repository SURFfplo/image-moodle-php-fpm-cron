FROM php:7.1-fpm-alpine
LABEL Description="image for moodle cronjobs"
LABEL image="moodle-php-fpm-cron"
LABEL versie="0.1"
LABEL datum="2019 10 01"

ARG DOCUMENT_ROOT=/var/www/html

ENV WEB_DOCUMENT_ROOT=$DOCUMENT_ROOT

RUN apk update && apk add --no-cache inetutils-syslogd supervisor

# Use cron
COPY conf/cron_moodle_entry /etc/cron.d/moodle
COPY conf/supervisor.conf /etc/supervisor/conf.d/supervisor_cron.conf

RUN sed -i "s@DOCROOT@${WEB_DOCUMENT_ROOT}@" /etc/cron.d/moodle && \
    chmod 0644 /etc/cron.d/moodle && \
    touch /var/log/cron.log && \
    touch /etc/crontab /etc/cron.*/* && \
    sed -i "s@^#cron.@cron.@" /etc/syslog.conf

# Config
COPY conf/php-fpm-entrypoint.sh /usr/local/bin/php-fpm-entrypoint

ENTRYPOINT ["php-fpm-entrypoint"]

CMD /usr/bin/supervisord
