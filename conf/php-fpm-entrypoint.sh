#!/bin/sh

set -e

# ### RUN STACK CONFIG ###
if [ -f "/startup.sh" ]
then
	/startup.sh
fi


# docker-php-entrypoint "$@"
exec "$@"
