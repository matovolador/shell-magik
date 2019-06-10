#!/bin/bash
# Put this script on project root. If you need to use credentials, store them somewhere else and give them as variables to the script. PLEASE DONT PUT THIS ON A BRANCH THAT AINT MASTER OR SUFFER THE CONSECUENCES.
yarn run build && scp -r dist/* root@172.105.0.231:/var/www/html || echo "Build failed. Skipping deployment."
read -p "Enter any key to exit." continue
