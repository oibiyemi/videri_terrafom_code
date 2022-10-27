#!/bin/bash
sudo su
yum update -y
amazon-linux-extras install nginx1 -y 
systemctl enable nginx
systemctl start nginx
ufw allow 'Nginx HTTP'
#mkdir -p /usr/share/nginx/html/index.html
chown -R $USER:$USER /usr/share/nginx/html/index.html
chmod -R 755 /usr/share/nginx/html
"${EDITOR: -vi}" index.html
echo '<h1>Shola</h1>' | sudo tee /usr/share/nginx/html/index.html
#install Postgresql
yum update -y
amazon-linux-extras install postgresql vim epel -y
yum install -y postgresql-server postgresql-devel
/usr/bin/postgresql-setup --initdb
systemctl enable postgresql
systemctl start postgresql
systemctl restart postgresql