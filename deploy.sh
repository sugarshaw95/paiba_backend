current_dir=$(pwd)
script_dir=$(dirname $0)

if [ $script_dir = '.' ]
then
  script_dir="$current_dir"
fi

NOW=$(date +"%m-%d-%Y-%H-%M")

echo configure nginx
sudo cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.old
sudo cp ./nginx.conf /etc/nginx/nginx.conf
sudo sed -i "s/PATH/$script_dir/g" /etc/nginx/nginx.conf
sudo cat /etc/nginx/nginx.conf

echo generate DH Parameters
sudo mkdir -p /etc/nginx/cert/
sudo openssl dhparam 2048 -out /etc/nginx/cert/dhparam.pem
sudo certbot certonly --agree-tos --webroot -w $script_dir -d 123.207.126.160

echo configure gunicorn
sudo cp ./gumicorn-paiba.service /etc/systemd/system/gumicorn-paiba.service
sudo sed -i "s/PATH/$script_dir/g" /etc/systemd/system/gumicorn-paiba.service

sudo systemctl start gumicorn-paiba
sudo systemctl enable gumicorn-paiba
sudo nginx -t
sudo systemctl restart nginx
