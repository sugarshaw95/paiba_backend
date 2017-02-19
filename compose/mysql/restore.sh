#!/bin/bash

# stop on errors
set -e

# we might run into trouble when using the default `mysql` user, e.g. when dropping the mysql
# database in restore.sh. Check that something else is used here
if [ "$MYSQL_USER" == "root" ]
then
    echo "restoring as the MySQL user is not supported, make sure to set the MYSQL_USER environment variable"
    exit 1
fi

# check that we have an argument for a filename candidate
if [[ $# -eq 0 ]] ; then
    echo 'usage:'
    echo '    docker-compose run MySQL restore <backup-file>'
    echo ''
    echo 'to get a list of available backups, run:'
    echo '    docker-compose run MySQL list-backups'
    exit 1
fi

# set the backupfile variable
BACKUPFILE=/backups/$1

# check that the file exists
if ! [ -f $BACKUPFILE ]; then
    echo "backup file not found"
    echo 'to get a list of available backups, run:'
    echo '    docker-compose run MySQL list-backups'
    exit 1
fi

echo "beginning restore from $1"
echo "-------------------------"

# restore the database
echo "restoring database $MYSQL_USER"
gunzip -c $BACKUPFILE | mysql --user=$MYSQL_USER --password=$MYSQL_PASSWORD $MYSQL_USER
