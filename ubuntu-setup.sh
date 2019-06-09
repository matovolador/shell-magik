#!/bin/bash
echo "This will install all ubuntu (tested 18.04 and 16.02) packages to use a flask app with apache2 with modwsgi and python2.7, using 1 shell script (the setup at least will be 1 click). You can also pass in a git repo to clone your app from later in the installation process."
read -p "Proceed?: (y/n)" proceed
if [[  "$proceed" != 'y' && "$proceed" != 'Y' ]]
then
    echo "Exiting script"
    exit 1
fi
sudo apt update && apt install build-essential -y && apt install apache2 -y && apt install virtualenv -y && apt install mysql-client -y && apt install libapache2-mod-wsgi python-dev -y
cd /var/www
sudo mkdir log
sudo a2enmod wsgi
cd /var/www
sudo mkdir -p flask_app/flask_app
cd flask_app/flask_app
read -p "Enter git repo to clone your code from in order to use in your flask app, like: https://you@repodomain/owner/repoName.git (leave blank to skip this):" repo
if [[ "$repo" != "" ]]
then
	echo "Cloning repo..."
	echo "Please make sure your flask app entry point is named __init__.py."
	git clone $repo .
else
	echo "Skipping repo cloning as no repo url was given."
fi
sudo virtualenv venv --python=/usr/bin/python
# Run this if repo was cloned
source venv/bin/activate
pip install -U -r requirements.txt
deactivate
sudo cat <<EOF >/var/www/flask_app/flask_app.wsgi
#!/usr/bin/python
import sys
import logging
python_home = '/var/www/flask_app/flask_app/venv'
activate_this = python_home + '/bin/activate_this.py'
execfile(activate_this, dict(__file__=activate_this))
logging.basicConfig(stream=sys.stderr)
sys.path.insert(0,"/var/www/flask_app/")

from flask_app import app as application
application.secret_key = 'secret123'
EOF
sudo chown -R ubuntu:www-data /var/www
sudo chmod -R 775 /var/www

# set a default value for site domain:
$domain = "<ENTER YOUR SITE DOMAIN>"
read -p "Enter server domain to use on the Apache2 site config file (without schema):" domain
sudo cat <<EOF >/etc/apache2/sites-enabled/flask_app.conf
<VirtualHost *:80>
		ServerName "$domain"
		ServerAdmin admin@mywebsite.com
		WSGIDaemonProcess flask_app threads=15 python-home=/var/www/flask_app/flask_app/venv
		WSGIScriptAlias / /var/www/flask_app/flask_app.wsgi
		# Add this if you are using any type of authorization header
		WSGIPassAuthorization On

		<Directory /var/www/flask_app/flask_app/>
			Require all granted
		</Directory>
		Alias /static /var/www/flask_app/flask_app/static
		<Directory /var/www/flask_app/flask_app/static/>
			Require all granted
		</Directory>
		ErrorLog /var/www/log/error.log
		LogLevel warn
		CustomLog /var/www/log/access.log combined
</VirtualHost>
EOF
sudo a2enmod rewrite
sudo service apache2 restart