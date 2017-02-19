#!/bin/bash
# stop on errors
set -e

# we might run into trouble when using the default `mysql` user, e.g. when dropping the mysql
# database in restore.sh. Check that something else is used here
if [ "$MYSQL_USER" == "root" ]
then
    echo "creating a backup as the MySQL user is not supported, make sure to set the MYSQL_USER environment variable"
    exit 1
fi

echo "creating backup"
echo "---------------"

FILENAME=backup_$(date +'%Y_%m_%dT%H_%M_%S').sql.gz /
mysqldump --user=$MYSQL_USER --password=$MYSQL_PASSWORD --all-databases | gzip > /backups/$FILENAME

echo "successfully created backup $FILENAME"
