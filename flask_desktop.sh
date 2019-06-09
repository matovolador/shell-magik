#!/bin/bash
echo "This script requires python3.6 and virtualenv.
Make sure you have both things installed before proceeding."
read -p "Proceed?: (y/n)" proceed
if [[  "$proceed" != 'y' && "$proceed" != 'Y' ]]
then
    echo "Exiting script"
    exit 1
fi
python_path_default="/usr/bin/python3.6"
read -p "Enter python3.6 path (defaults to $python_path_default ) Leave blank to use default:" python_path
if [[ $python_path != "" ]]
then
    python_path="/usr/bin/python3.6"
else
    python_path="$python_path_default"
fi
read -p "Enter project path: " path
mkdir $path
cd $path
virtualenv venv --python="$python_path"
source venv/bin/activate
pip install flask
pip install mypy
pip install pymysql
pip install requests
pip install pillow  # gona use this to auto generate the favico...plus its the best img module for python in the universe...yeah we've checked.
pip install git+git://github.com/widdershin/flask-desktop.git

pip freeze > requirements.txt

cat <<EOF >__init__.py
from flask import Flask, request, render_template, abort, send_file, redirect, url_for, send_from_directory, session, flash, g
import pymysql.cursors
import json, os, requests, sys
from webui import WebUI # Add WebUI to your imports
from modules.db import DB

app = Flask(__name__)
ui = WebUI(app, debug=True,port=3566) # Create a WebUI instance . Set port here (if you use 5000 somewhere else in your machine.)

@app.route("/")
def index():
        return render_template('index.html')

if __name__ == "__main__":
        ui.run()

EOF
mkdir modules
mkdir sql
mkdir -p templates/_partial
mkdir -p static/img
mkdir -p static/js
mkdir -p static/css
mkdir bin
cd templates
cat <<EOF >index.html
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Document</title>
</head>
<body>
    HELLO WORLD!
</body>
</html>
EOF
cd ..
cd modules
touch __init__.py


cat <<EOF >db.py
import sqlite3

class DB:
    def __init__(self,filename='example.db'):
        #You can also supply the special name :memory: to create a database in RAM.
        self.db_file = filename
        self.conn = False

    def connect():
        self.conn = sqlite3.connect(this.db_file)


    def close():
        self.conn.close()
        self.conn = False

    def get_cursor():
        if not self.conn:
            self.connect()
        return self.conn.cursor()


    def create_tables():
        c = self.get_cursor()
        c.execute('''CREATE TABLE stocks
             (date text, trans text, symbol text, qty real, price real)''')
        c.commit()

    def insert_sample():
        c = self.get_cursor()
        c.execute("INSERT INTO stocks VALUES ('2006-01-05','BUY','RHAT',100,35.14)")
        # Save (commit) the changes
        conn.commit()

EOF

cd ..

# make temp python file to generate favico
cat <<EOF >ico.py
from PIL import Image, ImageDraw

img = Image.new('RGB', (30, 30), color = (73, 109, 137))

d = ImageDraw.Draw(img)
d.text((10,10), "ico", fill=(255,255,0))

img.save('static/img/favico.ico')
EOF
python ico.py  # create favico
rm ico.py # remove the python script



git init
cat <<EOF >.gitignore
.vscode
venv
_labs
*.pyc
__pycache__

EOF

git add .
git commit -m 'init repo'

# # TODO MAKE THE README
# cat <<EOF >README.md
# # Welcome to flaskinit

# ## Description

# Flask init is a shell script that creates a basic project structure, with a few dependencies within a virtualenv folder, using python3.6 (which you need to have installed previously, along with virtualenv)
# If you can't execute the script, use $ \`chmod +x ./flaskinit.sh\` to provide the script with executable permissions. No sudo permissions are required.

# ## Requirements

# * virtualenv
# * python3.6 installed on /usr/bin/python3.6  (new versions of this script will accept the python path as arguement before initializing the project)
# * MySQL server

# ## Usage

# After you execute the script, you will have a folder containing all the project structure and files. The file \`__init__.py\` on the root folder will be the "flask app file". It comes with a default route and some basic stuff to get you started quickly into adding more routes. Even if the script is meant to generate a squeleton for a Rest API, the templates and static folders are also created just in case you want to do a HTML response application.

# The structure is made so that you include all your custom classes inside the modules folder, and all your "execute" files inside the bin folder.

# To start the flask app, just activate the virtualenv by doing \`source venv/bin/activate\` and then starting the flask app with \`python __init__.py\`

# ## Notes

# * This script uses pymysql as a connector driver for MySQL db. If you dont want to use it, remove it from the virtualenv
# EOF

# open readme for deepLearning:
URL='https://github.com/Widdershin/flask-desktop/blob/master/README.rst#usage'
[[ -x $BROWSER ]] && exec "$BROWSER" "$URL"
path=$(which xdg-open || which gnome-open) && exec "$path" "$URL" && exit 0
echo "Can't find browser" exit 1

read -p "Press enter to exit" continue