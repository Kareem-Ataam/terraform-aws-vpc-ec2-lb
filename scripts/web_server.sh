#!/bin/bash
WEBSITE_URL="https://codeload.github.com/themewagon/MiniStore/zip/refs/tags/v1.0.0"
sudo yum update -y && sudo yum install -y unzip httpd
sudo systemctl start httpd
wget $WEBSITE_URL
unzip v1.0.0
RESULTING_DIRECTORY=$(ls -td -- */ | head -n 1 | cut -d'/' -f1)
sudo mv $RESULTING_DIRECTORY/* /var/www/html/
sudo systemctl restart httpd
