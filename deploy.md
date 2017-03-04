#Prerequisites
  * systemd
  * nginx >= 1.9.5
  * certbot >= 0.9.3
  * Python >= 3.4.0
  	* virtualenv >= 15.1.0
  * MariaDB >= 10.1.21

#Deploy
  Run deploy.sh
  python manage.py collectstatic
  python manage.py makemigration
  python manage.py migrate
