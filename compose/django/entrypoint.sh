#!/bin/bash
set -e
cmd="$@"

# This entrypoint is used to play nicely with the current cookiecutter configuration.
# Since docker-compose relies heavily on environment variables itself for configuration, we'd have to define multiple
# environment variables just to support cookiecutter out of the box. That makes no sense, so this little entrypoint
# does all this for us.
export REDIS_URL=redis://redis:6379

# the official MySql image uses 'root' as default user if not set explictly.
if [ -z "$MYSQL_USER" ]; then
    export MYSQL_USER=root
fi

export DATABASE_URL=mysql://$MYSQL_USER:$MYSQL_PASSWORD@localhost:/$MYSQL_USER

export CELERY_BROKER_URL=$REDIS_URL/0


function mysql_ready(){
python << END
import sys
import MySQLdb
try:
    conn = MySQLdb.connect(db="$MYSQL_USER", user="$MYSQL_USER", passwd="$MYSQL_PASSWORD", host="localhost")
except MySQLdb.OperationalError:
    sys.exit(-1)
sys.exit(0)
END
}

until mysql_ready; do
  >&2 echo "MySQL is unavailable - sleeping"
  sleep 1
done

>&2 echo "MySQL is up - continuing..."
exec $cmd
