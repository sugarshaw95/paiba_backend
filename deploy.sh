current_dir=$(pwd)
script_dir=$(dirname $0)

if [ $script_dir = '.' ]
then
  script_dir="$current_dir"
fi

NOW=$(date +"%m-%d-%Y-%H-%M")

echo configure nginx
sudo cp ./nginx.conf /etc/nginx/nginx.conf
sudo sed "s/PATH/${script_dir}/g" /etc/nginx/nginx.conf > /etc/nginx/nginx.conf
sudo cat /etc/nginx/nginx.conf

echo generate DH Parameters
sudo mkdir -p /etc/nginx/cert/
sudo openssl dhparam 2048 -out /etc/nginx/cert/dhparam.pem
sudo certbot certonly --agree-tos --webroot -w $script_dir -d 123.207.126.160

echo configure gunicorn
sudo cp ./gunicorn-paiba.service /etc/systemd/system/gunicorn-paiba.service
sudo sed "s/PATH/${script_dir}/g" /etc/systemd/system/gunicorn-paiba.service > /etc/nginx/nginx.conf

sudo systemctl start gunicorn-paiba
sudo systemctl enable gunicorn-paiba
sudo nginx -t
sudo systemctl restart nginx
