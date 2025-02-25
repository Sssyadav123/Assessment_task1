#!/bin/bash -ex
amazon-linux-extras install nginx1 -y
echo "<h1>Deployed via Terraform</h1>" > /usr/share/nginx/html/index.html
systemctl enable nginx
systemctl start nginx