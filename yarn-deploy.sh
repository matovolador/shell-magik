#!/bin/bash
# Put this script on project root. If you need to use credentials, store them somewhere else and give them as variables to the script.
yarn run build && scp -r dist/* root@172.105.0.231:/var/www/html || echo "Build failed. Skipping deployment."
read -p "Enter any key to exit." continue
