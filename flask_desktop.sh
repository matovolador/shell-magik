#!/bin/bash
echo "This does not work with python2.* . Use 3.* instead (tested only with 3.6, cause thats where the magik is at).
If you are using virtualenv please make sure its activated before executing this."
read -p "Proceed?: (y/n)" proceed
if [[  "$proceed" != 'y' && "$proceed" != 'Y' ]]
then
    echo "Exiting script"
    exit 1
fi
pip install git+git://github.com/widdershin/flask-desktop.git
# open readme for deepLearning:
URL='https://github.com/Widdershin/flask-desktop/blob/master/README.rst#usage'
[[ -x $BROWSER ]] && exec "$BROWSER" "$URL"
path=$(which xdg-open || which gnome-open) && exec "$path" "$URL" && exit 0
echo "Can't find browser" exit 1